unit dlgSearch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Menus, ToolWin, Buttons;

type
  TSearchAction = (saSearch, saReplace, saFilesSearch, saFilesReplace);

  TSearchDialog = class(TForm)
    PageControl: TPageControl;
    SearchTS: TTabSheet;
    ReplaceTS: TTabSheet;
    FilesSearchTS: TTabSheet;
    FilesReplaceTS: TTabSheet;
    ButtonPanel: TPanel;
    OkBtn: TButton;
    CancelBtn: TButton;
    SearchOptionsGroup: TGroupBox;
    SearchCaseCB: TCheckBox;
    SearchWordsCB: TCheckBox;
    SearchDirectionGroup: TGroupBox;
    SearchDirectionForRB: TRadioButton;
    SearchDirectionBackRB: TRadioButton;
    SearchRangeGroup: TGroupBox;
    SearchRangeWholeRB: TRadioButton;
    SearchRangeSelectionRB: TRadioButton;
    SearchStartGroup: TGroupBox;
    SearchStartCursorRB: TRadioButton;
    SearchStartWholeRB: TRadioButton;
    SearchSearchLabel: TLabel;
    SearchSearchEdit: TEdit;
    ReplaceSearchEdit: TEdit;
    ReplaceSearchLabel: TLabel;
    ReplaceReplaceEdit: TEdit;
    ReplaceReplaceLabel: TLabel;
    ReplaceOptionsGroup: TGroupBox;
    ReplaceCaseCB: TCheckBox;
    ReplaceWordsCB: TCheckBox;
    ReplaceDirectionGroup: TGroupBox;
    ReplaceDirectionForRB: TRadioButton;
    ReplaceDirectionBackRB: TRadioButton;
    ReplaceRangeGroup: TGroupBox;
    ReplaceRangeWholeRB: TRadioButton;
    ReplaceRangeSelectionRB: TRadioButton;
    ReplaceStartGroup: TGroupBox;
    ReplaceStartCursorRB: TRadioButton;
    ReplaceStartWholeRB: TRadioButton;
    ReplaceConfirmCB: TCheckBox;
    FilesSearchOptionsGroup: TGroupBox;
    FilesSearchCaseCB: TCheckBox;
    FilesSearchWordsCB: TCheckBox;
    FilesSearchDirOptionsGroup: TGroupBox;
    FilesSearchSearchLabel: TLabel;
    FilesSearchSearchEdit: TEdit;
    FilesSearchDirGroup: TGroupBox;
    FilesSearchSubdirsCB: TCheckBox;
    FilesSearchDirEdit: TEdit;
    FilesSearchDirBtn: TButton;
    FilesReplaceOptionsGroup: TGroupBox;
    FilesReplaceCaseCB: TCheckBox;
    FilesReplaceWordsCB: TCheckBox;
    FilesReplaceDirOptionsGroup: TGroupBox;
    FilesReplaceSubdirsCB: TCheckBox;
    FilesReplaceSearchLabel: TLabel;
    FilesReplaceSearchEdit: TEdit;
    FilesReplaceDirGroup: TGroupBox;
    FilesReplaceDirEdit: TEdit;
    FilesReplaceDirBtn: TButton;
    FilesReplaceReplaceEdit: TEdit;
    FilesReplaceReplaceLabel: TLabel;
    FilesReplaceNoBackupCB: TCheckBox;
    EditPopupMenu: TPopupMenu;
    EditLineBreakDosMenu: TMenuItem;
    EditTabMenu: TMenuItem;
    EditBackslashMenu: TMenuItem;
    SearchSearchEditBtn: TBitBtn;
    FilesReplaceSearchEditBtn: TBitBtn;
    FilesReplaceReplaceEditBtn: TBitBtn;
    ReplaceSearchEditBtn: TBitBtn;
    ReplaceReplaceEditBtn: TBitBtn;
    FilesSearchSearchEditBtn: TBitBtn;
    EditLineBreakLinuxMenu: TMenuItem;
    EditLineBreakMacMenu: TMenuItem;
    ReplaceAllBtn: TButton;
    procedure CaseCBClick(Sender: TObject);
    procedure WordsCBClick(Sender: TObject);
    procedure RangeWholeRBClick(Sender: TObject);
    procedure DirectionForRBClick(Sender: TObject);
    procedure StartCursorRBClick(Sender: TObject);
    procedure SearchEditChange(Sender: TObject);
    procedure ReplaceEditChange(Sender: TObject);
    procedure SubdirsCBClick(Sender: TObject);
    procedure DirBtnClick(Sender: TObject);
    procedure DirEditChange(Sender: TObject);
    procedure SearchTSShow(Sender: TObject);
    procedure ReplaceTSShow(Sender: TObject);
    procedure FilesSearchTSShow(Sender: TObject);
    procedure FilesReplaceTSShow(Sender: TObject);
    procedure RangeSelectionRBClick(Sender: TObject);
    procedure DirectionBackRBClick(Sender: TObject);
    procedure StartWholeRBClick(Sender: TObject);
    procedure SearchSearchEditBtnClick(Sender: TObject);
    procedure ReplaceSearchEditBtnClick(Sender: TObject);
    procedure ReplaceReplaceEditBtnClick(Sender: TObject);
    procedure FilesSearchSearchEditBtnClick(Sender: TObject);
    procedure FilesReplaceSearchEditBtnClick(Sender: TObject);
    procedure FilesReplaceReplaceEditBtnClick(Sender: TObject);
    procedure EditMenuClick(Sender: TObject);
  private
    function GetSearch: String;
    function GetBackwards: Boolean;
    function GetConfirmation: Boolean;
    function GetDir: String;
    function GetMatchCase: Boolean;
    function GetOnlySelection: Boolean;
    function GetBackup: Boolean;
    function GetReplace: String;
    function GetStartAtCursor: Boolean;
    function GetSubdirs: Boolean;
    function GetWholeWords: Boolean;
    function GetSearchAction: TSearchAction;
    procedure SetSearchAction(const Value: TSearchAction);
    procedure SetBackup(const Value: Boolean);
    procedure SetBackwards(const Value: Boolean);
    procedure SetConfirmation(const Value: Boolean);
    procedure SetDir(const Value: String);
    procedure SetMatchCase(const Value: Boolean);
    procedure SetOnlySelection(const Value: Boolean);
    procedure SetReplace(const Value: String);
    procedure SetReplaceValue(const Value: String);
    procedure SetSearch(const Value: String);
    procedure SetSearchValue(const Value: String);
    procedure SetStartAtCursor(const Value: Boolean);
    procedure SetSubdirs(const Value: Boolean);
    procedure SetWholeWords(const Value: Boolean);

    procedure EditPopup(Edit: TEdit; Button: TButton);
    function EscapesToChars(const s: String): String;
    function CharsToEscapes(const s: String): String;
  published
  public
    property Search: String read GetSearch write SetSearch;
    property Replace: String read GetReplace write SetReplace;
    property MatchCase: Boolean read GetMatchCase write SetMatchCase;
    property WholeWords: Boolean read GetWholeWords write SetWholeWords;
    property Confirmation: Boolean read GetConfirmation write SetConfirmation;
    property OnlySelection: Boolean read GetOnlySelection write SetOnlySelection;
    property Backwards: Boolean read GetBackwards write SetBackwards;
    property StartAtCursor: Boolean read GetStartAtCursor write SetStartAtCursor;
    property Subdirs: Boolean read GetSubdirs write SetSubdirs;
    property Dir: String read GetDir write SetDir;
    property Backup: Boolean read GetBackup write SetBackup;
    property Action: TSearchAction read GetSearchAction write SetSearchAction;
  end;

implementation

{$R *.dfm}

uses
  SsBase, StBrowsr;

{ TSearchDialog }

function TSearchDialog.GetBackwards: Boolean;
begin
  Result := SearchDirectionBackRB.Checked;
end;

function TSearchDialog.GetConfirmation: Boolean;
begin
  Result := ReplaceConfirmCB.Checked;
end;

function TSearchDialog.GetDir: String;
begin
  Result := IncludeTrailingPathDelimiter(FilesSearchDirEdit.Text);
end;

function TSearchDialog.GetMatchCase: Boolean;
begin
  Result := SearchCaseCB.Checked;
end;

function TSearchDialog.GetOnlySelection: Boolean;
begin
  Result := SearchRangeSelectionRB.Checked;
end;

function TSearchDialog.GetBackup: Boolean;
begin
  Result := not FilesReplaceNoBackupCB.Checked;
end;

function TSearchDialog.GetReplace: String;
begin
  Result := EscapesToChars(ReplaceReplaceEdit.Text);
end;

function TSearchDialog.GetSearch: String;
begin
  Result := EscapesToChars(SearchSearchEdit.Text);
end;

function TSearchDialog.GetSearchAction: TSearchAction;
begin
  Result := TSearchAction(PageControl.TabIndex);
end;

function TSearchDialog.GetStartAtCursor: Boolean;
begin
  Result := SearchStartCursorRB.Checked;
end;

function TSearchDialog.GetSubdirs: Boolean;
begin
  Result := FilesSearchSubdirsCB.Checked;
end;

function TSearchDialog.GetWholeWords: Boolean;
begin
  Result := SearchWordsCB.Checked;
end;

procedure TSearchDialog.CaseCBClick(Sender: TObject);
begin
  if Sender is TCheckBox then
    MatchCase := (Sender as TCheckBox).Checked;
end;

procedure TSearchDialog.RangeSelectionRBClick(Sender: TObject);
begin
  if Sender is TRadioButton then
    OnlySelection := (Sender as TRadioButton).Checked;
end;

procedure TSearchDialog.RangeWholeRBClick(Sender: TObject);
begin
  if Sender is TRadioButton then
    OnlySelection := not (Sender as TRadioButton).Checked;
end;

function TSearchDialog.CharsToEscapes(const s: String): String;
begin
  Result := s;
  Result := StringReplace(Result, '\', '\b', [rfReplaceAll]);
  Result := StringReplace(Result, #13, '\r', [rfReplaceAll]);
  Result := StringReplace(Result, #10, '\n', [rfReplaceAll]);
  Result := StringReplace(Result, #9, '\t', [rfReplaceAll]);
end;

function TSearchDialog.EscapesToChars(const s: String): String;
begin
  Result := s;
  Result := StringReplace(Result, '\\', '\b', [rfReplaceAll]);
  Result := StringReplace(Result, '\r', #13, [rfReplaceAll]);
  Result := StringReplace(Result, '\n', #10, [rfReplaceAll]);
  Result := StringReplace(Result, '\t', #9, [rfReplaceAll]);
  Result := StringReplace(Result, '\b', '\', [rfReplaceAll]);
end;

procedure TSearchDialog.ReplaceEditChange(Sender: TObject);
begin
  if Sender is TEdit then
    SetReplaceValue((Sender as TEdit).Text);
end;

procedure TSearchDialog.ReplaceReplaceEditBtnClick(Sender: TObject);
begin
  EditPopup(ReplaceReplaceEdit, ReplaceReplaceEditBtn);
end;

procedure TSearchDialog.ReplaceSearchEditBtnClick(Sender: TObject);
begin
  EditPopup(ReplaceSearchEdit, ReplaceSearchEditBtn);
end;

procedure TSearchDialog.ReplaceTSShow(Sender: TObject);
begin
  ReplaceSearchEdit.SetFocus;
  ReplaceAllBtn.Enabled := True;
end;

procedure TSearchDialog.WordsCBClick(Sender: TObject);
begin
  if Sender is TCheckBox then
    WholeWords := (Sender as TCheckBox).Checked;
end;

procedure TSearchDialog.DirectionBackRBClick(Sender: TObject);
begin
  if Sender is TRadioButton then
    Backwards := (Sender as TRadioButton).Checked;
end;

procedure TSearchDialog.DirectionForRBClick(Sender: TObject);
begin
  if Sender is TRadioButton then
    Backwards := not (Sender as TRadioButton).Checked;
end;

procedure TSearchDialog.DirEditChange(Sender: TObject);
begin
  if Sender is TEdit then
    Dir := (Sender as TEdit).Text;
end;

procedure TSearchDialog.EditMenuClick(Sender: TObject);
var
  Insert: String;
  Edit: TEdit;
  start: Integer;
begin
  if Sender is TMenuItem then
  begin
    case (Sender as TMenuItem).Tag of
      0: Insert := '\r\n';
      1: Insert := '\n';
      2: Insert := '\r';
      3: Insert := '\t';
      4: Insert := '\b';
    end;
    Edit := TEdit(EditPopupMenu.Tag);
    Edit.SelText := Insert;
    start := Edit.SelStart;
    Edit.SetFocus;
    Edit.SelStart := start;
    Edit.SelLength := 0;
  end;
end;

procedure TSearchDialog.EditPopup(Edit: TEdit; Button: TButton);
var
  p: TPoint;
begin
  p.X := Button.Left;
  p.Y := Button.Top + Button.Height;
  p := Button.Parent.ClientToScreen(p);
  EditPopupMenu.Tag := Integer(Edit);
  EditPopupMenu.Popup(p.X, p.Y);
end;

procedure TSearchDialog.FilesSearchSearchEditBtnClick(Sender: TObject);
begin
  EditPopup(FilesSearchSearchEdit, FilesSearchSearchEditBtn);
end;

procedure TSearchDialog.FilesReplaceReplaceEditBtnClick(Sender: TObject);
begin
  EditPopup(FilesReplaceReplaceEdit, FilesReplaceReplaceEditBtn);
end;

procedure TSearchDialog.FilesReplaceSearchEditBtnClick(Sender: TObject);
begin
  EditPopup(FilesReplaceSearchEdit, FilesReplaceSearchEditBtn);
end;

procedure TSearchDialog.FilesReplaceTSShow(Sender: TObject);
begin
  FilesReplaceSearchEdit.SetFocus;
  ReplaceAllBtn.Enabled := False;
end;

procedure TSearchDialog.FilesSearchTSShow(Sender: TObject);
begin
  FilesSearchSearchEdit.SetFocus;
  ReplaceAllBtn.Enabled := False;
end;

procedure TSearchDialog.StartCursorRBClick(Sender: TObject);
begin
  if Sender is TRadioButton then
    StartAtCursor := (Sender as TRadioButton).Checked;
end;

procedure TSearchDialog.StartWholeRBClick(Sender: TObject);
begin
  if Sender is TRadioButton then
    StartAtCursor := not (Sender as TRadioButton).Checked;
end;

procedure TSearchDialog.SubdirsCBClick(Sender: TObject);
begin
  if Sender is TCheckBox then
    Subdirs := (Sender as TCheckBox).Checked;
end;

procedure TSearchDialog.SearchEditChange(Sender: TObject);
begin
  if Sender is TEdit then
    SetSearchValue((Sender as TEdit).Text);
end;

procedure TSearchDialog.SearchSearchEditBtnClick(Sender: TObject);
begin
  EditPopup(SearchSearchEdit, SearchSearchEditBtn);
end;

procedure TSearchDialog.SearchTSShow(Sender: TObject);
begin
  SearchSearchEdit.SetFocus;
  ReplaceAllBtn.Enabled := False;
end;

procedure TSearchDialog.DirBtnClick(Sender: TObject);
var
  dlg: TStBrowser;
  Edit: TEdit;
begin
  Edit := nil;
  if Sender = FilesSearchDirBtn then
    Edit := FilesSearchDirEdit
  else if Sender = FilesReplaceDirBtn then
    Edit := FilesReplaceDirEdit;

  if Assigned(Edit) then
  begin
    dlg := TStBrowser.Create(Self);
    try
      dlg.SelectedFolder := Edit.Text;
      dlg.Options := [boReturnOnlyDirs];
      dlg.Caption := 'Verzeichnis...';
      if dlg.Execute then
        Edit.Text := dlg.Path;
    finally
      dlg.Free;
    end;
  end;
end;

procedure TSearchDialog.SetBackup(const Value: Boolean);
begin
  FilesReplaceNoBackupCB.Checked := not Value;
end;

procedure TSearchDialog.SetBackwards(const Value: Boolean);
begin
  SearchDirectionBackRB.Checked := Value;
  ReplaceDirectionBackRB.Checked := Value;
  SearchDirectionForRB.Checked := not Value;
  ReplaceDirectionForRB.Checked := not Value;
end;

procedure TSearchDialog.SetConfirmation(const Value: Boolean);
begin
  ReplaceConfirmCB.Checked := Value;
end;

procedure TSearchDialog.SetDir(const Value: String);
begin
  FilesSearchDirEdit.Text := Value;
  FilesReplaceDirEdit.Text := Value;
end;

procedure TSearchDialog.SetMatchCase(const Value: Boolean);
begin
  SearchCaseCB.Checked := Value;
  ReplaceCaseCB.Checked := Value;
  FilesSearchCaseCB.Checked := Value;
  FilesReplaceCaseCB.Checked := Value;
end;

procedure TSearchDialog.SetOnlySelection(const Value: Boolean);
begin
  SearchRangeSelectionRB.Checked := Value;
  ReplaceRangeSelectionRB.Checked := Value;
  SearchRangeWholeRB.Checked := not Value;
  ReplaceRangeWholeRB.Checked := not Value;
end;

procedure TSearchDialog.SetReplace(const Value: String);
begin
  SetReplaceValue(CharsToEscapes(Value));
end;

procedure TSearchDialog.SetReplaceValue(const Value: String);
begin
  ReplaceReplaceEdit.Text := Value;
  FilesReplaceReplaceEdit.Text := Value;
end;

procedure TSearchDialog.SetSearch(const Value: String);
begin
  SetSearchValue(CharsToEscapes(Value));
end;

procedure TSearchDialog.SetSearchAction(const Value: TSearchAction);
begin
  PageControl.TabIndex := Ord(Value);
end;

procedure TSearchDialog.SetSearchValue(const Value: String);
begin
  SearchSearchEdit.Text := Value;
  ReplaceSearchEdit.Text := Value;
  FilesSearchSearchEdit.Text := Value;
  FilesReplaceSearchEdit.Text := Value;
end;

procedure TSearchDialog.SetStartAtCursor(const Value: Boolean);
begin
  SearchStartCursorRB.Checked := Value;
  ReplaceStartCursorRB.Checked := Value;
  SearchStartWholeRB.Checked := not Value;
  ReplaceStartWholeRB.Checked := not Value;
end;

procedure TSearchDialog.SetSubdirs(const Value: Boolean);
begin
  FilesSearchSubdirsCB.Checked := Value;
  FilesReplaceSubdirsCB.Checked := Value;
end;

procedure TSearchDialog.SetWholeWords(const Value: Boolean);
begin
  SearchWordsCB.Checked := Value;
  ReplaceWordsCB.Checked := Value;
  FilesSearchWordsCB.Checked := Value;
  FilesReplaceWordsCB.Checked := Value;
end;

end.
