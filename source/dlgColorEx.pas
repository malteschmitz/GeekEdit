unit dlgColorEx;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons;

type
  TColorExDialog = class(TForm)
    BlauRadioBtn: TRadioButton;
    GruenRadioBtn: TRadioButton;
    RotRadioBtn: TRadioButton;
    BlauEdit: TEdit;
    GruenEdit: TEdit;
    RotEdit: TEdit;
    ColorPanel: TPanel;
    Panel: TPanel;
    Image: TImage;
    Shape: TShape;
    SelPanel: TPanel;
    SelImage: TImage;
    SelShape: TShape;
    OldColorPanel: TPanel;
    HtmlEdit: TEdit;
    HtmlLabel: TLabel;
    DelphiEdit: TEdit;
    DelphiLabel: TLabel;
    UseNamesChkBox: TCheckBox;
    ValueRadioBtn: TRadioButton;
    SaturationRadioBtn: TRadioButton;
    HueRadioBtn: TRadioButton;
    ValueEdit: TEdit;
    SaturationEdit: TEdit;
    HueEdit: TEdit;
    VgaGroupBox: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    W3cGroupBox: TGroupBox;
    OkBtn: TButton;
    CancelBtn: TButton;
    DemoPanel: TPanel;
    DemoPaintBox: TPaintBox;
    WinSpeedButton: TSpeedButton;
    HelpSpeedButton: TSpeedButton;
    ColorDialog: TColorDialog;
    DemoCaptionPanel: TPanel;
    DemoLabel: TLabel;
    procedure WinSpeedButtonClick(Sender: TObject);
    procedure HelpSpeedButtonClick(Sender: TObject);
    procedure DemoPaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure FarbeClick(Sender: TObject);
    procedure DemoPaintBoxClick(Sender: TObject);
    procedure DemoPaintBoxPaint(Sender: TObject);
    procedure BlauEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ColorPanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DelphiEditExit(Sender: TObject);
    procedure HtmlEditExit(Sender: TObject);
    procedure UseNamesChkBoxClick(Sender: TObject);
    procedure ShapeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SelShapeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SelImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ZahlRadioBtnClick(Sender: TObject);
    procedure ShapeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SelImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SelShapeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SelShapeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SelImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure ShapeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ZahlEditChange(Sender: TObject);
    procedure ZahlEditKeyPress(Sender: TObject; var Key: Char);
    procedure GetRGB(var r, g, b: Byte);
    procedure Zeichne;
    procedure ZeichneSel;
    procedure GetHSV(var h, s, v: Byte);
    procedure ReglerFarbe;
  private
    AutoZeichnen: Bool; //verhindert das automatische Zeichnen bei OnChange
    NoOnChange: Bool; //verhindert jegliche Reaktion auf das OnChange-Ereignis
    DemoFarbe: TColor;
    DemoSwap, UseNumSign: Boolean;
    bild, demobild: TBitmap;
    procedure SetHtmlColor(NewHtmlColor: String);
    function GetHtmlColor: String;
  public
    property HtmlColor: String read GetHtmlColor write SetHtmlColor;
    function Execute: Boolean;
  end;

implementation

{$R *.dfm}

uses
  uColor, ShellApi;

procedure TColorExDialog.ReglerFarbe;
begin
  //setzte die Farbe der beiden Regler
  SelShape.Pen.Color := BlackWhiteContrastColor(SelImage.Picture.Bitmap.Canvas.Pixels[1,SelShape.Top + SelShape.Height div 2]);
  Shape.Pen.Color := BlackWhiteContrastColor(Image.Picture.Bitmap.Canvas.Pixels[Shape.Left + Shape.Width div 2, Shape.Top + Shape.Height div 2]);
end;

//Funcktion für die Property HtmlColor
procedure TColorExDialog.SetHtmlColor(NewHtmlColor:String);
begin
  //HtmlEdit.Text setzen und auf diese Weise alles andere Setzen
  HtmlEdit.Text := NewHtmlColor;
  HtmlEditExit(HtmlEdit);
  //die aktuell Farbe zur alten Farbe machen.
  //(tut nichts anderes, als unter der aktuellen Farbe angezeigt zu werden)
  OldColorPanel.Color := ColorPanel.Color;
end;

//Funktion für die Property HtmlColor
function TColorExDialog.GetHtmlColor: String;
begin
  //verhindern, dass der User gerade in HtmlEdit einen sinnfreien Wert geschrieben hat
  HtmlEditExit(HtmlEdit);
  //Wert aus HtmlEdit zurückgeben
  Result := HtmlEdit.Text;
end;

procedure TColorExDialog.ZahlEditKeyPress(Sender: TObject; var Key: Char);
begin
  //wird aufgerufen von Rot, Gruen, Blau, Farbton, Sättigung und Helligkeit
  //und verhindert eine andere Eingabe als Zahlen.
  case Key of
    '0'..'9', #8:;
  else
    Key := #0;
  end;
end;

procedure TColorExDialog.GetRGB(var r, g, b: Byte);
begin
  //Füllt die var-Parameter mit dern Werten aus den drei Edit-Feldern
  //try-except ist jedesmal nötig, da '' zwar erlaubt ist, aber nicht
  //in eine Zahl umgewandelt werden kann
  try
    r := StrToInt(RotEdit.Text);
  except
    r := 0;
  end;
  try
    g := StrToInt(GruenEdit.Text);
  except
    g := 0;
  end;
  try
    b := StrToInt(BlauEdit.Text);
  except
    b := 0;
  end;
end;

procedure TColorExDialog.GetHSV(var h, s, v: Byte);
begin
  //Füllt die var-Parameter mit dern Werten aus den drei Edit-Feldern
  //try-except ist jedesmal nötig, da '' zwar erlaubt ist, aber nicht
  //in eine Zahl umgewandelt werden kann
  try
    h := StrToInt(HueEdit.Text);
  except
    h := 0;
  end;
  try
    s := StrToInt(SaturationEdit.Text);
  except
    s := 0;
  end;
  try
    v := StrToInt(ValueEdit.Text);
  except
    v := 0;
  end;
end;

procedure TColorExDialog.Zeichne;
//Setzt den Selektor im kleinen Balken und zeichnet die
//große Fläche neu

var
  r,g,b,h,s,v,x,y: Byte;
  farbe: TColor;
  add1,add2: Integer;
  actPixel: ^Integer;

  procedure Anfang;
  begin
    SelShape.Top := y - SelShape.Height div 2;

    bild.PixelFormat := pf32Bit;
    bild.Width := 256;
    bild.Height := 256;
    actPixel := bild.ScanLine[255];
  end;

  procedure Ende;
  begin
    Image.Picture.Bitmap := bild;
    ReglerFarbe;
  end;

  procedure DoRGB;
  var
    xx,yy: Byte;
  begin
    Anfang;

    for yy := 255 downto 0 do
    begin
      for xx := 0 to 255 do
      begin
        actPixel^ := farbe;
        inc(actPixel);
        inc(farbe, add1);
      end;
      inc(farbe, add2);
    end;

    Ende;
  end;

begin
  if RotRadioBtn.Checked then
  begin
    GetRGB(r,g,b);
    y := 255 - r;
    farbe := r shl 16;
    add1 := 1; //Blau
    add2 := 0; //Gruen - Blau
    DoRGB;
  end
  else if GruenRadioBtn.Checked then
  begin
    GetRGB(r,g,b);
    y := 255 - g;
    farbe := g shl 8;
    add1 := 1; //Blau
    add2 := (1 shl 16) - (1 shl 8); //Rot - Blau
    DoRGB;
  end
  else if BlauRadioBtn.Checked then
  begin
    GetRGB(r,g,b);
    y := 255 - b;
    farbe := b;
    add1 := 1 shl 16; //Rot
    add2 := (1 shl 8) - (1 shl 24); //Gruen - Rot
    DoRGB;
  end
  else if HueRadioBtn.Checked then
  begin
    GetHSV(h,s,v);
    y := 255 - h;
    Anfang;
    for y := 255 downto 0 do
    begin
      v := 255 - y;
      for x := 0 to 255 do
      begin
        s := x;
        HSV2RGB(h,s,v,r,g,b);
        farbe := r shl 16 + g shl 8 + b;
        actPixel^ := farbe;
        inc(actPixel);
      end;
    end;
    Ende;
  end
  else if SaturationRadioBtn.Checked then
  begin
    GetHSV(h,s,v);
    y := 255 - s;
    Anfang;
    for y := 255 downto 0 do
    begin
      v := 255 - y;
      for x := 0 to 255 do
      begin
        h := x;
        HSV2RGB(h,s,v,r,g,b);
        farbe := r shl 16 + g shl 8 + b;
        actPixel^ := farbe;
        inc(actPixel);
      end;
    end;
    Ende;
  end
  else //Value
  begin
    GetHSV(h,s,v);
    y := 255 - v;
    Anfang;
    for y := 255 downto 0 do
    begin
      s := 255 - y;
      for x := 0 to 255 do
      begin
        h := x;
        HSV2RGB(h,s,v,r,g,b);
        farbe := r shl 16 + g shl 8 + b;
        actPixel^ := farbe;
        inc(actPixel);
      end;
    end;
    Ende;
  end;
end;

procedure TColorExDialog.ZeichneSel;
//Setzt den Selektor in der großen Fläche und zeichnet
//den kleinen Balken neu

var
  r,g,b,x,y,h,s,v: Byte;
  farbe: TColor;
  add1: Integer;
  actPixel: ^Integer;

  procedure Anfang;
  begin
    Shape.Top := y - Shape.Height div 2;
    Shape.Left := x - Shape.Width div 2;
    bild.PixelFormat := pf32Bit;
    bild.Width := 17;
    bild.Height := 256;
    actPixel := bild.ScanLine[255];
  end;

  procedure Ende;
  begin
    SelImage.Picture.Bitmap := bild;
    ReglerFarbe;
  end;

  procedure DoRGB;
  var
    xx,yy: Byte;
  begin
    Anfang;

    for yy := 255 downto 0 do
    begin
      for xx := 0 to 16 do
      begin
        actPixel^ := farbe;
        inc(actPixel);
      end;
      inc(farbe, add1);
    end;

    Ende;
  end;

begin
  if RotRadioBtn.Checked then
  begin
    GetRGB(r,g,b);
    y := 255 - g;
    x := b;
    farbe := g shl 8 + b;
    add1 := 1 shl 16;
    DoRGB;
  end
  else if GruenRadioBtn.Checked then
  begin
    GetRGB(r,g,b);
    y := 255 - r;
    x := b;
    farbe := r shl 16 + b;
    add1 := 1 shl 8;
    DoRGB;
  end
  else if BlauRadioBtn.Checked then
  begin
    GetRGB(r,g,b);
    y := 255 - g;
    x := r;
    farbe := r shl 16 + g shl 8;
    add1 := 1;
    DoRGB;
  end
  else if HueRadioBtn.Checked then
  begin
    GetHSV(h,s,v);
    y := 255 - v;
    x := s;
    Anfang;
    for y := 255 downto 0 do
    begin
      h := 255 - y;
      HSV2RGB(h,s,v,r,g,b);
      farbe := r shl 16 + g shl 8 + b;
      for x := 0 to 16 do
      begin
        actPixel^ := farbe;
        inc(actPixel);
      end;
    end;
    Ende;
  end
  else if SaturationRadioBtn.Checked then
  begin
    GetHSV(h,s,v);
    y := 255 - v;
    x := h;
    Anfang;
    for y := 255 downto 0 do
    begin
      s := 255 - y;
      HSV2RGB(h,s,v,r,g,b);
      farbe := r shl 16 + g shl 8 + b;
      for x := 0 to 16 do
      begin
        actPixel^ := farbe;
        inc(actPixel);
      end;
    end;
    Ende;
  end
  else //Value
  begin
    GetHSV(h,s,v);
    y := 255 - s;
    x := h;
    Anfang;
    for y := 255 downto 0 do
    begin
      v := 255 - y;
      HSV2RGB(h,s,v,r,g,b);
      farbe := r shl 16 + g shl 8 + b;
      for x := 0 to 16 do
      begin
        actPixel^ := farbe;
        inc(actPixel);
      end;
    end;
    Ende;
  end;
end;

//wird von Rot, Gruen, Blau, Farbton, Sättigung und Helligkiet aufegrufen
procedure TColorExDialog.ZahlEditChange(Sender: TObject);
var
  r,g,b, h,s,v: Byte;
begin
  if NoOnChange then
    exit;

  ///////////////////////
  //Prüfen, ob Eingabe im Rahmen
  if AutoZeichnen then
  begin
    if Sender = HueEdit then
    begin
      try
        if StrToInt(TEdit(Sender).Text) > 255 then
          TEdit(Sender).Text := '255';
      except;end;
    end
    else //Saturation, Value, Red, Green oder Blue
    begin
      try
        if StrToInt(TEdit(Sender).Text) > 255 then
          TEdit(Sender).Text := '255';
      except;end;
    end;
  end;

  /////////////////
  //Umrechnen und Zeichnen
  if (Sender = RotEdit) or (Sender = GruenEdit) or (Sender = BlauEdit) then
  begin //RGB
    GetRGB(r,g,b);
    ColorPanel.Color := RGB2TColor(r,g,b);
    RGB2HSV(r,g,b,h,s,v);
    NoOnChange := True;
    HueEdit.Text := IntToStr(h);
    SaturationEdit.Text := IntToStr(s);
    ValueEdit.Text := IntToStr(v);
    NoOnChange := False;

    if AutoZeichnen then
    begin
      if RotRadioBtn.Checked or GruenRadioBtn.Checked or BlauRadioBtn.Checked then
      begin //RGB-Block aktiv
        if ((Sender = RotEdit) and RotRadioBtn.Checked)
        or ((Sender = GruenEdit) and GruenRadioBtn.Checked)
        or ((Sender = BlauEdit) and BlauRadioBtn.Checked) then
          //Sender is Checked
          Zeichne
        else
          ZeichneSel;
      end
      else //HSV-Block aktiv
      begin
        Zeichne;
        ZeichneSel;
      end;
    end;

  end
  else //HSV
  begin
    GetHSV(h,s,v);
    HSV2RGB(h,s,v,r,g,b);
    ColorPanel.Color := RGB2TColor(r,g,b);
    NoOnChange := True;
    RotEdit.Text := IntToStr(r);
    GruenEdit.Text := IntToStr(g);
    BlauEdit.Text := IntToStr(b);
    NoOnChange := False;

    if AutoZeichnen then
    begin
      if HueRadioBtn.Checked or SaturationRadioBtn.Checked or ValueRadioBtn.Checked then
      begin //HSV-Block aktiv
        if ((Sender = HueEdit) and HueRadioBtn.Checked)
        or ((Sender = SaturationEdit) and SaturationRadioBtn.Checked)
        or ((Sender = ValueEdit) and ValueRadioBtn.Checked) then
          //Sender is Checked
          Zeichne
        else
          ZeichneSel;
      end
      else //RGB-Block aktiv
      begin
        Zeichne;
        ZeichneSel;
      end;
    end;
  end;

  ////////////////////
  //Umrechnen in Delphi und HTML
  //immer ausführen
  DelphiEdit.Text := IntToStr(ColorPanel.Color);
  if UseNamesChkBox.Checked then
  begin
    HtmlEdit.Text := Color2Name(ColorPanel.Color);
    if HtmlEdit.Text = '' then
    begin
      HtmlEdit.Text := Color2Html(ColorPanel.Color);
      if UseNumSign then
        HtmlEdit.Text := '#' + HtmlEdit.Text;
    end;
  end
  else
  begin
    HtmlEdit.Text := Color2Html(ColorPanel.Color);
    if UseNumSign then
      HtmlEdit.Text := '#' + HtmlEdit.Text;
  end;
  DemoPaintBoxPaint(DemoPaintBox);
end;

procedure TColorExDialog.ImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    if Y < 0 then
      Y := 0
    else if Y > 255 then
      Y := 255;
    if X < 0 then
      X := 0
    else if X > 255 then
      X := 255;
    AutoZeichnen := False;
    if RotRadioBtn.Checked then
    begin
      GruenEdit.Text := IntToStr(255 - Y);
      BlauEdit.Text := IntToStr(X);
    end
    else if GruenRadioBtn.Checked then
    begin
      RotEdit.Text := IntToStr(255 - Y);
      BlauEdit.Text := IntToStr(X);
    end
    else if BlauRadioBtn.Checked then
    begin
      GruenEdit.Text := IntToStr(255 - Y);
      RotEdit.Text := IntToStr(X);
    end
    else if HueRadioBtn.Checked then
    begin
      ValueEdit.Text := IntToStr(255 - Y);
      SaturationEdit.Text := IntToStr(X);
    end
    else if SaturationRadioBtn.Checked then
    begin
      ValueEdit.Text := IntToStr(255 - Y);
      HueEdit.Text := IntToStr(X);
    end
    else //Value
    begin
      SaturationEdit.Text := IntToStr(255 - Y);
      HueEdit.Text := IntToStr(X);
    end;
    ZeichneSel;
    AutoZeichnen := True;
  end;
end;

procedure TColorExDialog.ShapeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ImageMouseUp(Image, Button, Shift, Shape.Left + X, Shape.Top + Y);
end;

procedure TColorExDialog.FormCreate(Sender: TObject);
var
  i: Integer;
  Panel: TPanel;
begin
  bild := TBitmap.Create;
  demobild := TBitmap.Create;
  demobild.Width := DemoPaintBox.Width;
  demobild.Height := DemoPaintBox.Height;
  AutoZeichnen := False;
  HtmlColor := '#000000';
  ZeichneSel;
  Zeichne;
  AutoZeichnen := True;
  NoOnChange := False;
  DemoSwap := False;
  DemoLabel.Caption := 'V'#13#10'G';
  DemoLabel.Hint := 'Vordergrund';
  DemoFarbe := clWhite;

  //W3C-FarbLabels erstellen
  for i := Low(ColorTable) to High(ColorTable) do
  begin
    Panel := TPanel.Create(Self);
    with Panel do
    begin
      Parent := W3cGroupBox;
      Width := 13;
      Height := 13;
      Caption := '';
      Color := SwapColor(ColorTable[i].Value);
      ParentBackground := False;
      BevelOuter := bvNone;
      Hint := ColorTable[i].Name;
      ShowHint := True;
      OnClick := FarbeClick;
      Cursor := crHandPoint;
      Left := 11 + (i mod 6) * 15;
      Top := 17 + (i div 6) * 15;
    end;
  end;

  //VGA-Farblabels erstellen
  for i := Low(VgaColors) to High(VgaColors) do
  begin
    Panel := TPanel.Create(Self);
    with Panel do
    begin
      Parent := VgaGroupBox;
      Width := 20;
      Height := 20;
      Caption := '';
      Color := SwapColor(VgaColors[i].Value);
      ParentBackground := False;
      BevelOuter := bvNone;
      Hint := VgaColors[i].Name;
      ShowHint := True;
      OnClick := FarbeClick;
      Cursor := crHandPoint;
      Left := 8 + (i mod 8) * 24;
      Top := 18 + (i div 8) * 24;
    end;
  end;
end;

procedure TColorExDialog.SelImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    if Y < 0 then
      Y := 0
    else if Y > 255 then
      Y := 255;
    AutoZeichnen := False;
    if RotRadioBtn.Checked then
      RotEdit.Text := IntToStr(255 - Y)
    else if GruenRadioBtn.Checked then
      GruenEdit.Text := IntToStr(255 - Y)
    else if BlauRadioBtn.Checked then
      BlauEdit.Text := IntToStr(255 - Y)
    else if HueRadioBtn.Checked then
      HueEdit.Text := IntToStr(255 - Y)
    else if SaturationRadioBtn.Checked then
      SaturationEdit.Text := IntToStr(255 - Y)
    else //Value
      ValueEdit.Text := IntToStr(255 - Y);
    Zeichne;
    AutoZeichnen := True;
  end;
end;

procedure TColorExDialog.SelShapeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SelImageMouseUp(SelImage, Button, Shift, SelShape.Left + X, SelShape.Top + Y);
end;

procedure TColorExDialog.SelShapeMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  SelImageMouseMove(SelImage, Shift, SelShape.Left + X, SelShape.Top + Y);
end;

procedure TColorExDialog.SelImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if ssLeft in Shift then
    SelImageMouseUp(SelImage, mbLeft, Shift, X, Y);
end;

procedure TColorExDialog.ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if ssLeft in Shift then
    ImageMouseUp(Image, mbLeft, Shift, X, Y);
end;

procedure TColorExDialog.ShapeMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  ImageMouseMove(Image, Shift, Shape.Left + X, Shape.Top + Y);
end;

procedure TColorExDialog.ZahlRadioBtnClick(Sender: TObject);
begin
  Zeichne;
  ZeichneSel;
end;

procedure TColorExDialog.SelImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    SelImageMouseMove(SelImage, [ssLeft], X, Y);
end;

procedure TColorExDialog.SelShapeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SelImageMouseDown(SelImage, Button, Shift, SelShape.Left + X, SelShape.Top + Y);
end;

procedure TColorExDialog.ImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    ImageMouseMove(Image, [ssLeft], X, Y);
end;

procedure TColorExDialog.ShapeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ImageMouseDown(Image, Button, Shift, Shape.Left + X, Shape.Top + Y);
end;

procedure TColorExDialog.UseNamesChkBoxClick(Sender: TObject);
begin
  if UseNamesChkBox.Checked then
  begin
    HtmlEdit.Text := Color2Name(ColorPanel.Color);
    if HtmlEdit.Text = '' then
      HtmlEdit.Text := Color2Html(ColorPanel.Color);
  end
  else
    HtmlEdit.Text := Color2Html(ColorPanel.Color);
end;

procedure TColorExDialog.HtmlEditExit(Sender: TObject);
var
  farbe: TColor;
  r,g,b: Byte;
begin
  farbe := Name2Color(HtmlEdit.Text);
  UseNamesChkBox.OnClick := nil;
  UseNamesChkBox.Checked := farbe <> -1;
  UseNamesChkBox.OnClick := UseNamesChkBoxClick;
  if not UseNamesChkBox.Checked then
  begin
    UseNumSign := Copy(HtmlEdit.Text, 1, 1) = '#';
    farbe := Html2Color(HtmlEdit.Text);
  end;
  TColor2RGB(farbe, r, g, b);
  AutoZeichnen := False;
  NoOnChange := True;
  RotEdit.Text := IntToStr(r);
  GruenEdit.Text := IntToStr(g);
  BlauEdit.Text := IntToStr(b);
  NoOnChange := False;
  ZahlEditChange(BlauEdit);
  Zeichne;
  ZeichneSel;
  AutoZeichnen := True;
end;

procedure TColorExDialog.DelphiEditExit(Sender: TObject);
var
  r,g,b: Byte;
begin
  TColor2RGB(StrToIntDef(DelphiEdit.Text, 0), r, g, b);
  AutoZeichnen := False;
  NoOnChange := True;
  RotEdit.Text := IntToStr(r);
  GruenEdit.Text := IntToStr(g);
  BlauEdit.Text := IntToStr(b);
  NoOnChange := False;
  ZahlEditChange(BlauEdit); 
  Zeichne;
  ZeichneSel;
  AutoZeichnen := True;
end;

procedure TColorExDialog.ColorPanelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  dc: hDc;
  MousePos: TPoint;
  r,g,b: Byte;
  xx,yy,xxx,yyy: Integer;
begin
  if Button = mbLeft then
  begin
    Application.MainForm.Hide;
    Screen.Cursor := crCross;
    AutoZeichnen := False;
    Shape.Visible := False;
    Image.Canvas.Brush.Color := clWhite;
    Image.Canvas.FillRect(Rect(0,0,256,256));
    dc := GetDC(0);
    while True do
    begin
      GetCursorPos(MousePos);
      ColorPanel.Color := GetPixel(dc, MousePos.X, MousePos.Y);
      TColor2RGB(ColorPanel.Color, r, g, b);
      RotEdit.Text := IntToStr(r);
      GruenEdit.Text := IntToStr(g);
      BlauEdit.Text := IntToStr(b);
      xx := MousePos.X - 7;
      for xxx := 0 to 15 do
      begin
        yy := MousePos.Y - 7;
        for yyy := 0 to 15 do
        begin
          Image.Canvas.Brush.Color := GetPixel(dc, xx,yy);
          Image.Canvas.Brush.Style := bsSolid;
          Image.Canvas.FillRect(Rect(xxx * 16, yyy * 16, (xxx + 1) * 16, (yyy + 1) * 16));
          inc(yy);
        end;
        inc(xx);
      end;
      Image.Canvas.Pen.Color := BlackWhiteContrastColor(ColorPanel.Color);
      Image.Canvas.Brush.Color := Image.Canvas.Pen.Color;
      Image.Canvas.Pen.Style := psSolid;
      Image.Canvas.Brush.Style := bsDiagCross;
      Image.Canvas.Rectangle(7*16, 7*16, 8*16, 8*16);

      Application.ProcessMessages;
      if GetAsyncKeyState($01) = 0 then
      begin
        ReleaseDC(0, dc);
        Shape.Visible := True;
        Zeichne;
        ZeichneSel;
        AutoZeichnen := True;
        Screen.Cursor := crDefault;
        Application.MainForm.Show;
        BringToFront;
        break;
      end;
    end;
  end;
end;

procedure TColorExDialog.BlauEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Sender is TEdit then
    try
      if Key = VK_UP then
      begin
        if Sender = HueEdit then
        begin
          if StrToInt(TEdit(Sender).Text) >= 255 then exit;
        end
        else
          if StrToInt(TEdit(Sender).Text) >= 255 then exit;
        TEdit(Sender).Text := IntToStr(StrToInt(TEdit(Sender).Text) + 1);
        TEdit(Sender).SelStart := Length(TEdit(Sender).Text);
        Key := 0;
      end
      else if Key = VK_DOWN then
      begin
        if StrToInt(TEdit(Sender).Text) <= 0 then exit;
        TEdit(Sender).Text := IntToStr(StrToInt(TEdit(Sender).Text) - 1);
        TEdit(Sender).SelStart := Length(TEdit(Sender).Text);
        Key := 0;
      end;
    except;
      TEdit(Sender).Text := '0';
    end;
end;

procedure TColorExDialog.DemoPaintBoxPaint(Sender: TObject);
begin
  if Sender is TPaintBox then
  begin
    with demobild do
    begin
      if DemoSwap then
      begin
        Canvas.Brush.Color := ColorPanel.Color;
        Canvas.Font.Color := DemoFarbe;
      end
      else
      begin
        Canvas.Brush.Color := DemoFarbe;
        Canvas.Font.Color := ColorPanel.Color;
      end;

      Canvas.FillRect(Rect(0,0,Width, Height));
      Canvas.Font.Name := 'Times New Roman';
      Canvas.Font.Size := 12;
      Canvas.Font.Style := [];
      Canvas.TextOut(5, 5, 'Franz jagt im komplett verwahrlosten Taxi quer durch Berlin.');
      Canvas.Font.Style := [fsBold];
      Canvas.TextOut(5, 30, 'Franz jagt im ');
      Canvas.Font.Style := [fsBold, fsItalic];
      Canvas.TextOut(Canvas.PenPos.X, 30, 'komplett verwahrlosten ');
      Canvas.Font.Style := [fsItalic];
      Canvas.TextOut(Canvas.PenPos.X, 30, 'Taxi quer durch Berlin.');
      Canvas.Font.Name := 'Arial';
      Canvas.Font.Style := [];
      Canvas.TextOut(5, 55, 'The quick brown fox jumps over the lazy dog.');
      Canvas.Font.Style := [fsBold];
      Canvas.TextOut(5, 80, 'The quick brown ');
      Canvas.Font.Style := [fsBold, fsItalic];
      Canvas.TextOut(Canvas.PenPos.X, 80, 'fox jumps over ');
      Canvas.Font.Style := [fsItalic];
      Canvas.TextOut(Canvas.PenPos.X, 80, 'the lazy dog.');
    end;
    //demobild auf die PaintBox zeichnen
    BitBlt((Sender as TPaintBox).Canvas.Handle, 0, 0, demobild.Width, demobild.Height, demobild.Canvas.Handle, 0, 0, SRCCOPY);
  end;
end;

function TColorExDialog.Execute: Boolean;
begin
  Result := ShowModal = mrOk;
end;

procedure TColorExDialog.DemoPaintBoxClick(Sender: TObject);
var
  tmp: TColor;
begin
  DemoSwap := not DemoSwap;
  if DemoSwap then
  begin
    DemoLabel.Caption := 'H'#13#10'G';
    DemoLabel.Hint := 'Hintergrund';
  end
  else
  begin
    DemoLabel.Caption := 'V'#13#10'G';
    DemoLabel.Hint := 'Vordergrund';
  end;
  tmp := DemoFarbe;
  DemoFarbe := ColorPanel.Color;
  DelphiEdit.Text := IntToStr(tmp);
  DelphiEditExit(DelphiEdit);
end;

procedure TColorExDialog.FarbeClick(Sender: TObject);
begin
  DelphiEdit.Text := IntToStr((Sender as TPanel).Color);
  DelphiEditExit(DelphiEdit);
end;

procedure TColorExDialog.FormDestroy(Sender: TObject);
begin
  bild.Free;
  demobild.Free;
end;

procedure TColorExDialog.DemoPaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  tmp: TColor;
begin
  if Button = mbRight then
  begin
    with DemoPaintBox do
    begin
      tmp := DemoFarbe;
      DemoFarbe := ColorPanel.Color;
      ColorPanel.Color := tmp;
      DelphiEdit.Text := IntToStr(ColorPanel.Color);
      DelphiEditExit(DelphiEdit);
    end;
  end;
end;

procedure TColorExDialog.HelpSpeedButtonClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', 'http://de.selfhtml.org/diverses/farbpaletten.htm', nil, nil, SW_SHOWNORMAL);
end;

procedure TColorExDialog.WinSpeedButtonClick(Sender: TObject);
begin
  ColorDialog.Color := ColorPanel.Color;
  if ColorDialog.Execute then
  begin
    DelphiEdit.Text := IntToStr(ColorDialog.Color);
    DelphiEditExit(DelphiEdit);
  end;
end;

end.

