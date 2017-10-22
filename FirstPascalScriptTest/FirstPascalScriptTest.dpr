program FirstPascalScriptTest;

uses
  Forms,
  frmMain in 'frmMain.pas' {MainForm},
  uTestClass in 'uTestClass.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
