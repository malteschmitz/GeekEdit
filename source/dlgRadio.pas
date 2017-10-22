unit dlgRadio;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TRadioDialog = class(TForm)
    RadioGroup: TRadioGroup;
    ButtonPanel: TPanel;
    CancelBtn: TButton;
    OkBtn: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  end;

implementation

{$R *.dfm}

uses
  Menus;

procedure TRadioDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  s: TShortCut;
  i: Integer;
begin
  s := ShortCut(Key, Shift);
  for i := 0 to RadioGroup.Items.Count - 1 do
    if Assigned(RadioGroup.Items.Objects[i]) then
      if s = TShortCut(RadioGroup.Items.Objects[i]) then
      begin
        RadioGroup.ItemIndex := i;
        ModalResult := mrOk;
        Exit;
      end;
end;

procedure TRadioDialog.FormShow(Sender: TObject);
var
  i: Integer;
  l, r: Integer;
  s: TShortCut;
  Item: String;
begin
  for i := 0 to RadioGroup.Items.Count - 1 do
  begin
    Item := RadioGroup.Items.Strings[i];
    l := Pos('(', Item);
    r := Pos(')', Item);
    if r = Length(Item) then
      if l > 0 then
        if r > l then
        begin
          s := TextToShortCut(Copy(Item, l + 1, r - l - 1));
          RadioGroup.Items.Objects[i] := TObject(s);
        end;
  end;
end;

end.
