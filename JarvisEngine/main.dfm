object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Jarvis engine'
  ClientHeight = 107
  ClientWidth = 395
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
    Interval = 1
    OnTimer = Timer1Timer
    Left = 72
    Top = 8
  end
  object WorkTimer: TTimer
    Enabled = False
    OnTimer = WorkTimerTimer
    Left = 16
    Top = 8
  end
  object TCPCient: TIdTCPClient
    BoundPort = 27033
    ConnectTimeout = 0
    IPVersion = Id_IPv4
    Port = 0
    ReadTimeout = -1
    Left = 120
    Top = 8
  end
end
