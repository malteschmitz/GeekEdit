program GeekEdit;

{%File '..\ToDo.txt'}

uses
  Forms,
  frmMain in 'frmMain.pas' {MainForm},
  uScriptEditor in 'uScriptEditor.pas',
  uScriptManager in 'uScriptManager.pas',
  uIO in 'uIO.pas',
  uViewManager in 'uViewManager.pas',
  uScriptInterfaces in 'uScriptInterfaces.pas',
  uToolsManager in 'uToolsManager.pas',
  dlgRadio in 'dlgRadio.pas' {RadioDialog},
  dlgSearch in 'dlgSearch.pas' {SearchDialog},
  uSearchManager in 'uSearchManager.pas',
  uPrintManager in 'uPrintManager.pas',
  dlgPageSetup in 'dlgPageSetup.pas' {PageSetupDialog},
  dlgPrintPreview in 'dlgPrintPreview.pas' {PrintPreviewDialog},
  uFindApp in 'uFindApp.pas',
  dlgDirList in 'dlgDirList.pas' {DirListDialog},
  uShare in 'uShare.pas',
  uColor in 'uColor.pas',
  dlgColorEx in 'dlgColorEx.pas' {ColorExDialog},
  frmLineal in 'frmLineal.pas' {LinealForm},
  frmCharMap in 'frmCharMap.pas' {CharMapForm},
  uUnicodeTables in 'uUnicodeTables.pas',
  dlgImageMap in 'dlgImageMap.pas' {ImageMapDialog},
  dlgMetaTag in 'dlgMetaTag.pas' {MetaTagDialog},
  dlgHtmlFrame in 'dlgHtmlFrame.pas' {HtmlFrameDialog},
  dlgProcList in 'dlgProcList.pas' {ProcListDialog};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'GeekEdit';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TCharMapForm, CharMapForm);
  Application.Run;
end.
