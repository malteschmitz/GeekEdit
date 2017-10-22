unit uIO;

interface

uses
  SynEdit, Classes;

type
  TLineBreakType = (lbtUnknown, lbtDos, lbtUnix, lbtMac);
  TCharSetType = (cstCp1252, cstUtf8, cstUtf8Bom);

  TIO = class
  private
    SynEdit: TSynEdit;
    FLineBreakType: TLineBreakType;
    FCharSetType: TCharSetType;
    FFileDate: TDateTime;

    FOnUpdate: TNotifyEvent;

    procedure DoSave;
    procedure DoOpen;

    function GetLineBreakChars: String;
    procedure SaveFileDate;
    function GetFileDate: TDateTime;
  public
    constructor Create(SynEdit: TSynEdit);

    procedure NewFile;
    procedure OpenFile(const AFileName: string);

    procedure NewMenuClick(Sender: TObject);
    procedure OpenMenuClick(Sender: TObject);
    procedure SaveMenuClick(Sender: TObject);
    function Save: Boolean;
    procedure SaveAsMenuClick(Sender: TObject);
    function SaveAs: Boolean;
    procedure LineBreakTypeMenuClick(Sender: TObject);
    procedure CharSetTypeMenuClick(Sender: TObject);
    procedure ReloadMenuClick(Sender: TObject);
    procedure Reload;
    procedure ApplicationActivate(Sender: TObject);

    procedure OpenEditor(FileName: String = '');

    function CanClear: Boolean;

    property LineBreakType: TLineBreakType read FLineBreakType;
    property CharSetType: TCharSetType read FCharSetType;

    property OnUpdate: TNotifyEvent read FOnUpdate write FOnUpdate;
  end;

implementation

uses
  Windows, Dialogs, SysUtils, Controls, Menus, uShare;

{ TIO }

procedure TIO.ApplicationActivate(Sender: TObject);
begin
  if GetFileDate > FFileDate then
  begin
    // prevent asking twice
    SaveFileDate;

    if MessageDlg('Datei wurde verändert. Neuladen?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      Reload;
  end;
end;

function TIO.CanClear: Boolean;
var
  Erg: Integer;
begin
  Result := True;
  if SynEdit.Modified then
  begin
    if Share.FileName = '' then
      Erg := MessageDlg('Der Text in der unbenannten Datei wurde verändert.'#13#10#13#10'Änderungen speichern?', mtWarning, [mbYes, mbNo, mbCancel], 0)
    else
      Erg := MessageDlg(Format('Der Text in der Datei "%s" wurde verändert.'#13#10#13#10'Änderungen speichern?', [Share.FileName]), mtWarning, [mbYes, mbNo, mbCancel], 0);
    if Erg = mrYes then
      Result := Save
    else if Erg = mrCancel then
      Result := False;
  end;
end;

procedure TIO.CharSetTypeMenuClick(Sender: TObject);
var
  Item: TMenuItem;
begin
  if Sender is TMenuItem then
  begin
    Item := Sender as TMenuItem;
    case Item.Tag of
      0: FCharSetType := cstCp1252;
      1: FCharSetType := cstUtf8;
      2: FCharSetType := cstUtf8Bom;
    end;
    if Assigned(FOnUpdate) then
      FOnUpdate(Self);
  end;
end;

constructor TIO.Create(SynEdit: TSynEdit);
begin
  Self.SynEdit := SynEdit;
  FFileDate := 0;
end;

procedure TIO.NewFile;
begin
  Share.FileName := '';
  FFileDate := 0;
  SynEdit.Clear;
  SynEdit.Modified := False;
  FLineBreakType := lbtDos;
  FCharSetType := cstCp1252;
  if Assigned(FOnUpdate) then
    FOnUpdate(Self);
end;

procedure TIO.NewMenuClick(Sender: TObject);
begin
  if CanClear then
    NewFile;
end;

procedure TIO.OpenEditor(FileName: String = '');
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  if FileName <> '' then
      FileName := ' "' + FileName + '"';
  FillChar(StartupInfo, SizeOf(StartupInfo), #0); 
  StartupInfo.cb := SizeOf(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := SW_SHOWNORMAL;
  CreateProcess(nil, 
    PChar(ParamStr(0) + FileName),
    nil,
    nil,
    False,
    CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS,
    nil,
    nil,
    StartupInfo,
    ProcessInfo);
end;

procedure TIO.OpenFile(const AFileName: string);
begin
  // check if file exists
  if FileExists(AFileName) then
  begin
    // set FileName
    Share.FileName := AFileName;

    // read file content and get charset type
    DoOpen;

    // get file date
    SaveFileDate;
  end
  else
  begin
    MessageDlg('Die Datei "' + AFileName + '" konnte nicht gefunden werden!'
      + #13#10#13#10 + 'Speichern um die Datei zu erzeugen!', mtWarning,
      [mbOk], 0);

    // set FileName
    Share.FileName := AFileName;

    // new file
    SynEdit.Clear;
    SynEdit.Modified := False;
    FLineBreakType := lbtDos;
    FCharSetType := cstCp1252;
    FFileDate := 0;
  end;

  SynEdit.Modified := False;
  if Assigned(FOnUpdate) then
    FOnUpdate(Self);
end;

procedure TIO.OpenMenuClick(Sender: TObject);
var
  dlg: TOpenDialog;
begin
  if CanClear then
  begin
    dlg := TOpenDialog.Create(nil);
    try
      dlg.Options := [ofHideReadOnly, ofFileMustExist, ofEnableSizing];
      dlg.OptionsEx := [];
      dlg.Title := 'Öffnen...';
      dlg.Filter := 'Alle Dateien (*.*)|*.*';
      if dlg.Execute then
        OpenFile(dlg.FileName);
    finally
      dlg.Free;
    end;
  end;
end;

procedure TIO.Reload;
begin
  if CanClear then
  begin
    DoOpen;
    SaveFileDate;
    SynEdit.Modified := False;
    if Assigned(FOnUpdate) then
      FOnUpdate(Self);
  end;
end;

procedure TIO.ReloadMenuClick(Sender: TObject);
begin
  Reload;
end;

function TIO.Save: Boolean;
begin
  if Share.FileName = '' then
    Result := SaveAs
  else
  begin
    DoSave;
    SaveFileDate;
    SynEdit.Modified := False;
    Result := True;
  end;
end;

function TIO.SaveAs: Boolean;
var
  dlg: TSaveDialog;
begin
  dlg := TSaveDialog.Create(nil);
  try
    dlg.Title := 'Speichern unter...';
    dlg.Options := [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing];
    dlg.OptionsEx := [];
    dlg.Filter := 'Alle Dateien (*.*)|*.*';
    dlg.FileName := Share.FileName;
    Result := dlg.Execute;
    if Result then
    begin
      Share.FileName := dlg.FileName;
      Save;
      if Assigned(FOnUpdate) then
        FOnUpdate(Self);
    end;
  finally
    dlg.Free;
  end;
end;

procedure TIO.SaveAsMenuClick(Sender: TObject);
begin
  SaveAs;
end;

procedure TIO.SaveMenuClick(Sender: TObject);
begin
  Save;
end;

// reads the file into a string an discovers the charset
// @return the decoded string
procedure TIO.DoOpen;
var
  f: TFileStream;
  txt: String;
  len, i: Integer;
  sl: TStringList;
  utf8, ascii: Boolean;
begin
  // read the whole content of the file exactly into txt
  f := TFileStream.Create(Share.FileName, fmOpenRead or fmShareDenyNone);
  try
    len := f.Size;
    SetLength(txt, len);
    if len > 0 then
      f.Read(txt[1], len);
  finally
    f.Free;
  end;

  // guess line break type
  FLineBreakType := lbtUnknown;
  i := 1;
  while (FLineBreakType = lbtUnknown) and (i <= len) do
  begin
    if txt[i] = #10 then
      FLineBreakType := lbtUnix
    else if txt[i] = #13 then
    begin
      if Copy(txt, i, 2) = #13#10 then
        FLineBreakType := lbtDos
      else
        FLineBreakType := lbtMac;
    end;
    Inc(i);
  end;

  // guess encoding and decode if needed
  sl := TStringList.Create;
  try
    sl.LineBreak := GetLineBreakChars;
    sl.Text := txt;
    i := 0;
    utf8 := True;
    ascii := True;
    while utf8 and (i < sl.Count) do
    begin
      // the function Utf8ToAnsi tries to decode an UTF8 string
      // such a string contains onlay ASCII if the decoded string is the same as before
      // the function returns '' if it couldn't decode the string, which happens
      // with most ANSI chars
      if ascii then
        ascii := Utf8ToAnsi(sl.Strings[i]) = sl.Strings[i];
      if not ascii then
        if sl.Strings[i] > '' then
          utf8 := Utf8ToAnsi(sl.Strings[i]) > '';
      Inc(i);
    end;
  finally
    sl.Free;
  end;
  // handle ASCII as Cp1252
  if ascii then
    utf8 := False;
  // detect BOM
  if utf8 then
  begin
    if Copy(txt, 1, 3) = #$EF#$BB#$BF then
    begin
      Delete(txt, 1, 3);
      FCharSetType := cstUtf8Bom;
    end
    else
      FCharSetType := cstUtf8;
    txt := Utf8ToAnsi(txt);
  end
  else
    FCharSetType := cstCp1252;

  // load txt into SynEdit
  SynEdit.Lines.LineBreak := #13#10;
  // setting LineBreak to #13#10 makes SynEdit accept #13#10, #10 and #13 as
  // line break (even mixed in one file)
  // further more search and replace based on #13#10 line breaks does work

  // prevent SynEdits StringList "eating" the last line
  SynEdit.Lines.Text := txt + GetLineBreakChars;
end;

procedure TIO.SaveFileDate;
begin
  FFileDate := GetFileDate;
end;

function TIO.GetFileDate: TDateTime;
var
  F: TSearchRec;
begin
  if FindFirst(Share.FileName, faAnyFile, F) = 0 then
  begin
    Result := FileDateToDateTime(F.Time);
    FindClose(F);
  end
  else
    Result := 0
end;

function TIO.GetLineBreakChars: String;
begin
  case FLineBreakType of
    lbtUnknown: Result := #13#10; // default = Dos
    lbtDos: Result := #13#10;
    lbtUnix: Result := #10;
    lbtMac: Result := #13;
  end;
end;

procedure TIO.LineBreakTypeMenuClick(Sender: TObject);
var
  Item: TMenuItem;
begin
  if Sender is TMenuItem then
  begin
    Item := Sender as TMenuItem;
    case Item.Tag of
      0: FLineBreakType := lbtDos;
      1: FLineBreakType := lbtUnix;
      2: FLineBreakType := lbtMac;
    end;
    if Assigned(FOnUpdate) then
      FOnUpdate(Self);
  end;
end;

procedure TIO.DoSave;
var
  txt: String;
  fs: TFileStream;
begin
  // get the text only with #13#10 as line break
  // otherwise theres a bug in SynEdit eating the last char
  SynEdit.Lines.LineBreak := #13#10;
  txt := SynEdit.Lines.Text;

  // replace #13#10 with the wanted line break
  if FLineBreakType in [lbtUnix, lbtMac] then
    txt := StringReplace(txt, #13#10, GetLineBreakChars, [rfReplaceAll]);

  // encode as UTF-8 if needed
  if FCharSetType in [cstUtf8, cstUtf8Bom] then
    txt := AnsiToUtf8(txt);

  // add BOM if needed
  if FCharSetType = cstUtf8Bom then
    txt := #$EF#$BB#$BF + txt;

  // save txt exactly into file
  fs := TFileStream.Create(Share.FileName, fmCreate or fmShareDenyWrite);
  try
    if Length(txt) > 0 then
      fs.Write(txt[1], Length(txt));
  finally
    fs.Free;
  end;
end;

end.
