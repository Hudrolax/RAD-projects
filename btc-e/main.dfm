object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'BTC-E Trade BOT'
  ClientHeight = 768
  ClientWidth = 909
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 44
    Height = 13
    Caption = #1041#1072#1083#1072#1085#1089':'
    Color = clGreen
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Label2: TLabel
    Left = 58
    Top = 8
    Width = 23
    Height = 13
    Caption = 'BTC:'
    OnClick = BTCBalanceLabelClick
  end
  object BTCBalanceLabel: TLabel
    Left = 87
    Top = 8
    Width = 6
    Height = 13
    Caption = '0'
    OnClick = BTCBalanceLabelClick
  end
  object Label3: TLabel
    Left = 162
    Top = 8
    Width = 22
    Height = 13
    Caption = 'LTC:'
    OnClick = LTCBalanceLabelClick
  end
  object LTCBalanceLabel: TLabel
    Left = 191
    Top = 8
    Width = 6
    Height = 13
    Caption = '0'
    OnClick = LTCBalanceLabelClick
  end
  object Label5: TLabel
    Left = 267
    Top = 8
    Width = 25
    Height = 13
    Caption = 'RUR:'
    OnClick = RURBalanceLabelClick
  end
  object RURBalanceLabel: TLabel
    Left = 298
    Top = 8
    Width = 6
    Height = 13
    Caption = '0'
    OnClick = RURBalanceLabelClick
  end
  object Label15: TLabel
    Left = 535
    Top = 54
    Width = 32
    Height = 13
    Caption = #1055#1072#1088#1072':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label16: TLabel
    Left = 534
    Top = 81
    Width = 33
    Height = 13
    Caption = #1062#1077#1085#1072':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label17: TLabel
    Left = 668
    Top = 81
    Width = 21
    Height = 13
    Caption = 'RUR'
  end
  object Label18: TLabel
    Left = 680
    Top = 56
    Width = 70
    Height = 13
    Caption = #1058#1080#1087' '#1086#1088#1076#1077#1088#1072':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label19: TLabel
    Left = 535
    Top = 112
    Width = 71
    Height = 13
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label20: TLabel
    Left = 536
    Top = 136
    Width = 32
    Height = 13
    Caption = #1042#1089#1077#1075#1086':'
  end
  object Label21: TLabel
    Left = 592
    Top = 136
    Width = 7
    Height = 13
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label22: TLabel
    Left = 535
    Top = 155
    Width = 51
    Height = 13
    Caption = #1050#1086#1084#1080#1089#1089#1080#1103':'
  end
  object Label23: TLabel
    Left = 592
    Top = 155
    Width = 7
    Height = 13
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label24: TLabel
    Left = 379
    Top = 8
    Width = 24
    Height = 13
    Caption = 'NVC:'
    OnClick = Label24Click
  end
  object NVCBalanceLabel: TLabel
    Left = 410
    Top = 8
    Width = 6
    Height = 13
    Caption = '0'
    OnClick = NVCBalanceLabelClick
  end
  object Label25: TLabel
    Left = 475
    Top = 8
    Width = 24
    Height = 13
    Caption = 'TRC:'
    OnClick = TRCBalanceLabelClick
  end
  object TRCBalanceLabel: TLabel
    Left = 506
    Top = 8
    Width = 6
    Height = 13
    Caption = '0'
    OnClick = TRCBalanceLabelClick
  end
  object Label26: TLabel
    Left = 582
    Top = 8
    Width = 23
    Height = 13
    Caption = 'FTC:'
    OnClick = FTCBalanceLabelClick
  end
  object FTCBalanceLabel: TLabel
    Left = 613
    Top = 8
    Width = 6
    Height = 13
    Caption = '0'
    OnClick = FTCBalanceLabelClick
  end
  object Label27: TLabel
    Left = 696
    Top = 8
    Width = 24
    Height = 13
    Caption = 'USD:'
    OnClick = USDBalanceLabelClick
  end
  object USDBalanceLabel: TLabel
    Left = 727
    Top = 8
    Width = 6
    Height = 13
    Caption = '0'
    OnClick = USDBalanceLabelClick
  end
  object PageControl1: TPageControl
    Left = 1
    Top = 27
    Width = 529
    Height = 439
    ActivePage = TabSheet4
    MultiLine = True
    TabOrder = 0
    OnDrawTab = PageControl1DrawTab
    object TabSheet1: TTabSheet
      Caption = 'BTC/USD'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnShow = TabSheet1Show
      DesignSize = (
        521
        393)
      object Label4: TLabel
        Left = 263
        Top = 3
        Width = 114
        Height = 13
        Caption = #1054#1088#1076#1077#1088#1072' '#1085#1072' '#1087#1086#1082#1091#1087#1082#1091
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label6: TLabel
        Left = 0
        Top = 3
        Width = 120
        Height = 13
        Caption = #1054#1088#1076#1077#1088#1072' '#1085#1072' '#1087#1088#1086#1076#1072#1078#1091
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object sgBTCUSDsell: TStringGrid
        Left = 0
        Top = 16
        Width = 257
        Height = 374
        Anchors = [akLeft, akRight, akBottom]
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        OnClick = sgBTCUSDsellClick
        OnDrawCell = sgBTCUSDsellDrawCell
        ColWidths = (
          64
          71
          97)
      end
      object sgBTCUSDbuy: TStringGrid
        Left = 263
        Top = 16
        Width = 257
        Height = 376
        Anchors = [akLeft, akRight, akBottom]
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 1
        OnClick = sgBTCUSDsellClick
        OnDrawCell = sgBTCUSDsellDrawCell
        ColWidths = (
          64
          71
          97)
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'BTC/RUR'
      ImageIndex = 1
      OnShow = TabSheet1Show
      DesignSize = (
        521
        393)
      object Label7: TLabel
        Left = 3
        Top = 3
        Width = 120
        Height = 13
        Caption = #1054#1088#1076#1077#1088#1072' '#1085#1072' '#1087#1088#1086#1076#1072#1078#1091
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label8: TLabel
        Left = 263
        Top = 3
        Width = 114
        Height = 13
        Caption = #1054#1088#1076#1077#1088#1072' '#1085#1072' '#1087#1086#1082#1091#1087#1082#1091
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object sgBTCRURsell: TStringGrid
        Left = 0
        Top = 16
        Width = 257
        Height = 399
        Anchors = [akLeft, akRight, akBottom]
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        OnClick = sgBTCUSDsellClick
        OnDrawCell = sgBTCUSDsellDrawCell
        ColWidths = (
          64
          71
          97)
      end
      object sgBTCRURbuy: TStringGrid
        Left = 263
        Top = 16
        Width = 257
        Height = 399
        Anchors = [akLeft, akRight, akBottom]
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 1
        OnClick = sgBTCUSDsellClick
        OnDrawCell = sgBTCUSDsellDrawCell
        ColWidths = (
          64
          71
          97)
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'LTC/BTC'
      ImageIndex = 2
      OnShow = TabSheet1Show
      DesignSize = (
        521
        393)
      object Label9: TLabel
        Left = 3
        Top = 3
        Width = 120
        Height = 13
        Caption = #1054#1088#1076#1077#1088#1072' '#1085#1072' '#1087#1088#1086#1076#1072#1078#1091
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label10: TLabel
        Left = 263
        Top = 3
        Width = 114
        Height = 13
        Caption = #1054#1088#1076#1077#1088#1072' '#1085#1072' '#1087#1086#1082#1091#1087#1082#1091
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object sgLTCBTCSell: TStringGrid
        Left = 0
        Top = 16
        Width = 257
        Height = 399
        Anchors = [akLeft, akRight, akBottom]
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        OnClick = sgBTCUSDsellClick
        OnDrawCell = sgBTCUSDsellDrawCell
        ColWidths = (
          64
          71
          97)
      end
      object sgLTCBTCBuy: TStringGrid
        Left = 263
        Top = 16
        Width = 257
        Height = 399
        Anchors = [akLeft, akRight, akBottom]
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 1
        OnClick = sgBTCUSDsellClick
        OnDrawCell = sgBTCUSDsellDrawCell
        ColWidths = (
          64
          71
          97)
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'LTC/USD'
      ImageIndex = 3
      OnShow = TabSheet1Show
      DesignSize = (
        521
        393)
      object Label11: TLabel
        Left = 4
        Top = 3
        Width = 120
        Height = 13
        Caption = #1054#1088#1076#1077#1088#1072' '#1085#1072' '#1087#1088#1086#1076#1072#1078#1091
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label12: TLabel
        Left = 263
        Top = 3
        Width = 114
        Height = 13
        Caption = #1054#1088#1076#1077#1088#1072' '#1085#1072' '#1087#1086#1082#1091#1087#1082#1091
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object sgLTCUSDSell: TStringGrid
        Left = 0
        Top = 16
        Width = 257
        Height = 399
        Anchors = [akLeft, akRight, akBottom]
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        OnClick = sgBTCUSDsellClick
        OnDrawCell = sgBTCUSDsellDrawCell
        ColWidths = (
          64
          71
          97)
      end
      object sgLTCUSDBuy: TStringGrid
        Left = 263
        Top = 16
        Width = 257
        Height = 399
        Anchors = [akLeft, akRight, akBottom]
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 1
        OnClick = sgBTCUSDsellClick
        OnDrawCell = sgBTCUSDsellDrawCell
        ColWidths = (
          64
          71
          97)
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'LTC/RUR'
      ImageIndex = 4
      OnShow = TabSheet1Show
      DesignSize = (
        521
        393)
      object Label13: TLabel
        Left = 3
        Top = 3
        Width = 120
        Height = 13
        Caption = #1054#1088#1076#1077#1088#1072' '#1085#1072' '#1087#1088#1086#1076#1072#1078#1091
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label14: TLabel
        Left = 263
        Top = 3
        Width = 114
        Height = 13
        Caption = #1054#1088#1076#1077#1088#1072' '#1085#1072' '#1087#1086#1082#1091#1087#1082#1091
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object sgLTCRURSell: TStringGrid
        Left = 3
        Top = 16
        Width = 257
        Height = 376
        Anchors = [akLeft, akRight, akBottom]
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        OnClick = sgBTCUSDsellClick
        OnDrawCell = sgBTCUSDsellDrawCell
        ColWidths = (
          64
          71
          97)
      end
      object sgLTCRURBuy: TStringGrid
        Left = 264
        Top = 16
        Width = 257
        Height = 376
        Anchors = [akLeft, akRight, akBottom]
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 1
        OnClick = sgBTCUSDsellClick
        OnDrawCell = sgBTCUSDsellDrawCell
        ColWidths = (
          64
          71
          97)
      end
    end
    object TabSheet9: TTabSheet
      Caption = 'NMC/BTC'
      ImageIndex = 5
      OnShow = TabSheet1Show
      DesignSize = (
        521
        393)
      object Label28: TLabel
        Left = 3
        Top = 3
        Width = 120
        Height = 13
        Caption = #1054#1088#1076#1077#1088#1072' '#1085#1072' '#1087#1088#1086#1076#1072#1078#1091
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label29: TLabel
        Left = 263
        Top = 3
        Width = 114
        Height = 13
        Caption = #1054#1088#1076#1077#1088#1072' '#1085#1072' '#1087#1086#1082#1091#1087#1082#1091
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object sgNMCBTCSell: TStringGrid
        Left = 0
        Top = 16
        Width = 257
        Height = 399
        Anchors = [akLeft, akRight, akBottom]
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        OnClick = sgBTCUSDsellClick
        OnDrawCell = sgBTCUSDsellDrawCell
        ColWidths = (
          64
          71
          97)
      end
      object sgNMCBTCBuy: TStringGrid
        Left = 263
        Top = 16
        Width = 257
        Height = 399
        Anchors = [akLeft, akRight, akBottom]
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 1
        OnClick = sgBTCUSDsellClick
        OnDrawCell = sgBTCUSDsellDrawCell
        ColWidths = (
          64
          71
          97)
      end
    end
    object TabSheet10: TTabSheet
      Caption = 'NMC/USD'
      ImageIndex = 6
      OnShow = TabSheet1Show
      DesignSize = (
        521
        393)
      object Label30: TLabel
        Left = 3
        Top = 3
        Width = 120
        Height = 13
        Caption = #1054#1088#1076#1077#1088#1072' '#1085#1072' '#1087#1088#1086#1076#1072#1078#1091
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label31: TLabel
        Left = 263
        Top = 3
        Width = 114
        Height = 13
        Caption = #1054#1088#1076#1077#1088#1072' '#1085#1072' '#1087#1086#1082#1091#1087#1082#1091
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object sgNMCUSDSell: TStringGrid
        Left = 0
        Top = 16
        Width = 257
        Height = 376
        Anchors = [akLeft, akRight, akBottom]
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        OnClick = sgBTCUSDsellClick
        OnDrawCell = sgBTCUSDsellDrawCell
        ColWidths = (
          64
          71
          97)
      end
      object sgNMCUSDBuy: TStringGrid
        Left = 263
        Top = 16
        Width = 257
        Height = 376
        Anchors = [akLeft, akRight, akBottom]
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 1
        OnClick = sgBTCUSDsellClick
        OnDrawCell = sgBTCUSDsellDrawCell
        ColWidths = (
          64
          71
          97)
      end
    end
    object TabSheet11: TTabSheet
      Caption = 'NVC/BTC'
      ImageIndex = 7
      OnShow = TabSheet1Show
      DesignSize = (
        521
        393)
      object Label32: TLabel
        Left = 3
        Top = 3
        Width = 120
        Height = 13
        Caption = #1054#1088#1076#1077#1088#1072' '#1085#1072' '#1087#1088#1086#1076#1072#1078#1091
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label33: TLabel
        Left = 263
        Top = 3
        Width = 114
        Height = 13
        Caption = #1054#1088#1076#1077#1088#1072' '#1085#1072' '#1087#1086#1082#1091#1087#1082#1091
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object sgNVCBTCSell: TStringGrid
        Left = 0
        Top = 16
        Width = 257
        Height = 399
        Anchors = [akLeft, akRight, akBottom]
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        OnClick = sgBTCUSDsellClick
        OnDrawCell = sgBTCUSDsellDrawCell
        ColWidths = (
          64
          71
          97)
      end
      object sgNVCBTCBuy: TStringGrid
        Left = 263
        Top = 16
        Width = 257
        Height = 399
        Anchors = [akLeft, akRight, akBottom]
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 1
        OnClick = sgBTCUSDsellClick
        OnDrawCell = sgBTCUSDsellDrawCell
        ColWidths = (
          64
          71
          97)
      end
    end
    object TabSheet12: TTabSheet
      Caption = 'NVC/USD'
      ImageIndex = 8
      OnShow = TabSheet1Show
      DesignSize = (
        521
        393)
      object Label34: TLabel
        Left = 0
        Top = 3
        Width = 120
        Height = 13
        Caption = #1054#1088#1076#1077#1088#1072' '#1085#1072' '#1087#1088#1086#1076#1072#1078#1091
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label35: TLabel
        Left = 263
        Top = 3
        Width = 114
        Height = 13
        Caption = #1054#1088#1076#1077#1088#1072' '#1085#1072' '#1087#1086#1082#1091#1087#1082#1091
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object sgNVCUSDSell: TStringGrid
        Left = 0
        Top = 16
        Width = 257
        Height = 399
        Anchors = [akLeft, akRight, akBottom]
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        OnClick = sgBTCUSDsellClick
        OnDrawCell = sgBTCUSDsellDrawCell
        ColWidths = (
          64
          71
          97)
      end
      object sgNVCUSDBuy: TStringGrid
        Left = 263
        Top = 16
        Width = 257
        Height = 399
        Anchors = [akLeft, akRight, akBottom]
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 1
        OnClick = sgBTCUSDsellClick
        OnDrawCell = sgBTCUSDsellDrawCell
        ColWidths = (
          64
          71
          97)
      end
    end
    object TabSheet13: TTabSheet
      Caption = 'TRC/BTC'
      ImageIndex = 9
      OnShow = TabSheet1Show
      DesignSize = (
        521
        393)
      object Label36: TLabel
        Left = 3
        Top = 3
        Width = 120
        Height = 13
        Caption = #1054#1088#1076#1077#1088#1072' '#1085#1072' '#1087#1088#1086#1076#1072#1078#1091
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label37: TLabel
        Left = 263
        Top = 3
        Width = 114
        Height = 13
        Caption = #1054#1088#1076#1077#1088#1072' '#1085#1072' '#1087#1086#1082#1091#1087#1082#1091
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object sgTRCBTCSell: TStringGrid
        Left = 0
        Top = 16
        Width = 257
        Height = 399
        Anchors = [akLeft, akRight, akBottom]
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        OnClick = sgBTCUSDsellClick
        OnDrawCell = sgBTCUSDsellDrawCell
        ColWidths = (
          64
          71
          97)
      end
      object sgTRCBTCBuy: TStringGrid
        Left = 263
        Top = 16
        Width = 257
        Height = 399
        Anchors = [akLeft, akRight, akBottom]
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 1
        OnClick = sgBTCUSDsellClick
        OnDrawCell = sgBTCUSDsellDrawCell
        ColWidths = (
          64
          71
          97)
      end
    end
    object TabSheet14: TTabSheet
      Caption = 'PPC/BTC'
      ImageIndex = 10
      OnShow = TabSheet1Show
      DesignSize = (
        521
        393)
      object Label38: TLabel
        Left = 3
        Top = 3
        Width = 120
        Height = 13
        Caption = #1054#1088#1076#1077#1088#1072' '#1085#1072' '#1087#1088#1086#1076#1072#1078#1091
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label39: TLabel
        Left = 263
        Top = 3
        Width = 114
        Height = 13
        Caption = #1054#1088#1076#1077#1088#1072' '#1085#1072' '#1087#1086#1082#1091#1087#1082#1091
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object sgPPCBTCSell: TStringGrid
        Left = 0
        Top = 16
        Width = 257
        Height = 399
        Anchors = [akLeft, akRight, akBottom]
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        OnClick = sgBTCUSDsellClick
        OnDrawCell = sgBTCUSDsellDrawCell
        ColWidths = (
          64
          71
          97)
      end
      object sgPPCBTCBuy: TStringGrid
        Left = 263
        Top = 16
        Width = 257
        Height = 399
        Anchors = [akLeft, akRight, akBottom]
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 1
        OnClick = sgBTCUSDsellClick
        OnDrawCell = sgBTCUSDsellDrawCell
        ColWidths = (
          64
          71
          97)
      end
    end
    object TabSheet15: TTabSheet
      Caption = 'XPM/BTC'
      ImageIndex = 11
      OnShow = TabSheet1Show
      DesignSize = (
        521
        393)
      object Label40: TLabel
        Left = 3
        Top = 3
        Width = 120
        Height = 13
        Caption = #1054#1088#1076#1077#1088#1072' '#1085#1072' '#1087#1088#1086#1076#1072#1078#1091
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label41: TLabel
        Left = 263
        Top = 3
        Width = 114
        Height = 13
        Caption = #1054#1088#1076#1077#1088#1072' '#1085#1072' '#1087#1086#1082#1091#1087#1082#1091
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object sgXPMBTCSell: TStringGrid
        Left = 0
        Top = 16
        Width = 257
        Height = 399
        Anchors = [akLeft, akRight, akBottom]
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        OnClick = sgBTCUSDsellClick
        OnDrawCell = sgBTCUSDsellDrawCell
        ColWidths = (
          64
          71
          97)
      end
      object sgXPMBTCBuy: TStringGrid
        Left = 263
        Top = 16
        Width = 257
        Height = 399
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 16
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 1
        OnClick = sgBTCUSDsellClick
        OnDrawCell = sgBTCUSDsellDrawCell
        ColWidths = (
          64
          71
          97)
      end
    end
  end
  object PageControl2: TPageControl
    AlignWithMargins = True
    Left = 1
    Top = 467
    Width = 904
    Height = 190
    ActivePage = TabSheet18
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object TabSheet6: TTabSheet
      Caption = #1040#1082#1090#1080#1074#1085#1099#1077' '#1086#1088#1076#1077#1088#1072
      object sgActiveOrders: TStringGrid
        Left = 0
        Top = 0
        Width = 657
        Height = 166
        ColCount = 8
        DefaultColWidth = 30
        DefaultRowHeight = 15
        RowCount = 6
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        OnClick = sgActiveOrdersClick
        ColWidths = (
          30
          74
          43
          77
          125
          111
          115
          57)
      end
      object Button1: TButton
        Left = 691
        Top = 134
        Width = 75
        Height = 25
        Caption = #1054#1090#1084#1077#1085#1080#1090#1100
        TabOrder = 1
        OnClick = Button1Click
      end
      object chCancelAllOrders: TCheckBox
        Left = 663
        Top = 88
        Width = 90
        Height = 17
        Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1042#1057#1045
        TabOrder = 2
      end
      object chSelectedPair: TCheckBox
        Left = 663
        Top = 111
        Width = 123
        Height = 17
        Caption = #1055#1086' '#1074#1099#1073#1088#1072#1085#1085#1086#1081' '#1055#1072#1088#1077
        TabOrder = 3
      end
      object chActiveCurrent: TCheckBox
        Left = 663
        Top = 0
        Width = 123
        Height = 25
        Caption = #1055#1086' '#1090#1077#1082#1091#1097#1077#1081' '#1087#1072#1088#1077
        TabOrder = 4
        OnClick = chActiveCurrentClick
      end
    end
    object TabSheet7: TTabSheet
      Caption = #1048#1089#1090#1086#1088#1080#1103
      ImageIndex = 1
      object sgHistory: TStringGrid
        Left = 0
        Top = 0
        Width = 657
        Height = 166
        ColCount = 8
        DefaultColWidth = 30
        DefaultRowHeight = 15
        RowCount = 6
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        ColWidths = (
          30
          74
          43
          77
          125
          111
          115
          57)
      end
      object chHistoryActive: TCheckBox
        Left = 659
        Top = 3
        Width = 110
        Height = 17
        Caption = #1055#1086' '#1090#1077#1082#1091#1097#1077#1081' '#1087#1072#1088#1077
        TabOrder = 1
        OnClick = chHistoryActiveClick
      end
    end
    object ts1: TTabSheet
      Caption = #1042#1080#1088#1090#1091#1072#1083#1100#1085#1099#1077' '#1086#1088#1076#1077#1088#1072
      ImageIndex = 3
      object Label47: TLabel
        Left = 787
        Top = 0
        Width = 105
        Height = 13
        Caption = #1054#1073#1098#1077#1084' '#1085#1072#1076' '#1086#1088#1076#1077#1088#1086#1084':'
      end
      object Label48: TLabel
        Left = 787
        Top = 19
        Width = 7
        Height = 13
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label49: TLabel
        Left = 787
        Top = 57
        Width = 7
        Height = 13
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label50: TLabel
        Left = 787
        Top = 38
        Width = 92
        Height = 13
        Caption = #1054#1073#1098#1077#1084#1072' '#1086#1089#1090#1072#1083#1086#1089#1100':'
      end
      object sgVirtualOrders: TStringGrid
        Left = 0
        Top = 0
        Width = 781
        Height = 166
        ColCount = 13
        DefaultColWidth = 30
        DefaultRowHeight = 15
        RowCount = 6
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        OnClick = sgVirtualOrdersClick
        OnDrawCell = sgVirtualOrdersDrawCell
        ColWidths = (
          30
          68
          43
          71
          77
          66
          66
          62
          60
          49
          41
          64
          67)
      end
      object Button3: TButton
        Left = 824
        Top = 134
        Width = 68
        Height = 25
        Caption = #1059#1076#1072#1083#1080#1090#1100
        TabOrder = 1
        OnClick = Button3Click
      end
      object Button8: TButton
        Left = 787
        Top = 76
        Width = 73
        Height = 17
        Caption = 'Del comment'
        TabOrder = 2
        OnClick = Button8Click
      end
    end
    object TabSheet17: TTabSheet
      Caption = #1057#1080#1075#1085#1072#1083#1099
      ImageIndex = 4
      object sgSignalTab: TStringGrid
        Left = 0
        Top = 0
        Width = 657
        Height = 166
        ColCount = 3
        DefaultColWidth = 30
        DefaultRowHeight = 15
        RowCount = 6
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        ColWidths = (
          30
          93
          92)
      end
      object Button4: TButton
        Left = 680
        Top = 128
        Width = 89
        Height = 25
        Caption = #1059#1076#1072#1083#1080#1090#1100
        TabOrder = 1
        OnClick = Button4Click
      end
    end
    object TabSheet18: TTabSheet
      Caption = #1048#1089#1090#1086#1088#1080#1103' '#1090#1086#1088#1075#1086#1074
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ImageIndex = 2
      ParentFont = False
      object Label44: TLabel
        Left = 543
        Top = 3
        Width = 37
        Height = 13
        Caption = 'Label44'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label45: TLabel
        Left = 543
        Top = 22
        Width = 37
        Height = 13
        Caption = 'Label45'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label46: TLabel
        Left = 543
        Top = 41
        Width = 37
        Height = 13
        Caption = 'Label46'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object sgTradeHistory: TStringGrid
        Left = -4
        Top = -1
        Width = 541
        Height = 166
        ColCount = 6
        DefaultColWidth = 50
        DefaultRowHeight = 15
        RowCount = 6
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        ParentFont = False
        TabOrder = 0
        OnDrawCell = sgTradeHistoryDrawCell
        ColWidths = (
          50
          48
          106
          106
          86
          126)
      end
    end
    object TabSheet19: TTabSheet
      Caption = 'TabSheet19'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ImageIndex = 5
      ParentFont = False
      object StringGrid1: TStringGrid
        Left = -4
        Top = -4
        Width = 585
        Height = 166
        ColCount = 6
        DefaultColWidth = 50
        DefaultRowHeight = 15
        RowCount = 6
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        ParentFont = False
        TabOrder = 0
        OnDrawCell = sgTradeHistoryDrawCell
        ColWidths = (
          50
          123
          106
          106
          86
          126)
      end
    end
  end
  object Button2: TButton
    Left = 756
    Top = 143
    Width = 73
    Height = 25
    Caption = #1054#1090#1082#1088#1099#1090#1100
    TabOrder = 2
    OnClick = Button2Click
  end
  object cbOpenPair: TComboBox
    Left = 573
    Top = 51
    Width = 89
    Height = 21
    CharCase = ecLowerCase
    TabOrder = 3
    Text = 'btc_rur'
    OnChange = cbOpenPairChange
    Items.Strings = (
      'btc_usd'
      'btc_rur'
      'ltc_btc'
      'ltc_usd'
      'ltc_rur')
  end
  object EditPriceOpen: TEdit
    Left = 568
    Top = 78
    Width = 94
    Height = 21
    TabOrder = 4
    Text = '0'
    OnChange = EditPriceOpenChange
  end
  object cbTypeOpen: TComboBox
    Left = 756
    Top = 51
    Width = 49
    Height = 21
    Color = clRed
    TabOrder = 5
    Text = 'sell'
    OnChange = cbTypeOpenChange
    Items.Strings = (
      'buy'
      'sell')
  end
  object EditAmountOpen: TEdit
    Left = 612
    Top = 105
    Width = 117
    Height = 21
    TabOrder = 6
    Text = '0'
    OnChange = EditAmountOpenChange
  end
  object PageControl3: TPageControl
    Left = 532
    Top = 174
    Width = 373
    Height = 291
    ActivePage = TabSheet8
    TabOrder = 7
    object TabSheet8: TTabSheet
      Caption = #1047#1072#1076#1072#1085#1080#1077'1'
      object Label51: TLabel
        Left = 256
        Top = 56
        Width = 19
        Height = 13
        Caption = #1096#1072#1075
      end
      object Label52: TLabel
        Left = 126
        Top = 110
        Width = 149
        Height = 13
        Caption = #1052#1085#1086#1078#1080#1090#1077#1083#1100' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1082#1086#1083'-'#1074#1072':'
      end
      object Label57: TLabel
        Left = 214
        Top = 78
        Width = 61
        Height = 13
        Caption = #1055#1077#1088#1074#1099#1081' '#1096#1072#1075
      end
      object chk1: TCheckBox
        Left = 0
        Top = 3
        Width = 161
        Height = 17
        Caption = #1054#1090#1082#1088#1099#1074#1072#1090#1100' '#1087#1086' '#1074#1077#1088#1093#1085#1077#1081' '#1094#1077#1085#1077
        TabOrder = 0
        OnClick = chk1Click
      end
      object chk2: TCheckBox
        Left = 0
        Top = 26
        Width = 182
        Height = 17
        Caption = #1054#1090#1082#1088#1099#1090#1100' '#1087#1086#1089#1083#1077' '#1072#1082#1090#1080#1074#1085#1086#1075#1086' '#1086#1088#1076#1077#1088#1072
        TabOrder = 1
        OnClick = chk2Click
      end
      object edt1: TEdit
        Left = 188
        Top = 24
        Width = 97
        Height = 21
        TabOrder = 2
      end
      object chTrailBox: TCheckBox
        Left = 0
        Top = 49
        Width = 145
        Height = 17
        Caption = #1058#1088#1077#1081#1083' '#1086#1088#1076#1077#1088' '#1089' '#1086#1090#1089#1090#1091#1087#1086#1084
        TabOrder = 3
        OnClick = chTrailBoxClick
      end
      object TrailDelta: TEdit
        Left = 140
        Top = 49
        Width = 106
        Height = 21
        TabOrder = 4
        Text = '0'
      end
      object TrailStep: TEdit
        Left = 281
        Top = 51
        Width = 81
        Height = 21
        TabOrder = 5
        Text = '0'
      end
      object edtMultiAverge: TEdit
        Left = 281
        Top = 110
        Width = 81
        Height = 21
        TabOrder = 6
        Text = '3'
      end
      object cbOpenReverseOrder: TCheckBox
        Left = 128
        Top = 129
        Width = 177
        Height = 17
        Caption = #1054#1090#1082#1088#1099#1074#1072#1090#1100' '#1087#1088#1086#1090#1080#1074#1086#1087#1086#1083#1086#1078#1085#1099#1081
        TabOrder = 7
      end
      object TrailFirstStep: TEdit
        Left = 281
        Top = 78
        Width = 81
        Height = 21
        TabOrder = 8
        Text = '0'
      end
    end
    object TabSheet16: TTabSheet
      Caption = #1047#1072#1076#1072#1085#1080#1077'2'
      ImageIndex = 1
      object Label42: TLabel
        Left = 3
        Top = 3
        Width = 210
        Height = 13
        Caption = #1057#1086#1086#1073#1097#1080#1090#1100', '#1082#1086#1075#1076#1072' '#1082#1091#1088#1089' '#1076#1086#1089#1090#1080#1075#1085#1077#1090' '#1091#1088#1086#1074#1085#1103
      end
      object Label43: TLabel
        Left = 3
        Top = 22
        Width = 39
        Height = 13
        Caption = #1087#1086' '#1087#1072#1088#1077
      end
      object EditCourseLvl: TEdit
        Left = 219
        Top = 0
        Width = 105
        Height = 21
        TabOrder = 0
        Text = '0'
      end
      object cbCoursePair: TComboBox
        Left = 48
        Top = 22
        Width = 89
        Height = 21
        CharCase = ecLowerCase
        TabOrder = 1
        Text = 'btc_rur'
        OnChange = cbOpenPairChange
        Items.Strings = (
          'btc_usd'
          'btc_rur'
          'ltc_btc'
          'ltc_usd'
          'ltc_rur'
          'nmc_btc'
          'nmc_usd'
          'nvc_btc'
          'nvc_usd'
          'trc_btc'
          'ppc_btc'
          'xpm_btc')
      end
      object btnAddSignalCourse: TButton
        Left = 224
        Top = 27
        Width = 97
        Height = 25
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100
        TabOrder = 2
        OnClick = btnAddSignalCourseClick
      end
    end
    object TabSheet20: TTabSheet
      Caption = 'Strateg1'
      ImageIndex = 2
      object Label53: TLabel
        Left = 21
        Top = 197
        Width = 81
        Height = 13
        Caption = #1096#1072#1075' '#1087#1077#1088#1074#1080#1095#1085#1086#1075#1086
      end
      object Label54: TLabel
        Left = 3
        Top = 170
        Width = 99
        Height = 13
        Caption = #1054#1090#1089#1090#1091#1087' '#1087#1077#1088#1074#1080#1095#1085#1086#1075#1086
      end
      object Label55: TLabel
        Left = 3
        Top = 220
        Width = 99
        Height = 13
        Caption = #1054#1090#1089#1090#1091#1087' '#1074#1090#1086#1088#1080#1095#1085#1086#1075#1086
      end
      object Label56: TLabel
        Left = 21
        Top = 247
        Width = 81
        Height = 13
        Caption = #1096#1072#1075' '#1074#1090#1086#1088#1080#1095#1085#1086#1075#1086
      end
      object sgStrateg1: TStringGrid
        Left = 0
        Top = 16
        Width = 362
        Height = 121
        ColCount = 8
        DefaultColWidth = 30
        DefaultRowHeight = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
        TabOrder = 0
        ColWidths = (
          30
          48
          41
          45
          43
          47
          37
          54)
      end
      object Button7: TButton
        Left = 287
        Top = 143
        Width = 75
        Height = 25
        Caption = #1059#1076#1072#1083#1080#1090#1100
        TabOrder = 1
        OnClick = Button7Click
      end
      object Strateg1Type: TEdit
        Left = 146
        Top = 143
        Width = 65
        Height = 21
        TabOrder = 2
        Text = '0'
      end
      object cbStrateg1: TCheckBox
        Left = 3
        Top = 143
        Width = 137
        Height = 17
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1090#1088#1072#1090#1077#1075#1080#1102' 1'
        TabOrder = 3
        OnClick = cbStrateg1Click
      end
      object Str1Delta: TEdit
        Left = 108
        Top = 166
        Width = 106
        Height = 21
        TabOrder = 4
        Text = '0'
      end
      object Str1Step: TEdit
        Left = 108
        Top = 193
        Width = 81
        Height = 21
        TabOrder = 5
        Text = '0'
      end
      object Str2Delta: TEdit
        Left = 108
        Top = 216
        Width = 106
        Height = 21
        TabOrder = 6
        Text = '0'
      end
      object Str2Step: TEdit
        Left = 108
        Top = 243
        Width = 81
        Height = 21
        TabOrder = 7
        Text = '0'
      end
    end
  end
  object Button5: TButton
    Left = 776
    Top = 85
    Width = 100
    Height = 17
    Caption = #1054#1090#1082#1088#1099#1090#1100' '#1089#1074#1077#1088#1093#1091
    TabOrder = 8
    OnClick = Button5Click
  end
  object ListBox1: TListBox
    Left = 1
    Top = 663
    Width = 793
    Height = 105
    ItemHeight = 13
    TabOrder = 9
  end
  object Button6: TButton
    Left = 808
    Top = 736
    Width = 73
    Height = 17
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100
    TabOrder = 10
    OnClick = Button6Click
  end
  object server: TIdTCPServer
    Active = True
    Bindings = <>
    DefaultPort = 3737
    OnExecute = serverExecute
    Left = 336
    Top = 360
  end
  object UpdateTimer: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = UpdateTimerTimer
    Left = 24
    Top = 256
  end
  object StartThr: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = StartThrTimer
    Left = 288
    Top = 288
  end
  object tPlaySignal: TTimer
    Enabled = False
    Interval = 10
    OnTimer = tPlaySignalTimer
    Left = 112
    Top = 256
  end
  object FlashTimer: TTimer
    Enabled = False
    OnTimer = FlashTimerTimer
    Left = 397
    Top = 237
  end
end
