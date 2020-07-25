object Form1: TForm1
  Left = 0
  Top = 0
  Width = 550
  Height = 326
  AlphaBlend = True
  AutoScroll = True
  Caption = 'HudroMineWatchDog'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 0
    Top = 0
    Width = 534
    Height = 252
    Align = alTop
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
  end
  object Button1: TButton
    Left = 8
    Top = 258
    Width = 193
    Height = 25
    BiDiMode = bdRightToLeft
    Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1086#1096#1080#1073#1082#1080' gpu'
    ParentBiDiMode = False
    TabOrder = 1
    OnClick = Button1Click
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 264
    Top = 128
  end
  object TestMinerTimer: TTimer
    Enabled = False
    OnTimer = TestMinerTimerTimer
    Left = 232
    Top = 64
  end
  object StartMinerTimer: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = StartMinerTimerTimer
    Left = 72
    Top = 56
  end
end
