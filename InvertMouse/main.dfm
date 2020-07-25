object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 72
  ClientWidth = 301
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
  object Timer1: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Timer1Timer
    Left = 8
    Top = 8
  end
  object Timer2: TTimer
    Interval = 1
    OnTimer = Timer2Timer
    Left = 56
    Top = 8
  end
  object client: TIdTCPClient
    ConnectTimeout = 0
    Host = '192.168.1.10'
    IPVersion = Id_IPv4
    Port = 55555
    ReadTimeout = -1
    Left = 168
    Top = 24
  end
  object Timer3: TTimer
    OnTimer = Timer3Timer
    Left = 104
    Top = 8
  end
end
