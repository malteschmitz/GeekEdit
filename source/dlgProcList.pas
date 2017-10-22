unit dlgProcList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, VirtualTrees, Math, SynEditTypes,
  ImgList;

type
  TProcType = (ptProc, ptFctn, ptMethProc, ptMethFctn);

  TProcListDialog = class;

  TProcElement = class(TObject)
  private
    FName: string;
    FLine, FSelStart: Integer;
    FTyp: TProcType;
    FProcForm: TProcListDialog;
    FImageIndex: Integer;
    function GetImageIndex: Integer;
    function GetKlasse: string;
    function GetTypString: string;
    function GetLineString: string;
  public
    property Name: string read FName write FName;
    property Line: Integer read FLine write FLine;
    property Typ: TProcType read FTyp write FTyp;
    property Klasse: string read GetKlasse;
    property SelStart: Integer read FSelStart write FSelStart;
    property TypString: string read GetTypString;
    property LineString: string read GetLineString;
    property ProcForm: TProcListDialog read FProcFOrm write FProcForm;
    property ImageIndex: Integer read GetImageIndex;
    constructor Create;
  end;

  TProcSelectedEvent = procedure(ProcElement: TProcElement; Sender: TObject) of object;

  TProcListDialog = class(TForm)
    ObjectsLabel: TLabel;
    SearchEdit: TEdit;
    SearchLabel: TLabel;
    ObjectsComboBoxEx: TComboBoxEx;
    ClassImageList: TImageList;
    procedure VSTGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
      var ImageIndex: Integer);
    procedure VSTDblClick(Sender: TObject);
    procedure VSTChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VSTHeaderClick(Sender: TVTHeader; Column: TColumnIndex;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure VSTCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure VSTFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure SearchEditChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SearchEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FOnProcSelected: TProcSelectedEvent;
  public
    VST: TVirtualStringTree;
    procedure AddProc(const aName: string; const aLine: Integer; const aSelStart: Integer; const aTyp: TProcType);
    property OnProcSelected: TProcSelectedEvent read FOnProcSelected write FOnProcSelected;
    function Execute: Boolean;
  published
  private
    procedure SearchCallback(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
  end;

const
  PROC_TYPE_CAPTIONS: array[TProcType] of string = ('Prz', 'Fktn', 'Prz Me', 'Fktn Me');

  CLASS_COLORS: array[0..11] of TColor = (clRed, clLime, clYellow, clBlue, clFuchsia, clAqua, clMaroon, clGreen, clOlive, clNavy, clPurple, clTeal);

implementation

{$R *.dfm}

uses
  frmMain;

procedure TProcListDialog.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #27:
    begin
      ModalResult := mrCancel;
      Key := #0;
    end;
    #13:
    begin
      ModalResult := mrOk;
      Key := #0;
    end;
  end;
end;

function TProcElement.GetImageIndex: Integer;

  procedure AddIcon(const Index: Integer);
  var
    Sym, Map: TBitmap;
  begin
    Sym := TBitmap.Create;
    Map := TBitmap.Create;
    try
      Sym.Width := 16;
      Sym.Height := 16;
      Sym.Canvas.Pen.Color := clBlack;
      Sym.Canvas.Brush.Color := CLASS_COLORS[Index mod Length(CLASS_COLORS)];
      Sym.Canvas.MoveTo(8, 3);
      Sym.Canvas.LineTo(13, 8);
      Sym.Canvas.LineTo(8, 13);
      Sym.Canvas.LineTo(3, 8);
      Sym.Canvas.LineTo(8, 3);
      Map.Width := 16;
      Map.Height := 16;
      Map.Canvas.Pen.Color := clBlack;
      Map.Canvas.Brush.Color := clBlack;
      Map.Canvas.Draw(0,0,Sym);
      Sym.Canvas.FloodFill(8, 8, clWhite, fsSurface);
      Map.Canvas.FloodFill(8, 8, clWhite, fsSurface);
      ProcForm.ClassImageList.Insert(Index, Sym, Map);
    finally
      Sym.Free;
      Map.Free;
    end;
  end;

var
  Klasse: string;
  Found: Boolean;
  i: Integer;
begin
  if FImageIndex < -1 then
  begin
    Result := 0; // blank image -- no image (-1) makes the text start at the left
    Klasse := Self.Klasse;
    if Klasse > '' then
    begin
      Found := False;
      for i := 2 to ProcForm.ObjectsComboBoxEx.Items.Count - 1 do
      begin
        if CompareText(ProcForm.ObjectsComboBoxEx.Items.Strings[i], Klasse) = 0 then
        begin
          Result := i;
          Found := True;
          break;
        end;
      end;
      if not Found then
      begin
        Result := ProcForm.ObjectsComboBoxEx.Items.Add(Klasse);
        ProcForm.ObjectsComboBoxEx.ItemsEx[Result].ImageIndex := Result;
        AddIcon(Result);
      end;
    end;
    FImageIndex := Result;
  end
  else
    Result := FImageIndex;
end;

procedure TProcListDialog.AddProc(const aName: string; const aLine: Integer; const aSelStart: Integer; const aTyp: TProcType);
var
  Element: TProcElement;
begin
  Element := TProcElement.Create;
  with Element do
  begin
    Name := aName;
    Line := aLine;
    Typ := aTyp;
    SelStart := aSelStart;
    ProcForm := Self;
    if Klasse > '' then
      Typ := TProcType(Ord(Typ) + 2);
    ImageIndex; // let the getter of ImageIndex create the image and the entry in the ComboBox
  end;

  VST.AddChild(nil, Element);
end;

function TProcListDialog.Execute: Boolean;
begin
  Result := ShowModal = mrOk;
end;

procedure TProcListDialog.FormCreate(Sender: TObject);
var
  Bitmap: TBitmap;
begin
  // create VST
  VST := TVirtualStringTree.Create(Self);
  with VST.Header.Columns.Add do
  begin
    Position := 0;
    Width := 220;
    Text := 'Klasse.Name';
  end;
  with VST.Header.Columns.Add do
  begin
    Position := 1;
    Text := 'Typ';
  end;
  with VST.Header.Columns.Add do
  begin
    Position := 2;
    Width := 55;
    Text := 'Zeile';
  end;
  with VST do
  begin
    Name := 'VST';
    Parent := Self;
    Left := 5;
    Top := 39;
    Width := 329;
    Height := 169;
    Anchors := [akLeft, akTop, akRight, akBottom];
    Header.AutoSizeIndex := -1;
    Header.Font.Charset := DEFAULT_CHARSET;
    Header.Font.Color := clWindowText;
    Header.Font.Height := -11;
    Header.Font.Name := 'Tahoma';
    Header.Font.Style := [];
    Header.Options := [hoColumnResize, hoShowSortGlyphs, hoVisible];
    Header.SortColumn := 0;
    Images := ClassImageList;
    TabOrder := 2;
    TreeOptions.AutoOptions := [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes];
    TreeOptions.PaintOptions := [toHideFocusRect, toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages];
    TreeOptions.SelectionOptions := [toFullRowSelect];
    OnChange := VSTChange;
    OnCompareNodes := VSTCompareNodes;
    OnDblClick := VSTDblClick;
    OnFreeNode := VSTFreeNode;
    OnGetText := VSTGetText;
    OnGetImageIndex := VSTGetImageIndex;
    OnHeaderClick := VSTHeaderClick;
  end;

  VST.BeginUpdate;
  VST.NodeDataSize := SizeOf(TProcElement);

  Bitmap := TBitmap.Create;
  try
    Bitmap.Width := 16;
    Bitmap.Height := 16;
    ClassImageList.AddMasked(Bitmap, clWhite);
    ClassImageList.AddMasked(Bitmap, clWhite);
  finally
    Bitmap.Free;
  end;

  ObjectsComboBoxEx.Items.Clear;
  ObjectsComboBoxEx.ItemsEx.AddItem('alle', 0, -1, -1, 0, nil);
  ObjectsComboBoxEx.ItemsEx.AddItem('keine', 1, -1, -1, 0, nil);
end;

function TProcElement.GetKlasse: string;
begin
  Result := Copy(Name, 1, Pos('.', Name) - 1);
end;

procedure TProcListDialog.FormShow(Sender: TObject);
begin
  VST.EndUpdate;
  ObjectsComboBoxEx.ItemIndex := 0;
end;

procedure TProcListDialog.SearchEditChange(Sender: TObject);
begin
  VST.BeginUpdate;
  VST.IterateSubtree(nil, SearchCallback, nil);
  VST.Selected[VST.GetFirstVisible] := True;
  VST.FocusedNode := VST.GetFirstVisible;
  VST.EndUpdate;
end;

procedure TProcListDialog.SearchEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Node: PVirtualNode;
begin
  case Key of
    VK_DOWN:
    begin
      if Assigned(VST.FocusedNode) then
      begin
        Node := VST.GetNextVisible(VST.FocusedNode);
        if Assigned(Node) then
        begin
          VST.Selected[Node] := True;
          VST.FocusedNode := Node;
        end;
      end
      else
      begin
        VST.Selected[VST.GetFirstVisible] := True;
        VST.FocusedNode := VST.GetFirstVisible;
      end;
      Key := 0;
    end;
    VK_UP:
    begin
      if Assigned(VST.FocusedNode) then
      begin
        Node := VST.GetPreviousVisible(VST.FocusedNode);
        if Assigned(Node) then
        begin
          VST.Selected[Node] := True;
          VST.FocusedNode := Node;
        end;
      end
      else
      begin
        VST.Selected[VST.GetLastVisible] := True;
        VST.FocusedNode := VST.GetLastVisible;
      end;
      Key := 0;
    end;
  end;
end;

procedure TProcListDialog.VSTFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Element: TProcElement;
begin
  Element := TProcElement(VST.GetNodeData(Node)^);
  Element.Free;
end;

procedure TProcListDialog.VSTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Element: TProcElement;
begin
  Element := TProcElement(VST.GetNodeData(Node)^);
  case Column of
    0: CellText := Element.Name;
    1: CellText := Element.TypString;
    2: CellText := Element.LineString;
  end;
end;

function TProcElement.GetTypString: string;
begin
  Result := PROC_TYPE_CAPTIONS[Typ];
end;

function TProcElement.GetLineString: string;
begin
  Result := IntToStr(Line);
end;

procedure TProcListDialog.VSTCompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Element1, Element2: TProcElement;
begin
  Element1 := TProcElement(VST.GetNodeData(Node1)^);
  Element2 := TProcElement(VST.GetNodeData(Node2)^);
  case Column of
    0: Result := CompareStr(Element1.Name, Element2.Name);
    1: Result := CompareValue(Ord(Element1.Typ), Ord(Element2.Typ));
    2: Result := CompareValue(Element1.Line, Element2.Line);
  end;
end;

procedure TProcListDialog.VSTHeaderClick(Sender: TVTHeader;
  Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  if Button = mbLeft then
  begin
    if Column = VST.Header.SortColumn then
      VST.Header.SortDirection := TSortdirection(1 - Ord(VST.Header.SortDirection))
    else
      VST.Header.SortColumn := Column;
  end;
end;

procedure TProcListDialog.VSTChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Element: TProcElement;
begin
  if Assigned(Node) then
  begin
    Element := TProcElement(VST.GetNodeData(Node)^);
    if Assigned(FOnProcSelected) then
      FOnProcSelected(Element, Self);
  end;
end;

procedure TProcListDialog.VSTDblClick(Sender: TObject);
begin
  if VST.SelectedCount > 0 then
    ModalResult := mrOk;
end;

procedure TProcListDialog.SearchCallback(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
var
  Element: TProcElement;
begin
  Element := TProcElement(VST.GetNodeData(Node)^);
  if ObjectsComboBoxEx.ItemIndex <= 0 then
    VST.IsVisible[Node] := (SearchEdit.Text = '') or (Pos(LOwerCase(SearchEdit.Text), LowerCase(Element.Name)) > 0)
  else if ObjectsComboBoxEx.ItemIndex = 1 then
    VST.IsVisible[Node] := (Element.Klasse = '') and ((SearchEdit.Text = '') or (Pos(LOwerCase(SearchEdit.Text), LowerCase(Element.Name)) > 0))
  else
    VST.IsVisible[Node] := (Element.Klasse = ObjectsComboBoxEx.Items[ObjectsComboBoxEx.ItemIndex]) and ((SearchEdit.Text = '') or (Pos(LOwerCase(SearchEdit.Text), LowerCase(Element.Name)) > 0));
end;

procedure TProcListDialog.VSTGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  Element: TProcElement;
begin
  if Column = 0 then
  begin
    Element := TProcElement(VST.GetNodeData(Node)^);
    ImageIndex := Element.ImageIndex;
  end
  else
    ImageIndex := -1;
end;

constructor TProcElement.Create;
begin
  inherited Create;
  FImageIndex := -2;
end;


end.
