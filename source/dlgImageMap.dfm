object ImageMapDialog: TImageMapDialog
  Left = 344
  Top = 104
  BorderIcons = [biSystemMenu]
  Caption = 'ImageMap...'
  ClientHeight = 368
  ClientWidth = 581
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Button: TButton
    Left = 320
    Top = 152
    Width = 75
    Height = 25
    Caption = 'TestButton'
    TabOrder = 0
  end
  object ScrollBox: TScrollBox
    Left = 0
    Top = 0
    Width = 581
    Height = 147
    Align = alClient
    TabOrder = 1
    object PaintBox: TPaintBox
      Left = 0
      Top = 0
      Width = 500
      Height = 500
      OnDblClick = PaintBoxDblClick
      OnMouseMove = PaintBoxMouseMove
      OnMouseUp = PaintBoxMouseUp
      OnPaint = PaintBoxPaint
    end
  end
  object Panel: TPanel
    Left = 0
    Top = 147
    Width = 581
    Height = 221
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object MenuPanel: TPanel
      Left = 0
      Top = 98
      Width = 581
      Height = 123
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        581
        123)
      object Text7Label: TLabel
        Left = 8
        Top = 11
        Width = 70
        Height = 13
        Caption = '<area shape="'
      end
      object Text6Label: TLabel
        Left = 240
        Top = 11
        Width = 51
        Height = 13
        Caption = '" coords="'
      end
      object Text5Label: TLabel
        Left = 568
        Top = 11
        Width = 5
        Height = 13
        Caption = '"'
      end
      object Text4Label: TLabel
        Left = 8
        Top = 35
        Width = 29
        Height = 13
        Caption = 'href="'
      end
      object Text3Label: TLabel
        Left = 288
        Top = 35
        Width = 30
        Height = 13
        Caption = '" alt="'
      end
      object Text2Label: TLabel
        Left = 568
        Top = 35
        Width = 5
        Height = 13
        Caption = '"'
      end
      object TextLabel: TLabel
        Left = 568
        Top = 59
        Width = 6
        Height = 13
        Caption = '>'
      end
      object Bevel: TBevel
        Left = 8
        Top = 40
        Width = 569
        Height = 50
        Shape = bsBottomLine
      end
      object NameLabel: TLabel
        Left = 8
        Top = 99
        Width = 28
        Height = 13
        Caption = 'Name'
      end
      object CoordsEdit: TEdit
        Left = 296
        Top = 8
        Width = 265
        Height = 21
        TabOrder = 1
        OnChange = CoordsEditChange
        OnExit = CoordsEditExit
      end
      object ShapeComboBox: TComboBox
        Left = 88
        Top = 8
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 2
        TabOrder = 0
        Text = 'poly'
        Items.Strings = (
          'rect'
          'circle'
          'poly')
      end
      object HrefEdit: TEdit
        Left = 48
        Top = 32
        Width = 233
        Height = 21
        TabOrder = 2
        OnChange = CoordsEditChange
      end
      object AltEdit: TEdit
        Left = 328
        Top = 32
        Width = 233
        Height = 21
        TabOrder = 3
        OnChange = CoordsEditChange
      end
      object RestEdit: TEdit
        Left = 8
        Top = 56
        Width = 553
        Height = 21
        TabOrder = 4
        OnChange = CoordsEditChange
      end
      object OkBtn: TButton
        Left = 424
        Top = 96
        Width = 75
        Height = 23
        Anchors = [akTop, akRight]
        Caption = '&OK'
        Default = True
        ModalResult = 1
        TabOrder = 8
        OnClick = OkMenuClick
      end
      object CancelBtn: TButton
        Left = 504
        Top = 96
        Width = 75
        Height = 23
        Anchors = [akTop, akRight]
        Cancel = True
        Caption = '&Abbrechen'
        ModalResult = 2
        TabOrder = 9
        TabStop = False
      end
      object NameEdit: TEdit
        Left = 48
        Top = 96
        Width = 89
        Height = 21
        TabOrder = 5
        OnChange = CoordsEditChange
      end
      object MapChkBox: TCheckBox
        Left = 264
        Top = 99
        Width = 97
        Height = 17
        TabStop = False
        Caption = 'Map-Tag'
        TabOrder = 7
      end
      object ImgChkBox: TCheckBox
        Left = 160
        Top = 99
        Width = 97
        Height = 17
        Caption = 'Img-Tag'
        TabOrder = 6
      end
    end
    object MapListBox: TListBox
      Left = 0
      Top = 0
      Width = 581
      Height = 98
      Align = alClient
      ExtendedSelect = False
      ItemHeight = 13
      Items.Strings = (
        '(Neu)')
      TabOrder = 0
      OnClick = MapListBoxClick
      OnKeyUp = MapListBoxKeyUp
    end
  end
  object MainMenu: TMainMenu
    Left = 88
    Top = 8
    object ImageMapMenu: TMenuItem
      Caption = 'ImageMap'
      object NewMenu: TMenuItem
        Caption = 'Neu ...'
        OnClick = NewMenuClick
      end
      object LoadImageMenu: TMenuItem
        Caption = 'Bild laden ...'
        OnClick = LoadImageMenuClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object OkMenu: TMenuItem
        Caption = 'Einf'#252'gen'
        OnClick = OkMenuClick
      end
      object CancelMenu: TMenuItem
        Caption = 'Abbrechen'
        OnClick = CancelMenuClick
      end
    end
  end
end
