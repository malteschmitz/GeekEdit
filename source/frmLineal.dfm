object LinealForm: TLinealForm
  Left = 0
  Top = 0
  Cursor = crCross
  BorderStyle = bsNone
  Caption = 'GeekEdit - Lineal'
  ClientHeight = 50
  ClientWidth = 640
  Color = clCream
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = PopupMenu
  OnCreate = FormCreate
  OnMouseMove = FormMouseMove
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object ValueLabel: TLabel
    Left = 60
    Top = 19
    Width = 29
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = '000'
    Color = clYellow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object PopupMenu: TPopupMenu
    AutoHotkeys = maManual
    Left = 256
    Top = 8
    object s640Menu: TMenuItem
      Caption = '640 x 480'
      ShortCut = 49
      OnClick = s640MenuClick
    end
    object s800Menu: TMenuItem
      Caption = '800 x 600'
      ShortCut = 50
      OnClick = s800MenuClick
    end
    object s1024Menu: TMenuItem
      Caption = '1024 x 768'
      ShortCut = 51
      OnClick = s1024MenuClick
    end
    object s1280Menu: TMenuItem
      Caption = '1280 x 1024'
      ShortCut = 52
      OnClick = s1280MenuClick
    end
    object s1400Menu: TMenuItem
      Caption = '1400 x 1050'
      ShortCut = 53
      OnClick = s1400MenuClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Drehen1: TMenuItem
      Caption = 'Drehen'
      ShortCut = 68
      OnClick = Drehen1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Kopieren1: TMenuItem
      Caption = 'Kopieren'
      ShortCut = 16451
      OnClick = Kopieren1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object OkMenu: TMenuItem
      Caption = 'OK'
      ShortCut = 13
      OnClick = OkMenuClick
    end
    object CancelMenu: TMenuItem
      Caption = 'Abbrechen'
      ShortCut = 27
      OnClick = CancelMenuClick
    end
  end
end
