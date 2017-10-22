unit uScriptInterfaces;

interface

type
  TAbstractScriptEditor = class
  protected
    function GetCol: Integer; virtual; abstract;
    function GetRow: Integer; virtual; abstract;
    function GetSelLength: Integer; virtual; abstract;
    function GetSelStart: Integer; virtual; abstract;
    function GetSelText: String; virtual; abstract;
    function GetText: String; virtual; abstract;
    function GetCurLine: String; virtual; abstract;
    function GetFileName: String; virtual; abstract;
    function GetCurWord: String; virtual; abstract;

    procedure SetSelLength(const Value: Integer); virtual; abstract;
    procedure SetSelStart(const Value: Integer); virtual; abstract;
    procedure SetSelText(const Value: String); virtual; abstract;
    procedure SetText(const Value: String); virtual; abstract;

    // looks like Pascal Script Unit Importer does not support virtual
    // abstract methods very well -- so they are wrapped
    procedure DoRegisterMenu(const ParentMenuName,
      NewMenuName, NewMenuTitle: String); virtual; abstract;
    procedure DoRegisterScript(const ParentMenuName,
      ScriptTitle, ShortCut, ProcName: String); virtual; abstract;
    procedure DoRegisterActiveCharScript(const c: Char; const SyntaxName,
      ProcName: String); virtual; abstract;
    procedure DoSetSyntaxConditionalShortcut(const SyntaxName,
      MenuName: String); virtual; abstract;
    procedure DoSetGlobalGeekEditHotKey(const AShortcut: String); virtual;
      abstract;
    function DoSave: Boolean; virtual; abstract;
    procedure DoRunConsoleApp(const Command: String); virtual; abstract;
    procedure DoRunConsoleBatchTool(const Command: String); virtual; abstract;
  public
    { register a new menu entry without function -- can be used as parent menu }
    procedure RegisterMenu(const ParentMenuName,
      NewMenuName, NewMenuTitle: String);
    { registers a new JavaScript in the editor
      @param ParentMenuName   Delphi VCL Name of the parent menu where
                              the new menu will be inserted
      @param ScriptTitle   Caption of the menu entry
      @param ShortCut   Shortcut of the menu entry, will be
                        parsed using TextToShortCut routine
      @param ProcName   Name of the procedure in the script that is called when
                        the item is activated (click or shortcut)}
    procedure RegisterScript(const ParentMenuName, ScriptTitle,
      ShortCut, ProcName: String);
    procedure RegisterActiveCharScript(const c: Char; const SyntaxName,
      ProcName: String);
    { marks a menu and all submenus as conditional
      that means shortcuts of this menu and all submenus are only in effect if
      the sepcified syntax is choosen }
    procedure SetSyntaxConditionalShortcut(const SyntaxName,
      MenuName: String);
    procedure SetGlobalGeekEditHotKey(const Shortcut: String);
    function Save: Boolean;
    procedure RunConsoleApp(const Command: String);
    procedure RunConsoleBatchTool(const Command: String);

    property FileName: String read GetFileName;
    property Col: Integer read GetCol;
    property Row: Integer read GetRow;
    property SelText: String read GetSelText write SetSelText;
    property SelStart: Integer read GetSelStart write SetSelStart;
    property SelLength: Integer read GetSelLength write SetSelLength;
    property Text: String read GetText write SetText;
    property CurLine: String read GetCurLine;
    property CurWord: String read GetCurWord;
  end;

  TScriptTools = class
  public
    procedure ShowMessage(const Message: String);
    procedure ShowErrorMessage(const Message: String);
    function InputDlg(const Message: String; var Value: String): Boolean;
    function YesNoDlg(const Message: String): Boolean;
    function OpenFileDialog(const Caption: String): String;
    function OpenPictureDialog(const Caption: String): String;
    function RadioDialog(const Items: String): Integer;

    function StringReplace(const S, OldPattern, NewPattern: String;
      const IgnoreCase: Boolean): String;
    function Format(const Format: string; const Args: array of const): string;
    function FormatDateTime(const Format: string; DateTime: Double): string;
    function Now: Double;
    function Trim(const s: String): String;
    function TrimLeft(const s: String): String;
    function TrimRight(const s: String): String;
    procedure GetImageDimensions(const FileName: String; var width, height: Integer);
    function CreateLink(const NewFileName: String; BaseFileName: String): String;
    function ExtractFilePath(const FileName: String): String;
    function ExtractFileName(const FileName: String): String;
    // without the dot!
    function ExtractFileExt(const FileName: String): String;
    // without the dot!
    function ExtractFileBase(const FileName: String): String;
    // give new extension without the dot!
    function ChangeFileExt(const FileName, NewExt: String): String;

    procedure RunApp(const Command: String);
    function FindApp(const AFileName, ACaption: String): LongWord;
    procedure BringAppToFront(const Handle: LongWord);
    procedure InvokeKeystroke(const Handle: LongWord; const Shortcut: String);
    procedure ShellExecute(const Verb, FileName: String);
  end;

implementation

uses
  Windows, Classes, Dialogs, Controls, SysUtils, Graphics, jpeg, GifImage,
  pngimage, ExtDlgs, Menus, ShellApi, dlgRadio, uFindApp;

{ TScriptGui }

procedure TScriptTools.BringAppToFront(const Handle: LongWord);
begin
  SetForegroundWindow(Handle);
end;

function TScriptTools.ChangeFileExt(const FileName, NewExt: String): String;
begin
  Result := SysUtils.ExtractFileExt(FileName);
  Result := Copy(FileName, 1, Length(FileName) - Length(Result));
  if Copy(Result, Length(Result), 1) <> '.' then
    Result := Result + '.';
  Result := Result + NewExt;
end;

function TScriptTools.CreateLink(const NewFileName: String; BaseFileName: string): String;
begin
  if BaseFileName <> '' then
    BaseFileName := ExtractFilePath(BaseFileName)
  else                                             
    BaseFileName := ExtractFilePath(ParamStr(0));

  Result := Self.StringReplace(ExtractRelativePath(BaseFileName, NewFileName), '\', '/', False);
end;

function TScriptTools.ExtractFileBase(const FileName: String): String;
begin
  Result := SysUtils.ExtractFileName(FileName);
  Result := Copy(Result, 1, Length(Result)
    - Length(SysUtils.ExtractFileExt(Result)));
end;

function TScriptTools.ExtractFileExt(const FileName: String): String;
begin
  Result := SysUtils.ExtractFileExt(FileName);
  if Copy(Result, 1, 1) = '.' then
    Delete(Result, 1, 1);
end;

function TScriptTools.ExtractFileName(const FileName: String): String;
begin
  Result := SysUtils.ExtractFileName(FileName);
end;

function TScriptTools.ExtractFilePath(const FileName: String): String;
begin
  // new at 2011-01-13: ExcludeTrailingPathDelimiter to make pdflatex -output-directory happy
  Result := SysUtils.ExcludeTrailingPathDelimiter(SysUtils.ExtractFilePath(FileName));
end;

function TScriptTools.FindApp(const AFileName, ACaption: String): LongWord;
begin
  Result := uFindApp.FindApp(ExtractFileName(AFileName), ACaption);
end;

function TScriptTools.Format(const Format: string;
  const Args: array of const): string;
begin
  Result := SysUtils.Format(Format, Args);
end;

function TScriptTools.FormatDateTime(const Format: string;
  DateTime: Double): string;
begin
  Result := SysUtils.FormatDateTime(Format, DateTime);
end;

procedure TScriptTools.GetImageDimensions(const FileName: String; var Width,
  Height: Integer);
var
  Bild: TPicture;
begin
  Bild := TPicture.Create;
  try
    try
      Bild.LoadFromFile(FileName);
      Width := Bild.Width;
      Height := Bild.Height;
    finally
      Bild.Free;
    end;
  except
    Width := 0;
    Height := 0;
  end;
end;

function TScriptTools.InputDlg(const Message: String; var Value: String): Boolean;
begin
  Result := Dialogs.InputQuery('GeekEdit', Message, Value);
end;

procedure TScriptTools.InvokeKeystroke(const Handle: LongWord;
  const Shortcut: String);
var
  Key: Word;
  ShiftState: TShiftState;
begin
  ShortCutToKey(TextToShortCut(ShortCut), Key, ShiftState);
  SetForegroundWindow(Handle);
  sleep(100);
  if ssShift in ShiftState then
    keybd_event(VK_SHIFT, 0, 0, 0);
  if ssAlt in ShiftState then
    keybd_event(VK_MENU, 0, 0, 0);
  if ssCtrl in ShiftState then
    keybd_event(VK_LCONTROL, 0, 0, 0);
  keybd_event(Ord(Key), 0, 0, 0);
  keybd_event(Ord(Key), 0, KEYEVENTF_KEYUP, 0);
  if ssCtrl in ShiftState then
    keybd_event(VK_LCONTROL, 0, KEYEVENTF_KEYUP, 0);
  if ssAlt in ShiftState then
    keybd_event(VK_MENU, 0, KEYEVENTF_KEYUP, 0);
  if ssShift in ShiftState then
    keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
end;

function TScriptTools.Now: Double;
begin
  Result := SysUtils.Now;
end;

function TScriptTools.OpenFileDialog(const Caption: String): String;
var
  dlg: TOpenDialog;
begin
  Result := '';
  dlg := TOpenDialog.Create(nil);
  try
    dlg.Title := Caption;
    dlg.Options := [ofHideReadOnly, ofFileMustExist, ofEnableSizing];
    dlg.OptionsEx := [];
    if dlg.Execute then
      Result := dlg.FileName;
  finally
    dlg.Free;
  end;
end;

function TScriptTools.OpenPictureDialog(const Caption: String): String;
var
  dlg: TOpenPictureDialog;
begin
  Result := '';
  dlg := TOpenPictureDialog.Create(nil);
  try
    dlg.Title := Caption;
    dlg.Options := [ofHideReadOnly, ofFileMustExist, ofEnableSizing];
    dlg.OptionsEx := [];
    if dlg.Execute then
      Result := dlg.FileName;
  finally
    dlg.Free;
  end;

end;

function TScriptTools.RadioDialog(const Items: String): Integer;
var
  dlg: TRadioDialog;
begin
  dlg := TRadioDialog.Create(nil);
  try
    dlg.RadioGroup.Items.Text := Items;
    dlg.RadioGroup.ItemIndex := 0;
    if dlg.ShowModal = mrOk then
      Result := dlg.RadioGroup.ItemIndex
    else
      Result := -1;
  finally
    dlg.Free;
  end;
end;

procedure TScriptTools.RunApp(const Command: String);
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  FillChar(StartupInfo, SizeOf(StartupInfo), #0); 
  StartupInfo.cb := SizeOf(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := SW_SHOWNORMAL;
  CreateProcess(nil, 
    PChar(Command),
    nil,
    nil,
    False,
    CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS,
    nil,
    nil,
    StartupInfo,
    ProcessInfo);
end;

procedure TScriptTools.ShellExecute(const Verb, FileName: String);
var
  sei: ShellExecuteInfo;
begin
  FillChar(sei, SizeOf(sei), 0);
  sei.cbSize := SizeOf(sei);
  sei.lpFile := PChar(FileName);
  sei.lpVerb := PChar(Verb);
  sei.nShow := SW_SHOWNORMAL;
  sei.fMask  := SEE_MASK_INVOKEIDLIST;
  ShellExecuteEx(@sei);
end;

procedure TScriptTools.ShowErrorMessage(const Message: String);
begin
  Dialogs.MessageDlg(Message, mtWarning, [mbOk], 0);
end;

procedure TScriptTools.ShowMessage(const Message: String);
begin
  Dialogs.MessageDlg(Message, mtInformation, [mbOk], 0);
end;

function TScriptTools.StringReplace(const S, OldPattern, NewPattern: String;
  const IgnoreCase: Boolean): String;
var
  Flags: TReplaceFlags;
begin
  if IgnoreCase then
    Flags := [rfIgnoreCase, rfReplaceAll]
  else
    Flags := [rfReplaceAll];
  Result := SysUtils.StringReplace(S, OldPattern, NewPattern, Flags);
end;

function TScriptTools.Trim(const s: String): String;
begin
  Result := SysUtils.Trim(s);
end;

function TScriptTools.TrimLeft(const s: String): String;
begin
  Result := SysUtils.TrimLeft(s);
end;

function TScriptTools.TrimRight(const s: String): String;
begin
  Result := SysUtils.TrimRight(s);
end;

function TScriptTools.YesNoDlg(const Message: String): Boolean;
begin
  Result := Dialogs.MessageDlg(Message, mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes;
end;

{ TAbstractScriptEditor }

procedure TAbstractScriptEditor.RegisterActiveCharScript(const c: Char;
  const SyntaxName, ProcName: String);
begin
  DoRegisterActiveCharScript(c, SyntaxName, ProcName);
end;

procedure TAbstractScriptEditor.RegisterMenu(const ParentMenuName, NewMenuName,
  NewMenuTitle: String);
begin
  DoRegisterMenu(ParentMenuName, NewMenuName, NewMenuTitle);
end;

procedure TAbstractScriptEditor.RegisterScript(const ParentMenuName,
  ScriptTitle, ShortCut, ProcName: String);
begin
  DoRegisterScript(ParentMenuName, ScriptTitle, ShortCut, ProcName);
end;

procedure TAbstractScriptEditor.RunConsoleApp(const Command: String);
begin
  DoRunConsoleApp(Command);
end;

procedure TAbstractScriptEditor.RunConsoleBatchTool(const Command: String);
begin
  DoRunConsoleBatchTool(Command);
end;

function TAbstractScriptEditor.Save: Boolean;
begin
  Result := DoSave;
end;

procedure TAbstractScriptEditor.SetGlobalGeekEditHotKey(const Shortcut: String);
begin
  DoSetGlobalGeekEditHotKey(Shortcut);
end;

procedure TAbstractScriptEditor.SetSyntaxConditionalShortcut(const SyntaxName,
  MenuName: String);
begin
  DoSetSyntaxConditionalShortcut(SyntaxName, MenuName);
end;

end.
