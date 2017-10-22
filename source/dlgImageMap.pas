unit dlgImageMap;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ActnList, jpeg, GifImage, pngimage,
  Menus, ExtDlgs, ClipBrd, IniFiles;

type
  TImageMapDialog = class(TForm)
    Button: TButton;
    ScrollBox: TScrollBox;
    PaintBox: TPaintBox;
    Panel: TPanel;
    MenuPanel: TPanel;
    Text7Label: TLabel;
    Text6Label: TLabel;
    Text5Label: TLabel;
    Text4Label: TLabel;
    Text3Label: TLabel;
    Text2Label: TLabel;
    TextLabel: TLabel;
    CoordsEdit: TEdit;
    ShapeComboBox: TComboBox;
    HrefEdit: TEdit;
    AltEdit: TEdit;
    RestEdit: TEdit;
    MapListBox: TListBox;
    MainMenu: TMainMenu;
    ImageMapMenu: TMenuItem;
    LoadImageMenu: TMenuItem;
    N1: TMenuItem;
    OkMenu: TMenuItem;
    NewMenu: TMenuItem;
    CancelMenu: TMenuItem;
    OkBtn: TButton;
    CancelBtn: TButton;
    Bevel: TBevel;
    NameEdit: TEdit;
    NameLabel: TLabel;
    MapChkBox: TCheckBox;
    ImgChkBox: TCheckBox;
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CancelMenuClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject);
    procedure PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBoxDblClick(Sender: TObject);
    procedure CoordsEditExit(Sender: TObject);
    procedure OkMenuClick(Sender: TObject);
    procedure LoadImageMenuClick(Sender: TObject);
    procedure CoordsEditChange(Sender: TObject);
    procedure MapListBoxClick(Sender: TObject);
    procedure MapListBoxKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure NewMenuClick(Sender: TObject);
    procedure LoadBild(Datei: String);
  private
    Picture: TPicture;
    Coords: TStringList;
    Indent: Integer;
    PictureFileName: TFileName;
    FValue: String;
    function LoadImageDialog: Boolean;
    procedure DoNew;
  public
    property Value: String read FValue write FValue;
    function Execute: Boolean;
  end;

  {Drawing the object is done when PaintBox.Tag = 1}

implementation

{$R *.dfm}

uses
  uShare;

procedure TImageMapDialog.FormCreate(Sender: TObject);
begin
  Picture := TPicture.Create;
  Coords := TStringList.Create;
  Coords.Clear;
  Coords.Delimiter := ',';
  MapListBox.ItemIndex := 0;
  PaintBox.Canvas.Pen.Mode := pmNot;
end;

procedure TImageMapDialog.PaintBoxPaint(Sender: TObject);
var
  i: Integer;
begin
  with PaintBox.Canvas do
    Draw(0,0,Picture.Graphic);
  if (Coords.Count = 0) or (PaintBox.Tag = 0) then exit;
  case ShapeComboBox.ItemIndex of
  0:
  begin
    PaintBox.Canvas.Rectangle(StrToInt(Coords[0]),StrToInt(Coords[1]),StrToInt(Coords[2]),StrToInt(Coords[3]));
  end;
  1:
  begin
    PaintBox.Canvas.Ellipse(StrToInt(Coords.Strings[0]) - StrToInt(Coords.Strings[2]), StrToInt(Coords.Strings[1]) - StrToInt(Coords.Strings[2]), StrToInt(Coords.Strings[0]) + StrToInt(Coords.Strings[2]), StrToInt(Coords.Strings[1]) + StrToInt(Coords.Strings[2]));
  end;
  2:
  begin
    i := 0;
    while i < Coords.Count -1 do
    begin
      if i = 0 then PaintBox.Canvas.MoveTo(StrToInt(Coords[i]), StrToInt(Coords[i + 1])) else
      begin
        PaintBox.Canvas.MoveTo(StrToInt(Coords[i - 2]), StrToInt(Coords[i - 1]));
        PaintBox.Canvas.LineTo(StrToInt(Coords[i]), StrToInt(Coords[i + 1]));
      end;
      inc(i, 2);
    end;
    PaintBox.Canvas.MoveTo(StrToInt(Coords[i - 2]), StrToInt(Coords[i - 1]));
    PaintBox.Canvas.LineTo(StrToInt(Coords[0]), StrToInt(Coords[1]));
  end;
  end; //case
end;

procedure TImageMapDialog.PaintBoxMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
begin
  if (Coords.Count = 0) or (PaintBox.Tag = 1) or (Picture.Graphic = nil) then exit;
  with PaintBox.Canvas do
    Draw(0,0,Picture.Graphic);
  case ShapeComboBox.ItemIndex of
  0:
  begin
    PaintBox.Canvas.Rectangle(StrToInt(Coords[0]),StrToInt(Coords[1]),X,Y);
  end;
  1:
  begin
    i := Round(Sqrt( Sqr(X - StrToInt(Coords.Strings[0])) + Sqr(Y - StrToInt(Coords.Strings[1])) )); //Radius
    PaintBox.Canvas.Ellipse(StrToInt(Coords.Strings[0]) - i, StrToInt(Coords.Strings[1]) - i, StrToInt(Coords.Strings[0]) + i, StrToInt(Coords.Strings[1]) + i);
  end;
  2:
  begin
    i := 0;
    while i < Coords.Count -1 do
    begin
      if i = 0 then PaintBox.Canvas.MoveTo(StrToInt(Coords[i]), StrToInt(Coords[i + 1])) else
      begin
        PaintBox.Canvas.MoveTo(StrToInt(Coords[i - 2]), StrToInt(Coords[i - 1]));
        PaintBox.Canvas.LineTo(StrToInt(Coords[i]), StrToInt(Coords[i + 1]));
      end;
      inc(i, 2);
    end;
    PaintBox.Canvas.LineTo(X,Y);
  end;
  end; //case
end;

procedure TImageMapDialog.PaintBoxMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    if PaintBox.Tag < 1 then
    begin
      if (ShapeComboBox.ItemIndex = 1) and (Coords.Count = 2) then
      begin
        Coords.Add(IntToStr( Round(Sqrt( Sqr(X - StrToInt(Coords.Strings[0])) + Sqr(Y - StrToInt(Coords.Strings[1])) )) ));
      end
      else
      begin
        Coords.Add(IntToStr(X));
        Coords.Add(IntToStr(Y));
      end;
      CoordsEdit.Text := Coords.DelimitedText;
      if ShapeComboBox.ItemIndex = 0 then if Coords.Count = 4 then
      begin
        PaintBox.Tag := 1;
        PaintBoxPaint(Sender);
      end;
      if ShapeComboBox.ItemIndex = 1 then if Coords.Count = 3 then
      begin
        PaintBox.Tag := 1;
        PaintBoxPaint(Sender);
      end;
    end;
  end
  else if Button = mbRight then
  begin
    Coords.Clear;
    CoordsEdit.Text := Coords.DelimitedText;
    PaintBox.Canvas.Draw(0,0,Picture.Graphic);
    PaintBox.Tag := 0;
  end;
end;

procedure TImageMapDialog.PaintBoxDblClick(Sender: TObject);
begin
  if ShapeComboBox.ItemIndex = 2 then
  begin
    PaintBox.Tag := 1;
    PaintBoxPaint(Sender);
  end;
end;

procedure TImageMapDialog.CoordsEditExit(Sender: TObject);
begin
  Coords.DelimitedText := CoordsEdit.Text;
  if Coords.Count = 0 then PaintBox.Tag := 0;
  PaintBoxPaint(Sender);
end;

function TImageMapDialog.Execute: Boolean;
begin
  Result := ShowModal = mrOk;
end;

procedure TImageMapDialog.OkMenuClick(Sender: TObject);
  function Spaces: String;
  begin
    Result := StringOfChar(' ', Indent);
  end;

var
  i: Integer;
  ImgLink, BasePath: String;
begin
  ModalResult := mrOk;
  FValue := '';
  if MapChkBox.Checked then
    FValue := FValue + Spaces + '<map name="' + NameEdit.Text + '">'#13#10;
  for i := 0 to MapListBox.Count - 1 do
    if (MapListBox.Items.Strings[i] <> '') and (MapListBox.Items.Strings[i] <> '(Neu)') then
      FValue := FValue + Spaces + ' ' + MapListBox.Items.Strings[i] + #13#10;
  if MapChkBox.Checked then
    FValue := FValue + Spaces + '</map>'#13#10;
  if ImgChkBox.Checked then
  begin
    ImgLink := PictureFileName;
    if Share.FileName = '' then
      BasePath := ExtractFilePath(ParamStr(0))
    else
      BasePath := ExtractFilePath(Share.FileName);
    ImgLink := StringReplace(ExtractRelativePath(BasePath, ImgLink), '\', '/', [rfReplaceAll]);
    FValue := FValue + Spaces + '<img src="' + ImgLink + '" width="' + IntToStr(Picture.Width) + '" height="' + IntToStr(Picture.Height) + '" alt="' + NameEdit.Text + '" usemap="#' + NameEdit.Text + '">'
  end;
end;

procedure TImageMapDialog.LoadBild(Datei: String);
var
  Bild2: TPicture;
begin
  Bild2 := TPicture.Create;
  Bild2.LoadFromFile(Datei);
  Picture.Bitmap.Width := Bild2.Width;
  Picture.Bitmap.Height := Bild2.Height;
  with Picture.Bitmap.Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := clWhite;
    FillRect(Rect(0,0,PaintBox.Width, PaintBox.Height));
    Draw(0,0,Bild2.Graphic);
  end;
  Bild2.Free;
  PaintBox.Width := Picture.Width;
  PaintBox.Height := Picture.Height;
  PictureFileName := Datei;
end;

function TImageMapDialog.LoadImageDialog: Boolean;
var
  dlg: TOpenPictureDialog;
begin
  dlg := TOpenPictureDialog.Create(Self);
  with dlg do
  begin
    if Share.FileName = '' then
      InitialDir := ExtractFilePath(ParamStr(0))
    else
      InitialDir := ExtractFilePath(Share.FileName);
    Options := [ofHideReadOnly, ofFileMustExist, ofEnableSizing];
    Title := 'Bild laden ...';
    Result := Execute;
    if Result then
      LoadBild(FileName);
  end;
end;

procedure TImageMapDialog.LoadImageMenuClick(Sender: TObject);
begin
  LoadImageDialog;
end;

procedure TImageMapDialog.CoordsEditChange(Sender: TObject);
begin
  if MapListBox.Tag = 1 then exit;
  if MapListBox.ItemIndex = -1 then exit;
  if MapListBox.Items.Strings[MapListBox.ItemIndex] = '(Neu)' then // create <area>
  begin
    if CoordsEdit.Text = '' then exit;
    MapListBox.Items.Insert(MapListBox.Items.Count -1, '<area shape="' + ShapeComboBox.Text + '" coords="' + CoordsEdit.Text + '" href="' + HrefEdit.Text + '" alt="' + AltEdit.Text + '"' + RestEdit.Text + '>');
    MapListBox.ItemIndex := MapListBox.Items.Count -2;
  end
  else
  begin
    MapListBox.Items.Strings[MapListBox.ItemIndex] := '<area shape="' + ShapeComboBox.Text + '" coords="' + CoordsEdit.Text + '" href="' + HrefEdit.Text + '" alt="' + AltEdit.Text + '"' + RestEdit.Text + '>';
  end;
end;

procedure TImageMapDialog.MapListBoxClick(Sender: TObject);
begin
  if MapListBox.Items.Strings[MapListBox.ItemIndex] = '(Neu)' then
  begin
    CoordsEdit.Text := '';
    HrefEdit.Text := '';
    AltEdit.Text := '';
    RestEdit.Text := '';
  end
  else
  begin
    MapListBox.Tag := 1;
    if Pos('shape="rect"', LowerCase(MapListBox.Items.Strings[MapListBox.ItemIndex])) <> 0 then
      ShapeComboBox.ItemIndex := 0
    else if Pos('shape="circle"', LowerCase(MapListBox.Items.Strings[MapListBox.ItemIndex])) <> 0 then
      ShapeComboBox.ItemIndex := 1
    else if Pos('shape="poly"', LowerCase(MapListBox.Items.Strings[MapListBox.ItemIndex])) <> 0 then
      ShapeComboBox.ItemIndex := 2;
    CoordsEdit.Text := Copy(MapListBox.Items.Strings[MapListBox.ItemIndex], Pos('coords="', LowerCase(MapListBox.Items.Strings[MapListBox.ItemIndex])) + 8, Length(LowerCase(MapListBox.Items.Strings[MapListBox.ItemIndex])) - Pos('coords="', LowerCase(MapListBox.Items.Strings[MapListBox.ItemIndex])) - 7);
    CoordsEdit.Text := Copy(CoordsEdit.Text, 1, Pos('"', CoordsEdit.Text) - 1);
    HrefEdit.Text := Copy(MapListBox.Items.Strings[MapListBox.ItemIndex], Pos('href="', LowerCase(MapListBox.Items.Strings[MapListBox.ItemIndex])) + 6, Length(LowerCase(MapListBox.Items.Strings[MapListBox.ItemIndex])) - Pos('href="', LowerCase(MapListBox.Items.Strings[MapListBox.ItemIndex])) - 5);
    HrefEdit.Text := Copy(HrefEdit.Text, 1, Pos('"', HrefEdit.Text) - 1);
    AltEdit.Text := Copy(MapListBox.Items.Strings[MapListBox.ItemIndex], Pos('alt="', LowerCase(MapListBox.Items.Strings[MapListBox.ItemIndex])) + 5, Length(LowerCase(MapListBox.Items.Strings[MapListBox.ItemIndex])) - Pos('alt="', LowerCase(MapListBox.Items.Strings[MapListBox.ItemIndex])) - 4);
    AltEdit.Text := Copy(AltEdit.Text, 1, Pos('"', AltEdit.Text) - 1);
    RestEdit.Text := Copy(MapListBox.Items.Strings[MapListBox.ItemIndex], Pos('alt="', LowerCase(MapListBox.Items.Strings[MapListBox.ItemIndex])) + 5, Length(LowerCase(MapListBox.Items.Strings[MapListBox.ItemIndex])) - Pos('alt="', LowerCase(MapListBox.Items.Strings[MapListBox.ItemIndex])) - 4);
    RestEdit.Text := Copy(RestEdit.Text, Pos('"', RestEdit.Text) + 1, Length(RestEdit.Text) - Pos('"', RestEdit.Text) - 1);
    MapListBox.Tag := 0;
  end;
  PaintBox.Tag := 1;
  CoordsEditExit(Sender);
  PaintBoxPaint(Sender);
end;

procedure TImageMapDialog.MapListBoxKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  Tmp: Integer;
begin
  if Key = 46 then
  begin
    if MapListBox.Items.Strings[MapListBox.ItemIndex] = '(Neu)' then exit;
    Tmp := MapListBox.ItemIndex;
    MapListBox.Items.Delete(MapListBox.ItemIndex);
    if Tmp > 0 then dec(tmp);
    MapListBox.ItemIndex := Tmp;
  end;
end;

procedure TImageMapDialog.DoNew;
begin
  MapListBox.Clear;
  MapListBox.Items.Add('(Neu)');
  MapListBox.ItemIndex := 0;
  MapChkBox.Checked := True;
  ImgChkBox.Checked := True;
  NameEdit.Text := '';
end;

procedure TImageMapDialog.NewMenuClick(Sender: TObject);
begin
  if LoadImageDialog then
    DoNew;
end;

procedure TImageMapDialog.CancelMenuClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TImageMapDialog.FormShow(Sender: TObject);

  function GetZK(i: Integer): String;
  begin
    Result := '';
    while (FValue[i] <> '"') and (i <= Length(FValue)) do
    begin
      Result := Result + FValue[i];
      inc(i);
    end;
  end;

var
  i: Integer;
  map, area, img: Bool;
begin
  // parse data of existing image map if there is one
  Indent := 0;
  if FValue = '' then
  begin
    if LoadImageDialog then
      DoNew
    else
      ModalResult := mrCancel;
  end
  else
  begin
    MapListBox.Clear;
    if Pos('<map name="', FValue) = 0 then
    begin
      map := True;
      NameEdit.Text := '';
      MapChkBox.Checked := False;
    end
    else
      map := False;
    area := False;
    img := False;
    PictureFileName := '';
    for i := 1 to Length(FValue) do
    begin
      if map then
      begin
        if Copy(FValue, i, 6) = '</map>' then
          map := False
        else
        begin
          if area then
          begin
            if FValue[i] = '>' then
              area := False;
            MapListBox.Items.Strings[MapListBox.Items.Count - 1] := MapListBox.Items.Strings[MapListBox.Items.Count - 1] + FValue[i];
          end
          else
          begin
            if Copy(FValue, i, 6) = '<area ' then
            begin
              area := True;
              MapListBox.Items.Add(FValue[i]);
            end;
          end; //area
        end;
      end // map
      else
      begin
        if Copy(FValue, i, 11) = '<map name="' then
        begin
          map := True;
          MapChkBox.Checked := True;
          NameEdit.Text := GetZK(i + 11);
        end
        else
        begin
          // find image tag
          if Copy(FValue, i, 5) = '<img ' then
            img := True;
          if img then
          begin
            if FValue[i] = '>' then
              img := False;
            if Copy(FValue, i, 6) = ' src="' then
              LoadBild(ExtractFilePath(Share.FileName) + GetZK(i + 6));
          end;
        end;
      end; // not map
    end; // for i
    MapListBox.Items.Add('(Neu)');
    if PictureFileName = '' then
    begin
      if not LoadImageDialog then
        ModalResult := mrCancel;
      ImgChkBox.Checked := False;
    end
    else
      ImgChkBox.Checked := True;
  end; // not FValue = ''
end;

procedure TImageMapDialog.FormDestroy(Sender: TObject);
begin
  Picture.Free;
  Coords.Free;
end;

end.
