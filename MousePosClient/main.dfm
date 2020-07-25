object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'MPosForm'
  ClientHeight = 44
  ClientWidth = 214
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
  object Timer1: TTimer
    Interval = 1
    OnTimer = Timer1Timer
    Left = 8
    Top = 8
  end
  object Timer2: TTimer
    Enabled = False
    OnTimer = Timer2Timer
    Left = 88
    Top = 8
  end
  object client: TIdTCPClient
    ConnectTimeout = 20
    Host = '127.0.0.1'
    IPVersion = Id_IPv4
    Port = 27030
    ReadTimeout = -1
    Left = 144
    Top = 8
  end
end
