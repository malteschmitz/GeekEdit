unit uViewManager;

interface

uses
  Classes, Menus, SynEdit,

  SynHighlighterMulti, SynHighlighterPHP, SynHighlighterVBScript,
  SynHighlighterJScript, SynHighlighterHtml, SynEditHighlighter,
  SynHighlighterCSS, SynHighlighterPas, SynHighlighterIni, SynHighlighterTeX,
  SynHighlighterDfm, SynHighlighterAsm, SynHighlighterUNIXShellScript,
  SynHighlighterBat, SynHighlighterXML, SynHighlighterJava, SynHighlighterRuby;

type
  TViewManager = class
  private
    FSynEdit: TSynEdit;
    FCompOwner: TComponent;
    FViewMenu: TMenuItem;
    FOnSynHighlighterChange: TNotifyEvent;
    // file extension including the dot as unique entry of string list
    // matching highlighter as associated object
    FFileExtList: TStringList;

    procedure FileNameUpdate(Sender: TObject);
    function NewHighlighter(const MenuTitle: String; const Highlighter:
      TSynCustomHighlighter; const FileExts: array of String): TMenuItem;
    procedure SynMenuClick(Sender: TObject);
    procedure SetHighlighter(HighlighterName: String);
    function GetHighlighter: String;
    function GetSyntaxNames: string;
  public
    procedure IncFontMenuClick(Sender: TObject);
    procedure DecFontMenuClick(Sender: TObject);
    procedure NormalFontMenuClick(Sender: TObject);
    procedure WordWrapMenuClick(Sender: TObject);
    procedure ShowSpecialCharsMenuClick(Sender: TObject);

    function CanOpen(const FileName: String): Boolean;
    property SyntaxNames: string read GetSyntaxNames;
    
    constructor Create(const ASynEdit: TSynEdit; const AViewMenu: TMenuItem;
      const ACompOwner: TComponent);
    destructor Destroy; override;

    property SynHighlighter: String read GetHighlighter;
    property OnSynHighlighterChange: TNotifyEvent read FOnSynHighlighterChange write FOnSynHighlighterChange;
  end;

implementation

uses
  Graphics, SysUtils, uShare, StrUtils;

const
  FONT_SIZES: array[0..10] of Integer = (6, 8, 10, 12, 14, 16, 18, 20, 24, 28, 36);
  NORMAL_FONT_SIZE: Integer = 10;

{ TViewManager }

procedure TViewManager.DecFontMenuClick(Sender: TObject);
var
  i: Integer;
begin
  i := Low(FONT_SIZES);
  while (FSynEdit.Font.Size <> FONT_SIZES[i]) and (i < High(FONT_SIZES)) do
    Inc(i);
  if i > Low(FONT_SIZES) then
    Dec(i);
  FSynEdit.Font.Size := FONT_SIZES[i];
end;

destructor TViewManager.Destroy;
begin
  FFileExtList.Free;
  
  inherited;
end;

function TViewManager.GetHighlighter: String;
begin
  if Assigned(FSynEdit.Highlighter) then
    Result := FSynEdit.Highlighter.Name
  else
    Result := 'SynNon';
end;

function TViewManager.GetSyntaxNames: string;
var
  Highlighters, FileExts: TStringList;
  i, Index: Integer;
begin
  Result := 'verfügbare Highlighter'#13#10
          + '~~~~~~~~~~~~~~~~~~~~~~'#13#10#13#10;
  Highlighters := TStringList.Create;
  FileExts := TStringList.Create;
  try
    for i := 0 to FFileExtList.Count - 1 do
    begin
      if Assigned(FFileExtList.Objects[i]) then
        Index := Highlighters.IndexOf(TComponent(FFileExtList.Objects[i]).Name)
      else
        Index := Highlighters.IndexOf('SynNon');
      if Index > -1 then
        FileExts.Strings[Index] := FileExts.Strings[Index] + ', ' + FFileExtList.Strings[i]
      else
      begin
        FileExts.Append(FFileExtList.Strings[i]);
        if Assigned(FFileExtList.Objects[i]) then
          Highlighters.Append(TComponent(FFileExtList.Objects[i]).Name)
        else
          Highlighters.Append('SynNon');
      end;
    end;

    for i := 0 to Highlighters.Count - 1 do
      Result := Result + '* ' + Highlighters.Strings[i] + ' (' + FileExts.Strings[i] + ')'#13#10;
  finally
    Highlighters.Free;
    FileExts.Free;
  end;
end;

procedure TViewManager.IncFontMenuClick(Sender: TObject);
var
  i: Integer;
begin
  i := Low(FONT_SIZES);
  while (FSynEdit.Font.Size <> FONT_SIZES[i]) and (i < High(FONT_SIZES)) do
    Inc(i);
  if i < High(FONT_SIZES) then
    Inc(i);
  FSynEdit.Font.Size := FONT_SIZES[i];
end;

function TViewManager.NewHighlighter(const MenuTitle: String; const Highlighter:
      TSynCustomHighlighter; const FileExts: array of String): TMenuItem;
var
  i: Integer;
begin
  // create menu item
  Result := TMenuItem.Create(FCompOwner);
  with Result do
  begin
    Caption := MenuTitle;
    OnClick := SynMenuClick;
    HelpContext := 0;
    Checked := False;
    Enabled := True;
    if Assigned(Highlighter) then
    begin
      Name := Highlighter.Name + 'Menu';
      Tag := Integer(Highlighter);
    end
    else
    begin
      Name := 'SynNonMenu';
      Tag := 0;
    end;
    GroupIndex := 42;
    RadioItem := True;
  end;
  FViewMenu.Add(Result);

  // create FFlieExtList entries
  for i := 0 to Length(FileExts) - 1 do
    FFileExtList.Objects[FFileExtList.Add(FileExts[i])] := Highlighter;
end;

procedure TViewManager.NormalFontMenuClick(Sender: TObject);
begin
  FSynEdit.Font.Size := NORMAL_FONT_SIZE;
end;

function TViewManager.CanOpen(const FileName: String): Boolean;
begin
  Result := FFileExtList.IndexOf(ExtractFileExt(FileName)) > -1;
end;

constructor TViewManager.Create(const ASynEdit: TSynEdit;
  const AViewMenu: TMenuItem; const ACompOwner: TComponent);
var
  SynHtmlMulti: TSynMultiSyn;
  SynHtml: TSynHtmlSyn;
  SynCss: TSynCssSyn;
  SynJs: TSynJScriptSyn;
  SynVbs: TSynVBScriptSyn;
  SynPhp: TSynPhpSyn;
  SynPas: TSynPasSyn;
  SynIni: TSynIniSyn;
  SynJava: TSynJavaSyn;
  SynXml: TSynXMLSyn;
  SynBat: TSynBatSyn;
  SynSh: TSynUNIXShellScriptSyn;
  SynAsm: TSynAsmSyn;
  SynDfm: TSynDfmSyn;
  SynTex: TSynTeXSyn;
  SynRuby: TSynRubySyn;
  SynHtmlErbMulti: TSynMultiSyn;
  SynJsErbMulti: TSynMultiSyn;
begin
  FSynEdit := ASynEdit;
  FCompOwner := ACompOwner;
  FViewMenu := AViewMenu;
  FFileExtList := TStringList.Create;

  Share.AddFileNameUpdateListener(FileNameUpdate);

  // create SynEdit Highlighter
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~

  // keine Syntax
  NewHighlighter('keine Syntax', nil, ['.txt', '.log']).Checked := True;

  // CSS
  SynCss := TSynCssSyn.Create(ACompOwner);
  with SynCss do
  begin
    Name := 'SynCss';
    CommentAttri.Foreground := clGray;
    CommentAttri.Style := [fsItalic];
    KeyAttri.Foreground := clBlue;
    ValueAttri.Foreground := clGreen;
  end;

  // HTML
  SynHTML := TSynHTMLSyn.Create(ACompOwner);
  with SynHTML do
  begin
    Name := 'SynHTML';
    AndAttri.Foreground := clGreen;
    AndAttri.Style := [];
    CommentAttri.Foreground := clGray;
    CommentAttri.Style := [fsItalic];
    IdentifierAttri.Foreground := clNavy;
    KeyAttri.Foreground := clBlue;
    SymbolAttri.Foreground := clNavy;
    ValueAttri.Foreground := clGreen;
  end;

  // JavaScript
  SynJs := TSynJScriptSyn.Create(ACompOwner);
  with SynJs do
  begin
    Name := 'SynJs';
    CommentAttri.Foreground := clGray;
    IdentifierAttri.Foreground := clNavy;
    IdentifierAttri.Style := [fsBold];
    KeyAttri.Foreground := clBlue;
    StringAttri.Foreground := clGreen;
  end;

  // Visual Basic Script
  SynVbs := TSynVBScriptSyn.Create(ACompOwner);
  with SynVbs do
  begin
    Name := 'SynVbs';
    CommentAttri.Foreground := clGray;
    IdentifierAttri.Foreground := clNavy;
    IdentifierAttri.Style := [fsBold];
    KeyAttri.Foreground := clBlue;
    StringAttri.Foreground := clGreen;
  end;

  // PHP
  SynPhp := TSynPHPSyn.Create(ACompOwner);
  with SynPhp do
  begin
    Name := 'SynPhp';
    CommentAttri.Foreground := clGray;
    KeyAttri.Foreground := clBlue;
    StringAttri.Foreground := clGreen;
    VariableAttri.Foreground := clPurple;
  end;

  // HTML mit PHP, CSS, JavaScript und VBScript
  SynHtmlMulti := TSynMultiSyn.Create(ACompOwner);
  SynHtmlMulti.Name := 'SynHtmlMulti';
  with SynHtmlMulti.Schemes.Add as TScheme do begin
    CaseSensitive := False;
    StartExpr := '<style[^>]*?type="text/css"[^>]*?>';
    EndExpr := '</style>';
    Highlighter := SynCss;
    MarkerAttri.Background := clNone;
    MarkerAttri.Foreground := clGreen;
    SchemeName := 'CSS';
  end;
  with SynHtmlMulti.Schemes.Add as TScheme do begin
    CaseSensitive := False;
    StartExpr := '<style[^>]*?>';
    EndExpr := '</style>';
    Highlighter := SynCss;
    MarkerAttri.Background := clNone;
    MarkerAttri.Foreground := clRed;
    SchemeName := 'CSS short';
  end;
  with SynHtmlMulti.Schemes.Add as TScheme do begin
    CaseSensitive := False;
    StartExpr := '<script[^>]*?type="text/javascript"[^>]*?>';
    EndExpr := '</script>';
    Highlighter := SynJs;
    MarkerAttri.Background := clNone;
    MarkerAttri.Foreground := clGreen;
    SchemeName := 'JScript';
  end;
  with SynHtmlMulti.Schemes.Add as TScheme do begin
    CaseSensitive := False;
    StartExpr := '<script[^>]*?>';
    EndExpr := '</script>';
    Highlighter := SynJs;
    MarkerAttri.Background := clNone;
    MarkerAttri.Foreground := clRed;
    SchemeName := 'JScript short';
  end;
  with SynHtmlMulti.Schemes.Add as TScheme do begin
    CaseSensitive := False;
    StartExpr := '<\?php';
    EndExpr := '\?>';
    Highlighter := SynPhp;
    MarkerAttri.Background := clNone;
    MarkerAttri.Foreground := clGreen;
    SchemeName := 'PHP';
  end;
  with SynHtmlMulti.Schemes.Add as TScheme do begin
    CaseSensitive := False;
    StartExpr := '<\?';
    EndExpr := '\?>';
    Highlighter := SynPhp;
    MarkerAttri.Background := clNone;
    MarkerAttri.Foreground := clRed;
    SchemeName := 'PHP short';
  end;
  with SynHtmlMulti.Schemes.Add as TScheme do begin
    CaseSensitive := False;
    StartExpr := '<script[^>]*?type="text/vbscript"[^>]*?>';
    EndExpr := '</script>';
    Highlighter := SynVbs;
    MarkerAttri.Background := clNone;
    MarkerAttri.Foreground := clGreen;
    SchemeName := 'VBScript';
  end;
  SynHtmlMulti.DefaultHighlighter := SynHtml;
  SynHtmlMulti.DefaultLanguageName := 'HTML';

  NewHighlighter('HTML (mit PHP, JS, CSS && VBS)', SynHtmlMulti, ['.htm', '.html', '.php', '.php3', '.php4', '.php5', '.inc']);
  NewHighlighter('JavaScript', SynJs, ['.js']);
  NewHighlighter('CSS', SynCss, ['.css']);
  NewHighlighter('VBScript', SynVbs, ['.vbs']);

  // Pascal
  SynPas := TSynPasSyn.Create(ACompOwner);
  with SynPas do
  begin
    Name := 'SynPas';
    CommentAttri.Foreground := clGreen;
    KeyAttri.Foreground := clNavy;
    NumberAttri.Foreground := clBlue;
    FloatAttri.Foreground := clBlue;
    HexAttri.Foreground := clBlue;
    StringAttri.Foreground := clBlue;
    CharAttri.Foreground := clPurple;
  end;
  NewHighlighter('Pascal', SynPas, ['.pas', '.dpr']);

  // INI
  SynIni := TSynIniSyn.Create(ACompOwner);
  with SynIni do
  begin
    Name := 'SynIni';
    SectionAttri.Foreground := clBlue;
    KeyAttri.Foreground := clMaroon;
    NumberAttri.Foreground := clNavy;
    SymbolAttri.Foreground := clOlive;
    SymbolAttri.Style := [fsBold];
  end;
  NewHighlighter('INI', SynIni, ['.ini']);

  // Java
  SynJava := TSynJavaSyn.Create(ACompOwner);
  with SynJava do
  begin
    Name := 'SynJava';
  end;
  NewHighlighter('Java', SynJava, ['.java']);

  // XML
  SynXml := TSynXMLSyn.Create(ACompOwner);
  with SynXml do
  begin
    Name := 'SynXml';
    WantBracesParsed := False;
  end;
  NewHighlighter('XML', SynXml, ['.xml']);

  // Batch
  SynBat := TSynBatSyn.Create(ACompOwner);
  with SynBat do
  begin
    Name := 'SynBat';
  end;
  NewHighlighter('Windows Batch', SynBat, ['.bat']);

  // Unix Shell Script
  SynSh := TSynUNIXShellScriptSyn.Create(ACompOwner);
  with SynSh do
  begin
    Name := 'SynSh';
  end;
  NewHighlighter('Unix Shell', SynSh, ['.sh']);

  // Assembler
  SynAsm := TSynAsmSyn.Create(ACompOwner);
  with SynAsm do
  begin
    Name := 'SynAsm';
  end;
  NewHighlighter('Assembler', SynAsm, ['.asm']);

  // Delphi Form
  SynDfm := TSynDfmSyn.Create(ACompOwner);
  with SynDfm do
  begin
    Name := 'SynDfm';
  end;
  NewHighlighter('Dellphi Form', SynDfm, ['.dfm']);

  // TeX
  SynTex := TSynTeXSyn.Create(ACompOwner);
  with SynTex do
  begin
    Name := 'SynTex';
  end;
  NewHighlighter('TeX', SynTex, ['.tex']);

  // Ruby
  SynRuby := TSynRubySyn.Create(ACompOwner);
  with SynRuby do
  begin
    Name := 'SynRuby';
  end;
  NewHighlighter('Ruby', SynRuby, ['.rb']);

  // HTML mit Ruby (Embedded Ruby)
  SynHtmlErbMulti := TSynMultiSyn.Create(ACompOwner);
  SynHtmlErbMulti.Name := 'SynHtmlErbMulti';
  with SynHtmlErbMulti.Schemes.Add as TScheme do begin
    CaseSensitive := False;
    StartExpr := '<%';
    EndExpr := '%>';
    Highlighter := SynRuby;
    MarkerAttri.Background := clNone;
    MarkerAttri.Foreground := clGreen;
    SchemeName := 'Ruby';
  end;
  SynHtmlErbMulti.DefaultHighlighter := SynHtml;
  SynHtmlErbMulti.DefaultLanguageName := 'HTML';
  NewHighlighter('HTML && Ruby (ERB)', SynHtmlErbMulti, ['.html.erb', '.htm.erb']);

  // JavaScript mit Ruby (Embedded Ruby)
  SynJsErbMulti := TSynMultiSyn.Create(ACompOwner);
  SynJsErbMulti.Name := 'SynJsErbMulti';
  with SynJsErbMulti.Schemes.Add as TScheme do begin
    CaseSensitive := False;
    StartExpr := '<%';
    EndExpr := '%>';
    Highlighter := SynRuby;
    MarkerAttri.Background := clNone;
    MarkerAttri.Foreground := clGreen;
    SchemeName := 'Ruby';
  end;
  SynJsErbMulti.DefaultHighlighter := SynJs;
  SynJsErbMulti.DefaultLanguageName := 'JavaScript';
  NewHighlighter('JavaScript && Ruby (ERB)', SynJsErbMulti, ['.js.erb']);
end;

procedure TViewManager.SetHighlighter(HighlighterName: String);
var
  i: Integer;
begin
  HighlighterName := HighlighterName + 'Menu';
  for i := 0 to FViewMenu.Count - 1 do
    if FViewMenu.Items[i].Name = HighlighterName then
      FViewMenu.Items[i].Click;
  if Assigned(FOnSynHighlighterChange) then
    FOnSynHighlighterChange(Self);
end;

procedure TViewManager.ShowSpecialCharsMenuClick(Sender: TObject);
begin
  if Sender is TMenuItem then
    with Sender as TMenuItem, FSynEdit do
    begin
      Checked := not Checked;
      if Checked then
        Options := Options + [eoShowSpecialChars]
      else
        Options := Options - [eoShowSpecialChars];
    end;
end;

procedure TViewManager.FileNameUpdate(Sender: TObject);
var
  i: Integer;
begin
  // set highlighter depending on the new filename
  for i := 0 to FFileExtList.Count - 1 do
  begin
    if RightStr(Share.FileName, Length(FFileExtList.Strings[i])) = FFileExtList.Strings[i] then
    begin
      if Assigned(FFileExtList.Objects[i]) then
      begin
        SetHighlighter(TComponent(FFileExtList.Objects[i]).Name);
        Exit;
      end;
    end;
  end;
  SetHighlighter('SynNon');
end;

procedure TViewManager.SynMenuClick(Sender: TObject);
var
  MenuItem: TMenuItem;
  Highlighter: TSynCustomHighlighter;
begin
  if Sender is TMenuItem then
  begin
    MenuItem := Sender as TMenuItem;
    if MenuItem.Tag > 0 then
      Highlighter := TSynCustomHighlighter(MenuItem.Tag)
    else
      Highlighter := nil;
    FSynEdit.Highlighter := Highlighter;
    MenuItem.Checked := True;
    if Assigned(FOnSynHighlighterChange) then
      FOnSynHighlighterChange(Self);
  end;
end;

procedure TViewManager.WordWrapMenuClick(Sender: TObject);
begin
  if Sender is TMenuItem then
    with Sender as TMenuItem, FSynEdit do
    begin
      Checked := not Checked;
      WordWrap := Checked;
    end;
end;

end.
