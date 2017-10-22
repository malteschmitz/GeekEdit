unit uColor;

interface

uses
 Graphics, Windows, SysUtils, Math;

function ValueBetween(V1, V2: Byte; Blend:Real): Byte;
function ColorBetween(C1, C2: TColor; Blend:Real): TColor;
function RGB2TColor(const R, G, B: Byte): Integer;
procedure TColor2RGB(Color: TColor; var R, G, B: Byte);
function BlackWhiteContrastColor(Color: TColor): TColor;
function Color2HTML(Color: TColor): String; safecall;
function HTML2Color(const HTML: String): TColor; safecall;
function Color2Name(Color: TColor): String; safecall;
function Name2Color(const Name: String): TColor; safecall;
function SwapColor(Color: TColor): TColor;
procedure RGB2HSV(Red, Green, Blue: Byte; var Hue, Saturation, Value: Byte);
procedure HSV2RGB(H, S, V: Byte; var R,G,B: Byte);

type
  RColor = record
    Name: String;
    Value: Integer;
  end;

const
  VgaColors: array[0..15] of RColor = (
    (Name: 'Schwarz';              Value: $000000),
    (Name: 'Dunkelrot';            Value: $800000),
    (Name: 'Dunkelgrün';           Value: $008000),
    (Name: 'Dunkelgelb';           Value: $808000),
    (Name: 'Dunkelblau';           Value: $000080),
    (Name: 'Purpur';               Value: $800080),
    (Name: 'Teal';                 Value: $008080),
    (Name: 'Hellgrau';             Value: $C0C0C0),
    (Name: 'Dunkelgrau';           Value: $808080),
    (Name: 'Rot';                  Value: $FF0000),
    (Name: 'Grün';                 Value: $00FF00),
    (Name: 'Gelb';                 Value: $FFFF00),
    (Name: 'Blau';                 Value: $0000FF),
    (Name: 'Fuchsia';              Value: $FF00FF),
    (Name: 'Aqua';                 Value: $00FFFF),
    (Name: 'Weiß';                 Value: $FFFFFF)
  );

  // the following list shows 140 basic html color names and their corresponding
  // HTML hex-values
  ColorTable: array[0..140] of RColor = (
    (Name: 'aliceblue';            Value: $F0F8FF),
    (Name: 'antiquewhite';         Value: $FAEBD7),
    (Name: 'aqua';                 Value: $00FFFF),
    (Name: 'aquamarine';           Value: $7FFFD4),
    (Name: 'azure';                Value: $F0FFFF),
    (Name: 'beige';                Value: $F5F5DC),
    (Name: 'bisque';               Value: $FFE4C4),
    (Name: 'black';                Value: $000000),
    (Name: 'blanchedalmond';       Value: $FFFFCD),
    (Name: 'blue';                 Value: $0000FF),
    (Name: 'blueviolet';           Value: $8A2BE2),
    (Name: 'brown';                Value: $A52A2A),
    (Name: 'burlywood';            Value: $DEB887),
    (Name: 'cadetblue';            Value: $5F9EA0),
    (Name: 'chartreuse';           Value: $7FFF00),
    (Name: 'chocolate';            Value: $D2691E),
    (Name: 'coral';                Value: $FF7F50),
    (Name: 'cornflowerblue';       Value: $6495ED),
    (Name: 'cornsilk';             Value: $FFF8DC),
    (Name: 'crimson';              Value: $DC143C),
    (Name: 'cyan';                 Value: $00FFFF),
    (Name: 'darkblue';             Value: $00008B),
    (Name: 'darkcyan';             Value: $008B8B),
    (Name: 'darkgoldenrod';        Value: $B8860B),
    (Name: 'darkgray';             Value: $A9A9A9),
    (Name: 'darkgreen';            Value: $006400),
    (Name: 'darkkhaki';            Value: $BDB76B),
    (Name: 'darkmagenta';          Value: $8B008B),
    (Name: 'darkolivegreen';       Value: $556B2F),
    (Name: 'darkorange';           Value: $FF8C00),
    (Name: 'darkorchid';           Value: $9932CC),
    (Name: 'darkred';              Value: $8B0000),
    (Name: 'darksalmon';           Value: $E9967A),
    (Name: 'darkseagreen';         Value: $8FBC8F),
    (Name: 'darkslateblue';        Value: $483D8B),
    (Name: 'darkslategray';        Value: $2F4F4F),
    (Name: 'darkturquoise';        Value: $00CED1),
    (Name: 'darkviolet';           Value: $9400D3),
    (Name: 'deeppink';             Value: $FF1493),
    (Name: 'deepskyblue';          Value: $00BFFF),
    (Name: 'dimgray';              Value: $696969),
    (Name: 'dodgerblue';           Value: $1E90FF),
    (Name: 'firebrick';            Value: $B22222),
    (Name: 'floralwhite';          Value: $FFFAF0),
    (Name: 'forestgreen';          Value: $228B22),
    (Name: 'fuchsia';              Value: $FF00FF),
    (Name: 'gainsboro';            Value: $DCDCDC),
    (Name: 'ghostwhite';           Value: $F8F8FF),
    (Name: 'gold';                 Value: $FFD700),
    (Name: 'goldenrod';            Value: $DAA520),
    (Name: 'gray';                 Value: $808080),
    (Name: 'green';                Value: $008000),
    (Name: 'greenyellow';          Value: $ADFF2F),
    (Name: 'honeydew';             Value: $F0FFF0),
    (Name: 'hotpink';              Value: $FF69B4),
    (Name: 'indianred';            Value: $CD5C5C),
    (Name: 'indigo';               Value: $4B0082),
    (Name: 'ivory';                Value: $FFF0F0),
    (Name: 'khaki';                Value: $F0E68C),
    (Name: 'lavender';             Value: $E6E6FA),
    (Name: 'lavenderblush';        Value: $FFF0F5),
    (Name: 'lawngreen';            Value: $7CFC00),
    (Name: 'lemonchiffon';         Value: $FFFACD),
    (Name: 'lightblue';            Value: $ADD8E6),
    (Name: 'lightcoral';           Value: $F08080),
    (Name: 'lightcyan';            Value: $E0FFFF),
    (Name: 'lightgoldenrodyellow'; Value: $FAFAD2),
    (Name: 'lightgreen';           Value: $90EE90),
    (Name: 'lightgrey';            Value: $D3D3D3),
    (Name: 'lightpink';            Value: $FFB6C1),
    (Name: 'lightsalmon';          Value: $FFA07A),
    (Name: 'lightseagreen';        Value: $20B2AA),
    (Name: 'lightskyblue';         Value: $87CEFA),
    (Name: 'lightslategray';       Value: $778899),
    (Name: 'lightsteelblue';       Value: $B0C4DE),
    (Name: 'lightyellow';          Value: $FFFFE0),
    (Name: 'lime';                 Value: $00FF00),
    (Name: 'limegreen';            Value: $32CD32),
    (Name: 'linen';                Value: $FAF0E6),
    (Name: 'magenta';              Value: $FF00FF),
    (Name: 'maroon';               Value: $800000),
    (Name: 'mediumaquamarine';     Value: $66CDAA),
    (Name: 'mediumblue';           Value: $0000CD),
    (Name: 'mediumorchid';         Value: $BA55D3),
    (Name: 'mediumpurple';         Value: $9370DB),
    (Name: 'mediumseagreen';       Value: $3CB371),
    (Name: 'mediumpurple';         Value: $9370DB),
    (Name: 'mediumslateblue';      Value: $7B68EE),
    (Name: 'mediumspringgreen';    Value: $00FA9A),
    (Name: 'mediumturquoise';      Value: $48D1CC),
    (Name: 'mediumvioletred';      Value: $C71585),
    (Name: 'midnightblue';         Value: $191970),
    (Name: 'mintcream';            Value: $F5FFFA),
    (Name: 'mistyrose';            Value: $FFE4E1),
    (Name: 'moccasin';             Value: $FFE4B5),
    (Name: 'navajowhite';          Value: $FFDEAD),
    (Name: 'navy';                 Value: $000080),
    (Name: 'oldlace';              Value: $FDF5E6),
    (Name: 'olive';                Value: $808000),
    (Name: 'olivedrab';            Value: $6B8E23),
    (Name: 'orange';               Value: $FFA500),
    (Name: 'orangered';            Value: $FF4500),
    (Name: 'orchid';               Value: $DA70D6),
    (Name: 'palegoldenrod';        Value: $EEE8AA),
    (Name: 'palegreen';            Value: $98FB98),
    (Name: 'paleturquoise';        Value: $AFEEEE),
    (Name: 'palevioletred';        Value: $DB7093),
    (Name: 'papayawhip';           Value: $FFEFD5),
    (Name: 'peachpuff';            Value: $FFDBBD),
    (Name: 'peru';                 Value: $CD853F),
    (Name: 'pink';                 Value: $FFC0CB),
    (Name: 'plum';                 Value: $DDA0DD),
    (Name: 'powderblue';           Value: $B0E0E6),
    (Name: 'purple';               Value: $800080),
    (Name: 'red';                  Value: $FF0000),
    (Name: 'rosybrown';            Value: $BC8F8F),
    (Name: 'royalblue';            Value: $4169E1),
    (Name: 'saddlebrown';          Value: $8B4513),
    (Name: 'salmon';               Value: $FA8072),
    (Name: 'sandybrown';           Value: $F4A460),
    (Name: 'seagreen';             Value: $2E8B57),
    (Name: 'seashell';             Value: $FFF5EE),
    (Name: 'sienna';               Value: $A0522D),
    (Name: 'silver';               Value: $C0C0C0),
    (Name: 'skyblue';              Value: $87CEEB),
    (Name: 'slateblue';            Value: $6A5ACD),
    (Name: 'slategray';            Value: $708090),
    (Name: 'snow';                 Value: $FFFAFA),
    (Name: 'springgreen';          Value: $00FF7F),
    (Name: 'steelblue';            Value: $4682B4),
    (Name: 'tan';                  Value: $D2B48C),
    (Name: 'teal';                 Value: $008080),
    (Name: 'thistle';              Value: $D8BFD8),
    (Name: 'tomato';               Value: $FD6347),
    (Name: 'turquoise';            Value: $40E0D0),
    (Name: 'violet';               Value: $EE82EE),
    (Name: 'wheat';                Value: $F5DEB3),
    (Name: 'white';                Value: $FFFFFF),
    (Name: 'whitesmoke';           Value: $F5F5F5),
    (Name: 'yellow';               Value: $FFFF00),
    (Name: 'yellowgreen';          Value: $9ACD32)
  );

implementation

function ValueBetween(V1, V2: Byte; Blend: Real): Byte;
begin
  Result := Round(V1 + (V2 - V1) * Blend);
end;

// Farbe zwischen 2 vorgegebenen Farbwerten berechnen
// http://www.delphipraxis.net/topic67805_farbverlauf+berechnen.html
function ColorBetween(C1, C2 : TColor; Blend: Real): TColor;
var
   r, g, b : Byte;
begin
   C1 := ColorToRGB(C1);
   C2 := ColorToRGB(C2);

   r := ValueBetween(GetRValue(C1), GetRValue(C2), Blend);
   g := ValueBetween(GetGValue(C1), GetGValue(C2), Blend);
   b := ValueBetween(GetBValue(C1), GetBValue(C2), Blend);

   Result := RGB(r, g, b);
end;

function RGB2TColor(const R, G, B: Byte): Integer;
begin
  // convert hexa-decimal values to RGB
  Result := R + G shl 8 + B shl 16;
end;

procedure TColor2RGB(Color: TColor; var R, G, B: Byte);
begin
  Color := ColorToRGB(Color);

  // convert hexa-decimal values to RGB
  R := Color and $FF;
  G := (Color shr 8) and $FF;
  B := (Color shr 16) and $FF;
end;

{**************************************************************************
* NAME:    BlackWhiteContrastColor
* DESC:    Berechne die Kontrastfarbe (nur schwarz oder weiss)
*          zur übergebenen Farbe
*************************************************************************}
function BlackWhiteContrastColor(Color: TColor):TColor;
var
  intensity : Integer;
begin
  Color := ColorToRGB(Color);

  intensity := GetBValue(Color) * 21  // Blue
    + GetGValue(Color) * 174   // Green
    + GetRValue(Color) * 61;   // Red

   // intensity = 0        -> dark
   // intensity = 255*256  -> bright

  if intensity >= (128*256) then
    Result := clBlack
  else
    Result := clWhite;
end;

// function to turn a Delphi TColor to HTML Hex Code
// without leading #, because this can be optionally added
function Color2HTML(Color: TColor): String;
begin
  Color := ColorToRGB(Color);

  try
    // convert RGB color to  HTML color string
    Result :=
      IntToHex(Byte(Color), 2) +
      IntToHex(Byte(Color shr 8), 2) +
      IntToHex(Byte(Color shr 16), 2);
  except
    Result := '000000';
  end;
end;

function HTML2Color(const HTML: String): TColor;
var
  Offset: Integer;
begin
  try
    // check for leading '#'
    if Copy(HTML, 1, 1) = '#' then
      Offset := 1
    else
      Offset := 0;
    // convert hexa-decimal values to RGB
    Result :=
      Integer(StrToInt('$' + Copy(HTML, Offset + 1, 2))) +
      Integer(StrToInt('$' + Copy(HTML, Offset + 3, 2))) shl 8 +
      Integer(StrToInt('$' + Copy(HTML, Offset + 5, 2))) shl 16;
  except
    Result := 0;
  end;
end;

function Name2Color(const Name: String): TColor;
var
  I: Integer;
begin
  Result := -1;
  for I := Low(ColorTable) to High(ColorTable) do
    // find matching color name
    if ColorTable[I].Name = Name then
    begin
      // return RGB colors
      Result :=
        Byte(ColorTable[I].Value shr 16) +
        Byte(ColorTable[I].Value shr 8) shl 8 +
        Byte(ColorTable[I].Value) shl 16;
      Break;
    end;
end;

function SwapColor(Color: TColor): TColor;
begin
  Result :=
    Color and $FF0000 shr 16 +
    Color and $00FF00 +
    Color and $0000FF shl 16;
end;

function Color2Name(Color: TColor): String;

var
  I: Integer;
begin
  Color := ColorToRGB(Color);

  Result := '';
  for I := Low(ColorTable) to High(ColorTable) do
    if ColorTable[I].Value = SwapColor(Color) then
    begin
      Result := ColorTable[I].Name;
      Break;
    end;
end;

procedure RGB2HSV(Red, Green, Blue: Byte; var Hue, Saturation, Value: Byte);
var
  Maximum, Minimum: Byte;
  Rc, Gc, Bc: Single;
  H: Single;
begin
  Maximum := Max(Red, Max(Green, Blue));
  Minimum := Min(Red, Min(Green, Blue));
  Value := Maximum;
  if Maximum <> 0 then
    Saturation := MulDiv(Maximum - Minimum, 255, Maximum)
  else
    Saturation := 0;
  if Saturation = 0 then
    Hue := 0 // arbitrary value
  else
  begin
    Assert(Maximum <> Minimum);
    Rc := (Maximum - Red) / (Maximum - Minimum);
    Gc := (Maximum - Green) / (Maximum - Minimum);
    Bc := (Maximum - Blue) / (Maximum - Minimum);
    if Red = Maximum then
      H := Bc - Gc
    else if Green = Maximum then
      H := 2 + Rc - Bc
    else
    begin
      Assert(Blue = Maximum);
      H := 4 + Gc - Rc;
    end;
    H := H * (256 / 6); //60
    if H < 0 then
      H := H + 255;//360;
    Hue := Round(H);
  end;
end;

procedure HSV2RGB(H, S, V: Byte; var R,G,B: Byte);
var
  ht, d, t1, t2, t3:Integer;
begin
  if S = 0 then
   begin
    R := V;  G := V;  B := V;
   end
  else
   begin
    ht := H * 6;
    d := ht mod 256;

    t1 := round(V * (255 - S) / 256);
    t2 := round(V * (255 - S * d / 256) / 256);
    t3 := round(V * (255 - S * (255 - d) / 256) / 256);

    case ht div 256 of
    0:
      begin
        R := V;  G := t3; B := t1;
      end;
    1:
      begin
        R := t2; G := V;  B := t1;
      end;
    2:
      begin
        R := t1; G := V;  B := t3;
      end;
    3:
      begin
        R := t1; G := t2; B := V;
      end;
    4:
      begin
        R := t3; G := t1; B := V;
      end;
    else
      begin
        R := V;  G := t1; B := t2;
      end;
    end;
   end;
end;

end.
