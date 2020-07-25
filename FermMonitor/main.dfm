object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'FermMonitor'
  ClientHeight = 486
  ClientWidth = 508
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
    Left = 8
    Top = 8
    Width = 489
    Height = 470
    ItemHeight = 13
    TabOrder = 0
  end
  object IdTCPServer1: TIdTCPServer
    Active = True
    Bindings = <>
    DefaultPort = 27033
    OnExecute = IdTCPServer1Execute
    Left = 456
    Top = 8
  end
  object Timer1: TTimer
    Interval = 3000
    OnTimer = Timer1Timer
    Left = 424
    Top = 240
  end
end
