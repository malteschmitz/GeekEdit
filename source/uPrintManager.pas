unit uPrintManager;

interface

uses
  SynEdit, SynEditPrint;

type
  TPrintManager = class
  private
    FSynEdit: TSynEdit;
    FSynEditPrint: TSynEditPrint;
  public
    procedure PrintMenuClick(Sender: TObject);
    procedure PrintPreviewMenuClick(Sender: TObject);
    procedure PageSetupMenuClick(Sender: TObject);
    constructor Create(ASynEdit: TSynEdit);
    destructor Destroy; override;
  end;

implementation

{ TPrintManager }

{$R PrintResources.res}

uses
  Classes, Dialogs, Graphics, Controls, SysUtils, dlgPageSetup, dlgPrintPreview,
  uShare;

constructor TPrintManager.Create(ASynEdit: TSynEdit);
begin
  FSynEdit := ASynEdit;
  FSynEditPrint := TSynEditPrint.Create(nil);
  with FSynEditPrint do
  begin
    Header.Add('$TITLE$', nil, taCenter, 1);
    Header.FrameTypes := [];
    Footer.Add('Seite $PAGENUM$ von $PAGECOUNT$', nil, taCenter, 1);
    Footer.FrameTypes := [];
  end;
end;

destructor TPrintManager.Destroy;
begin
  FSynEditPrint.Free;
  inherited;
end;

procedure TPrintManager.PageSetupMenuClick(Sender: TObject);
var
  dlg: TPageSetupDialog;
begin
  dlg := TPageSetupDialog.Create(nil);
  try
    dlg.SetValues(FSynEditPrint);
    if dlg.ShowModal = mrOk then
      dlg.GetValues(FSynEditPrint);
  finally
    dlg.Free;
  end;
end;

procedure TPrintManager.PrintMenuClick(Sender: TObject);
var
  dlg: TPrintDialog;
begin
  dlg := TPrintDialog.Create(nil);
  with dlg do
  begin
    try
      if Execute then
      begin
        FSynEditPrint.SynEdit := FSynEdit;
        FSynEditPrint.Title := ExtractFileName(Share.FileName);
        FSynEditPrint.Print;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TPrintManager.PrintPreviewMenuClick(Sender: TObject);
var
  dlg: TPrintPreviewDialog;
begin
  dlg := TPrintPreviewDialog.Create(nil);
  try
    FSynEditPrint.SynEdit := FSynEdit;
    FSynEditPrint.Title := ExtractFileName(Share.FileName);
    with dlg do begin
      SynEditPrintPreview.SynEditPrint := FSynEditPrint;
      ShowModal;
    end;
  finally
    dlg.Free;
  end;
end;

end.
