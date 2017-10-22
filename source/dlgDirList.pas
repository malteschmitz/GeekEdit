unit dlgDirList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TDirListDialog = class(TForm)
    ButtonPanel: TPanel;
    CancelBtn: TButton;
    OkBtn: TButton;
    FormatMemo: TMemo;
    Label1: TLabel;
    SelDirBtn: TButton;
    DirEdit: TEdit;
    Label2: TLabel;
    FilesListBox: TListBox;
    DescMemo: TMemo;
    Label3: TLabel;
    FormatLabel: TLabel;
    PreviewMemo: TMemo;
    Label5: TLabel;
    Label4: TLabel;
    OffsetEdit: TEdit;
    procedure SelDirBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OffsetEditExit(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure Change(Sender: TObject);
  private
    function GetListing: String;
    procedure SetDir(const Value: String);
  published
  public
    function Execute: Boolean;
    property Listing: String read GetListing;
    property Dir: String write SetDir;
  end;

implementation

{$R *.dfm}

uses
  StBrowsr, jpeg, PngImage, GifImage;

procedure TDirListDialog.Change(Sender: TObject);
begin
  PreviewMemo.Text := GetListing;
end;

function TDirListDialog.Execute: Boolean;
begin
  Result := ShowModal = mrOk;
end;

procedure TDirListDialog.FormCreate(Sender: TObject);
begin
  Application.HintPause := 0;
  Application.HintHidePause := 99999;
  Application.HintColor := clMoneyGreen;
  FormatLabel.Hint := '%0:.3d = Index als 001'#13#10
                    + '%1:s = Dateiname ohne Pfad'#13#10
                    + '%2:s = Dateiname mit Pfad'#13#10
                    + '%3:s = Beschreibung (indiziert wie Index)'#13#10
                    + '%4:s = Breite des Bildes'#13#10
                    + '%5:s = Höhe des Bildes';
  FormatLabel.ShowHint := True;
  FormatMemo.ShowHint := True;
end;

procedure TDirListDialog.FormDeactivate(Sender: TObject);
begin
  Application.HintPause := 500;
  Application.HintHidePause := 5 * 500;
  Application.HintColor := clInfoBk;
end;

function TDirListDialog.GetListing: String;

  function GetDesc(Index: Integer): String;
  begin
    if Index > DescMemo.Lines.Count then
      Result := DescMemo.Lines.Strings[Index]
    else
      Result := '';
  end;

var
  i: Integer;
  Index: Integer;
  Offset: Integer;
  Width, Height: Integer;
  Picture: TPicture;
begin
  try
    Result := '';
    Picture := TPicture.Create;
    try
      Index := 0;
      Offset := StrToIntDef(OffsetEdit.Text, 0);
      for i := 0 to FilesListBox.Count - 1 do
        if FilesListBox.Selected[i] then
        begin
          try
            Picture.LoadFromFile(DirEdit.Text + FilesListBox.Items.Strings[i]);
            Width := Picture.Width;
            Height := Picture.Height;
          except
            Width := 0;
            Height := 0;
          end;
          Result := Result + Format(FormatMemo.Text, [Offset, FilesListBox.Items[i], DirEdit.Text + FilesListBox.Items[i], GetDesc(Index), Width, Height]) + #13#10;
          Inc(Offset);
          Inc(Index);
        end;
      // delete last line break
      Delete(Result, Length(Result) - 1, 2);
    finally
      Picture.Free;
    end;
  except
    on E: EconvertError do
      Result := E.Message;
    on E: Exception do
      raise E;
  end;
end;

procedure TDirListDialog.OffsetEditExit(Sender: TObject);
begin
  OffsetEdit.Text := IntToStr(StrToIntDef(OffsetEdit.Text, 0));
end;

procedure TDirListDialog.SelDirBtnClick(Sender: TObject);
var
  dlg: TStBrowser;
begin
  dlg := TStBrowser.Create(Self);
  try
    dlg.SelectedFolder := DirEdit.Text;
    dlg.Options := [boReturnOnlyDirs];
    dlg.Caption := 'Verzeichnis...';
    if dlg.Execute then
      Dir := dlg.Path;
  finally
    dlg.Free;
  end;
end;

procedure TDirListDialog.SetDir(const Value: String);
var
  F: TSearchRec;
begin
  DirEdit.Text := IncludeTrailingPathDelimiter(Value);
  FilesListBox.Clear;
  if FindFirst(DirEdit.Text + '*.*', 0, F) = 0 then
    repeat
      FilesListBox.Items.Append(F.Name);
    until FindNext(F) <> 0;
  FilesListBox.SelectAll;
end;

end.
