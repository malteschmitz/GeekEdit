object ColorExDialog: TColorExDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Farbe...'
  ClientHeight = 457
  ClientWidth = 542
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object HtmlLabel: TLabel
    Left = 8
    Top = 300
    Width = 26
    Height = 13
    Caption = 'HTML'
  end
  object DelphiLabel: TLabel
    Left = 8
    Top = 276
    Width = 29
    Height = 13
    Caption = 'Delphi'
  end
  object WinSpeedButton: TSpeedButton
    Left = 424
    Top = 424
    Width = 25
    Height = 23
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      04000000000080000000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333000003333333300303000003333000033333000000000033CCCC00C000
      0B00C3C3CC00CC00BB00C3333300CC00BB00339999000C00B000939399000000
      00009333330090000A00330000009900AA00030300009900AA00033333000900
      A000333333300000000333333333300003333333333333333333}
    OnClick = WinSpeedButtonClick
  end
  object HelpSpeedButton: TSpeedButton
    Left = 424
    Top = 392
    Width = 25
    Height = 23
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
      5555555555FFFFF555555555544C4C5555555555F777775FF5555554C444C444
      5555555775FF55775F55554C4334444445555575577F55557FF554C4C334C4C4
      335557F5577FF55577F554CCC3334444335557555777F555775FCCCCC333CCC4
      C4457F55F777F555557F4CC33333CCC444C57F577777F5F5557FC4333333C3C4
      CCC57F777777F7FF557F4CC33333333C4C457F577777777F557FCCC33CC4333C
      C4C575F7755F777FF5755CCCCC3333334C5557F5FF777777F7F554C333333333
      CC55575777777777F755553333CC3C33C555557777557577755555533CC4C4CC
      5555555775FFFF77555555555C4CCC5555555555577777555555}
    NumGlyphs = 2
    OnClick = HelpSpeedButtonClick
  end
  object BlauRadioBtn: TRadioButton
    Left = 296
    Top = 160
    Width = 81
    Height = 17
    Caption = 'Blau'
    TabOrder = 2
    OnClick = ZahlRadioBtnClick
  end
  object GruenRadioBtn: TRadioButton
    Left = 296
    Top = 136
    Width = 81
    Height = 17
    Caption = 'Gr'#252'n'
    TabOrder = 1
    OnClick = ZahlRadioBtnClick
  end
  object RotRadioBtn: TRadioButton
    Left = 296
    Top = 112
    Width = 81
    Height = 17
    Caption = 'Rot'
    Checked = True
    TabOrder = 0
    TabStop = True
    OnClick = ZahlRadioBtnClick
  end
  object BlauEdit: TEdit
    Left = 376
    Top = 160
    Width = 40
    Height = 21
    MaxLength = 3
    TabOrder = 8
    OnChange = ZahlEditChange
    OnKeyDown = BlauEditKeyDown
    OnKeyPress = ZahlEditKeyPress
  end
  object GruenEdit: TEdit
    Left = 376
    Top = 136
    Width = 40
    Height = 21
    MaxLength = 3
    TabOrder = 7
    OnChange = ZahlEditChange
    OnKeyDown = BlauEditKeyDown
    OnKeyPress = ZahlEditKeyPress
  end
  object RotEdit: TEdit
    Left = 376
    Top = 112
    Width = 40
    Height = 21
    MaxLength = 3
    TabOrder = 6
    OnChange = ZahlEditChange
    OnKeyDown = BlauEditKeyDown
    OnKeyPress = ZahlEditKeyPress
  end
  object ColorPanel: TPanel
    Left = 296
    Top = 8
    Width = 121
    Height = 41
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 17
    OnMouseDown = ColorPanelMouseDown
  end
  object Panel: TPanel
    Left = 8
    Top = 8
    Width = 256
    Height = 256
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 18
    object Image: TImage
      Left = 0
      Top = 0
      Width = 256
      Height = 256
      Align = alClient
      OnMouseDown = ImageMouseDown
      OnMouseMove = ImageMouseMove
      OnMouseUp = ImageMouseUp
    end
    object Shape: TShape
      Left = 8
      Top = -2
      Width = 12
      Height = 12
      Brush.Style = bsClear
      Shape = stCircle
      OnMouseDown = ShapeMouseDown
      OnMouseMove = ShapeMouseMove
      OnMouseUp = ShapeMouseUp
    end
  end
  object SelPanel: TPanel
    Left = 272
    Top = 8
    Width = 17
    Height = 256
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 19
    object SelImage: TImage
      Left = 0
      Top = 0
      Width = 17
      Height = 256
      Align = alClient
      OnMouseDown = SelImageMouseDown
      OnMouseMove = SelImageMouseMove
      OnMouseUp = SelImageMouseUp
    end
    object SelShape: TShape
      Left = 0
      Top = 96
      Width = 17
      Height = 3
      Brush.Style = bsClear
      OnMouseDown = SelShapeMouseDown
      OnMouseMove = SelShapeMouseMove
      OnMouseUp = SelShapeMouseUp
    end
  end
  object OldColorPanel: TPanel
    Left = 296
    Top = 48
    Width = 121
    Height = 41
    BevelOuter = bvNone
    Color = clBlack
    ParentBackground = False
    TabOrder = 20
  end
  object HtmlEdit: TEdit
    Left = 56
    Top = 296
    Width = 121
    Height = 21
    TabOrder = 13
    OnExit = HtmlEditExit
  end
  object DelphiEdit: TEdit
    Left = 56
    Top = 272
    Width = 121
    Height = 21
    TabOrder = 12
    OnExit = DelphiEditExit
  end
  object UseNamesChkBox: TCheckBox
    Left = 56
    Top = 320
    Width = 121
    Height = 17
    Caption = 'Namen benutzen'
    TabOrder = 14
    OnClick = UseNamesChkBoxClick
  end
  object ValueRadioBtn: TRadioButton
    Left = 296
    Top = 240
    Width = 81
    Height = 17
    Caption = 'Helligkeit'
    TabOrder = 5
    OnClick = ZahlRadioBtnClick
  end
  object SaturationRadioBtn: TRadioButton
    Left = 296
    Top = 216
    Width = 81
    Height = 17
    Caption = 'S'#228'ttigung'
    TabOrder = 4
    OnClick = ZahlRadioBtnClick
  end
  object HueRadioBtn: TRadioButton
    Left = 296
    Top = 192
    Width = 81
    Height = 17
    Caption = 'Farbton'
    TabOrder = 3
    OnClick = ZahlRadioBtnClick
  end
  object ValueEdit: TEdit
    Left = 376
    Top = 240
    Width = 40
    Height = 21
    MaxLength = 3
    TabOrder = 11
    OnChange = ZahlEditChange
    OnKeyDown = BlauEditKeyDown
    OnKeyPress = ZahlEditKeyPress
  end
  object SaturationEdit: TEdit
    Left = 376
    Top = 216
    Width = 40
    Height = 21
    MaxLength = 3
    TabOrder = 10
    OnChange = ZahlEditChange
    OnKeyDown = BlauEditKeyDown
    OnKeyPress = ZahlEditKeyPress
  end
  object HueEdit: TEdit
    Left = 376
    Top = 192
    Width = 40
    Height = 21
    MaxLength = 3
    TabOrder = 9
    OnChange = ZahlEditChange
    OnKeyDown = BlauEditKeyDown
    OnKeyPress = ZahlEditKeyPress
  end
  object VgaGroupBox: TGroupBox
    Left = 216
    Top = 264
    Width = 203
    Height = 73
    Caption = 'VGA-Farben'
    TabOrder = 21
    object Label3: TLabel
      Left = 8
      Top = 18
      Width = 20
      Height = 20
      Cursor = crHandPoint
      AutoSize = False
      Color = clBlack
      ParentColor = False
      OnClick = FarbeClick
    end
    object Label4: TLabel
      Left = 8
      Top = 42
      Width = 20
      Height = 20
      Cursor = crHandPoint
      AutoSize = False
      Color = clGray
      ParentColor = False
      OnClick = FarbeClick
    end
    object Label5: TLabel
      Left = 32
      Top = 18
      Width = 20
      Height = 20
      Cursor = crHandPoint
      AutoSize = False
      Color = clMaroon
      ParentColor = False
      OnClick = FarbeClick
    end
    object Label6: TLabel
      Left = 32
      Top = 42
      Width = 20
      Height = 20
      Cursor = crHandPoint
      AutoSize = False
      Color = clRed
      ParentColor = False
      OnClick = FarbeClick
    end
    object Label7: TLabel
      Left = 56
      Top = 18
      Width = 20
      Height = 20
      Cursor = crHandPoint
      AutoSize = False
      Color = clGreen
      ParentColor = False
      OnClick = FarbeClick
    end
    object Label8: TLabel
      Left = 80
      Top = 18
      Width = 20
      Height = 20
      Cursor = crHandPoint
      AutoSize = False
      Color = clOlive
      ParentColor = False
      OnClick = FarbeClick
    end
    object Label9: TLabel
      Left = 104
      Top = 18
      Width = 20
      Height = 20
      Cursor = crHandPoint
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = FarbeClick
    end
    object Label10: TLabel
      Left = 128
      Top = 18
      Width = 20
      Height = 20
      Cursor = crHandPoint
      AutoSize = False
      Color = clPurple
      ParentColor = False
      OnClick = FarbeClick
    end
    object Label11: TLabel
      Left = 152
      Top = 18
      Width = 20
      Height = 20
      Cursor = crHandPoint
      AutoSize = False
      Color = clTeal
      ParentColor = False
      OnClick = FarbeClick
    end
    object Label12: TLabel
      Left = 176
      Top = 18
      Width = 20
      Height = 20
      Cursor = crHandPoint
      AutoSize = False
      Color = clSilver
      ParentColor = False
      OnClick = FarbeClick
    end
    object Label13: TLabel
      Left = 56
      Top = 42
      Width = 20
      Height = 20
      Cursor = crHandPoint
      AutoSize = False
      Color = clLime
      ParentColor = False
      OnClick = FarbeClick
    end
    object Label14: TLabel
      Left = 80
      Top = 42
      Width = 20
      Height = 20
      Cursor = crHandPoint
      AutoSize = False
      Color = clYellow
      ParentColor = False
      OnClick = FarbeClick
    end
    object Label15: TLabel
      Left = 104
      Top = 42
      Width = 20
      Height = 20
      Cursor = crHandPoint
      AutoSize = False
      Color = clBlue
      ParentColor = False
      OnClick = FarbeClick
    end
    object Label16: TLabel
      Left = 128
      Top = 42
      Width = 20
      Height = 20
      Cursor = crHandPoint
      AutoSize = False
      Color = clFuchsia
      ParentColor = False
      OnClick = FarbeClick
    end
    object Label17: TLabel
      Left = 152
      Top = 42
      Width = 20
      Height = 20
      Cursor = crHandPoint
      AutoSize = False
      Color = clAqua
      ParentColor = False
      OnClick = FarbeClick
    end
    object Label18: TLabel
      Left = 176
      Top = 42
      Width = 20
      Height = 20
      Cursor = crHandPoint
      AutoSize = False
      Color = clWhite
      ParentColor = False
      OnClick = FarbeClick
    end
  end
  object W3cGroupBox: TGroupBox
    Left = 424
    Top = 0
    Width = 113
    Height = 385
    Caption = 'W3C Namen'
    TabOrder = 22
  end
  object OkBtn: TButton
    Left = 461
    Top = 392
    Width = 75
    Height = 23
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 15
  end
  object CancelBtn: TButton
    Left = 461
    Top = 424
    Width = 75
    Height = 23
    Cancel = True
    Caption = '&Abbrechen'
    ModalResult = 2
    TabOrder = 16
    TabStop = False
  end
  object DemoPanel: TPanel
    Left = 7
    Top = 343
    Width = 409
    Height = 106
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 23
    object DemoPaintBox: TPaintBox
      Left = 0
      Top = 0
      Width = 409
      Height = 106
      Cursor = crHandPoint
      Align = alClient
      OnClick = DemoPaintBoxClick
      OnMouseUp = DemoPaintBoxMouseUp
      OnPaint = DemoPaintBoxPaint
    end
  end
  object DemoCaptionPanel: TPanel
    Left = 183
    Top = 270
    Width = 27
    Height = 67
    BevelKind = bkTile
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clInactiveCaption
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 24
    object DemoLabel: TLabel
      Left = 0
      Top = 0
      Width = 23
      Height = 63
      Cursor = crHandPoint
      Align = alClient
      Alignment = taCenter
      Caption = 'DemoLabel'
      ParentShowHint = False
      ShowAccelChar = False
      ShowHint = True
      WordWrap = True
      OnClick = DemoPaintBoxClick
      OnMouseUp = DemoPaintBoxMouseUp
      ExplicitWidth = 117
      ExplicitHeight = 25
    end
  end
  object ColorDialog: TColorDialog
    Options = [cdFullOpen, cdAnyColor]
    Left = 456
    Top = 344
  end
end
