object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'BotController'
  ClientHeight = 86
  ClientWidth = 328
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Timer1: TTimer
    Enabled = False
    Interval = 60000
    OnTimer = Timer1Timer
    Left = 288
    Top = 16
  end
  object Timer2: TTimer
    Interval = 1
    OnTimer = Timer2Timer
    Left = 160
    Top = 40
  end
end
