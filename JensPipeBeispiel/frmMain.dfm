object MainForm: TMainForm
  Left = 192
  Top = 112
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'MainForm'
  ClientHeight = 428
  ClientWidth = 673
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LabelCmd: TLabel
    Left = 8
    Top = 403
    Width = 59
    Height = 13
    Caption = 'Command:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object MemoOutput: TMemo
    Left = 8
    Top = 8
    Width = 657
    Height = 385
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSilver
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 2
    WordWrap = False
  end
  object EdCmd: TEdit
    Left = 72
    Top = 400
    Width = 505
    Height = 21
    TabOrder = 0
    OnKeyPress = EdCmdKeyPress
  end
  object BtnWriteCmd: TButton
    Left = 590
    Top = 399
    Width = 75
    Height = 25
    Caption = 'Write'
    TabOrder = 1
    OnClick = BtnWriteCmdClick
  end
  object Button1: TButton
    Left = 528
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 3
    OnClick = Button1Click
  end
end
