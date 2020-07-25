object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'JarvisAndroidServer'
  ClientHeight = 364
  ClientWidth = 439
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 0
    Top = 8
    Width = 393
    Height = 292
    ItemHeight = 13
    TabOrder = 0
  end
  object Edit1: TEdit
    Left = 0
    Top = 306
    Width = 393
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 304
    Top = 333
    Width = 89
    Height = 25
    Caption = 'Send'
    TabOrder = 2
    OnClick = Button1Click
  end
  object server: TIdTCPServer
    Active = True
    Bindings = <>
    DefaultPort = 27020
    OnConnect = serverConnect
    OnExecute = serverExecute
    Left = 400
    Top = 8
  end
  object Timer1: TTimer
    Interval = 200
    OnTimer = Timer1Timer
    Left = 400
    Top = 80
  end
end
