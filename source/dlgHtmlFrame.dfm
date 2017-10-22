object HtmlFrameDialog: THtmlFrameDialog
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 8
  Caption = 'HTML-Ger'#252'st...'
  ClientHeight = 345
  ClientWidth = 456
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object MetaLabel: TLabel
    Left = 8
    Top = 192
    Width = 75
    Height = 13
    Caption = 'Meta-Angaben:'
  end
  object HtmlLabel: TLabel
    Left = 8
    Top = 8
    Width = 75
    Height = 13
    Caption = 'XHTML-Version:'
  end
  object TitleLabel: TLabel
    Left = 8
    Top = 144
    Width = 52
    Height = 13
    Caption = 'Seitentitel:'
  end
  object XmlLabel: TLabel
    Left = 288
    Top = 88
    Width = 62
    Height = 13
    Caption = 'XML-Version:'
  end
  object OkBtn: TBitBtn
    Left = 374
    Top = 290
    Width = 74
    Height = 23
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 9
    NumGlyphs = 2
  end
  object CancelBtn: TBitBtn
    Left = 374
    Top = 319
    Width = 74
    Height = 23
    Cancel = True
    Caption = '&Abbrechen'
    ModalResult = 2
    TabOrder = 10
    TabStop = False
    NumGlyphs = 2
  end
  object XhtmlComboBox: TComboBox
    Left = 8
    Top = 27
    Width = 121
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 0
    Text = 'XHTML 1.0'
    Items.Strings = (
      'XHTML 1.0'
      'XHTML 1.1')
  end
  object MetaMemo: TMemo
    Left = 8
    Top = 208
    Width = 360
    Height = 134
    TabOrder = 7
  end
  object AddMetaBtn: TButton
    Left = 374
    Top = 207
    Width = 35
    Height = 23
    Caption = '...'
    TabOrder = 8
    OnClick = AddMetaBtnClick
  end
  object DoctypeRadioGroup: TRadioGroup
    Left = 152
    Top = 8
    Width = 113
    Height = 89
    Caption = 'Doctype'
    ItemIndex = 0
    Items.Strings = (
      'Transitional'
      'Frameset'
      'Strict')
    TabOrder = 2
  end
  object NoDoctypeUrlChkBox: TCheckBox
    Left = 152
    Top = 112
    Width = 121
    Height = 17
    Caption = 'Doctype ohne URL'
    TabOrder = 3
  end
  object MetaGroupBox: TGroupBox
    Left = 288
    Top = 8
    Width = 160
    Height = 57
    Caption = 'Meta-Angaben zu Sprachen:'
    TabOrder = 4
    object CssChkBox: TCheckBox
      Left = 8
      Top = 17
      Width = 97
      Height = 17
      Caption = 'CSS'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object JsChkBox: TCheckBox
      Left = 8
      Top = 35
      Width = 97
      Height = 17
      TabStop = False
      Caption = 'JavaScript'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
  end
  object TitleEdit: TEdit
    Left = 8
    Top = 160
    Width = 440
    Height = 21
    TabOrder = 6
  end
  object HtmlRadioGroup: TRadioGroup
    Left = 8
    Top = 72
    Width = 121
    Height = 57
    Caption = 'neues Dokument'
    ItemIndex = 0
    Items.Strings = (
      'HTML'
      'XHTML')
    TabOrder = 1
    OnClick = HtmlRadioGroupClick
  end
  object XmlVersionComboBox: TComboBox
    Left = 288
    Top = 106
    Width = 160
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 5
    Text = 'XML 1.0'
    Items.Strings = (
      'XML 1.0'
      'XML 1.1')
  end
end
