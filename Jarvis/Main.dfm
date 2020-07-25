object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Jarvis'
  ClientHeight = 111
  ClientWidth = 439
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 37
    Width = 116
    Height = 13
    Caption = #1056#1091#1095#1085#1086#1081' '#1074#1074#1086#1076' '#1082#1086#1084#1072#1085#1076#1099':'
  end
  object Button1: TButton
    Left = 8
    Top = 83
    Width = 65
    Height = 25
    Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 8
    Width = 393
    Height = 21
    TabOrder = 1
    OnChange = Edit1Change
  end
  object Edit2: TEdit
    Left = 8
    Top = 56
    Width = 385
    Height = 21
    TabOrder = 2
  end
  object client: TIdTCPClient
    ConnectTimeout = 10000
    Host = '192.168.18.11'
    IPVersion = Id_IPv4
    Port = 27032
    ReadTimeout = -1
    Left = 408
    Top = 8
  end
end
