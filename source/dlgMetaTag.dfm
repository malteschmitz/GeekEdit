object MetaTagDialog: TMetaTagDialog
  Left = 195
  Top = 108
  BorderIcons = [biSystemMenu]
  BorderWidth = 8
  Caption = 'Meta-Angabe...'
  ClientHeight = 227
  ClientWidth = 238
  Color = clBtnFace
  Constraints.MinHeight = 270
  Constraints.MinWidth = 262
  ParentFont = True
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    238
    227)
  PixelsPerInch = 96
  TextHeight = 13
  object CategoryLabel: TLabel
    Left = 8
    Top = 8
    Width = 46
    Height = 13
    Caption = 'Kategorie'
  end
  object NameLabel: TLabel
    Left = 8
    Top = 56
    Width = 37
    Height = 13
    Caption = 'Angabe'
  end
  object ValueLabel: TLabel
    Left = 8
    Top = 104
    Width = 24
    Height = 13
    Caption = 'Wert'
  end
  object LanguageLabel: TLabel
    Left = 8
    Top = 152
    Width = 126
    Height = 13
    Caption = 'Sprache der Meta-Angabe'
  end
  object CategoryComboBox: TComboBox
    Left = 8
    Top = 24
    Width = 226
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 0
    OnChange = CategoryComboBoxChange
  end
  object NameComboBox: TComboBox
    Left = 8
    Top = 72
    Width = 226
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 1
    OnChange = NameComboBoxChange
  end
  object ValueComboBox: TComboBox
    Left = 8
    Top = 120
    Width = 226
    Height = 21
    AutoDropDown = True
    AutoCloseUp = True
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 2
    OnChange = ValueComboBoxChange
  end
  object LanguageComboBox: TComboBox
    Left = 8
    Top = 168
    Width = 226
    Height = 21
    AutoDropDown = True
    AutoCloseUp = True
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 3
    OnChange = ValueComboBoxChange
    Items.Strings = (
      ''
      'de'
      'de-DE'
      'de-AT'
      'de-CH'
      'en'
      'en-GB'
      'en-UK'
      'en-US'
      'en-CA'
      'fr'
      'fr-FR'
      'fr-CA'
      'pl'
      'pl-PL')
  end
  object ButtonPanel: TPanel
    Left = 0
    Top = 196
    Width = 238
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    DesignSize = (
      238
      31)
    object CancelBtn: TButton
      Left = 82
      Top = 6
      Width = 75
      Height = 23
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = '&Abbrechen'
      ModalResult = 2
      TabOrder = 1
      TabStop = False
    end
    object OkBtn: TButton
      Left = 1
      Top = 6
      Width = 75
      Height = 23
      Anchors = [akTop, akRight]
      Caption = '&Ok'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object HelpBtn: TButton
      Left = 163
      Top = 6
      Width = 75
      Height = 23
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = '&Hilfe'
      ModalResult = 2
      TabOrder = 2
      TabStop = False
      OnClick = HelpBtnClick
    end
  end
end
