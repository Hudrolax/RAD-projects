object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'BTC-e BOT'
  ClientHeight = 393
  ClientWidth = 813
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    813
    393)
  PixelsPerInch = 96
  TextHeight = 13
  object edtCommLine: TEdit
    Left = 1
    Top = 367
    Width = 737
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 0
    OnKeyDown = edtCommLineKeyDown
  end
  object btnSendButton: TButton
    Left = 744
    Top = 368
    Width = 65
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Send'
    TabOrder = 1
    OnClick = btnSendButtonClick
  end
  object Console: TRichEdit
    Left = -3
    Top = 0
    Width = 808
    Height = 362
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
  end
end
