unit uSearchManager;

interface

uses
  SynEdit, dlgSearch;

type
  TSearchManager = class
  private
    // Sucheinstellungen
    FSearch: String;
    FReplace: String;
    FMatchCase: Boolean;
    FWholeWords: Boolean;
    FConfirmation: Boolean;
    FOnlySelection: Boolean;
    FBackwards: Boolean;
    FStartAtCursor: Boolean;
    FSubdirs: Boolean;
    FDir: String;
    FBackup: Boolean;
    FReplaceAll: Boolean;
    FAction: TSearchAction;
    FReplaceCount: Integer;

    FSynEdit: TSynEdit;

    procedure Search(const AAction: TSearchAction);

    function DoSearch(AContinue: Boolean = False; AReverseDirection: Boolean = False): Boolean;
    procedure DoReplace(AContinue: Boolean = False; AReverseDirection: Boolean = False);
    procedure DoFilesSearch;
    procedure DoFilesReplace;
  public
    procedure SearchMenuClick(Sender: TObject);
    procedure ReplaceMenuClick(Sender: TObject);
    procedure FilesSearchMenuClick(Sender: TObject);
    procedure FilesReplaceMenuClick(Sender: TObject);
    procedure SearchNextMenuClick(Sender: TObject);
    procedure SearchPrevMenuClick(Sender: TObject);
    constructor Create(ASynEdit: TSynEdit);
  end;

implementation

{ TSearchManager }

uses
  Controls, Dialogs,

  // for debuggin
  Windows, SysUtils, StrUtils;

constructor TSearchManager.Create(ASynEdit: TSynEdit);
begin
  FSynEdit := ASynEdit;

  FSearch := '';
  FReplace := '';
  FMatchCase := False;
  FWholeWords := False;
  FConfirmation := False;
  FOnlySelection := False;
  FBackwards := False;
  FStartAtCursor := True;
  FSubdirs := False;
  FDir := '';
  FBackup := True;
  FReplaceAll := False;
  FAction := saSearch;
  FReplaceCount := 0;
end;

procedure TSearchManager.DoFilesReplace;
begin
  raise Exception.Create('nicht implementiert!');
end;

procedure TSearchManager.DoFilesSearch;
begin
  raise Exception.Create('nicht implementiert!');
end;

procedure TSearchManager.DoReplace(AContinue: Boolean = False; AReverseDirection: Boolean = False);
var
  DoIt: Boolean;
  res: Integer;
begin
  if DoSearch(AContinue, AReverseDirection) then
  begin
    // if this is the first time we found FSearch then start replace all if wanted
    if not AContinue and FReplaceAll and not FConfirmation then
    begin
      FReplaceCount := 0;
      FSynEdit.BeginUpdate;
    end;

    if FConfirmation then
    begin
      res := MessageDlg('Dieses Vorkommen von "' + FSearch + '" ersetzen?', mtConfirmation, [mbYes, mbNo, mbAbort, mbAll], 0);
      DoIt := (res = mrYes) or (res = mrAll);
      if res = mrAbort then
        FReplaceAll := False
      else if res = mrAll then
      begin
        FReplaceAll := True;
        FConfirmation := False;
        FReplaceCount := 0;
        FSynEdit.BeginUpdate;
      end;
    end
    else
      DoIt := True;

    if DoIt then
      FSynEdit.SelText := FReplace;

    if FReplaceAll then
    begin
      Inc(FReplaceCount);
      DoReplace(True);
    end;
  end
  else if FReplaceAll and not FConfirmation then
  begin
    FSynEdit.EndUpdate;
    MessageDlg(IntToStr(FReplaceCount) + ' Vorkommen von "' + FSearch + '" ersetzt.', mtInformation, [mbOk], 0);
  end;
end;

function TSearchManager.DoSearch(AContinue: Boolean = False; AReverseDirection: Boolean = False): Boolean;
var
  pRes, pText: PChar;
  i: Integer;
  Options: TStringSearchOptions; // soDown, soMatchCase, soWholeWord
  ende: Integer;
begin
  Result := False;

  Options := [];
  if FMatchCase then
    Include(Options, soMatchCase);
  if FWholeWords then
    Include(Options, soWholeWord);
  if AReverseDirection then
  begin
    if FBackwards then
      Include(Options, soDown);
  end
  else
  begin
    if not FBackwards then
      Include(Options, soDown);
  end;

  ende := 0;
  if not AContinue and not FStartAtCursor and not FOnlySelection then
  begin
    // search whole text
    FSynEdit.SelStart := 0;
    FSynEdit.SelLength := 0;
  end
  else if FOnlySelection then
  begin
    ende := FSynEdit.SelStart + FSynEdit.SelLength;
    FSynEdit.SelLength := 0;
  end;

  pText := PAnsiChar(FSynEdit.Text);
  pRes := SearchBuf(pText, Length(FSynEdit.Text), FSynEdit.SelStart, FSynEdit.SelLength, FSearch, Options);

  if Assigned(pRes) then
  begin
    i := Ord(pRes - pText);

    if FOnlySelection and (i + Length(FSearch) > ende) then
    begin
      FSynEdit.SelStart := ende;
      if not ((FAction = saReplace) and FReplaceAll) then
        MessageDlg('Text "' + FSearch + '" nicht innerhalb des markierten Textes gefunden.', mtWarning, [mbOk], 0);
    end
    else
    begin
      FSynEdit.SelStart := i;
      FSynEdit.SelLength := Length(FSearch);
      Result := True;
    end;
  end
  else if not ((FAction = saReplace) and FReplaceAll) then
    MessageDlg('Text "' + FSearch + '" nicht gefunden.', mtWarning, [mbOk], 0);
end;

procedure TSearchManager.FilesReplaceMenuClick(Sender: TObject);
begin
  Search(saFilesReplace);
end;

procedure TSearchManager.FilesSearchMenuClick(Sender: TObject);
begin
  Search(saFilesSearch);
end;

procedure TSearchManager.ReplaceMenuClick(Sender: TObject);
begin
  Search(saReplace)
end;

procedure TSearchManager.Search(const AAction: TSearchAction);
var
  dlg : TSearchDialog;
  res: Integer;
begin
  dlg := TSearchDialog.Create(nil);
  try
    dlg.Action := AAction;
    if Length(FSynEdit.SelText) > 0 then
      dlg.Search := FSynEdit.SelText
    else
      dlg.Search := FSearch;
    dlg.Replace := FReplace;
    dlg.MatchCase := FMatchCase;
    dlg.WholeWords := FWholeWords;
    dlg.Confirmation := FConfirmation;
    dlg.OnlySelection := FOnlySelection;
    dlg.Backwards := FBackwards;
    dlg.StartAtCursor := FStartAtCursor;
    dlg.Subdirs := FSubdirs;
    dlg.Dir := FDir;
    dlg.Backup := FBackup;

    res := dlg.ShowModal;
    if (res = mrOk) or (res = mrAll) then
    begin
      FSearch := dlg.Search;
      FReplace := dlg.Replace;
      FMatchCase := dlg.MatchCase;
      FWholeWords := dlg.WholeWords;
      FConfirmation := dlg.Confirmation;
      FOnlySelection := dlg.OnlySelection;
      FBackwards := dlg.Backwards;
      FStartAtCursor := dlg.StartAtCursor;
      FSubdirs := dlg.Subdirs;
      FDir := dlg.Dir;
      FBackup := dlg.Backup;
      FAction := dlg.Action;
      FReplaceAll := res = mrAll;

      case dlg.Action of
        saSearch: DoSearch;
        saReplace: DoReplace(False);
        saFilesSearch: DoFilesSearch;
        saFilesReplace: DoFilesReplace;
      end;

    end;
  finally
    dlg.Free;
  end;
end;

procedure TSearchManager.SearchMenuClick(Sender: TObject);
begin
  Search(saSearch);
end;

procedure TSearchManager.SearchNextMenuClick(Sender: TObject);
begin
  if FAction = saSearch then
    DoSearch(True)
  else if FAction = saReplace then
    DoReplace(True);
end;

procedure TSearchManager.SearchPrevMenuClick(Sender: TObject);
begin
  if FAction = saSearch then
    DoSearch(True, True)
  else if FAction = saReplace then
    DoReplace(True);
end;

end.
