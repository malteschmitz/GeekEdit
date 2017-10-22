unit uScriptManager;

interface

uses
  uScriptEditor, uScriptInterfaces, uPSI_uScriptInterfaces,
  Menus, Classes, SynEdit, uPSComponent, uPSComponent_Default;

type
  TScriptManager = class
  private
    Engine: TPSScript;

    FEditor: TScriptEditor;
    FTools: TScriptTools;

    FScriptFileName: String;
    FBatchToolFileName: String;

    procedure EngineCompile(Sender: TPSScript);
    procedure EngineExecute(Sender: TPSScript);
  public
    constructor Create(SynEdit: TSynEdit; MainMenu: TMenuItem;
      CompOwner: TComponent);
    destructor Destroy; override;
    property Editor: TScriptEditor read FEditor;
    property Tools: TScriptTools read FTools;
    property ScriptFileName: String read FScriptFileName;
    property BatchToolFileName: String read FBatchToolFileName;
  end;

implementation

uses
  Dialogs, uSysFolderLocation, SysUtils;

{ TScriptManager }

constructor TScriptManager.Create(SynEdit: TSynEdit; MainMenu: TMenuItem;
  CompOwner: TComponent);
var
  i: Integer;
  Msg: String;
  SysFolderLocation: TSysFolderLocation;
  ScriptFileName: array[0..6] of String;
begin
  Engine := TPSScript.Create(CompOwner);
  Engine.OnCompile := EngineCompile;
  Engine.OnExecute := EngineExecute;
  // import classes unit (e.g. for TStringList for text file handling)
  (Engine.Plugins.Add as TPSPluginItem).Plugin := TPSImport_Classes.Create(CompOwner);
  // import Editor, Programs and GUI class
  (Engine.Plugins.Add as TPSPluginItem).Plugin := TPSImport_uScriptInterfaces.Create(CompOwner);

  // load GeekEdit.pas into PSScript and GeekEdit.bat
  SysFolderLocation := TSysFolderLocation.Create(CSIDL_APPDATA);
  try
    FScriptFileName := SysFolderLocation.GetShellFolder;
    // %APPDATA%\de.schmitz-sh.malte\GeekEdit\GeekEdit
    ScriptFileName[0] := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(
      IncludeTrailingPathDelimiter(FScriptFileName) + 'de.schmitz-sh.malte')
      + 'GeekEdit') + 'GeekEdit';
    // %APPDATA%\de.schmitz-sh.malte\GeekEdit
    ScriptFileName[1] := IncludeTrailingPathDelimiter(
      IncludeTrailingPathDelimiter(FScriptFileName) + 'de.schmitz-sh.malte')
      + 'GeekEdit';
    // %APPDATA%\GeekEdit\GeekEdit
    ScriptFileName[2] := IncludeTrailingPathDelimiter(
      IncludeTrailingPathDelimiter(FScriptFileName)
      + 'GeekEdit') + 'GeekEdit';
    // %APPDATA%\GeekEdit
    ScriptFileName[3] :=
      IncludeTrailingPathDelimiter(FScriptFileName)
      + 'GeekEdit.pas';

    // %HOME%\GeekEdit\GeekEdit
    SysFolderLocation.CSIDL := CSIDL_PERSONAL;
    FScriptFileName := SysFolderLocation.GetShellFolder;
    ScriptFileName[4] := IncludeTrailingPathDelimiter(
      IncludeTrailingPathDelimiter(FScriptFileName)
      + 'GeekEdit') + 'GeekEdit';
    // %HOME%\GeekEdit
    ScriptFileName[5] :=
      IncludeTrailingPathDelimiter(FScriptFileName)
      + 'GeekEdit';
      
    // GeekEdit
    ScriptFileName[6] := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))
      + 'GeekEdit';
  finally
    SysFolderLocation.Free;
  end;

  i := 0;
  while not FileExists(ScriptFileName[i] + '.pas') and (i < High(ScriptFileName)) do
    Inc(i);
  FScriptFileName := ScriptFileName[i] + '.pas';

  i := 0;
  while not FileExists(ScriptFileName[i] + '.bat') and (i < High(ScriptFileName)) do
    Inc(i);
  FBatchToolFileName := ScriptFileName[i] + '.bat';

  FEditor := TScriptEditor.Create(Engine, SynEdit, MainMenu, CompOwner, FBatchToolFileName);
  FTools := TScriptTools.Create();

  Engine.Script.LoadFromFile(FScriptFileName);

  // compile the script
  if not Engine.Compile then
  begin
    Msg := 'Fehler beim Compilieren des Scriptes!' + #13#10;
    for i := 0 to Engine.CompilerMessageCount - 1 do
      Msg := Msg + Engine.CompilerMessages[i].MessageToString + #13#10;
    MessageDlg(Msg, mtError, [mbOk], 0);
  end
  else
  begin
    // execute the script
    if not Engine.Execute then
      MessageDlg('Fehler beim Ausführen des Scriptes!' + #13#10
        + Engine.ExecErrorToString, mtError, [mbOk], 0);
  end;

  // debugging & testing
  // ShowMessage(Engine.ExecuteFunction(['Hallo', 'Welt'], 'UserTag'));
end;

destructor TScriptManager.Destroy;
begin
  FTools.Free;
  FEditor.Free;
end;

procedure TScriptManager.EngineCompile(Sender: TPSScript);
begin
  with Sender do
  begin
    // add pointer to Editor, GUI and Programs
    AddRegisteredPTRVariable('Editor', 'TAbstractScriptEditor');
    AddRegisteredPTRVariable('Tools', 'TScriptTools');
  end;
end;

procedure TScriptManager.EngineExecute(Sender: TPSScript);
begin
  Sender.SetPointerToData('Editor', @FEditor, Sender.FindNamedType('TAbstractScriptEditor'));
  Sender.SetPointerToData('Tools', @FTools, Sender.FindNamedType('TScriptTools'));
end;

end.
