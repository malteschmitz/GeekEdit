unit uScriptEditor;

interface

uses
  Classes, SysUtils, Menus, Contnrs, SynEdit, uPSComponent, uScriptInterfaces,
  DFHotKey;

type
  TSaveEvent = procedure(Sender: TObject; var Result: Boolean) of object;
  TOutputUpdateEvent = procedure(Sender: TObject; const NewOutput: String;
    Running: Boolean) of object;
  EMenuNotFound = class(Exception);
  TCharSet = set of Char;

  TMenuList = class(TObject)
  private
    FObjList: TObjectList;
    function GetItem(Index: Integer): TMenuItem;
    procedure SetItem(Index: Integer; const Value: TMenuItem);
    function GetCount: Integer;
  public
    constructor Create(FirstItem: TMenuItem);
    destructor Destroy; override;
    procedure AddItem(Item: TMenuItem);
    property Items[Index: Integer]: TMenuItem read GetItem write SetItem; default;
    property Count: Integer read GetCount;
  end;

  TSyntaxCondMenuList = class(TStringList)
  public
    destructor Destroy; override;
    procedure AddSyntaxCondMenu(const Syntax: String; Menu: TMenuItem);
    function GetMenuList(const Syntax: String): TMenuList;
  end;

  TProcessThread = class(TThread)
  private
    FOnOutputUpdate: TOutputUpdateEvent;
    FStdInputPipeRead, FStdInputPipeWrite,
    FStdOutputPipeRead, FStdOutputPipeWrite: Cardinal;
    FProcessHandle, FProcessId: Cardinal;
    FBuffer: String;
    FBytesRead: Cardinal;
    FMessage: String;
    FKilled: Boolean;
    procedure SyncOutputUpdate;
    procedure SyncMessage;
    procedure WriteMessage(Message: String);
  protected
    procedure Execute; override;
  public
    constructor Create(AOnOutputUpdate: TOutputUpdateEvent;
      const ACommand: String; const AMessage: String = '');
    procedure KillProcess;
    procedure SendInput(const Input: String);
  end;

  TScriptEditor = class(TAbstractScriptEditor)
  private
    // Pscal Script Engine Component
    FEngine: TPSScript;
    // SynEdit of GeekEdit (needed for the scripts to manipulated)
    FSynEdit: TSynEdit;
    // Items of the main menu of the GeekEdit Gui where the JavaScripts are added
    FMainMenu: TMenuItem;
    // Owner of new menu items (needed to free the components automatically)
    FCompOwner: TComponent;
    // file name of the batch file containing the batch tool collection
    FBatchToolFileName: String;

    FOnSave: TSaveEvent;
    FOnOutputUpdate: TOutputUpdateEvent;

    // list of all conditional shortcut menus
    // menu stored as associated object; syntax as string entry
    // FCondShortCutList: TStringList;
    FSyntaxCondMenuList: TSyntaxCondMenuList;

    // list of all active chars
    // char stored as associated object; syntax=script as string entry
    FActiveCharList: TStringList;
    FActiveChars: TCharSet;

    FSyntax: String;

    FAppHotKey: TDFAppHotKey;

    FProcessThread: TProcessThread;

    procedure AppHotKey(Sender: TObject);

    function FindMenuItem(const MenuItem: TMenuItem;
      const Name: String): TMenuItem;
    function NewMenu(const ACaption: String;
      const AShortCut: TShortCut; const AOnClick: TNotifyEvent;
      const AName: String): TMenuItem;

    procedure MenuItemClick(Sender: TObject);

    procedure SetShortCut(const Menu: TMenuItem; const Enable: Boolean);
    procedure SetSynHighlighter(const Value: String);

  protected
    function GetCol: Integer; override;
    function GetRow: Integer; override;
    function GetSelLength: Integer; override;
    function GetSelStart: Integer; override;
    function GetSelText: String; override;
    function GetText: String; override;
    function GetCurLine: String; override;
    function GetFileName: String; override;
    function GetCurWord: String; override;

    procedure SetSelLength(const Value: Integer); override;
    procedure SetSelStart(const Value: Integer); override;
    procedure SetSelText(const Value: String); override;
    procedure SetText(const Value: String); override;

    procedure DoRegisterMenu(const ParentMenuName,
      NewMenuName, NewMenuTitle: String); override;
    procedure DoRegisterScript(const ParentMenuName,
      ScriptTitle, ShortCut, ProcName: String); override;
    procedure DoRegisterActiveCharScript(const c: Char; const SyntaxName,
      ProcName: String); override;
    procedure DoSetSyntaxConditionalShortcut(const SyntaxName,
      MenuName: String); override;
    procedure DoSetGlobalGeekEditHotKey(const AShortcut: String); override;
    function DoSave: Boolean; override;
    procedure DoRunConsoleApp(const ACommand: String);
      override;
    procedure DoRunConsoleBatchTool(const ACommand: String);
      override;
    procedure StartProcessThread(const ACommand: String; const AMessage: String = '');
  public
    property OnSave: TSaveEvent read FOnSave write FOnSave;
    property OnOutputUpdate: TOutputUpdateEvent read FOnOutputUpdate
      write FOnOutputUpdate;
    property SynHighlighter: String write SetSynHighlighter;
    property ActiveChars: TCharSet read FActiveChars;

    procedure ApplicationActivate(Sender: TObject);

    function ActiveCharPressed(c: Char): Boolean;

    procedure ConsoleAppKill;
    procedure ConsoleAppSendInput(const Input: String);

    constructor Create(Engine: TPSScript; SynEdit: TSynEdit;
      MainMenu: TMenuItem; CompOwner: TComponent; const BatchToolFileName: String);

    destructor Destroy; override;
  end;

implementation

uses
  Windows, Forms, Dialogs, Controls, uShare;

{ TScriptInterface }

function TScriptEditor.ActiveCharPressed(c: Char): Boolean;
var
  i: Integer;
begin
  Result := False;
  i := 0;
  while (i < FActiveCharList.Count) and not Result do
  begin
    if FActiveCharList.Objects[i] = TObject(Ord(c)) then
      if FActiveCharList.Names[i] = FSyntax then
      begin
        FEngine.ExecuteFunction([], FActiveCharList.ValueFromIndex[i]);
        Result := True;
      end;
    Inc(i);
  end;
end;

procedure TScriptEditor.AppHotKey(Sender: TObject);
begin
  SetForegroundWindow(Application.Handle);
end;

procedure TScriptEditor.ApplicationActivate(Sender: TObject);
begin
  if FAppHotKey.Enabled then
  begin
    FAppHotKey.Enabled := False;
    Share.TitlePrefix := '';
  end;
end;

constructor TScriptEditor.Create(Engine: TPSScript; SynEdit: TSynEdit;
  MainMenu: TMenuItem; CompOwner: TComponent; const BatchToolFileName: String);
begin
  Self.FEngine := Engine;
  Self.FSynEdit := SynEdit;
  Self.FMainMenu := MainMenu;
  Self.FCompOwner := CompOwner;
  Self.FBatchToolFileName := BatchToolFileName;
  FSyntaxCondMenuList := TSyntaxCondMenuList.Create;
  FActiveCharList := TStringList.Create;
  FActiveChars := [];
  FSyntax := 'SynNon';
  FAppHotKey := TDFAppHotKey.Create(CompOwner);
  FAppHotKey.Enabled := False;
  FAppHotKey.OnHotKey := AppHotKey;
  FProcessThread := nil;
end;

function TScriptEditor.FindMenuItem(const MenuItem: TMenuItem;
  const Name: String): TMenuItem;
var
  i: Integer;
begin
  if Name = '' then
    Result := MenuItem
  else
  begin
    Result := nil;
    i := 0;
    while (Result = nil) and (i < MenuItem.Count) do
    begin
      if MenuItem.Items[i].Name = Name then
        Result := MenuItem.Items[i]
      else
        Result := FindMenuItem(MenuItem.Items[i], Name);
      Inc(i);
    end;
  end;
end;

function TScriptEditor.GetCol: Integer;
begin
  Result := FSynEdit.CaretX;
end;

function TScriptEditor.GetCurLine: String;
begin
  Result := FSynEdit.Lines[GetRow - 1];
end;

function TScriptEditor.GetCurWord: String;
const
  WordChars = ['a'..'z', 'A'..'Z', '0'..'9', '-', '_'];

  function IsWordChar(const Text: String; const Pos: Integer): Boolean;
  begin
    Result := False;
    if Pos >= 1 then
      if Length(Text) >= Pos then
        Result := Text[Pos] in WordChars;
  end;

var
  first, last: Integer;
begin
  if FSynEdit.SelLength > 0 then
    Result := FSynEdit.SelText
  else
  begin
    // start with char after cursor
    first := FSynEdit.SelStart + 1;
    while IsWordChar(FSynEdit.Text, first - 1) do
      Dec(first);
    // start with char before cursor
    last := FSynEdit.SelStart;
    while IsWordChar(FSynEdit.Text, last + 1) do
      Inc(last);
    Result := Copy(FSynEdit.Text, first, last - first + 1);
  end;
end;

function TScriptEditor.GetFileName: String;
begin
  Result := Share.FileName;
end;

function TScriptEditor.GetRow: Integer;
begin
  Result := FSynEdit.CaretY;
end;

function TScriptEditor.GetSelLength: Integer;
begin
  Result := FSynEdit.SelLength;
end;

function TScriptEditor.GetSelStart: Integer;
begin
  Result := FSynEdit.SelStart;
end;

function TScriptEditor.GetSelText: String;
begin
  Result := FSynEdit.SelText;
end;

function TScriptEditor.GetText: String;
begin
  Result := FSynEdit.Text;
end;

procedure TScriptEditor.ConsoleAppKill;
begin
  if Assigned(FProcessThread) then
    FProcessThread.KillProcess;
end;

procedure TScriptEditor.ConsoleAppSendInput(const Input: string);
begin
  if Assigned(FProcessThread) then
    FProcessThread.SendInput(Input);
end;

function TScriptEditor.NewMenu(const ACaption: String;
  const AShortCut: TShortCut; const AOnClick: TNotifyEvent;
  const AName: String): TMenuItem;
begin
  Result := TMenuItem.Create(FCompOwner);
  with Result do
  begin
    Caption := ACaption;
    ShortCut := AShortCut;
    Tag := Integer(AShortCut);
    OnClick := AOnClick;
    HelpContext := 0;
    Checked := False;
    Enabled := True;
    Name := AName;
  end;
end;

destructor TScriptEditor.Destroy;
begin
  FActiveCharList.Free;
  FSyntaxCondMenuList.Free;

  inherited;
end;

procedure TScriptEditor.DoRegisterActiveCharScript(const c: Char;
  const SyntaxName, ProcName: String);
begin
  FactiveCharList.Objects[FActiveCharList.Add(SyntaxName
    + '=' + ProcName)] := TObject(Ord(c));
  Include(FActiveChars, c);
end;

procedure TScriptEditor.DoRegisterMenu(const ParentMenuName,
  NewMenuName, NewMenuTitle: String);
var
  NewMenu, ParentMenu: TMenuItem;
begin
  // find parent menu
  ParentMenu := FindMenuItem(FMainMenu, ParentMenuName);
  if not Assigned(ParentMenu) then
    raise EMenuNotFound.Create('Menü ' + ParentMenuName + ' nicht gefunden.');

  // create new menu item
  NewMenu := Self.NewMenu(NewMenuTitle, 0, nil, NewMenuName);

  // insert new menu item into menu
  ParentMenu.Add(NewMenu);
end;

procedure TScriptEditor.DoRegisterScript(const ParentMenuName, ScriptTitle,
  ShortCut, ProcName: String);
var
  NewItem, ParentMenu: TMenuItem;
begin
  // find parent menu
  ParentMenu := FindMenuItem(FMainMenu, ParentMenuName);
  if not Assigned(ParentMenu) then
    raise EMenuNotFound.Create('Menü "' + ParentMenuName + '" nicht gefunden.');

  // create new menu item
  // and store the ProcName as the name of the menu entry
  NewItem := Self.NewMenu(ScriptTitle, TextToShortCut(ShortCut), MenuItemClick, ProcName + 'ScriptMenu');

  // insert new menu item into MainMenu
  ParentMenu.Add(NewItem);
end;

procedure TScriptEditor.DoRunConsoleBatchTool(const ACommand: String);
begin
  StartProcessThread('cmd /C ""' + FBatchToolFileName + '" ' + ACommand + '"', ACommand);
end;

procedure TScriptEditor.DoRunConsoleApp(const ACommand: String);
begin
  StartProcessThread(ACommand);
end;

procedure TScriptEditor.MenuItemClick(Sender: TObject);
var
  MenuItem: TMenuItem;
begin
  if Sender is TMenuItem then
  begin
    MenuItem := Sender as TMenuItem;
    FSynEdit.BeginUndoBlock;
    FSynEdit.BeginUpdate;
    FEngine.ExecuteFunction([], Copy(MenuItem.Name, 1, Length(MenuItem.Name) - Length('ScriptMenu')));
    FSynEdit.EndUpdate;
    FSynEdit.EndUndoBlock;
    // ??? SetCaretInView
  end;
end;

procedure TScriptEditor.SetSelLength(const Value: Integer);
begin
  FSynEdit.SelLength := Value;
end;

procedure TScriptEditor.SetSelStart(const Value: Integer);
begin
  FSynEdit.SelStart := Value;
end;

procedure TScriptEditor.SetSelText(const Value: String);
begin
  FSynEdit.SelText := Value;
end;

procedure TScriptEditor.SetShortCut(const Menu: TMenuItem;
  const Enable: Boolean);
var
  i: Integer;
begin
  if Enable then
    Menu.ShortCut := TShortCut(Menu.Tag)
  else
    Menu.ShortCut := 0;
    
  for i := 0 to Menu.Count - 1 do
    if Menu.Items[i].Count > 0 then
      SetShortCut(Menu.Items[i], Enable)
    else if Enable then
      Menu.Items[i].ShortCut := TShortCut(Menu.Items[i].Tag)
    else
      Menu.Items[i].ShortCut := 0;
end;

procedure TScriptEditor.SetSynHighlighter(const Value: String);
var
  // i: Integer;
  // LHLStringList: TStringList;
  i: Integer;
  MenuList: TMenuList;
begin
  if FSyntax <> Value then
  begin
    MenuList := FSyntaxCondMenuList.GetMenuList(FSyntax);
    if Assigned(MenuList) then
      for i := 0 to MenuList.Count - 1 do
        SetShortCut(MenuList.Items[i], False);
    FSyntax := Value;
    MenuList := FSyntaxCondMenuList.GetMenuList(FSyntax);
    if Assigned(MenuList) then
      for i := 0 to MenuList.Count - 1 do
        SetShortCut(MenuList.Items[i], True);
  end;
  {LHLStringList := TStringList.Create;
  LHLStringList.Delimiter := ',';
  LHLStringList.QuoteChar := #0;
  try
    for i := 0 to FCondShortCutList.Count - 1 do
    begin
      LHLStringList.DelimitedText := FCondShortCutList.Strings[i];
      SetShortCut(TMenuItem(FCondShortCutList.Objects[i]),
        LHLStringList.IndexOf(Value) > 0);
    end;
  finally
    LHLStringList.Free;
  end;}
end;

function TScriptEditor.DoSave: Boolean;
begin
  if Assigned(FOnSave) then
    FOnSave(Self, Result);
end;

procedure TScriptEditor.DoSetGlobalGeekEditHotKey(const AShortcut: String);
var
  LKey: Word;
  LShiftState: TShiftState;
  LShortCut: TShortCut;
begin
  LShortCut := TextToShortCut(AShortcut);
  if LShortCut > 0 then
  begin
    ShortCutToKey(LShortCut, LKey, LShiftState);
    case LKey of
      Ord('A')..Ord('Z'):
        FAppHotKey.Key := DFHotKeys(LKey - Ord('A') + Ord(Key_A));
      Ord('0')..Ord('9'):
        FAppHotKey.Key := DFHotKeys(LKey - Ord('0') + Ord(Key_0));
      Ord(VK_F1)..Ord(VK_F12):
        FAppHotKey.Key := DFHotKeys(LKey - Ord(VK_F1) + Ord(Key_F1));
    end;
    if ssShift in LShiftState then
      FAppHotKey.Shift := True;
    if ssAlt in LShiftState then
      FAppHotKey.Alt := True;
    if ssCtrl in LShiftState then
      FAppHotKey.Ctrl := True;
    FAppHotKey.Enabled := True;
    Share.TitlePrefix := ShortCutToText(LShortCut);
  end;
end;

procedure TScriptEditor.DoSetSyntaxConditionalShortcut(const SyntaxName,
  MenuName: String);
var
  MenuItem: TMenuItem;
begin
  MenuItem := FindMenuItem(FMainMenu, MenuName);
  if Assigned(MenuItem) then
  begin
    FSyntaxCondMenuList.AddSyntaxCondMenu(SyntaxName, MenuItem);
    SetShortCut(MenuItem, False);
  end
  else
    raise EMenuNotFound.Create('Menü "' + MenuName + '" nicht gefunden.');
end;

procedure TScriptEditor.SetText(const Value: String);
var
  start, len: Integer;
begin
  start := FSynEdit.SelStart;
  len := FSynEdit.SelLength;
  FSynEdit.SelStart := 0;
  FSynEdit.SelLength := Length(FSynEdit.Text);
  FSynEdit.SelText := Value;
  FSynEdit.SelStart := start;
  FSynEdit.SelLength := len;
end;

procedure TScriptEditor.StartProcessThread(const ACommand: String; const AMessage: String = '');
begin
  if Assigned(FProcessThread) then
    if FProcessThread.Terminated then
      FreeAndNil(FProcessThread);

  if Assigned(FProcessThread) then
    if MessageDlg('Konsolenanwendung läuft noch. Nur eine '
      + 'Konsolenanwendung zur Zeit unterstützt.' + #13#10 + #13#10
      + 'Konsolenanwendung abbrechen um neue zu starten?', mtConfirmation,
      [mbYes, mbNo], 0) = mrYes then
    begin
      ConsoleAppKill;
      // wait on termination
      sleep(500);
      FreeAndNil(FProcessThread);
    end;

  if not Assigned(FProcessThread) then
  begin
    if AMessage = '' then
      FProcessThread := TProcessThread.Create(FOnOutputUpdate, ACommand, ACommand)
    else
      FProcessThread := TProcessThread.Create(FOnOutputUpdate, ACommand, AMessage);
  end;
end;

{ TPipeReadThread }

constructor TProcessThread.Create(AOnOutputUpdate: TOutputUpdateEvent;
  const ACommand: String; const AMessage: String = '');
var
  LStartupInfo: TStartupInfo;
  LProcessInfo: TProcessInformation;
  LSecurityAttr: TSECURITYATTRIBUTES;
  LSecurityDesc: TSecurityDescriptor;
begin
  inherited Create(True);

  FProcessHandle := 0;
  FOnOutputUpdate := AOnOutputUpdate;
  FKilled := False;

  FillChar(LSecurityDesc, SizeOf(LSecurityDesc), 0);
  InitializeSecurityDescriptor(@LSecurityDesc, SECURITY_DESCRIPTOR_REVISION);
  SetSecurityDescriptorDacl(@LSecurityDesc, True, nil, False);

  LSecurityAttr.nLength := SizeOf(LSecurityAttr);
  LSecurityAttr.lpSecurityDescriptor := @LSecurityDesc;
  LSecurityAttr.bInheritHandle := True;

  // create standard input pipe
  if CreatePipe(FStdInputPipeRead, FStdInputPipeWrite, @LSecurityAttr, 0) then
  begin
    // create standard output pipe
    if CreatePipe(FStdOutputPipeRead, FStdOutputPipeWrite, @LSecurityAttr, 0) then
    begin
      FillChar(LStartupInfo, SizeOf(LStartupInfo), 0);
      FillChar(LProcessInfo, SizeOf(LProcessInfo), 0);
      LStartupInfo.cb := SizeOf(LStartupInfo);
      LStartupInfo.hStdOutput := FStdOutputPipeWrite;
      LStartupInfo.hStdError := FStdOutputPipeWrite;
      LStartupInfo.hStdInput := FStdInputPipeRead;
      LStartupInfo.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
      LStartupInfo.wShowWindow := SW_HIDE;
      if CreateProcess(nil, PChar(ACommand), @LSecurityAttr, nil, True,
        0, nil, nil, LStartupInfo, LProcessInfo) then
      begin
        FProcessHandle := LProcessInfo.hProcess;
        FProcessId := LProcessInfo.dwProcessId;
        WriteMessage(AMessage);
        SetLength(FBuffer, 4000);
        // close standard output pipe write handle before reading
        CloseHandle(FStdOutputPipeWrite);
        Resume;
      end
      else
      begin
        // close standard output pipe
        CloseHandle(FStdOutputPipeRead);
        CloseHandle(FStdOutputPipeWrite);

        // close standard input pipe
        CloseHandle(FStdInputPipeRead);
        CloseHandle(FStdInputPipeWrite);
      end;
    end
    else
    begin
      // close standard input pipe   
      CloseHandle(FStdInputPipeRead);
      CloseHandle(FStdInputPipeWrite);
    end;
  end;
end;

procedure TProcessThread.Execute;
var
  ExitCode: Cardinal;
begin
  while not Terminated do
  begin
    if ReadFile(FStdOutputPipeRead, FBuffer[1], Length(FBuffer), FBytesRead, nil) then
      Synchronize(SyncOutputUpdate)
    else
      Terminate;
  end;

  // close standard output pipe
  CloseHandle(FStdOutputPipeRead);
  // FStdOutputPipeWrite allready closed in TProcessThread.Create

  // close standard input pipe
  CloseHandle(FStdInputPipeRead);
  CloseHandle(FStdInputPipeWrite);

  if FKilled then
    FMessage := 'Konsolenanwendung abgebrochen.'
  else
  begin
    GetExitCodeProcess(FProcessHandle, ExitCode);
    FMessage := 'Konsolenanwendung beendet mit ExitCode ' + IntToStr(ExitCode) + '.';
  end;
  Synchronize(SyncMessage);
end;

procedure TProcessThread.KillProcess;
begin
  if TerminateProcess(FProcessHandle, 0) then
    FKilled := True;
end;

procedure TProcessThread.SyncOutputUpdate;
var
  s: String;
begin
  if FBytesRead > 0 then
    if Assigned(FOnOutputUpdate) then
    begin
      s := Copy(FBuffer, 1, FBytesRead);
      OemToChar(PChar(s), PChar(s));
      FOnOutputUpdate(Self, s, not Terminated);
    end;
end;

procedure TProcessThread.WriteMessage(Message: String);
begin
   if Assigned(FOnOutputUpdate) then
    FOnOutputUpdate(Self, #13#10 + '>>> ' + Message + #13#10, not Terminated);
end;

procedure TProcessThread.SendInput(const Input: String);
var
  p, BytesWritten: Cardinal;
  res :Boolean;
begin
  p := 1;
  repeat
    BytesWritten := 0;
    res := WriteFile(FStdInputPipeWrite, Input[p], Cardinal(Length(Input)) - p + 1, BytesWritten, nil);
    inc(p, BytesWritten);
  until not res or (p > Cardinal(Length(Input)));
end;

procedure TProcessThread.SyncMessage;
begin
  WriteMessage(FMessage);
end;

{ TSyntaxCondMenuList }

procedure TSyntaxCondMenuList.AddSyntaxCondMenu(const Syntax: String;
  Menu: TMenuItem);
var
  Index: Integer;
begin
  Index := IndexOf(Syntax);
  if Index > -1 then
    TMenuList(Objects[Index]).AddItem(Menu)
  else
    Objects[Add(Syntax)] := TMenuList.Create(Menu);
end;

destructor TSyntaxCondMenuList.Destroy;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Objects[i].Free;
  inherited;
end;

function TSyntaxCondMenuList.GetMenuList(const Syntax: String): TMenuList;
var
  Index: Integer;
begin
  Index := IndexOf(Syntax);
  if Index > -1 then
    Result := TMenuList(Objects[Index])
  else
    Result := nil;
end;

{ TMenuList }

procedure TMenuList.AddItem(Item: TMenuItem);
begin
  FObjList.Add(Item);
end;

constructor TMenuList.Create(FirstItem: TMenuItem);
begin
  FObjList := TObjectList.Create(False);
  FObjList.Add(FirstItem);
end;

destructor TMenuList.Destroy;
begin
  FObjList.Free;
  inherited;
end;

function TMenuList.GetCount: Integer;
begin
  Result := FObjList.Count;
end;

function TMenuList.GetItem(Index: Integer): TMenuItem;
begin
  Result := TMenuItem(FObjList.Items[Index]);
end;

procedure TMenuList.SetItem(Index: Integer; const Value: TMenuItem);
begin
  FObjList.Items[Index] := Value;
end;

end.
