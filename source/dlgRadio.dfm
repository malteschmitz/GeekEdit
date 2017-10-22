object RadioDialog: TRadioDialog
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderWidth = 5
  Caption = 'GeekEdit'
  ClientHeight = 291
  ClientWidth = 457
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object RadioGroup: TRadioGroup
    Left = 0
    Top = 0
    Width = 457
    Height = 260
    Align = alClient
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 0
    ExplicitLeft = 144
    ExplicitTop = 112
    ExplicitWidth = 185
    ExplicitHeight = 105
  end
  object ButtonPanel: TPanel
    Left = 0
    Top = 260
    Width = 457
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      457
      31)
    object CancelBtn: TButton
      Left = 382
      Top = 6
      Width = 75
      Height = 23
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = '&Abbrechen'
      ModalResult = 2
      TabOrder = 0
    end
    object OkBtn: TButton
      Left = 301
      Top = 6
      Width = 75
      Height = 23
      Anchors = [akTop, akRight]
      Caption = '&Ok'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
  end
end
