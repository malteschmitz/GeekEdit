object DirListDialog: TDirListDialog
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderWidth = 5
  Caption = 'Verzeichnis-Listing...'
  ClientHeight = 483
  ClientWidth = 502
  Color = clBtnFace
  Constraints.MinHeight = 520
  Constraints.MinWidth = 520
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  DesignSize = (
    502
    483)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 53
    Height = 13
    Caption = 'Verzeichnis'
  end
  object Label2: TLabel
    Left = 8
    Top = 62
    Width = 37
    Height = 13
    Caption = 'Dateien'
  end
  object Label3: TLabel
    Left = 311
    Top = 62
    Width = 76
    Height = 13
    Caption = 'Beschreibungen'
  end
  object FormatLabel: TLabel
    Left = 8
    Top = 280
    Width = 34
    Height = 13
    Caption = 'Format'
  end
  object Label5: TLabel
    Left = 8
    Top = 370
    Width = 44
    Height = 13
    Caption = 'Vorschau'
  end
  object Label4: TLabel
    Left = 112
    Top = 280
    Width = 35
    Height = 13
    Caption = 'Offset:'
  end
  object ButtonPanel: TPanel
    Left = 0
    Top = 452
    Width = 502
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 6
    DesignSize = (
      502
      31)
    object CancelBtn: TButton
      Left = 427
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
      Left = 346
      Top = 6
      Width = 75
      Height = 23
      Anchors = [akTop, akRight]
      Caption = '&Ok'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
  end
  object FormatMemo: TMemo
    Left = 8
    Top = 299
    Width = 484
    Height = 57
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 4
    OnChange = Change
  end
  object SelDirBtn: TButton
    Left = 419
    Top = 26
    Width = 75
    Height = 23
    Anchors = [akTop, akRight]
    Caption = 'Ausw'#228'hlen'
    TabOrder = 0
    OnClick = SelDirBtnClick
  end
  object DirEdit: TEdit
    Left = 8
    Top = 27
    Width = 405
    Height = 21
    TabStop = False
    Anchors = [akLeft, akTop, akRight]
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 7
  end
  object FilesListBox: TListBox
    Left = 8
    Top = 81
    Width = 297
    Height = 184
    AutoComplete = False
    ExtendedSelect = False
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 1
  end
  object DescMemo: TMemo
    Left = 311
    Top = 81
    Width = 181
    Height = 184
    Anchors = [akLeft, akTop, akRight]
    ScrollBars = ssVertical
    TabOrder = 2
    OnChange = Change
  end
  object PreviewMemo: TMemo
    Left = 10
    Top = 389
    Width = 486
    Height = 57
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 5
  end
  object OffsetEdit: TEdit
    Left = 153
    Top = 277
    Width = 48
    Height = 21
    TabOrder = 3
    Text = '0'
    OnChange = Change
    OnExit = OffsetEditExit
  end
end
