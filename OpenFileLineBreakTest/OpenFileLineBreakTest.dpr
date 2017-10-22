program OpenFileLineBreakTest;

// TESTZIEL
// scheinbar reagiert ReadLn(F) anders als TStringList auf Mac-Zeilenumbrüche?

uses
  Classes, Dialogs, SysUtils;

procedure ShowHex(const s: String);
var
  tmp: String;
  i: Integer;
begin
  tmp := '';
  for i := 1 to Length(s) do
    tmp := tmp + s[i] + ' (' + IntToHex(Ord(s[i]), 2) + '), ';
  ShowMessage(tmp);
end;

const
  FILENAME = 'C:\Stz\m\daten\ProjekteT61\GeekEdit\test.txt';
var
  F: System.Text;
  txt, tmp: String;
  sl: TStringList;
  fs: TFileStream;
begin
  AssignFile(F, FILENAME);
  try
    Reset(F);
    while not Eof(F) do
    begin
      ReadLn(F, tmp);
      txt := txt + tmp + #13#10;
    end;
    Delete(txt, Length(txt) - 1, 2);
    //ShowMessage('"' + txt + '"');
  finally
    CloseFile(F);
  end;

  sl := TStringList.Create;
  try
    sl.LoadFromFile(FILENAME);
    //ShowMessage('"' + sl.Text + '"');
  finally
    sl.Free;
  end;

  txt := '';
  SetLength(txt, 12);
  // ShowHex(txt);

  fs := TFileStream.Create(FILENAME, fmOpenRead);
  try
    SetLength(txt, fs.Size);
    fs.Read(txt[1], fs.Size);
  finally
    fs.Free;
  end;
  ShowHex(txt);

  sl := TStringList.Create;
  try
    sl.Text := txt;
    // ShowMessage(sl.LineBreak);
    ShowMessage(IntToStr(sl.Count));
    ShowHex(sl.Text);
  finally
    sl.Free;
  end;
end.
