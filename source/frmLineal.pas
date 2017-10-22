unit frmLineal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, Menus, Clipbrd;

type
  TLinealForm = class(TForm)
    PopupMenu: TPopupMenu;
    s640Menu: TMenuItem;
    s800Menu: TMenuItem;
    s1024Menu: TMenuItem;
    ValueLabel: TLabel;
    s1280Menu: TMenuItem;
    s1400Menu: TMenuItem;
    Drehen1: TMenuItem;
    OkMenu: TMenuItem;
    CancelMenu: TMenuItem;
    Kopieren1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure s1024MenuClick(Sender: TObject);
    procedure s800MenuClick(Sender: TObject);
    procedure s640MenuClick(Sender: TObject);
    procedure Drehen;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure s1280MenuClick(Sender: TObject);
    procedure s1400MenuClick(Sender: TObject);
    procedure Drehen1Click(Sender: TObject);
    procedure Kopieren1Click(Sender: TObject);
    procedure OkMenuClick(Sender: TObject);
    procedure CancelMenuClick(Sender: TObject);
  private
    function GetValue: String;
  public
    function Execute: Boolean;
    property Value: String read GetValue;
  published
  private
    horizontal: Boolean;
    procedure WMNCHitTest(var M: TWMNCHitTest); message wm_NCHitTest;
  end;

implementation

{$R *.dfm}

procedure TLinealForm.WMNCHitTest (var M: TWMNCHitTest);
begin
  inherited;
  if M.Result = htClient then
  begin
    if (GetAsyncKeyState(VK_LBUTTON) <> 0) or (GetAsyncKeyState(VK_RBUTTON) <> 0) then
      M.Result := htCaption;
  end;
end;

procedure TLinealForm.FormPaint(Sender: TObject);
var
  i: Integer;
begin
  if horizontal then
  begin
    for i := 1 to Width do
    begin
      if (i = 640) or (i = 800) or (i = 1024) or (i = 1208) or (i = 1400) then
      begin
        Canvas.Pen.Style := psSolid;
        Canvas.Pen.Color := clRed;
        Canvas.MoveTo(i - 1, 0);
        Canvas.LineTo(i - 1, Height);
      end
      else if i mod 50 = 0 then
      begin
        Canvas.Pen.Style := psSolid;
        Canvas.Pen.Color := clBlack;
        Canvas.MoveTo(i - 1, 0);
        Canvas.LineTo(i - 1, Height);
        Canvas.TextFlags := ETO_OPAQUE;
        Canvas.TextOut(i - 1 - Canvas.TextWidth(IntToStr(i)) div 2, Height div 2 - Canvas.TextHeight(IntToStr(i)) div 2, IntToStr(i));
      end
      else if i mod 10 = 0 then
      begin
        Canvas.Pen.Style := psSolid;
        Canvas.Pen.Color := clBlack;
        Canvas.MoveTo(i - 1, 0);
        Canvas.LineTo(i - 1, 10);
        Canvas.MoveTo(i - 1, Height - 10);
        Canvas.LineTo(i - 1, Height);
      end
      else if i mod 5 = 0 then
      begin
        Canvas.Pen.Style := psSolid;
        Canvas.Pen.Color := clBlue;
        Canvas.MoveTo(i - 1, 0);
        Canvas.LineTo(i - 1, 5);
        Canvas.MoveTo(i - 1, Height - 5);
        Canvas.LineTo(i - 1, Height);
      end;
    end;
  end
  else //vertikal
  begin
    for i := 1 to Height do
    begin
      if (i = 480) or (i = 600) or (i = 768) or (i = 1024) or (i = 1050) then
      begin
        Canvas.Pen.Style := psSolid;
        Canvas.Pen.Color := clRed;
        Canvas.MoveTo(0, i - 1);
        Canvas.LineTo(Width, i - 1);
      end
      else if i mod 50 = 0 then
      begin
        Canvas.Pen.Style := psSolid;
        Canvas.Pen.Color := clBlack;
        Canvas.MoveTo(0, i - 1);
        Canvas.LineTo(Width, i - 1);
        Canvas.TextFlags := ETO_OPAQUE;
        Canvas.TextOut(Width div 2 - Canvas.TextWidth(IntToStr(i)) div 2, i - 1 - Canvas.TextHeight(IntToStr(i)) div 2, IntToStr(i));
      end
      else if i mod 10 = 0 then
      begin
        Canvas.Pen.Style := psSolid;
        Canvas.Pen.Color := clBlack;
        Canvas.MoveTo(0, i - 1);
        Canvas.LineTo(10, i - 1);
        Canvas.MoveTo(Width - 10, i - 1);
        Canvas.LineTo(Width, i - 1);
      end
      else if i mod 5 = 0 then
      begin
        Canvas.Pen.Style := psSolid;
        Canvas.Pen.Color := clBlue;
        Canvas.MoveTo(0, i - 1);
        Canvas.LineTo(5, i - 1);
        Canvas.MoveTo(Width - 5, i - 1);
        Canvas.LineTo(Width, i - 1);
      end;
    end;
  end;
end;

function TLinealForm.GetValue: String;
begin
  Result := ValueLabel.Caption;
end;

procedure TLinealForm.Kopieren1Click(Sender: TObject);
begin
  Clipboard.AsText := Value;
end;

procedure TLinealForm.OkMenuClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TLinealForm.Drehen1Click(Sender: TObject);
begin
  Drehen;
end;

function TLinealForm.Execute: Boolean;
begin
  Result := ShowModal = mrOk;
end;

procedure TLinealForm.FormCreate(Sender: TObject);
begin
  horizontal := True;
  ValueLabel.Top := (Height - ValueLabel.Height) div 2;
  ValueLabel.Left := (50 - ValueLabel.Width) div 2;;
  ValueLabel.Repaint;
end;

procedure TLinealForm.CancelMenuClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TLinealForm.Drehen;
begin
  Canvas.Brush.Style := bsSolid;
  Canvas.Brush.Color := Color;
  Canvas.FillRect(Rect(0, 0, Width, Height));
  if horizontal then
  begin
    //Vertikal
    horizontal := False;
    if Width = 640 then
      Height := 480
    else if Width = 800 then
      Height := 600
    else
      Height := 768;
    Width := 50;
    ValueLabel.Top := (50 - ValueLabel.Height) div 2;;
    ValueLabel.Left := (Width - ValueLabel.Width) div 2;
    ValueLabel.Repaint;
  end
  else
  begin
    //Horizontal
    horizontal := True;
    if Height = 480 then
      Width := 640
    else if Height = 600 then
      Width := 800
    else
      Width := 1024;
    Height := 50;
    ValueLabel.Top := (Height - ValueLabel.Height) div 2;
    ValueLabel.Left := (50 - ValueLabel.Width) div 2;;
    ValueLabel.Repaint;
  end;
  FormPaint(Self);
end;

procedure TLinealForm.s640MenuClick(Sender: TObject);
begin
  if horizontal then
    Width := 640
  else
    Height := 480;
end;

procedure TLinealForm.s800MenuClick(Sender: TObject);
begin
  if horizontal then
    Width := 800
  else
    Height := 600;
end;

procedure TLinealForm.s1024MenuClick(Sender: TObject);
begin
  if horizontal then
    Width := 1024
  else
    Height := 768;
end;

procedure TLinealForm.s1280MenuClick(Sender: TObject);
begin
  if horizontal then
    Width := 1280
  else
    Height := 1024;
end;

procedure TLinealForm.s1400MenuClick(Sender: TObject);
begin
  if horizontal then
    Width := 1400
  else
    Height := 1050;
end;

procedure TLinealForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if horizontal then
    ValueLabel.Caption := IntToStr(X + 1)
  else
    ValueLabel.Caption := IntToStr(Y + 1);
end;

end.
