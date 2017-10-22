program JensPipeBeispiel;

uses
  Forms,
  frmMain in 'frmMain.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
