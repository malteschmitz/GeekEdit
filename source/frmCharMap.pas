unit frmCharMap;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, JvExGrids, JvCharMap, Menus, ComCtrls;

type
  TMalteJvCharMap = class(TJvCharMap)
  published
    property ColCount;
    property RowCount;
  end;
  // these properties are needed in CharMapForm.FitSize

  TGetUName = function(cCodwW: WideChar; pBufferW: PWideChar): integer; stdcall;

  TCharClickEvent = procedure(const c: String; Sender: TObject) of object;

  TCharMapForm = class(TForm)
    CharMapPopupMenu: TPopupMenu;
    HighlightInvalidMenu: TMenuItem;
    ShowZoomPanelMenu: TMenuItem;
    FontMenu: TMenuItem;
    ShowShadowMenu: TMenuItem;
    FilterMenu: TMenuItem;
    StyleMenu: TMenuItem;
    InsertMenu: TMenuItem;
    InsertZeichenMenu: TMenuItem;
    InsertHtmlMenu: TMenuItem;
    InsertUnicodeMenu: TMenuItem;
    InsertUnicodeHexMenu: TMenuItem;
    StatusBar: TStatusBar;
    StatusMenu: TMenuItem;
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StatusMenuClick(Sender: TObject);
    procedure JvCharMapSelectChar(Sender: TObject; AChar: WideChar);
    procedure FormCreate(Sender: TObject);
    procedure ShowShadowMenuClick(Sender: TObject);
    procedure FontMenuClick(Sender: TObject);
    procedure ShowZoomPanelMenuClick(Sender: TObject);
    procedure HighlightInvalidMenuClick(Sender: TObject);
    procedure JvCharMapKeyPress(Sender: TObject; var Key: Char);
    procedure JvCharMapDblClick(Sender: TObject);
    procedure FilterMenuItemClick(Sender: TObject);
    procedure FitSize;
    function GetUnicodeName(Zeichen: WideChar): string;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    GetUNameDllHandle: THandle;
    GetUName: TGetUName;
    FOnCharClick: TCharClickEvent;
    FOnCharMapClose: TNotifyEvent;
  public
    JvCharMap: TMalteJvCharMap;
    property OnCharClick: TCharClickEvent read FOnCharClick write FOnCharClick;
    property OnCharMapClose: TNotifyEvent read FOnCharMapClose write FOnCharMapClose;
  end;

var
  CharMapForm: TCharMapForm;

implementation

{$R *.dfm}

uses
  StdCtrls, uUnicodeTables;

function DoUnicodeHex(Zeichen: WideChar): string;
begin
  {Hxedezimal HTML-Entity für das Unicode-Zeichen zurückgeben}
  Result := '&#x' + IntToHex(Ord(Zeichen), 2) + ';';
end;

function DoUnicode(Zeichen: WideChar): string;
begin
  {Dezimale HTML-Entity für das Unicode-Zeichen zurückgeben}
  Result := '&#' + IntToStr(Ord(Zeichen)) + ';';
end;

function DoHtmlName(Zeichen: WideChar): string;
var
  i: Integer;
begin
  {benannte HTML-Entity für das Unicode-Zeichen zurückgeben}
  Result := '';
  //In der HtmlNameTable nach dem Zeichen suchen:
  for i := Low(HtmlNameTable) to High(HtmlNameTable) do
    if HtmlNameTable[i].Zeichen = Zeichen then
    begin
      Result := HtmlNameTable[i].HtmlName;
      break;
    end;
  //Wenn das Zeichen nicht gefunden wurde, dezimale HTML-Entity
  //für das Unicode-Zeichen zurückgeben
  if Result = '' then
    Result := DoUnicode(Zeichen);
end;

procedure TCharMapForm.JvCharMapDblClick(Sender: TObject);
begin
  {Passend zu den Einstellungen im PopupMenu das aktuelle Zeichen in
  SynEdit einfügen}
  if Assigned(FOnCharClick) then
  begin
    if InsertZeichenMenu.Checked then
      FOnCharClick(JvCharMap.Character, Self)
  else if InsertUnicodeMenu.Checked then
      FOnCharClick(DoUnicode(JvCharMap.Character), Self)
  else if InsertUnicodeHexMenu.Checked then
      FOnCharClick(DoUnicodeHex(JvCharMap.Character), Self)
  else if InsertHtmlMenu.Checked then
      FOnCharClick(DoHtmlName(JvCharMap.Character), Self);
  end;
end;

procedure TCharMapForm.JvCharMapKeyPress(Sender: TObject; var Key: Char);
begin
  {Bei einem Return wie bei einem Doppelclick verhalten}
  if Key = #13 then
  begin
    JvCharMapDblClick(Sender);
    Key := #0;
  end;
end;

procedure TCharMapForm.HighlightInvalidMenuClick(Sender: TObject);
begin
  {Option HighlightInvalid ein-/ausschalten}
  JvCharMap.HighlightInvalid := (Sender as TMenuItem).Checked;
end;

procedure TCharMapForm.ShowZoomPanelMenuClick(Sender: TObject);
begin
  {Option ShowZoomPanel ein-/ausschalten}
  JvCharMap.ShowZoomPanel := (Sender as TMenuItem).Checked;
end;

procedure TCharMapForm.FontMenuClick(Sender: TObject);
var
  dlg: TFontDialog;
begin
  {Schriftart von JvCharMap über einen FontDialog ändern}
  dlg := TFontDialog.Create(Self); //Dialog wird nur hier gebraucht
  try
    dlg.Font.Assign(JvCharMap.Font); //dem Dialog den alten Font zuweisen
    if dlg.Execute then
      JvCharMap.Font.Assign(dlg.Font); //den neuen Font übernehmen
  finally
    dlg.Free;
  end;
  {Größe der Form an die von JvCharMap benötigte anpassen}
  FitSize;
end;

procedure TCharMapForm.ShowShadowMenuClick(Sender: TObject);
begin
  {Option ShowShadow ein-/ausblenden}
  JvCharMap.ShowShadow := (Sender as TMenuItem).Checked;
end;

procedure TCharMapForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {Es muss sichergestellt werden, dass das Panel nict mehr sichtbar ist, nachdem
  die Form geschlossen wurde, da das Panel sonst auch ohne JvCharMap weiterhin
  zu sehen ist}
  JvCharMap.PanelVisible := False;

  if Assigned(FOnCharMapClose) then
    FOnCharMapClose(Self);
end;

procedure TCharMapForm.FormCreate(Sender: TObject);
var
  i: TJvCharMapUnicodeFilter;
begin
  {DLL laden}
  GetUNameDllHandle := LoadLibrary(PChar('getuname.dll'));
  @GetUName := nil;
  if GetUNameDllHandle <> 0 then
    @GetUName := GetProcAddress(GetUNameDllHandle, 'GetUName');

  {JvCharMap erstellen}
  JvCharMap := TMalteJvCharMap.Create(Self);
  with JvCharMap do
  begin
    Name := 'JvCharMap';
    Parent := Self;
    Left := 0;
    Top := 0;
    Width := 426;
    Height := 293;
    Col := 0;
    Row := 0;
    Align := alClient;
    Font.Charset := ANSI_CHARSET;
    Font.Color := clWindowText;
    Font.Height := -16;
    Font.Name := 'Verdana';
    Font.Style := [];
    ParentFont := False;
    PopupMenu := CharMapPopupMenu;
    TabOrder := 1;
    OnSelectChar := JvCharMapSelectChar;
    OnDblClick := JvCharMapDblClick;
    OnKeyPress := JvCharMapKeyPress;
  end;

  {Gruppierung-Menü erstellen}
  FilterMenu.Clear;
  for i := Low(FilterTable) to High(FilterTable) do
  begin
    FilterMenu.Add(NewItem(FilterTable[i].Name, 0, False, True, FilterMenuItemClick, 0, ''));
    FilterMenu.Items[Ord(i)].Tag := Ord(FilterTable[i].Value); //wird verwendet um in OnClick das passende Filter zu finden
    FilterMenu.Items[Ord(i)].AutoCheck := True;
    FilterMenu.Items[Ord(i)].GroupIndex := 1;
    FilterMenu.Items[Ord(i)].RadioItem := True;
  end;
  FilterMenu.Items[0].Checked := True; //ersten Eintrag markieren

  {StatusBar aktualisieren}
  JvCharMapSelectChar(Sender, JvCharMap.Character);
end;

procedure TCharMapForm.FilterMenuItemClick(Sender: TObject);
begin
  {zum geclickten Menüeintrag gehörenden Filter setzen}
  with Sender as TMenuItem do
    JvCharMap.CharRange.Filter := TJvCharMapUnicodeFilter(Tag);
  {Größe der Form an die von JvCharMap benötigte anpassen}
  FitSize;
  {StatusBar aktualisieren}
  JvCharMapSelectChar(Sender, JvCharMap.Character);
end;

function TCharMapForm.GetUnicodeName(Zeichen: WideChar): string;
var
  Buffer: PWideChar;
begin
  Result := '';
  if @GetUName <> nil then
  begin
    GetMem(Buffer, 256 * SizeOf(WideChar));
    try
      Buffer^ := #0;
      GetUName(Zeichen, Buffer);
      Result := Buffer;
    finally
      FreeMem(Buffer);
    end;
  end;
end;

procedure TCharMapForm.JvCharMapSelectChar(Sender: TObject; AChar: WideChar);
var
  i: Integer;
begin
  {Infos zum aktuellen Zeichen in der StatusBar anzeigen}
  with StatusBar do
  begin
    Panels[0].Text := AChar;                     //das Zeichen
    Panels[1].Text := IntToStr(Ord(AChar));      //HEX
    Panels[2].Text := IntToHex(Ord(AChar), 2);   //DEZ
    Panels[3].Text := DoHtmlName(AChar);         //HTML-Entity
    Panels[4].Text := GetUnicodeName(AChar);     //Beschreibung
    {leere Panels "ausblenden"}
    for i := 0 to 4 do
      if Panels[i].Text > '' then
        Panels[i].Bevel := pbLowered
      else
        Panels[i].Bevel := pbNone;
  end;
end;

procedure TCharMapForm.StatusMenuClick(Sender: TObject);
const
  BorderStyleFlags: array[Boolean] of TBorderStyle = (bsNone, bsSingle);
begin
  {StatusBar ein-/ausblenden}
  StatusBar.Visible := (Sender as TMenuItem).Checked;
  {Passend dazu die Borderstyle von JvCharMap ändern}
  JvCharMap.BorderStyle := BorderStyleFlags[StatusBar.Visible];
end;

procedure TCharMapForm.FitSize;
begin
  {Größe der Form an die von JvCharMap benötigte anpassen}
  ClientWidth := JvCharMap.ColCount * (JvCharMap.ColWidths[0] + 1) + 3;
  ClientHeight := JvCharMap.RowCount * (JvCharMap.RowHeights[0] + 1) + 3;
  //Wenn die StatusBar zu sehen ist, braucht auch diese Platz
  if StatusBar.Visible then
    ClientHeight := ClientHeight + StatusBar.Height;
  {ACHTUNG: ColCount und RowCount sind nur in TMalteJvCharMap published.
  In TJvCharMap sind diese Eigenschaften protected
  Dies ist auch die einzige neuerung in TMaleJvCharMap}
end;

procedure TCharMapForm.FormShow(Sender: TObject);
begin
  {Größe der Form an die von JvCharMap benötigte anpassen}
  FitSize;
end;

procedure TCharMapForm.FormDestroy(Sender: TObject);
begin
  if GetUNameDllHandle <> 0 then
    FreeLibrary(GetUNameDllHandle);
  @GetUName := nil;
end;

end.
