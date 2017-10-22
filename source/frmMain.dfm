object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'GeekEdit'
  ClientHeight = 766
  ClientWidth = 714
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 747
    Width = 714
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Width = 75
      end
      item
        Width = 75
      end
      item
        Width = 75
      end
      item
        Width = 75
      end
      item
        Width = 75
      end>
    ExplicitTop = 728
  end
  object MainPanel: TPanel
    Left = 0
    Top = 0
    Width = 714
    Height = 747
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitHeight = 728
    object OutputSplitter: TSplitter
      Left = 0
      Top = 589
      Width = 714
      Height = 8
      Cursor = crVSplit
      Align = alBottom
      MinSize = 100
      Visible = False
      OnMoved = OutputSplitterMoved
      ExplicitLeft = 8
      ExplicitTop = 420
    end
    object OutputPanel: TPanel
      Left = 0
      Top = 597
      Width = 714
      Height = 150
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      Visible = False
      ExplicitTop = 578
      object OutputMemo: TMemo
        Left = 0
        Top = 0
        Width = 714
        Height = 129
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Lucida Console'
        Font.Style = []
        ParentFont = False
        PopupMenu = OutputPopupMenu
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object OutputEdit: TEdit
        Left = 0
        Top = 129
        Width = 714
        Height = 21
        Align = alBottom
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Lucida Console'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        Visible = False
        OnKeyDown = OutputEditKeyDown
        OnKeyPress = OutputEditKeyPress
      end
    end
  end
  object MainMenu: TMainMenu
    Left = 272
    Top = 8
    object FileMenu: TMenuItem
      Caption = 'Datei'
      object NewMenu: TMenuItem
        Caption = 'Neu'
        ShortCut = 16462
      end
      object NewInstanceMenu: TMenuItem
        Caption = 'Neue Instanz...'
        ShortCut = 49230
        OnClick = NewInstanceMenuClick
      end
      object OpenMenu: TMenuItem
        Caption = #214'ffnen...'
        ShortCut = 16463
      end
      object ReloadMenu: TMenuItem
        Caption = 'Neu laden'
        ShortCut = 116
      end
      object SaveMenu: TMenuItem
        Caption = 'Speichern'
        ShortCut = 16467
      end
      object SaveAsMenu: TMenuItem
        Caption = 'Speichern unter...'
        ShortCut = 24659
      end
      object BackupMenu: TMenuItem
        Caption = 'Backup erstellen'
        ShortCut = 24642
        OnClick = BackupMenuClick
      end
      object LineBreakMenu: TMenuItem
        Caption = 'Zeilenumbruch'
        object LineBreakDosMenu: TMenuItem
          Caption = 'DOS (CR + LF)'
          Checked = True
          GroupIndex = 1
          RadioItem = True
        end
        object LineBreakUnixMenu: TMenuItem
          Tag = 1
          Caption = 'Unix (LF)'
          GroupIndex = 1
          RadioItem = True
        end
        object LineBreakMacMenu: TMenuItem
          Tag = 2
          Caption = 'Mac (CR)'
          GroupIndex = 1
          RadioItem = True
        end
      end
      object CharsetMenu: TMenuItem
        Caption = 'Zeichensatz'
        object CharsetCp1252Menu: TMenuItem
          Caption = 'Codepage 1252 (Windows)'
          Checked = True
          GroupIndex = 1
          RadioItem = True
        end
        object CharsetUtf8Menu: TMenuItem
          Tag = 1
          Caption = 'UTF-8 N'#228'herung'
          GroupIndex = 1
          RadioItem = True
        end
        object CharsetUtf8BomMenu: TMenuItem
          Tag = 2
          Caption = 'UTF-8 N'#228'herung mit BOM'
          GroupIndex = 1
          RadioItem = True
        end
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object PrintMenu: TMenuItem
        Caption = 'Durcken...'
        ShortCut = 16464
      end
      object PrintPreviewMenu: TMenuItem
        Caption = 'Druckvorschau...'
      end
      object PageSetupMenu: TMenuItem
        Caption = 'Seiteneinstellungen...'
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object AboutMenu: TMenuItem
        Caption = 'Info...'
        OnClick = AboutMenuClick
      end
      object ShowHighlighterMenu: TMenuItem
        Caption = 'verf'#252'gbare Highlighter...'
        OnClick = ShowHighlighterMenuClick
      end
      object SettingsMenu: TMenuItem
        Caption = 'Einstellungen...'
        OnClick = SettingsMenuClick
      end
      object CloseMenu: TMenuItem
        Caption = 'Beenden'
        ShortCut = 32883
        OnClick = CloseMenuClick
      end
    end
    object EditMenu: TMenuItem
      Caption = 'Bearbeiten'
      object UndoMenu: TMenuItem
        Caption = 'R'#252'ckg'#228'ngig'
        ShortCut = 16474
        OnClick = UndoMenuClick
      end
      object RedoMenu: TMenuItem
        Caption = 'Wiederherstellen'
        ShortCut = 24666
        OnClick = RedoMenuClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object CopyMenu: TMenuItem
        Caption = 'Kopieren'
        ShortCut = 16451
        OnClick = CopyMenuClick
      end
      object PasteMenu: TMenuItem
        Caption = 'Einf'#252'gen'
        ShortCut = 16470
        OnClick = PasteMenuClick
      end
      object CutMenu: TMenuItem
        Caption = 'Ausschneiden'
        ShortCut = 16472
        OnClick = CutMenuClick
      end
      object SelectAllMenu: TMenuItem
        Caption = 'alles markieren'
        ShortCut = 16449
        OnClick = SelectAllMenuClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object SearchMenu: TMenuItem
        Caption = 'Suchen...'
        ShortCut = 16454
      end
      object ReplaceMenu: TMenuItem
        Caption = 'Ersetzen...'
        ShortCut = 16466
      end
      object FilesSearchMenu: TMenuItem
        Caption = 'in Dateien suchen...'
        Visible = False
      end
      object FilesReplaceMenu: TMenuItem
        Caption = 'in Dateien ersetzen...'
        Visible = False
      end
      object SearchNextMenu: TMenuItem
        Caption = 'n'#228'chstes Vorkommen suchen'
        ShortCut = 114
      end
      object SearchPrevMenu: TMenuItem
        Caption = 'vorheriges Vorkommen suchen'
        ShortCut = 8306
      end
    end
    object ViewMenu: TMenuItem
      Caption = 'Ansicht'
      object IncFontMenu: TMenuItem
        Caption = 'Schrift gr'#246#223'er'
        ShortCut = 16571
      end
      object DecFontMenu: TMenuItem
        Caption = 'Schrift kleiner'
        ShortCut = 24763
      end
      object NormalFontMenu: TMenuItem
        Caption = 'Schrift normal'
        ShortCut = 49339
      end
      object WordWrapMenu: TMenuItem
        Caption = 'Zeilenumburch'
        ShortCut = 16471
      end
      object ShowSpecialCharsMenu: TMenuItem
        Caption = 'Sonderzeichen'
        ShortCut = 115
      end
      object OutputMenu: TMenuItem
        Caption = 'Ausgabe'
        ShortCut = 113
        OnClick = OutputMenuClick
      end
      object N5: TMenuItem
        Caption = '-'
      end
    end
    object ToolsMenu: TMenuItem
      Caption = 'Tools'
    end
  end
  object OutputPopupMenu: TPopupMenu
    Left = 208
    Top = 528
    object KillOutputMenu: TMenuItem
      Caption = 'Anwendung abbrechen'
      OnClick = KillOutputMenuClick
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object ClearOutputMenu: TMenuItem
      Caption = 'Ausgabe leeren'
      OnClick = ClearOutputMenuClick
    end
    object HideOutputMenu: TMenuItem
      Caption = 'Ausgabe ausblenden'
      OnClick = HideOutputMenuClick
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object OutputCopyMenu: TMenuItem
      Caption = 'kopieren'
      OnClick = OutputCopyMenuClick
    end
    object OutputSelectAllMenu: TMenuItem
      Caption = 'alles markieren'
      OnClick = OutputSelectAllMenuClick
    end
  end
  object SynEditPopupMenu: TPopupMenu
    Left = 264
    Top = 216
    object OpenSelectionMenu: TMenuItem
      Caption = 'Auswahl '#246'ffnen'
      OnClick = OpenSelectionMenuClick
    end
    object N10: TMenuItem
      Caption = '-'
    end
    object PopupUndoMenu: TMenuItem
      Caption = 'R'#252'ckg'#228'ngig'
      OnClick = UndoMenuClick
    end
    object PopupRedoMenu: TMenuItem
      Caption = 'Wiederherstellen'
      OnClick = RedoMenuClick
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object PopupCutMenu: TMenuItem
      Caption = 'Ausschneiden'
      OnClick = CutMenuClick
    end
    object PopupCopyMenu: TMenuItem
      Caption = 'Kopieren'
      OnClick = CopyMenuClick
    end
    object PopupPasteMenu: TMenuItem
      Caption = 'Einf'#252'gen'
      OnClick = PasteMenuClick
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object PopupSelectAllMenu: TMenuItem
      Caption = 'alles markieren'
      OnClick = SelectAllMenuClick
    end
  end
end
