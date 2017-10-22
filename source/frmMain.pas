unit frmMain;

interface

uses
  // Basics
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls,

  // SynEdit
  SynEdit, SynEditMiscClasses, StdCtrls,

  // Manager
  uScriptManager,
  uIO,
  uViewManager,
  uToolsManager,
  uSearchManager,
  uPrintManager, ExtCtrls, ToolWin;

type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    StatusBar: TStatusBar;
    FileMenu: TMenuItem;
    NewMenu: TMenuItem;
    NewInstanceMenu: TMenuItem;
    OpenMenu: TMenuItem;
    ReloadMenu: TMenuItem;
    SaveMenu: TMenuItem;
    SaveAsMenu: TMenuItem;
    BackupMenu: TMenuItem;
    LineBreakMenu: TMenuItem;
    LineBreakDosMenu: TMenuItem;
    LineBreakUnixMenu: TMenuItem;
    LineBreakMacMenu: TMenuItem;
    CharsetMenu: TMenuItem;
    CharsetCp1252Menu: TMenuItem;
    CharsetUtf8Menu: TMenuItem;
    CharsetUtf8BomMenu: TMenuItem;
    N1: TMenuItem;
    PrintPreviewMenu: TMenuItem;
    PageSetupMenu: TMenuItem;
    N2: TMenuItem;
    CloseMenu: TMenuItem;
    EditMenu: TMenuItem;
    UndoMenu: TMenuItem;
    RedoMenu: TMenuItem;
    N3: TMenuItem;
    CopyMenu: TMenuItem;
    PasteMenu: TMenuItem;
    CutMenu: TMenuItem;
    N4: TMenuItem;
    SearchMenu: TMenuItem;
    ReplaceMenu: TMenuItem;
    SearchNextMenu: TMenuItem;
    SearchPrevMenu: TMenuItem;
    ViewMenu: TMenuItem;
    IncFontMenu: TMenuItem;
    DecFontMenu: TMenuItem;
    NormalFontMenu: TMenuItem;
    N5: TMenuItem;
    ToolsMenu: TMenuItem;
    PrintMenu: TMenuItem;
    WordWrapMenu: TMenuItem;
    ShowSpecialCharsMenu: TMenuItem;
    AboutMenu: TMenuItem;
    SettingsMenu: TMenuItem;
    FilesSearchMenu: TMenuItem;
    FilesReplaceMenu: TMenuItem;
    OutputSplitter: TSplitter;
    MainPanel: TPanel;
    OutputMenu: TMenuItem;
    OutputPopupMenu: TPopupMenu;
    ClearOutputMenu: TMenuItem;
    KillOutputMenu: TMenuItem;
    HideOutputMenu: TMenuItem;
    OutputEdit: TEdit;
    OutputPanel: TPanel;
    OutputMemo: TMemo;
    N6: TMenuItem;
    OutputSelectAllMenu: TMenuItem;
    OutputCopyMenu: TMenuItem;
    N7: TMenuItem;
    SelectAllMenu: TMenuItem;
    SynEditPopupMenu: TPopupMenu;
    PopupUndoMenu: TMenuItem;
    PopupRedoMenu: TMenuItem;
    N8: TMenuItem;
    PopupCutMenu: TMenuItem;
    PopupCopyMenu: TMenuItem;
    PopupPasteMenu: TMenuItem;
    N9: TMenuItem;
    PopupSelectAllMenu: TMenuItem;
    OpenSelectionMenu: TMenuItem;
    N10: TMenuItem;
    ShowHighlighterMenu: TMenuItem;
    procedure CloseMenuClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SyntaxMenuClick(Sender: TObject);
    procedure NewInstanceMenuClick(Sender: TObject);
    procedure IOUpdate(Sender: TObject);
    procedure TitleUpdate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure AboutMenuClick(Sender: TObject);
    procedure SynEditStatusChange(Sender: TObject;
      Changes: TSynStatusChanges);
    procedure BackupMenuClick(Sender: TObject);
    procedure ViewManagerHighlighterChange(Sender: TObject);
    procedure SettingsMenuClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure UndoMenuClick(Sender: TObject);
    procedure RedoMenuClick(Sender: TObject);
    procedure CopyMenuClick(Sender: TObject);
    procedure PasteMenuClick(Sender: TObject);
    procedure CutMenuClick(Sender: TObject);
    procedure CheckEditMenuStatus;
    procedure ApplicationActivate(Sender: TObject);
    procedure ScriptEditorSave(Sender: TObject; var Result: Boolean);
    procedure OutputSplitterMoved(Sender: TObject);
    procedure OutputMenuClick(Sender: TObject);
    procedure ScriptEditorOutputUpdate(Sender: TObject; const NewOutput: String;
      Running: Boolean);
    procedure HideOutputMenuClick(Sender: TObject);
    procedure KillOutputMenuClick(Sender: TObject);
    procedure ClearOutputMenuClick(Sender: TObject);
    procedure OutputEditKeyPress(Sender: TObject; var Key: Char);
    procedure OutputCopyMenuClick(Sender: TObject);
    procedure OutputSelectAllMenuClick(Sender: TObject);
    procedure OutputEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SelectAllMenuClick(Sender: TObject);
    procedure SynEditKeyPress(Sender: TObject; var Key: Char);
    procedure SynEditDropFiles(Sender: TObject; X, Y: integer; AFiles: TStrings);
    procedure SynEditPaintTransient(Sender: TObject; Canvas: TCanvas;
      TransientType: TTransientType);
    procedure OpenSelectionMenuClick(Sender: TObject);
    procedure SynEditMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShowHighlighterMenuClick(Sender: TObject);
  private
    OutputEditHistoryStringList: TStringList;
    OutputEditHistoryIndex: Integer;
    SynEdit: TSynEdit;
    ScriptManager: TScriptManager;
    IO: TIO;
    ViewManager: TViewManager;
    ToolsManager: TToolsManager;
    SearchManager: TSearchManager;
    PrintManager: TPrintManager;
    AppVersion: String; //< saves the actual version of GeekEdit, used in IOUpdate
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  SynEditHighlighter, StrUtils, ShellApi, uShare;

procedure TMainForm.AboutMenuClick(Sender: TObject);
var
  AboutFileName: String;
begin
  // open new GeekEdit showing GeekEdit.txt
  AboutFileName := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'GeekEdit.txt';
  if FileExists(AboutFileName) then
    IO.OpenEditor(AboutFileName)
  else // if GeekEdit.txt cannot be found
    MessageBox(Application.Handle, PChar('(c) Malte Schmitz' + #13#10
      + 'http://malte.schmitz-sh.de'), PChar('GeekEdit ' + AppVersion),
      MB_OK or MB_ICONINFORMATION);
end;

procedure TMainForm.ApplicationActivate(Sender: TObject);
begin
  CheckEditMenuStatus;

  // pass on event to ScriptManager
  if Assigned(ScriptManager) then
    ScriptManager.Editor.ApplicationActivate(Sender);

  // pass on event to IO
  if Assigned(IO) then
    IO.ApplicationActivate(Sender);
end;

procedure TMainForm.BackupMenuClick(Sender: TObject);
var
  i: Integer;
begin
  if Share.FileName = '' then
    MessageDlg('Backup kann nur von bereits gespeicherten Dateien angelegt werden.', mtError, [mbOk], 0)
  else
  begin
    i := 0;
    while FileExists(Format('%s.bak.%.3d', [Share.FileName, i])) do
      Inc(i);
    if CopyFile(PChar(Share.FileName), PChar(Format('%s.bak.%.3d',
          [Share.FileName, i])), True) then
      StatusBar.Panels.Items[4].Text :=
            Format('Backup "%s.bak.%.3d" erstellt in "%s"',
            [ExtractFileName(Share.FileName), i, ExtractFilePath(Share.FileName)])
    else
      RaiseLastOsError;
  end;
end;

procedure TMainForm.ClearOutputMenuClick(Sender: TObject);
begin
  OutputMemo.Clear;
end;

procedure TMainForm.CloseMenuClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.CopyMenuClick(Sender: TObject);
begin
  if SynEdit.Focused then
  begin
    SynEdit.CopyToClipboard;
    CheckEditMenuStatus;
  end
  else if OutputMemo.Focused then
    OutputMemo.CopyToClipboard
  else if OutputEdit.Focused then
    OutputEdit.CopyToClipboard;
end;

procedure TMainForm.CutMenuClick(Sender: TObject);
begin
  if SynEdit.Focused then
  begin
    SynEdit.CutToClipboard;
    CheckEditMenuStatus;
  end
  else if OutputEdit.Focused then
    OutputEdit.CutToClipboard;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  try
    CanClose := IO.CanClear;
  except
    on E: Exception do
    begin
      // prevent getting closed in case of any problem
      CanClose := False;
      // show error message
      MessageDlg(E.Message, mtError, [mbOk], 0);
    end;
  end;
  if CanClose then
    if OutputEdit.Visible then
      if MessageDlg('Konsolenanwendung läuft noch und wird abgebrochen beim Beenden.', mtConfirmation, [mbok, mbCancel], 0) = mrOk then
        ScriptManager.Editor.ConsoleAppKill
      else
        CanClose := False;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  lpVerInfo: Pointer;
  rVerValue: PVSFixedFileInfo;
  dwInfoSize, dwValueSize, dwDummy: Cardinal;
begin
  Application.OnActivate := ApplicationActivate;

  Share.AddFileNameUpdateListener(TitleUpdate);
  Share.AddModifiedUpdateListener(TitleUpdate);
  Share.AddTitlePrefixUpdateListener(TitleUpdate);

  // read version information of application
  // used by IOUpdate
  dwInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), dwDummy);
  if dwInfoSize <> 0 then
  begin
    GetMem(lpVerInfo, dwInfoSize);
    try
      GetFileVersionInfo(PChar(ParamStr(0)), 0, dwInfoSize, lpVerInfo);
      VerQueryValue(lpVerInfo, '\', Pointer(rVerValue), dwValueSize);
      AppVersion := IntTostr(rVerValue^.dwFileVersionMS shr 16);
      AppVersion := AppVersion + '.' + IntTostr(rVerValue^.dwFileVersionMS and $FFFF);
      AppVersion := AppVersion + '.' + IntTostr(rVerValue^.dwFileVersionLS shr 16);
    finally
      FreeMem(lpVerInfo, dwInfoSize);
    end;
  end;

  // create SynEdit
  SynEdit := TSynEdit.Create(Self);
  with SynEdit do
  begin
    Name := 'SynEdit';
    Text := '';
    Parent := MainPanel;
    Left := 0;
    Top := 0;
    Width := 613;
    Height := 351;
    Align := alClient;
    Color := clWhite;
    ActiveLineColor := 12189695;
    Font.Charset := DEFAULT_CHARSET;
    Font.Color := clWindowText;
    Font.Size := 10;
    Font.Name := 'Courier New';
    Font.Style := [];
    TabOrder := 0;
    Gutter.AutoSize := True;
    Gutter.BorderStyle := gbsNone;
    Gutter.DigitCount := 2;
    Gutter.Font.Charset := DEFAULT_CHARSET;
    Gutter.Font.Color := clWindowText;
    Gutter.Font.Height := -11;
    Gutter.Font.Name := 'Courier New';
    Gutter.Font.Style := [];
    Gutter.RightOffset := 0;
    Gutter.ShowLineNumbers := True;
    Gutter.UseFontStyle := False;
    Gutter.Gradient := True;
    Gutter.GradientStartColor := 13882323;
    Gutter.GradientEndColor := clSilver;
    Options := [eoAutoIndent, eoAutoSizeMaxScrollWidth, eoDragDropEditing, eoDropFiles, eoEnhanceEndKey, eoHideShowScrollbars, eoRightMouseMovesCursor, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabIndent, eoTabsToSpaces];
    TabWidth := 2;
    WantTabs := True;
    OnStatusChange := SynEditStatusChange;
    PopupMenu := SynEditPopupMenu;
    OnKeyPress := SynEditKeyPress;
    OnDropFiles := SynEditDropFiles;
    OnPaintTransient := SynEditPaintTransient;
    OnMouseUp := SynEditMouseUp;
  end;

  // create ScriptManager
  ScriptManager := TScriptManager.Create(SynEdit, MainMenu.Items, Self);
  ScriptManager.Editor.OnSave := ScriptEditorSave;
  ScriptManager.Editor.OnOutputUpdate := ScriptEditorOutputUpdate;

  // create I/O manager
  IO := TIO.Create(SynEdit);
  IO.OnUpdate := IOUpdate;
  NewMenu.OnClick := IO.NewMenuClick;
  OpenMenu.OnClick := IO.OpenMenuClick;
  SaveMenu.OnClick := IO.SaveMenuClick;
  SaveAsMenu.OnClick := IO.SaveAsMenuClick;
  ReloadMenu.OnClick := IO.ReloadMenuClick;

  LineBreakDosMenu.OnClick := IO.LineBreakTypeMenuClick;
  LineBreakUnixMenu.OnClick := IO.LineBreakTypeMenuClick;
  LineBreakMacMenu.OnClick := IO.LineBreakTypeMenuClick;

  CharSetCp1252Menu.OnClick := IO.CharSetTypeMenuClick;
  CharSetUtf8Menu.OnClick := IO.CharSetTypeMenuClick;
  CharSetUtf8BomMenu.OnClick := IO.CharSetTypeMenuClick;

  // create output editor management
  OutputEditHistoryStringList := TStringList.Create;

  // create ViewManager
  ViewManager := TViewManager.Create(SynEdit, ViewMenu, Self);
  ViewManager.OnSynHighlighterChange := ViewManagerHighlighterChange;
  ScriptManager.Editor.SynHighlighter := ViewManager.SynHighlighter;
  IncFontMenu.OnClick := ViewManager.IncFontMenuClick;
  DecFontMenu.OnClick := ViewManager.DecFontMenuClick;
  NormalFontMenu.OnClick := ViewManager.NormalFontMenuClick;
  WordWrapMenu.OnClick := ViewManager.WordWrapMenuClick;
  ShowSpecialCharsMenu.OnClick := ViewManager.ShowSpecialCharsMenuClick;

  // create ToolsManager
  ToolsManager := TToolsManager.Create(SynEdit, Self, ToolsMenu);

  // create SearchManager
  SearchManager := TSearchManager.Create(SynEdit);
  SearchMenu.OnClick := SearchManager.SearchMenuClick;
  ReplaceMenu.OnClick := SearchManager.ReplaceMenuClick;
  FilesSearchMenu.OnClick := SearchManager.FilesSearchMenuClick;
  FilesReplaceMenu.OnClick := SearchManager.FilesReplaceMenuClick;
  SearchNextMenu.OnClick := SearchManager.SearchNextMenuClick;
  SearchPrevMenu.OnClick := SearchManager.SearchPrevMenuClick;

  // create PrintManager
  PrintManager := TPrintManager.Create(SynEdit);
  PrintMenu.OnClick := PrintManager.PrintMenuClick;
  PrintPreviewMenu.OnClick := PrintManager.PrintPreviewMenuClick;
  PageSetupMenu.OnClick := PrintManager.PageSetupMenuClick;

  // initiate Caption
  IOUpdate(IO);

  // parse command line
  if ParamStr(1) <> '' then
  begin
    if ParamStr(1) = '*highlighter*' then
      SynEdit.Text := ViewManager.SyntaxNames
    else
      IO.OpenFile(ParamStr(1));
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  ToolsManager.Free;
  ViewManager.Free;
  IO.Free;
  OutputEditHistoryStringList.Free;
  ScriptManager.Free;
end;

procedure TMainForm.HideOutputMenuClick(Sender: TObject);
begin
  if OutputMenu.Checked then
    OutputMenu.Click;
end;

procedure TMainForm.TitleUpdate(Sender: TObject);
var
  c: String;
begin
  // Caption und App Title anpassen
  if Share.TitlePrefix <> '' then
    c := '[' + Share.TitlePrefix + '] '
  else
    c := '';

  if Share.FileName <> '' then
  begin
    c := c + ExtractFileName(Share.FileName);
    if SynEdit.Modified then
      c := c + '*';
    c := c + ' - ';
  end;

  c := c + 'GeekEdit ' + AppVersion;

  Self.Caption := c;
  Application.Title := c;

  // StatusBar anpassen
  if Share.Modified then
    Statusbar.Panels[3].Text := 'Geändert'
  else
    Statusbar.Panels[3].Text := '';
end;

procedure TMainForm.IOUpdate(Sender: TObject);
begin
  // Zeichensatz-Menü anpassen
  if IO.CharSetType = cstUtf8 then
    CharsetUtf8Menu.Checked := True
  else if IO.CharSetType = cstUtf8Bom then
    CharsetUtf8BomMenu.Checked := True
  else
    CharsetCp1252Menu.Checked := True;

  // Zeilenumbruch-Menü anpassen
  if IO.LineBreakType = lbtUnix then
    LineBreakUnixMenu.Checked := True
  else if IO.LineBreakType = lbtMac then
    LineBreakMacMenu.Checked := True
  else
    LineBreakDosMenu.Checked := True;
end;

procedure TMainForm.KillOutputMenuClick(Sender: TObject);
begin
  ScriptManager.Editor.ConsoleAppKill;
end;

procedure TMainForm.SynEditMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if [ssCtrl] = Shift then
    if Button = mbLeft then
      OpenSelectionMenu.Click;
end;

procedure TMainForm.NewInstanceMenuClick(Sender: TObject);
begin
  IO.OpenEditor;
end;

procedure TMainForm.OpenSelectionMenuClick(Sender: TObject);

  function GetBetween(const Line, QuoteMark: String; Position: Integer): String;
  var
    start, stop, val: Integer;
    run: Boolean;
  begin
    start := 0;
    stop := 0;
    run := True;
    while run do
    begin
      val := PosEx(QuoteMark, Line, stop + 1);
      if val > 0 then
      begin
        stop := val;
        if stop < Position then
          start := stop
        else
          run := False;
      end
      else
        run := False;
    end;
    if start > 0 then
      Result := Copy(Line, start + 1, stop - start - 1);
  end;

var
  FileName, Line: String;
  Position, i: Integer;
  OpenIntern: Boolean;

const
  QuoteMarks: array[0..2] of String = ('"', '''', ' ');

begin
  if SynEdit.SelLength > 0 then
    FileName := SynEdit.SelText
  else
  begin
    Position := SynEdit.CaretX;
    Line := SynEdit.Lines[SynEdit.CaretY - 1];
    i := 0;
    FileName := '';
    while (FileName = '') and (i < Length(QuoteMarks)) do
    begin
      FileName := GetBetween(Line, QuoteMarks[i], Position);
      Inc(i);
    end;
  end;

  if Length(FileName) > 0 then
  begin
    OpenIntern := ViewManager.CanOpen(FileName);
    if OpenIntern then
    begin
      if not FileExists(FileName) then
      begin
        if FileExists(IncludeTrailingPathDelimiter(ExtractFilePath(Share.FileName)) + FileName) then
          FileName := IncludeTrailingPathDelimiter(ExtractFilePath(Share.FileName)) + FileName
        else
          OpenIntern := False;
      end;
    end;
    if OpenIntern then
    begin
      FileName := StringReplace(FileName, '/', '\', [rfReplaceAll]);
      IO.OpenEditor(FileName);
    end
    else
      ShellExecute(Application.Handle, 'open', PChar(FileName), nil, nil, SW_SHOWNORMAL);
  end
  else
    MessageDlg('keine Markierung', mtWarning, [mbOk], 0);
end;

procedure TMainForm.OutputCopyMenuClick(Sender: TObject);
begin
  OutputMemo.CopyToClipboard;
end;

procedure TMainForm.OutputEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Shift = [] then
    case Key of
      VK_UP:
      begin
        Key := 0;
        if OutputEditHistoryIndex > 0 then
        begin
          Dec(OutputEditHistoryIndex);
          OutputEdit.Text := OutputEditHistoryStringList.Strings[OutputEditHistoryIndex];
          OutputEdit.SelStart := Length(OutputEdit.Text);
        end;
      end;
      VK_DOWN:
      begin
        Key := 0;
        if OutputEditHistoryIndex < OutputEditHistoryStringList.Count - 1 then
        begin
          Inc(OutputEditHistoryIndex);
          OutputEdit.Text := OutputEditHistoryStringList.Strings[OutputEditHistoryIndex];
          OutputEdit.SelStart := Length(OutputEdit.Text);
        end;
      end;
    end;
end;

procedure TMainForm.OutputEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    ScriptManager.Editor.ConsoleAppSendInput(OutputEdit.Text + #13#10);
    OutputEditHistoryStringList.Append(OutputEdit.Text);
    OutputEditHistoryIndex := OutputEditHistoryStringList.Count;
    OutputEdit.Text := '';
  end;
end;

procedure TMainForm.OutputMenuClick(Sender: TObject);
begin
  OutputMenu.Checked := not OutputMenu.Checked;
  if OutputMenu.Checked then
    if OutputPanel.Height < OutputSplitter.MinSize then
      OutputPanel.Height := OutputSplitter.MinSize;
  OutputPanel.Visible := OutputMenu.Checked;
  OutputSplitter.Visible := OutputMenu.Checked;
  if not OutputMenu.Checked then
    SynEdit.SetFocus
  else if OutputEdit.Visible then
    OutputEdit.SetFocus;
end;

procedure TMainForm.OutputSelectAllMenuClick(Sender: TObject);
begin
  OutputMemo.SelectAll;
end;

procedure TMainForm.OutputSplitterMoved(Sender: TObject);
begin
  if OutputPanel.Height < OutputSplitter.MinSize then
  begin
    OutputSplitter.Hide;
    OutputPanel.Hide;
    OutputMenu.Checked := False;
  end;
end;

procedure TMainForm.PasteMenuClick(Sender: TObject);
begin
  if SynEdit.Focused then
    SynEdit.PasteFromClipboard
  else if OutputEdit.Focused then
    OutputEdit.PasteFromClipboard;
end;

procedure TMainForm.RedoMenuClick(Sender: TObject);
begin
  SynEdit.Redo;
  CheckEditMenuStatus;
end;

procedure TMainForm.SyntaxMenuClick(Sender: TObject);
var
  Item: TMenuItem;
begin
  if Sender is TMenuItem then
  begin
    Item := Sender as TMenuItem;
    case Item.Tag of
      0:
    end;
    Item.Checked := True;
  end;
end;

procedure TMainForm.UndoMenuClick(Sender: TObject);
begin
  if SynEdit.Focused then
  begin
    SynEdit.Undo;
    CheckEditMenuStatus;
  end
  else if OutputEdit.Focused then
    OutputEdit.Undo;
end;

procedure TMainForm.ViewManagerHighlighterChange(Sender: TObject);
begin
  ScriptManager.Editor.SynHighlighter := ViewManager.SynHighlighter;
end;

procedure TMainForm.ScriptEditorOutputUpdate(Sender: TObject;
  const NewOutput: String; Running: Boolean);
begin
  if not OutputMenu.Checked then
    OutputMenu.Click;
  OutputMemo.SelStart := Length(OutputMemo.Text);
  OutputMemo.SelText := NewOutput;

  if not OutputEdit.Visible and Running then
  begin
    OutputEdit.Visible := True;
    // only set focus to OutputEdit if status changed to running
    OutputEdit.SetFocus;
  end
  else if OutputEdit.Visible and not Running then
  begin
    OutputEdit.Visible := False;
    SynEdit.SetFocus;
  end;
end;

procedure TMainForm.ScriptEditorSave(Sender: TObject; var Result: Boolean);
begin
  Result := IO.Save;
end;

procedure TMainForm.SelectAllMenuClick(Sender: TObject);
begin
  if SynEdit.Focused then
    SynEdit.SelectAll
  else if OutputEdit.Focused then
    OutputEdit.SelectAll
  else if OutputMemo.Focused then
    OutputMemo.SelectAll;
end;

procedure TMainForm.SettingsMenuClick(Sender: TObject);
begin
  IO.OpenEditor(ScriptManager.ScriptFileName);
end;

procedure TMainForm.ShowHighlighterMenuClick(Sender: TObject);
begin
  IO.OpenEditor('*highlighter*');
end;

procedure TMainForm.CheckEditMenuStatus;
begin
  UndoMenu.Enabled := SynEdit.CanUndo;
  PopupUndoMenu.Enabled := UndoMenu.Enabled;
  RedoMenu.Enabled := SynEdit.CanRedo;
  PopupRedoMenu.Enabled := RedoMenu.Enabled;
  PasteMenu.Enabled := SynEdit.CanPaste;
  PopupPasteMenu.Enabled := PasteMenu.Enabled;
end;

procedure TMainForm.SynEditPaintTransient(Sender: TObject; Canvas: TCanvas;
  TransientType: TTransientType);
const
  AllBrackets = ['{', '[', '(', '<', '}', ']', ')', '>'];
  OpenChars: array[0..3] of Char = ('{', '[', '(', '<');
  CloseChars: array[0..3] of Char = ('}', ']', ')', '>');
var
  Editor: TSynEdit;

  function CharToPixels(P: TBufferCoord): TPoint;
  begin
    Result := Editor.RowColumnToPixels(Editor.BufferToDisplayPos(P));
  end;

var
  P, Q: TBufferCoord;
  Pix: TPoint;
  D: TDisplayCoord;
  S: String;
  I: Integer;
  Attri: TSynHighlighterAttributes;
  start: Integer;
  TmpCharA, TmpCharB: Char;
begin
  Editor := TSynEdit(Sender);
  if Editor.SelAvail then Exit;

  P := Editor.CaretXY;
  D := Editor.DisplayXY;

  Start := Editor.SelStart;

  if (Start > 0) and (Start <= length(Editor.Text)) then
    TmpCharA := Editor.Text[Start]
  else
    TmpCharA := #0;

  if (Start < length(Editor.Text)) then
    TmpCharB := Editor.Text[Start + 1]
  else
    TmpCharB := #0;

  if not(TmpCharA in AllBrackets) and not(TmpCharB in AllBrackets) then
    Exit;

  if not(TmpCharB in AllBrackets) then
    P.Char := P.Char - 1;

  Editor.GetHighlighterAttriAtRowCol(P, S, Attri);

  for i := low(OpenChars) to High(OpenChars) do
    if (S = OpenChars[i]) or (S = CloseChars[i]) then
    begin
      Pix := CharToPixels(P);

      Editor.Canvas.Brush.Style := bsSolid;
      Editor.Canvas.Font.Assign(Editor.Font);
      Editor.Canvas.Font.Style := Attri.Style;

      if (TransientType = ttAfter) then
      begin
        Editor.Canvas.Font.Color := clNone;
        Editor.Canvas.Brush.Color := clAqua;
      end
      else
      begin
        Editor.Canvas.Font.Color := Attri.Foreground;
        Editor.Canvas.Brush.Color := Editor.ActiveLineColor;
      end;
      if Editor.Canvas.Font.Color = clNone then
        Editor.Canvas.Font.Color := Editor.Font.Color;
      if Editor.Canvas.Brush.Color = clNone then
        Editor.Canvas.Brush.Color := Editor.Color;

      Editor.Canvas.TextOut(Pix.X, Pix.Y, S);
      Q := Editor.GetMatchingBracketEx(P);

      if (Q.Char > 0) and (Q.Line > 0) then
      begin
        Pix := CharToPixels(Q);
        if Pix.X > Editor.Gutter.Width then
        begin
          if (Q.Line <> P.Line) and (TransientType <> ttAfter) then
          begin
            Editor.Canvas.Brush.Color := Attri.Background;
            if Editor.Canvas.Brush.Color = clNone then
              Editor.Canvas.Brush.Color := Editor.Color;
          end;
          if S = OpenChars[i] then
            Editor.Canvas.TextOut(Pix.X, Pix.Y, CloseChars[i])
          else Editor.Canvas.TextOut(Pix.X, Pix.Y, OpenChars[i]);
        end;
      end;

    end;
end;

procedure TMainForm.SynEditDropFiles(Sender: TObject; X, Y: integer;
  AFiles: TStrings);
var
  Opened: Boolean;
  i: Integer;
begin
  Opened := False;
  if IO.CanClear then
    for i := 0 to AFiles.Count - 1 do
      if ViewManager.CanOpen(AFiles.Strings[i]) then
        if Opened then
          IO.OpenEditor(AFiles.Strings[i])
        else
        begin
          IO.OpenFile(AFiles.Strings[i]);
          Opened := True;
        end;
end;

procedure TMainForm.SynEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in ScriptManager.Editor.ActiveChars then
    if ScriptManager.Editor.ActiveCharPressed(Key) then
      Key := #0;
end;

procedure TMainForm.SynEditStatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
var
  p: TBufferCoord;
const
  //ModifiedStrs: array[boolean] of string = ('', 'Geändert');
  InsertModeStrs: array[boolean] of string = ('Überschreiben', 'Einfügen');
begin
  // always scAll to cover new file loaded
  // caret position has changed
  if Changes * [scAll, scCaretX, scCaretY] <> [] then
  begin
    p := SynEdit.CaretXY;
    Statusbar.Panels[0].Text := Format('%6d:%3d', [p.Line, p.Char]);
    Statusbar.Panels[1].Text := Format('%d - %d', [SynEdit.SelStart, SynEdit.SelLength]);
  end;
  // insert mode has changed
  if Changes * [scAll, scInsertMode, scReadOnly] <> [] then
  begin
    Statusbar.Panels[2].Text := InsertModeStrs[SynEdit.InsertMode];
  end;
  // modified has changed
  if Changes * [scAll, scModified] <> [] then
  begin
    CheckEditMenuStatus;
    Share.Modified := SynEdit.Modified;
    //Statusbar.Panels[3].Text := ModifiedStrs[SynEdit.Modified];
    // update modified marker in caption and app title
    //TitleUpdate(Sender);
  end;
end;

end.
