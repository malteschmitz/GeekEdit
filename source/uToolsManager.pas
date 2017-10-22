unit uToolsManager;

interface

uses
  Classes, Menus, SynEdit, frmCharMap, dlgProcList;

type
  TToolsManager = class
  private
    FSynEdit: TSynEdit;
    FCompOwner: TComponent;
    FCharMapForm: TCharMapForm;
    FCharMapMenu: TMenuItem;
    procedure DirListMenuClick(Sender: TObject);
    procedure ColorMenuClick(Sender: TObject);
    procedure LinealMenuClick(Sender: TObject);
    procedure CharMapMenuClick(Sender: TObject);
    procedure CharMapClose(Sender: Tobject);
    procedure CharMapCharClick(const c: String; Sender: TObject);
    procedure ImageMapMenuClick(Sender: TObject);
    procedure MetaTagMenuClick(Sender: TObject);
    procedure HtmlFrameMenuClick(Sender: TObject);
    procedure ProcListMenuClick(Sender: TObject);
    procedure ProcListProcSelected(ProcElement: TProcElement; Sender: TObject);
  public
    constructor Create(ASynEdit: TSynEdit; ACompOwner: TComponent; AToolsMenu: TMenuItem);
  end;

implementation

{ TToolsManager }

uses
  SysUtils, Forms, dlgDirList, uShare, dlgColorEx, frmLineal,
  dlgImageMap, dlgMetaTag, dlgHtmlFrame;

procedure TToolsManager.CharMapCharClick(const c: String; Sender: TObject);
begin
  FSynEdit.BeginUndoBlock;
  FSynEdit.SelText := c;
  FSynEdit.EndUndoBlock;
end;

procedure TToolsManager.CharMapClose(Sender: Tobject);
begin
  FCharMapMenu.Checked := False;
end;

procedure TToolsManager.CharMapMenuClick(Sender: TObject);
begin
  if not Assigned(FCharMapForm) then
  begin
    FCharMapForm := TCharMapForm.Create(FCompOwner);
    FCharMapForm.OnCharClick := CharMapCharClick;
    FCharMapForm.OnCharMapClose := CharMapClose;
  end;

  FCharMapMenu.Checked := not FCharMapMenu.Checked;
  if FCharMapMenu.Checked then
  begin
    FCharMapForm.Show;
    FCharMapForm.BringToFront;
  end
  else
    FCharMapForm.Close;
end;

procedure TToolsManager.ColorMenuClick(Sender: TObject);
var
  dlg: TColorExDialog;
begin
  dlg := TColorExDialog.Create(FCompOwner);
  try
    dlg.HtmlColor := FSynEdit.SelText;
    if dlg.Execute then
    begin
      FSynEdit.BeginUndoBlock;
      FSynEdit.SelText := dlg.HtmlColor;
      FSynEdit.EndUndoBlock;
    end;
  finally
    dlg.Free;
  end;
end;

constructor TToolsManager.Create(ASynEdit: TSynEdit; ACompOwner: TComponent; AToolsMenu: TMenuItem);
var
  Menu: TMenuItem;
begin
  FSynEdit := ASynEdit;
  FCompOwner := ACompOwner;
  FCharMapForm := nil;

  Menu := TMenuItem.Create(ACompOwner);
  Menu.Caption := 'Verzeichnis-Listing...';
  Menu.OnClick := DirListMenuClick;
  AToolsMenu.Add(Menu);

  Menu := TMenuItem.Create(ACompOwner);
  Menu.Caption := 'Farbe...';
  Menu.ShortCut := TextToShortCut('Strg+Umsch+C');
  Menu.OnClick := ColorMenuClick;
  AToolsMenu.Add(Menu);

  Menu := TMenuItem.Create(ACompOwner);
  Menu.Caption := 'Lineal...';
  Menu.Shortcut := TextToShortCut('Strg+Umsch+R');
  Menu.OnClick := LinealMenuClick;
  AToolsMenu.Add(Menu);

  FCharMapMenu := TMenuItem.Create(ACompOwner);
  FCharMapMenu.Caption := 'Zeichentabelle';
  FCharMapMenu.ShortCut := TextToShortCut('Strg+E');
  FCharMapMenu.OnClick := CharMapMenuClick;
  AToolsMenu.Add(FCharMapMenu);

  Menu := TMenuItem.Create(ACompOwner);
  Menu.Caption := 'ImageMap...';
  Menu.OnClick := ImageMapMenuClick;
  AToolsMenu.Add(Menu);

  Menu := TMenuItem.Create(ACompOwner);
  Menu.Caption := 'Meta-Angabe...';
  Menu.ShortCut := TextToShortCut('Umsch+Strg+M');
  Menu.OnClick := MetaTagMenuClick;
  AToolsMenu.Add(Menu);

  Menu := TMenuItem.Create(ACompOwner);
  Menu.Caption := 'HTML-Gerüst...';
  Menu.ShortCut := TextToShortCut('Strg+Umsch+N');
  Menu.OnClick :=  HtmlFrameMenuClick;
  AToolsMenu.Add(Menu);

  Menu := TMenuItem.Create(ACompOwner);
  Menu.Caption := 'Prozedurliste...';
  Menu.ShortCut := TextToShortCut('Strg+G');
  Menu.OnClick := ProcListMenuClick;
  AToolsMenu.Add(Menu);
end;

procedure TToolsManager.DirListMenuClick(Sender: TObject);
var
  dlg: TDirListDialog;
begin
  dlg := TDirListDialog.Create(FCompOwner);
  try
    if Share.FileName <> '' then
      dlg.Dir := ExtractFilePath(Share.FileName)
    else
      dlg.Dir := ExtractFilePath(ParamStr(0));
    if dlg.Execute then
    begin
      FSynEdit.BeginUndoBlock;
      FSynEdit.SelText := dlg.Listing;
      FSynEdit.EndUndoBlock;
    end;
  finally
    dlg.Free;
  end;
end;

procedure TToolsManager.HtmlFrameMenuClick(Sender: TObject);
var
  dlg: THtmlFrameDialog;
begin
  dlg := THtmlFrameDialog.Create(FCompOwner);
  try
    if dlg.Execute then
    begin
      FSynEdit.BeginUndoBlock;
      FSynEdit.SelText := dlg.Result;
      FSynEdit.SelStart := FSynEdit.SelStart - Length(#13#10'</body>'#13#10'</html>');
      FSynEdit.EndUndoBlock;
    end;
  finally
    dlg.Free;
  end;
end;

procedure TToolsManager.ImageMapMenuClick(Sender: TObject);
var
  dlg: TImageMapDialog;
begin
  dlg := TImageMapDialog.Create(FCompOwner);
  try
    dlg.Value := FSynEdit.SelText;
    if dlg.Execute then
    begin
      FSynEdit.BeginUndoBlock;
      FSynEdit.SelText := dlg.Value;
      FSynEdit.EndUndoBlock;
    end;
  finally
    dlg.Free;
  end;
end;

procedure TToolsManager.LinealMenuClick(Sender: TObject);
var
  lnl: TLinealForm;
begin
  lnl := TLinealForm.Create(FCompOwner);
  Application.MainForm.Hide;
  try
    if lnl.Execute then
    begin
      FSynEdit.BeginUndoBlock;
      FSynEdit.SelText := lnl.Value;
      FSynEdit.EndUndoBlock;
    end;
  finally
    Application.MainForm.Show;
    lnl.Free;
  end;
end;

procedure TToolsManager.MetaTagMenuClick(Sender: TObject);
var
  dlg: TMetaTagDialog;
begin
  dlg := TMetaTagDialog.Create(FCompOwner);
  try
    if dlg.Execute then
    begin
      FSynEdit.BeginUndoBlock;
      FSynEdit.SelText := dlg.Result;
      FSynEdit.EndUndoBlock;
    end;
  finally
    dlg.Free;
  end;
end;

procedure TToolsManager.ProcListMenuClick(Sender: TObject);
var
  dlg: TProcListDialog;
  i: Integer;
  CmtEnd, txt: string;
  Cmt {scanner is in comment section},
  Imp {scanner is in implementation section or no sections found}: Boolean;
  Line, SelStart: Integer;

  procedure FindProc(Typ: TProcType);
  const
    PROC_NAME_CHARS = ['a'..'z', 'A'..'Z', '0'..'9', '.'];
  var
    Name: string;
  begin
    Name := '';
    while i <= Length(txt) do
    begin
      if txt[i] in PROC_NAME_CHARS then
        Name := Name + txt[i]
      else
        break;
      Inc(i);
    end;
    dlg.AddProc(Name, Line, SelStart, Typ);
    Dec(i);
  end;

var
  sstart, slen, tline: Integer;

begin
  dlg := TProcListDialog.Create(FCompOwner);
  try
    Cmt := False;
    txt := FSynEdit.Text;
    // do not wait for "implementation" if there is no "implementation"
    Imp := Pos('implementation', txt) = 0;
    i := 1;
    Line := 1;
    while i <= Length(txt) do
    begin
      if Copy(txt, i, 2) = #13#10 then Inc(Line);

      if Cmt then
      begin
        if Copy(txt, i, Length(CmtEnd)) = CmtEnd then
        begin
          Cmt := False;
          i := i + Length(CmtEnd) - 1;
        end;
      end
      else
      begin
        if not Imp then
        begin
          if Copy(txt, i, 14) = 'implementation' then
          begin
            Imp := True;
            Inc(i, 14-1);
          end;
        end
        else
        begin
          if Copy(txt, i, 2) = '//' then
          begin
            Cmt := True;
            CmtEnd := #13#10;
            Inc(i);
          end
          else if Copy(txt, i, 1) = '{' then
          begin
            Cmt := True;
            CmtEnd := '}';
          end
          else if Copy(txt, i, 2) = '(*' then
          begin
            Cmt := True;
            CmtEnd := '*)';
            Inc(i);
          end
          else if Copy(txt, i, 10) = 'procedure ' then
          begin
            SelStart := i - 1;
            Inc(i, 10);
            FindProc(ptProc);
          end
          else if Copy(txt, i, 09) = 'function ' then
          begin
            SelStart := i - 1;
            Inc(i, 9);
            FindProc(ptFctn);
          end;
        end;
      end;
      Inc(i);
    end;
    dlg.OnProcSelected := ProcListProcSelected;
    sstart := FSynEdit.SelStart;
    slen := FSynEdit.SelLength;
    tline := FSynEdit.TopLine;
    if not dlg.Execute then
    begin
      FSynEdit.SelStart := sstart;
      FSynEdit.SelLength := slen;
      FSynEdit.TopLine := tline;
    end;
  finally
    dlg.Free;
  end;
end;

procedure TToolsManager.ProcListProcSelected(ProcElement: TProcElement;
  Sender: TObject);
begin
  FSynEdit.SelStart := ProcElement.SelStart;
  FSynEdit.TopLine := ProcElement.Line;
end;

end.
