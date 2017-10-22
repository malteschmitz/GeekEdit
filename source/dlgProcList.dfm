object ProcListDialog: TProcListDialog
  Left = 0
  Top = 0
  ActiveControl = SearchEdit
  BorderIcons = [biSystemMenu]
  Caption = 'Prozeduren-Liste...'
  ClientHeight = 213
  ClientWidth = 339
  Color = clBtnFace
  Constraints.MinHeight = 240
  Constraints.MinWidth = 347
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  DesignSize = (
    339
    213)
  PixelsPerInch = 96
  TextHeight = 13
  object ObjectsLabel: TLabel
    Left = 146
    Top = 11
    Width = 42
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'Objekte:'
  end
  object SearchLabel: TLabel
    Left = 8
    Top = 11
    Width = 33
    Height = 13
    Caption = 'Suche:'
  end
  object SearchEdit: TEdit
    Left = 51
    Top = 8
    Width = 81
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    OnChange = SearchEditChange
    OnKeyDown = SearchEditKeyDown
  end
  object ObjectsComboBoxEx: TComboBoxEx
    Left = 196
    Top = 8
    Width = 138
    Height = 22
    AutoCompleteOptions = []
    ItemsEx = <>
    Style = csExDropDownList
    Anchors = [akTop, akRight]
    ItemHeight = 16
    TabOrder = 1
    OnChange = SearchEditChange
    Images = ClassImageList
  end
  object ClassImageList: TImageList
    Left = 160
    Top = 104
  end
end
