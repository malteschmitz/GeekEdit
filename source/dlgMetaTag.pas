unit dlgMetaTag;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ComCtrls, ExtCtrls, Dialogs, JvExStdCtrls, JvButton, JvCtrls,
  JvFooter, JvExExtCtrls, JvComponent;

type
  TAngabe = record
    typ, name, defaults: String;
  end;
  TMetaTagDialog = class(TForm)
    CategoryLabel: TLabel;
    CategoryComboBox: TComboBox;
    NameLabel: TLabel;
    NameComboBox: TComboBox;
    ValueLabel: TLabel;
    ValueComboBox: TComboBox;
    LanguageLabel: TLabel;
    LanguageComboBox: TComboBox;
    ButtonPanel: TPanel;
    CancelBtn: TButton;
    OkBtn: TButton;
    HelpBtn: TButton;
    procedure HelpBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ValueComboBoxChange(Sender: TObject);
    procedure NameComboBoxChange(Sender: TObject);
    procedure CategoryComboBoxChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LoadCategory;
  private
    FMetaTags: array of TAngabe;
    FResult: String;
  public
    property Result: String read FResult;
    function Execute: Boolean;
  end;

implementation

uses
  ShellApi;

const
  META_TAGS_FILE_NAME = 'GeekEditMetaTags.txt';

{$R *.dfm}

procedure TMetaTagDialog.LoadCategory;
var
  dat: System.Text;
  tmp: String;
  los: Bool;
  werte: array of String;
  i: Integer;
begin
  if not FileExists(ExtractFilePath(ParamStr(0)) + META_TAGS_FILE_NAME) then
  begin
    MessageDlg('Die Datei "' + META_TAGS_FILE_NAME + '" fehlt.', mtError, [mbOk], 0);
    exit;
  end;
  AssignFile(dat, ExtractFilePath(ParamStr(0)) + META_TAGS_FILE_NAME);
  Reset(dat);
  NameComboBox.Items.Clear;
  SetLength(FMetaTags, 0);
  los := False;
  while not eof(dat) do
  begin
    readln(dat, tmp);
    tmp := Trim(tmp);
    if tmp <> '' then
    begin
    if tmp[1] <> '#' then //Kein Kommentar
      begin
        if los then
        begin
          if (tmp[1] = '[') and (tmp[Length(tmp)] = ']') then //Kategorie zuende
            break;
          if tmp <> '' then
          begin
            SetLength(werte, 0);
            while Pos('|', tmp) > 0 do
            begin
              SetLength(werte, Length(werte) + 1);
              werte[Length(werte) - 1] := Copy(tmp, 1, Pos('|', tmp) - 1);
              Delete(tmp, 1, Pos('|', tmp));
            end;
            SetLength(werte, Length(werte) + 1);
            werte[Length(werte) - 1] := tmp;

            SetLength(FMetaTags, Length(FMetaTags) + 1);
            with FMetaTags[Length(FMetaTags) - 1] do
            begin
              name := werte[2];
              typ := werte[0];
              defaults := '';
              for i := 3 to Length(werte) - 1 do
              begin
                if defaults <> '' then
                  defaults := defaults + #13#10;
                defaults := defaults + werte[i];
              end;
            end;
            NameComboBox.Items.Add(werte[1] + ' "' + werte[2] + '"');
          end;
        end
        else
          if tmp = '[' + CategoryComboBox.Items.Strings[CategoryComboBox.ItemIndex] + ']' then
            los := True;
      end;
    end; //tmp <> ''
  end;
  if NameComboBox.Items.Count > 0 then
  begin
    NameComboBox.ItemIndex := 0;
    NameComboBoxChange(NameComboBox);
  end
  else
    MessageDlg('Die Datei "' + META_TAGS_FILE_NAME + '" ist beschädigt.', mtError, [mbOk], 0);
  CloseFile(dat);
end;

function TMetaTagDialog.Execute: Boolean;
begin
  Result := ShowModal = mrOk;
end;

procedure TMetaTagDialog.FormCreate(Sender: TObject);
var
  dat: System.Text;
  tmp: String;
begin
  if not FileExists(ExtractFilePath(ParamStr(0)) + META_TAGS_FILE_NAME) then
  begin
    MessageDlg('Die Datei "' + META_TAGS_FILE_NAME + '" fehlt.', mtError, [mbOk], 0);
    exit;
  end;
  AssignFile(dat, ExtractFilePath(ParamStr(0)) + META_TAGS_FILE_NAME);
  Reset(dat);
  CategoryComboBox.Items.Clear;
  while not eof(dat) do
  begin
    readln(dat, tmp);
    tmp := Trim(tmp);
    if tmp <> '' then
    begin
      if tmp[1] <> '#' then //Kein Kommentar
      begin
        if (tmp[1] = '[') and (tmp[Length(tmp)] = ']') then //Kategorie
          CategoryComboBox.Items.Add(Copy(tmp, 2, Length(tmp) - 2));
      end;
    end; //tmp <> ''
  end;
  CloseFile(dat);
  if CategoryComboBox.Items.Count = 0 then
    MessageDlg('Die Datei "' + META_TAGS_FILE_NAME +  '" ist beschädigt.', mtError, [mbOk], 0)
  else
  begin
    CategoryComboBox.ItemIndex := 0;
    LoadCategory;
  end;
end;

procedure TMetaTagDialog.CategoryComboBoxChange(Sender: TObject);
begin
  LoadCategory;
end;

procedure TMetaTagDialog.NameComboBoxChange(Sender: TObject);
begin
  ValueComboBox.Text := '';
  LanguageComboBox.Text := '';
  ValueComboBox.Items.Text := FMetaTags[NameComboBox.ItemIndex].defaults;
  ValueComboBoxChange(ValueComboBox);
end;

procedure TMetaTagDialog.ValueComboBoxChange(Sender: TObject);
var
  lang: String;
begin
  if LanguageComboBox.Text <> '' then
    lang := ' lang="' + LanguageComboBox.Text + '"'
  else
    lang := '';
  with FMetaTags[NameComboBox.ItemIndex] do
    FResult := '<meta ' + typ + '="' + name + '"' + lang + ' content="' + ValueComboBox.Text + '">';
end;

procedure TMetaTagDialog.FormShow(Sender: TObject);
begin
  ValueComboBox.Text := '';
  NameComboBox.SetFocus;
end;

procedure TMetaTagDialog.HelpBtnClick(Sender: TObject);
begin
  ShellExecute(0, 'open', 'http://de.selfhtml.org/html/kopfdaten/meta.htm',
    nil, nil, SW_SHOWNORMAL);
end;

end.

