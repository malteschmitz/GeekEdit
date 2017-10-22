unit frmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uTestClass,

  // Pascal Script
  uPSComponent, uPSComponent_Default, uPSComponent_Controls,
  uPSComponent_StdCtrls, uPSCompiler, uPSUtils, uPSI_uTestClass;

type
  TTestFunction = function(a: String; b: String): String of object;

  TMainForm = class(TForm)
    CompileRunBtn: TButton;
    Memo1: TMemo;
    FunctTestBtn: TButton;
    EasyFunc: TButton;
    procedure CompileRunBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PSScriptCompile(Sender: TPSScript);
    procedure PSScriptVerifyProc(Sender: TPSScript;
                              Proc: TPSInternalProcedure;
                              const Decl: String;
                              var Error: Boolean);
    procedure PSScriptExecute(Sender: TPSScript);
    procedure FunctTestBtnClick(Sender: TObject);
    procedure EasyFuncClick(Sender: TObject);
  public
    PSScript: TPSScript;
    TestClass: TTestClass;
    procedure ShowNewMessage(const Message: String);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.CompileRunBtnClick(Sender: TObject);
var
  messages: String;
  compiled: Boolean;
  i: Integer;
begin
  PSScript.Script.Text := Memo1.Text;
  Compiled := PSScript.Compile;
  for i := 0 to PSScript.CompilerMessageCount -1 do
    Messages := Messages +
                PSScript.CompilerMessages[i].MessageToString +
                #13#10;
  if Compiled then
    Messages := Messages + 'Succesfully compiled'#13#10;
  ShowMessage(Messages);
  if Compiled then begin
    if PSScript.Execute then
      ShowMessage('Succesfully Executed')
    else
      ShowMessage('Error while executing script: '+
                  PSScript.ExecErrorToString);
  end;
end;

procedure TMainForm.FunctTestBtnClick(Sender: TObject);
var
  i: Integer;
  Msg: String;
  TestFunction: TTestFunction;
begin
  PSScript.Script.Text := Memo1.Text;
  if not PSScript.Compile then
  begin
    Msg := 'Fehler beim Compilieren des Scriptes!' + #13#10;
    for i := 0 to PSScript.CompilerMessageCount - 1 do
      Msg := Msg + PSScript.CompilerMessages[i].MessageToString + #13#10;
    MessageDlg(Msg, mtError, [mbOk], 0);
  end
  else
  begin
    TestFunction := TTestFunction(PSScript.GetProcMethod('TestFunction'));
    if Assigned(@TestFunction) then
      ShowMessage(TestFunction('Hase', 'Igel'))
    else
      MessageDlg('Fehler beim finden der Funktion TestFunction!', mtError, [mbOk], 0);
  end;
end;

procedure TMainForm.EasyFuncClick(Sender: TObject);
var
  i: Integer;
  Msg: String;
begin
  PSScript.Script.Text := Memo1.Text;
  if not PSScript.Compile then
  begin
    Msg := 'Fehler beim Compilieren des Scriptes!' + #13#10;
    for i := 0 to PSScript.CompilerMessageCount - 1 do
      Msg := Msg + PSScript.CompilerMessages[i].MessageToString + #13#10;
    MessageDlg(Msg, mtError, [mbOk], 0);
  end
  else
  begin
    ShowMessage(PSScript.ExecuteFunction(['Hase', 'Igel'], 'TestFunction'));
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  PSScript := TPSScript.Create(Self);
  PSScript.Name := 'PSScript';
  PSScript.OnCompile := PSScriptCompile;
  PSScript.OnVerifyProc := PSScriptVerifyProc;
  PSScript.OnExecute := PSScriptExecute;

  // import classes unit (e.g. TStringList)
  (PSScript.Plugins.Add as TPSPluginItem).Plugin := TPSImport_Classes.Create(Self);

  (PSScript.Plugins.Add as TPSPluginItem).Plugin := TPSImport_Controls.Create(Self);
  (PSScript.Plugins.Add as TPSPluginItem).Plugin := TPSImport_StdCtrls.Create(Self);
  (PSScript.Plugins.Add as TPSPluginItem).Plugin := TPSImport_uTestClass.Create(Self);

  TestClass := TTestClass.Create;
end;

procedure TMainForm.PSScriptCompile(Sender: TPSScript);
begin
  Sender.AddMethod(Self, @TMainForm.ShowNewMessage, 'procedure ShowNewMessage(const Message: String);');
  Sender.AddFunction(@Format, 'function Format(const Format: string; const Args: array of const): string;');
  Sender.AddRegisteredPTRVariable('Memo1', 'TMemo');
  Sender.AddRegisteredPTRVariable('TestClass', 'TTestClass');
end;

procedure TMainForm.PSScriptVerifyProc(Sender: TPSScript;
                              Proc: TPSInternalProcedure;
                              const Decl: String;
                              var Error: Boolean);
begin
  if Proc.Name = 'TESTFUNCTION' then
  begin
    if not ExportCheck(Sender.Comp, Proc, [btString, btString, btString], [pmIn, pmIn]) then
    begin
      Sender.Comp.MakeError('', ecCustomError, 'Function header for TestFunction does not match.');
      Error := True;
    end
    else begin
      Error := False;
    end;
  end
  else
    Error := False;
end;

procedure TMainForm.PSScriptExecute(Sender: TPSScript);
begin
  Sender.SetPointerToData('Memo1', @Memo1, Sender.FindNamedType('TMemo'));
  Sender.SetPointerToData('TestClass', @TestClass, Sender.FindNamedType('TTestClass'));
end;

procedure TMainForm.ShowNewMessage(const Message: String);
begin
  ShowMessage('ShowNewMessage invoked:' + #13#10 + Message);
end;

end.
