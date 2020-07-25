object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 470
  ClientWidth = 632
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object tcpserver1: TIdTCPServer
    Bindings = <>
    DefaultPort = 27033
    OnConnect = tcpserver1Connect
    OnExecute = tcpserver1Execute
    Left = 576
    Top = 16
  end
end
