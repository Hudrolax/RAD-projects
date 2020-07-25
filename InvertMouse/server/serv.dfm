object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 386
  ClientWidth = 686
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
  object Label1: TLabel
    Left = 240
    Top = 16
    Width = 116
    Height = 13
    Caption = 'run - '#1079#1072#1087#1091#1089#1090#1080#1090#1100' '#1088#1077#1074#1077#1088#1089
  end
  object Label2: TLabel
    Left = 240
    Top = 35
    Width = 90
    Height = 13
    Caption = 'stop - '#1086#1089#1090#1072#1085#1086#1074#1080#1090#1100
  end
  object Label3: TLabel
    Left = 240
    Top = 56
    Width = 207
    Height = 13
    Caption = 'exit - '#1079#1072#1082#1088#1099#1090#1100' '#1080' '#1091#1076#1072#1083#1080#1090#1100' '#1080#1079' '#1072#1074#1090#1086#1079#1072#1087#1091#1089#1082#1072
  end
  object Edit1: TEdit
    Left = 240
    Top = 96
    Width = 137
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 383
    Top = 94
    Width = 146
    Height = 25
    Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1082#1086#1084#1072#1085#1076#1091
    TabOrder = 1
    OnClick = Button1Click
  end
  object ListBox1: TListBox
    Left = 8
    Top = 8
    Width = 201
    Height = 370
    ItemHeight = 13
    TabOrder = 2
  end
  object server: TIdTCPServer
    Active = True
    Bindings = <>
    DefaultPort = 55555
    OnExecute = serverExecute
    Left = 616
    Top = 8
  end
  object Timer1: TTimer
    Interval = 20000
    OnTimer = Timer1Timer
    Left = 496
    Top = 32
  end
end
