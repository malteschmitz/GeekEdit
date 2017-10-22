unit dlgPrintPreview;

interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls, ToolWin, ActnList, ImgList, Dialogs,
  SynEditPrintPreview, Menus, AppEvnts, Printers;

type
  TPrintPreviewDialog = class(TForm)
    ImageList: TImageList;
    ActionList: TActionList;
    FirstCmd: TAction;
    PrevCmd: TAction;
    NextCmd: TAction;
    LastCmd: TAction;
    ZoomCmd: TAction;
    PrintCmd: TAction;
    CloseCmd: TAction;
    ToolBar: TToolBar;
    FirstToolBtn: TToolButton;
    PrevToolBtn: TToolButton;
    NextToolBtn: TToolButton;
    LastToolBtn: TToolButton;
    Divider3ToolBtn: TToolButton;
    ZoomToolBtn: TToolButton;
    Divider2ToolBtn: TToolButton;
    PrintToolBtn: TToolButton;
    DividerToolBtn: TToolButton;
    CloseToolBtn: TToolButton;
    StatusBar: TStatusBar;
    PopupMenu: TPopupMenu;
    FitMenu: TMenuItem;
    PagewidthMenu: TMenuItem;
    N1: TMenuItem;
    z25Label: TMenuItem;
    z50Label: TMenuItem;
    z100Label: TMenuItem;
    z200Menu: TMenuItem;
    z400Menu: TMenuItem;
    ApplicationEvents: TApplicationEvents;
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);

    procedure FirstCmdExecute(Sender: TObject);
    procedure PrevCmdExecute(Sender: TObject);
    procedure NextCmdExecute(Sender: TObject);
    procedure LastCmdExecute(Sender: TObject);
    procedure ZoomCmdExecute(Sender: TObject);
    procedure PrintCmdExecute(Sender: TObject);
    procedure CloseCmdExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FitMenuClick(Sender: TObject);
    procedure ApplicationEventsHint(Sender: TObject);
    procedure SynEditPrintPreviewMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SynEditPrintPreviewPreviewPage(Sender: TObject;
      PageNumber: Integer);
  public
    SynEditPrintPreview: TSynEditPrintPreview;
  end;

const
  crPlus = 1;
  crMinus = 2;

implementation

uses frmMain;

{$R *.DFM}

procedure TPrintPreviewDialog.FormShow(Sender: TObject);
begin
  SynEditPrintPreview.UpdatePreview;
  SynEditPrintPreview.FirstPage;
end;

procedure TPrintPreviewDialog.FirstCmdExecute(Sender: TObject);
begin
  SynEditPrintPreview.FirstPage;
end;

procedure TPrintPreviewDialog.PrevCmdExecute(Sender: TObject);
begin
  SynEditPrintPreview.PreviousPage;
end;

procedure TPrintPreviewDialog.NextCmdExecute(Sender: TObject);
begin
  SynEditPrintPreview.NextPage;
end;

procedure TPrintPreviewDialog.LastCmdExecute(Sender: TObject);
begin
  SynEditPrintPreview.LastPage;
end;

procedure TPrintPreviewDialog.ZoomCmdExecute(Sender: TObject);
begin
  SynEditPrintPreview.ScaleMode := pscWholePage;
end;

procedure TPrintPreviewDialog.PrintCmdExecute(Sender: TObject);
begin
  MainForm.PrintMenu.Click;
end;

procedure TPrintPreviewDialog.CloseCmdExecute(Sender: TObject);
begin
  Close;
end;

procedure TPrintPreviewDialog.FitMenuClick(Sender: TObject);
begin
  case (Sender as TMenuItem).Tag of
    -1: SynEditPrintPreview.ScaleMode := pscWholePage;
    -2: SynEditPrintPreview.ScaleMode := pscPageWidth;
  else
    SynEditPrintPreview.ScalePercent := (Sender as TMenuItem).Tag;
  end;
end;

procedure TPrintPreviewDialog.ApplicationEventsHint(Sender: TObject);
begin
  StatusBar.Panels[0].Text := '  ' + Application.Hint;
end;

procedure TPrintPreviewDialog.SynEditPrintPreviewMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  FScale: Integer;
begin
  FScale := SynEditPrintPreview.ScalePercent;
  if ssShift in Shift then
  begin
    FScale := FScale div 2;
    if FScale < 25 then
      FScale := 25;
    SynEditPrintPreview.ScalePercent := FScale;
  end
  else
  begin
    if SynEditPrintPreview.ScaleMode = pscWholePage then
      SynEditPrintPreview.ScalePercent := 100
    else
    begin
      FScale := FScale * 2;
      if FScale > 400 then
        FScale := 400;
      SynEditPrintPreview.ScalePercent := FScale;
    end;
  end;
end;

procedure TPrintPreviewDialog.SynEditPrintPreviewPreviewPage(
  Sender: TObject; PageNumber: Integer);
begin
  StatusBar.Panels[1].Text := ' Seite: ' + IntToStr(SynEditPrintPreview.PageNumber);
end;

procedure TPrintPreviewDialog.FormCreate(Sender: TObject);
begin
  SynEditPrintPreview := TSynEditPrintPreview.Create(Self);
  with SynEditPrintPreview do
  begin
    Name := 'SynEditPrintPreview';
    Parent := Self;
    Left := 0;
    Top := 23;
    Width := 508;
    Height := 332;
    ScaleMode := pscWholePage;
    OnMouseDown := SynEditPrintPreviewMouseDown;
    OnPreviewPage := SynEditPrintPreviewPreviewPage;
  end;

  Screen.Cursors[crPlus] := LoadCursor(hInstance, 'PLUS');
  Screen.Cursors[crMinus] := LoadCursor(hInstance, 'MINUS');
  SynEditPrintPreview.Cursor := crPlus;
end;

procedure TPrintPreviewDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_SHIFT then
    SynEditPrintPreview.Cursor := crMinus;
end;

procedure TPrintPreviewDialog.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_SHIFT then
    SynEditPrintPreview.Cursor := crPlus;
end;

end.

