object CharMapForm: TCharMapForm
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Zeichentabelle...'
  ClientHeight = 312
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 293
    Width = 426
    Height = 19
    Panels = <
      item
        Width = 20
      end
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Width = 75
      end
      item
        Width = 50
      end>
  end
  object CharMapPopupMenu: TPopupMenu
    Left = 120
    Top = 104
    object FontMenu: TMenuItem
      Caption = 'Font...'
      OnClick = FontMenuClick
    end
    object FilterMenu: TMenuItem
      Caption = 'Gruppierung'
    end
    object StyleMenu: TMenuItem
      Caption = 'Darstellung'
      object HighlightInvalidMenu: TMenuItem
        AutoCheck = True
        Caption = 'ung'#252'ltige Zeichen markieren'
        Checked = True
        OnClick = HighlightInvalidMenuClick
      end
      object ShowZoomPanelMenu: TMenuItem
        AutoCheck = True
        Caption = 'Zeichen vergr'#246#223'ern'
        Checked = True
        OnClick = ShowZoomPanelMenuClick
      end
      object ShowShadowMenu: TMenuItem
        AutoCheck = True
        Caption = 'Schatten anzeigen'
        Checked = True
        OnClick = ShowShadowMenuClick
      end
      object StatusMenu: TMenuItem
        AutoCheck = True
        Caption = 'Status anzeigen'
        Checked = True
        OnClick = StatusMenuClick
      end
    end
    object InsertMenu: TMenuItem
      Caption = 'Einf'#252'gen'
      object InsertZeichenMenu: TMenuItem
        AutoCheck = True
        Caption = 'Zeichen'
        GroupIndex = 1
        RadioItem = True
      end
      object InsertHtmlMenu: TMenuItem
        AutoCheck = True
        Caption = 'Name in HTML'
        Checked = True
        GroupIndex = 1
        RadioItem = True
      end
      object InsertUnicodeMenu: TMenuItem
        AutoCheck = True
        Caption = 'Unicode in HTML'
        GroupIndex = 1
        RadioItem = True
      end
      object InsertUnicodeHexMenu: TMenuItem
        AutoCheck = True
        Caption = 'Unicode (Hexadzimal) in HTML'
        GroupIndex = 1
        RadioItem = True
      end
    end
  end
end
