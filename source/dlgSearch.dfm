object SearchDialog: TSearchDialog
  Left = 0
  Top = 0
  ActiveControl = PageControl
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 8
  Caption = 'Suchen...'
  ClientHeight = 309
  ClientWidth = 428
  Color = clBtnFace
  Constraints.MinHeight = 350
  Constraints.MinWidth = 450
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 428
    Height = 278
    ActivePage = SearchTS
    Align = alClient
    TabOrder = 0
    object SearchTS: TTabSheet
      Caption = 'Suchen'
      OnShow = SearchTSShow
      DesignSize = (
        420
        250)
      object SearchSearchLabel: TLabel
        Left = 11
        Top = 14
        Width = 65
        Height = 13
        Caption = 'Suchen nach:'
      end
      object SearchOptionsGroup: TGroupBox
        Left = 11
        Top = 38
        Width = 185
        Height = 75
        Caption = 'Optionen'
        TabOrder = 1
        object SearchCaseCB: TCheckBox
          Left = 11
          Top = 20
          Width = 153
          Height = 17
          Caption = 'Gro'#223'-/Kleinschreibung'
          TabOrder = 0
          OnClick = CaseCBClick
        end
        object SearchWordsCB: TCheckBox
          Left = 11
          Top = 43
          Width = 137
          Height = 17
          Caption = 'nur ganze W'#246'rter'
          TabOrder = 1
          OnClick = WordsCBClick
        end
      end
      object SearchDirectionGroup: TGroupBox
        Left = 210
        Top = 38
        Width = 198
        Height = 75
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Richtung'
        TabOrder = 2
        object SearchDirectionForRB: TRadioButton
          Left = 11
          Top = 20
          Width = 113
          Height = 17
          Caption = 'Vorw'#228'rts'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = DirectionForRBClick
        end
        object SearchDirectionBackRB: TRadioButton
          Left = 11
          Top = 43
          Width = 113
          Height = 17
          Caption = 'R'#252'ckw'#228'rts'
          TabOrder = 1
          OnClick = DirectionBackRBClick
        end
      end
      object SearchStartGroup: TGroupBox
        Left = 210
        Top = 119
        Width = 198
        Height = 75
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Beginn'
        TabOrder = 4
        object SearchStartCursorRB: TRadioButton
          Left = 11
          Top = 20
          Width = 113
          Height = 17
          Caption = 'ab Cursor'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = StartCursorRBClick
        end
        object SearchStartWholeRB: TRadioButton
          Left = 11
          Top = 43
          Width = 113
          Height = 17
          Caption = 'Textanfang'
          TabOrder = 1
          OnClick = StartWholeRBClick
        end
      end
      object SearchRangeGroup: TGroupBox
        Left = 11
        Top = 119
        Width = 185
        Height = 75
        Caption = 'Bereich'
        TabOrder = 3
        object SearchRangeWholeRB: TRadioButton
          Left = 11
          Top = 20
          Width = 113
          Height = 17
          Caption = 'gesamter Text'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = RangeWholeRBClick
        end
        object SearchRangeSelectionRB: TRadioButton
          Left = 11
          Top = 43
          Width = 113
          Height = 17
          Caption = 'markierter Text'
          TabOrder = 1
          OnClick = RangeSelectionRBClick
        end
      end
      object SearchSearchEdit: TEdit
        Left = 88
        Top = 11
        Width = 293
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        OnChange = SearchEditChange
      end
      object SearchSearchEditBtn: TBitBtn
        Left = 380
        Top = 11
        Width = 28
        Height = 21
        Anchors = [akTop, akRight]
        Caption = #182
        TabOrder = 5
        OnClick = SearchSearchEditBtnClick
        Glyph.Data = {
          92000000424D8A04000000000000360400002800000009000000070000000100
          08000000000054000000120B0000120B00000200000002000000DA69FF000000
          0000000000000000000000000000000000000000000000000000000000000100
          0000000000000000000101010000000000000000010101010100000000000000
          00000000000000000000000000000000000000000000}
        Layout = blGlyphRight
        Spacing = 1
      end
    end
    object ReplaceTS: TTabSheet
      Caption = 'Ersetzen'
      ImageIndex = 1
      OnShow = ReplaceTSShow
      DesignSize = (
        420
        250)
      object ReplaceSearchLabel: TLabel
        Left = 11
        Top = 14
        Width = 65
        Height = 13
        Caption = 'Suchen nach:'
      end
      object ReplaceReplaceLabel: TLabel
        Left = 11
        Top = 41
        Width = 76
        Height = 13
        Caption = 'Ersetzen durch:'
      end
      object ReplaceSearchEdit: TEdit
        Left = 104
        Top = 11
        Width = 277
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        OnChange = SearchEditChange
      end
      object ReplaceReplaceEdit: TEdit
        Left = 104
        Top = 38
        Width = 277
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
        OnChange = ReplaceEditChange
      end
      object ReplaceOptionsGroup: TGroupBox
        Left = 11
        Top = 65
        Width = 185
        Height = 96
        Caption = 'Optionen'
        TabOrder = 2
        object ReplaceCaseCB: TCheckBox
          Left = 11
          Top = 20
          Width = 153
          Height = 17
          Caption = 'Gro'#223'-/Kleinschreibung'
          TabOrder = 0
          OnClick = CaseCBClick
        end
        object ReplaceWordsCB: TCheckBox
          Left = 11
          Top = 43
          Width = 137
          Height = 17
          Caption = 'nur ganze W'#246'rter'
          TabOrder = 1
          OnClick = WordsCBClick
        end
        object ReplaceConfirmCB: TCheckBox
          Left = 11
          Top = 66
          Width = 137
          Height = 17
          Caption = 'mit Best'#228'tigung'
          TabOrder = 2
        end
      end
      object ReplaceDirectionGroup: TGroupBox
        Left = 210
        Top = 65
        Width = 198
        Height = 96
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Richtung'
        TabOrder = 3
        object ReplaceDirectionForRB: TRadioButton
          Left = 11
          Top = 20
          Width = 113
          Height = 17
          Caption = 'Vorw'#228'rts'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = DirectionForRBClick
        end
        object ReplaceDirectionBackRB: TRadioButton
          Left = 11
          Top = 43
          Width = 113
          Height = 17
          Caption = 'R'#252'ckw'#228'rts'
          TabOrder = 1
          OnClick = DirectionBackRBClick
        end
      end
      object ReplaceRangeGroup: TGroupBox
        Left = 11
        Top = 167
        Width = 185
        Height = 70
        Caption = 'Bereich'
        TabOrder = 4
        object ReplaceRangeWholeRB: TRadioButton
          Left = 11
          Top = 20
          Width = 113
          Height = 17
          Caption = 'gesamter Text'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = RangeWholeRBClick
        end
        object ReplaceRangeSelectionRB: TRadioButton
          Left = 11
          Top = 43
          Width = 113
          Height = 17
          Caption = 'markierter Text'
          TabOrder = 1
          OnClick = RangeSelectionRBClick
        end
      end
      object ReplaceStartGroup: TGroupBox
        Left = 210
        Top = 167
        Width = 198
        Height = 70
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Beginn'
        TabOrder = 5
        object ReplaceStartCursorRB: TRadioButton
          Left = 11
          Top = 20
          Width = 113
          Height = 17
          Caption = 'ab Cursor'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = StartCursorRBClick
        end
        object ReplaceStartWholeRB: TRadioButton
          Left = 11
          Top = 43
          Width = 113
          Height = 17
          Caption = 'Textanfang'
          TabOrder = 1
          OnClick = StartWholeRBClick
        end
      end
      object ReplaceSearchEditBtn: TBitBtn
        Left = 380
        Top = 11
        Width = 28
        Height = 21
        Anchors = [akTop, akRight]
        Caption = #182
        TabOrder = 6
        OnClick = ReplaceSearchEditBtnClick
        Glyph.Data = {
          92000000424D8A04000000000000360400002800000009000000070000000100
          08000000000054000000120B0000120B00000200000002000000DA69FF000000
          0000000000000000000000000000000000000000000000000000000000000100
          0000000000000000000101010000000000000000010101010100000000000000
          00000000000000000000000000000000000000000000}
        Layout = blGlyphRight
        Spacing = 1
      end
      object ReplaceReplaceEditBtn: TBitBtn
        Left = 380
        Top = 38
        Width = 28
        Height = 21
        Anchors = [akTop, akRight]
        Caption = #182
        TabOrder = 7
        OnClick = ReplaceReplaceEditBtnClick
        Glyph.Data = {
          92000000424D8A04000000000000360400002800000009000000070000000100
          08000000000054000000120B0000120B00000200000002000000DA69FF000000
          0000000000000000000000000000000000000000000000000000000000000100
          0000000000000000000101010000000000000000010101010100000000000000
          00000000000000000000000000000000000000000000}
        Layout = blGlyphRight
        Spacing = 1
      end
    end
    object FilesSearchTS: TTabSheet
      Caption = 'in Dateien suchen'
      ImageIndex = 2
      TabVisible = False
      OnShow = FilesSearchTSShow
      DesignSize = (
        420
        250)
      object FilesSearchSearchLabel: TLabel
        Left = 11
        Top = 14
        Width = 65
        Height = 13
        Caption = 'Suchen nach:'
      end
      object FilesSearchOptionsGroup: TGroupBox
        Left = 11
        Top = 38
        Width = 185
        Height = 75
        Caption = 'Optionen'
        TabOrder = 1
        object FilesSearchCaseCB: TCheckBox
          Left = 11
          Top = 20
          Width = 153
          Height = 17
          Caption = 'Gro'#223'-/Kleinschreibung'
          TabOrder = 0
          OnClick = CaseCBClick
        end
        object FilesSearchWordsCB: TCheckBox
          Left = 11
          Top = 43
          Width = 137
          Height = 17
          Caption = 'nur ganze W'#246'rter'
          TabOrder = 1
          OnClick = WordsCBClick
        end
      end
      object FilesSearchDirOptionsGroup: TGroupBox
        Left = 210
        Top = 38
        Width = 198
        Height = 75
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Optionen f'#252'r Verzeichnissuche'
        TabOrder = 2
        DesignSize = (
          198
          75)
        object FilesSearchSubdirsCB: TCheckBox
          Left = 11
          Top = 14
          Width = 184
          Height = 29
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Unterverzeichnisse durchsuchen'
          TabOrder = 0
          WordWrap = True
          OnClick = SubdirsCBClick
        end
      end
      object FilesSearchSearchEdit: TEdit
        Left = 88
        Top = 11
        Width = 293
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        OnChange = SearchEditChange
      end
      object FilesSearchDirGroup: TGroupBox
        Left = 11
        Top = 119
        Width = 397
        Height = 54
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Verzeichnis'
        TabOrder = 3
        DesignSize = (
          397
          54)
        object FilesSearchDirEdit: TEdit
          Left = 11
          Top = 19
          Width = 348
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          OnChange = DirEditChange
        end
        object FilesSearchDirBtn: TButton
          Left = 358
          Top = 19
          Width = 28
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 1
          OnClick = DirBtnClick
        end
      end
      object FilesSearchSearchEditBtn: TBitBtn
        Left = 380
        Top = 11
        Width = 28
        Height = 21
        Anchors = [akTop, akRight]
        Caption = #182
        TabOrder = 4
        OnClick = FilesSearchSearchEditBtnClick
        Glyph.Data = {
          92000000424D8A04000000000000360400002800000009000000070000000100
          08000000000054000000120B0000120B00000200000002000000DA69FF000000
          0000000000000000000000000000000000000000000000000000000000000100
          0000000000000000000101010000000000000000010101010100000000000000
          00000000000000000000000000000000000000000000}
        Layout = blGlyphRight
        Spacing = 1
      end
    end
    object FilesReplaceTS: TTabSheet
      Caption = 'in Dateien ersetzen'
      ImageIndex = 3
      TabVisible = False
      OnShow = FilesReplaceTSShow
      DesignSize = (
        420
        250)
      object FilesReplaceSearchLabel: TLabel
        Left = 11
        Top = 14
        Width = 65
        Height = 13
        Caption = 'Suchen nach:'
      end
      object FilesReplaceReplaceLabel: TLabel
        Left = 11
        Top = 41
        Width = 76
        Height = 13
        Caption = 'Ersetzen durch:'
      end
      object FilesReplaceOptionsGroup: TGroupBox
        Left = 11
        Top = 65
        Width = 185
        Height = 75
        Caption = 'Optionen'
        TabOrder = 0
        object FilesReplaceCaseCB: TCheckBox
          Left = 11
          Top = 20
          Width = 153
          Height = 17
          Caption = 'Gro'#223'-/Kleinschreibung'
          TabOrder = 0
          OnClick = CaseCBClick
        end
        object FilesReplaceWordsCB: TCheckBox
          Left = 11
          Top = 43
          Width = 137
          Height = 17
          Caption = 'nur ganze W'#246'rter'
          TabOrder = 1
          OnClick = WordsCBClick
        end
      end
      object FilesReplaceDirOptionsGroup: TGroupBox
        Left = 210
        Top = 65
        Width = 198
        Height = 75
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Optionen f'#252'r Verzeichnissuche'
        TabOrder = 1
        DesignSize = (
          198
          75)
        object FilesReplaceSubdirsCB: TCheckBox
          Left = 11
          Top = 14
          Width = 184
          Height = 29
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Unterverzeichnisse durchsuchen'
          TabOrder = 0
          WordWrap = True
          OnClick = SubdirsCBClick
        end
        object FilesReplaceNoBackupCB: TCheckBox
          Left = 11
          Top = 37
          Width = 184
          Height = 29
          Anchors = [akLeft, akTop, akRight]
          Caption = 'ohne Backup ersetzen'
          TabOrder = 1
          WordWrap = True
        end
      end
      object FilesReplaceSearchEdit: TEdit
        Left = 104
        Top = 11
        Width = 277
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 2
        OnChange = SearchEditChange
      end
      object FilesReplaceDirGroup: TGroupBox
        Left = 11
        Top = 146
        Width = 397
        Height = 54
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Verzeichnis'
        TabOrder = 3
        DesignSize = (
          397
          54)
        object FilesReplaceDirEdit: TEdit
          Left = 11
          Top = 19
          Width = 347
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          OnChange = DirEditChange
        end
        object FilesReplaceDirBtn: TButton
          Left = 358
          Top = 19
          Width = 28
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 1
          OnClick = DirBtnClick
        end
      end
      object FilesReplaceReplaceEdit: TEdit
        Left = 104
        Top = 38
        Width = 277
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 4
        OnChange = ReplaceEditChange
      end
      object FilesReplaceSearchEditBtn: TBitBtn
        Left = 380
        Top = 11
        Width = 28
        Height = 21
        Anchors = [akTop, akRight]
        Caption = #182
        TabOrder = 5
        OnClick = FilesReplaceSearchEditBtnClick
        Glyph.Data = {
          92000000424D8A04000000000000360400002800000009000000070000000100
          08000000000054000000120B0000120B00000200000002000000DA69FF000000
          0000000000000000000000000000000000000000000000000000000000000100
          0000000000000000000101010000000000000000010101010100000000000000
          00000000000000000000000000000000000000000000}
        Layout = blGlyphRight
        Spacing = 1
      end
      object FilesReplaceReplaceEditBtn: TBitBtn
        Left = 380
        Top = 38
        Width = 28
        Height = 21
        Anchors = [akTop, akRight]
        Caption = #182
        TabOrder = 6
        OnClick = FilesReplaceReplaceEditBtnClick
        Glyph.Data = {
          92000000424D8A04000000000000360400002800000009000000070000000100
          08000000000054000000120B0000120B00000200000002000000DA69FF000000
          0000000000000000000000000000000000000000000000000000000000000100
          0000000000000000000101010000000000000000010101010100000000000000
          00000000000000000000000000000000000000000000}
        Layout = blGlyphRight
        Spacing = 1
      end
    end
  end
  object ButtonPanel: TPanel
    Left = 0
    Top = 278
    Width = 428
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      428
      31)
    object OkBtn: TButton
      Left = 191
      Top = 6
      Width = 75
      Height = 23
      Anchors = [akTop, akRight]
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object CancelBtn: TButton
      Left = 353
      Top = 6
      Width = 75
      Height = 23
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'A&bbrechen'
      ModalResult = 2
      TabOrder = 1
      TabStop = False
    end
    object ReplaceAllBtn: TButton
      Left = 272
      Top = 6
      Width = 75
      Height = 23
      Anchors = [akTop, akRight]
      Caption = '&Alle erstezen'
      ModalResult = 8
      TabOrder = 2
    end
  end
  object EditPopupMenu: TPopupMenu
    Left = 208
    Top = 160
    object EditLineBreakDosMenu: TMenuItem
      Caption = 'Zeilenumburch DOS \r\n'
      OnClick = EditMenuClick
    end
    object EditLineBreakLinuxMenu: TMenuItem
      Tag = 1
      Caption = 'Zeilenumbruch Linux \n'
      OnClick = EditMenuClick
    end
    object EditLineBreakMacMenu: TMenuItem
      Tag = 2
      Caption = 'Zeilenumbruch Mac \r'
      OnClick = EditMenuClick
    end
    object EditTabMenu: TMenuItem
      Tag = 3
      Caption = 'Tab \t'
      OnClick = EditMenuClick
    end
    object EditBackslashMenu: TMenuItem
      Tag = 4
      Caption = 'Backslash \b'
      OnClick = EditMenuClick
    end
  end
end
