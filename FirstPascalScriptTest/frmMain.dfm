object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 290
  ClientWidth = 467
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    467
    290)
  PixelsPerInch = 96
  TextHeight = 13
  object CompileRunBtn: TButton
    Left = 282
    Top = 257
    Width = 177
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Compile && Execute'
    TabOrder = 0
    OnClick = CompileRunBtnClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 451
    Height = 243
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'function TestFunction(x, y: String): String;'
      'begin'
      '  Result := Format('#39'Wir spielen %s und %s!'#39', [x,y]);'
      'end;'
      ''
      'begin'
      '  ShowNewMessage(TestFunction('#39'Golf'#39', '#39'Tennis'#39'));'
      'end.')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object FunctTestBtn: TButton
    Left = 8
    Top = 257
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'FuncTest'
    TabOrder = 2
    OnClick = FunctTestBtnClick
  end
  object EasyFunc: TButton
    Left = 89
    Top = 257
    Width = 75
    Height = 25
    Caption = 'EasyFunc'
    TabOrder = 3
    OnClick = EasyFuncClick
  end
end
