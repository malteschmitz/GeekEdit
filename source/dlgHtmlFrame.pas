unit dlgHtmlFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  THtmlFrameDialog = class(TForm)
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    XhtmlComboBox: TComboBox;
    MetaMemo: TMemo;
    AddMetaBtn: TButton;
    MetaLabel: TLabel;
    HtmlLabel: TLabel;
    DoctypeRadioGroup: TRadioGroup;
    NoDoctypeUrlChkBox: TCheckBox;
    MetaGroupBox: TGroupBox;
    CssChkBox: TCheckBox;
    JsChkBox: TCheckBox;
    TitleEdit: TEdit;
    TitleLabel: TLabel;
    HtmlRadioGroup: TRadioGroup;
    XmlVersionComboBox: TComboBox;
    XmlLabel: TLabel;
    procedure AddMetaBtnClick(Sender: TObject);
    procedure HtmlRadioGroupClick(Sender: TObject);
  private
    function GetResult: String;
  published
  public
    function Execute: Boolean;
    property Result: String read GetResult;
  end;

implementation

uses
  StrUtils, dlgMetaTag;

{$R *.dfm}

procedure THtmlFrameDialog.AddMetaBtnClick(Sender: TObject);
var
  dlg: TMetaTagDialog;
  result: String;
begin
  dlg := TMetaTagDialog.Create(Self);
  try
    if dlg.ShowModal = mrOk then
    begin
      result := dlg.Result;
      if HtmlRadioGroup.ItemIndex = 1 then // XHTML
        result := Copy(result, 1, Length(result) - 1) + ' />';
      MetaMemo.Lines.Append(result);
    end;
  finally
    dlg.Free;
  end;
end;

function THtmlFrameDialog.Execute: Boolean;
begin
  Result := ShowModal = mrOk;
end;

function THtmlFrameDialog.GetResult: String;
var
  Zeilen: TStringList;
  xhtml: Boolean;
begin
  Result := '';
  Zeilen := TStringList.Create;
  try
    xhtml := HtmlRadioGroup.ItemIndex = 1;
    if xhtml then
      case XmlVersionComboBox.ItemIndex of
        0: Zeilen.Append('<?xml version="1.0" encoding="ISO-8859-1" ?>');
        1: Zeilen.Append('<?xml version="1.1" encoding="ISO-8859-1" ?>');
      end;

    if xhtml then
    begin
      case XhtmlComboBox.ItemIndex of
        0:
          case DoctypeRadioGroup.ItemIndex of
              0: //Transitional
                 Zeilen.Append('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">');
              1: //Frameset
                 Zeilen.Append('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">');
              2: //Strict
                 Zeilen.Append('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">');
            end;
        1:
          Zeilen.Append('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">');
      end;
      Zeilen.Append('<html xmlns="http://www.w3.org/1999/xhtml">');
    end // xhtml
    else
    begin
      case DoctypeRadioGroup.ItemIndex of
        0: //Transitional
           begin
             if NoDoctypeUrlChkBox.Checked then
               Zeilen.Append('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">')
             else
               Zeilen.Append('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">');
           end;
        1: //Frameset
           begin
             if NoDoctypeUrlChkBox.Checked then
               Zeilen.Append('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN">')
             else
               Zeilen.Append('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">');
           end;
        2: //Strict
           begin
             if NoDoctypeUrlChkBox.Checked then
               Zeilen.Append('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN>')
             else
               Zeilen.Append('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">');
           end;
      end;
      Zeilen.Append('<html>');
    end;

    Zeilen.Append('<head>');

    if xhtml then
    begin
      Zeilen.Append('<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" />');
      if CssChkBox.Checked then
        Zeilen.Append('<meta http-equiv="Content-Style-Type" content="text/css" />');
      if JsChkBox.Checked then
        Zeilen.Append('<meta http-equiv="Content-Script-Type" content="text/javascript" />');
    end
    else
    begin
      Zeilen.Append('<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">');
      if CssChkBox.Checked then
        Zeilen.Append('<meta http-equiv="Content-Style-Type" content="text/css">');
      if JsChkBox.Checked then
        Zeilen.Append('<meta http-equiv="Content-Script-Type" content="text/javascript">');
    end;

    Zeilen.AddStrings(MetaMemo.Lines);

    Zeilen.Append('<title>' + TitleEdit.Text + '</title>');
    Zeilen.Append('</head>');
    Zeilen.Append('<body>');
    Zeilen.Append('');
    Zeilen.Append('</body>');
    Zeilen.Append('</html>');

    Result := Copy(Zeilen.Text, 1, Length(Zeilen.Text) - Length(#13#10));
  finally
    Zeilen.Free;
  end;
end;

procedure THtmlFrameDialog.HtmlRadioGroupClick(Sender: TObject);
var
  i: Integer;
begin
  if HtmlRadioGroup.ItemIndex = 0 then // XHTML -> HTML
  begin
    for i := 0 to MetaMemo.Lines.Count - 1 do
      if RightStr(MetaMemo.Lines[i], 3) = ' />' then
        MetaMemo.Lines[i] := LeftStr(MetaMemo.Lines[i], Length(MetaMemo.Lines[i]) - 3) + '>'
      else if RightStr(MetaMemo.Lines[i], 2) = '/>' then
        MetaMemo.Lines[i] := LeftStr(MetaMemo.Lines[i], Length(MetaMemo.Lines[i]) - 2) + '>';
  end
  else // HTML -> XHTML
  begin
    for i := 0 to MetaMemo.Lines.Count - 1 do
      if RightStr(MetaMemo.Lines[i], 2) = ' >' then
        MetaMemo.Lines[i] := LeftStr(MetaMemo.Lines[i], Length(MetaMemo.Lines[i]) - 1) + '/>'
      else if RightStr(MetaMemo.Lines[i], 1) = '>' then
        MetaMemo.Lines[i] := LeftStr(MetaMemo.Lines[i], Length(MetaMemo.Lines[i]) - 1) + ' />';
  end;
end;

end.
