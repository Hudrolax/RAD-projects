object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'BTC-E Trade BOT'
  ClientHeight = 739
  ClientWidth = 905
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
  object Memo1: TMemo
    Left = 0
    Top = 664
    Width = 801
    Height = 73
    TabOrder = 0
  end
  object PageControl1: TPageControl
    Left = 1
    Top = 27
    Width = 529
    Height = 439
    ActivePage = TabSheet15
    MultiLine = True
    TabOrder = 1
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
      ExplicitTop = 24
      ExplicitHeight = 411
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
        Height = 399
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
        Height = 399
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 1
        OnClick = sgBTCUSDbuyClick
        OnDrawCell = sgBTCUSDbuyDrawCell
        ColWidths = (
          64
          71
          97)
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'BTC/RUR'
      ImageIndex = 1
      OnShow = TabSheet2Show
      ExplicitTop = 24
      ExplicitHeight = 411
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
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        OnClick = sgBTCRURsellClick
        OnDrawCell = sgBTCRURsellDrawCell
        ColWidths = (
          64
          71
          97)
      end
      object sgBTCRURbuy: TStringGrid
        Left = 263
        Top = 12
        Width = 257
        Height = 399
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 1
        OnClick = sgBTCRURbuyClick
        OnDrawCell = sgBTCRURbuyDrawCell
        ColWidths = (
          64
          71
          97)
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'LTC/BTC'
      ImageIndex = 2
      OnShow = TabSheet3Show
      ExplicitTop = 24
      ExplicitHeight = 411
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
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        OnClick = sgLTCBTCSellClick
        OnDrawCell = sgLTCBTCSellDrawCell
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
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 1
        OnClick = sgLTCBTCBuyClick
        OnDrawCell = sgLTCBTCBuyDrawCell
        ColWidths = (
          64
          71
          97)
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'LTC/USD'
      ImageIndex = 3
      OnShow = TabSheet4Show
      ExplicitTop = 24
      ExplicitHeight = 411
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
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        OnClick = sgLTCUSDSellClick
        OnDrawCell = sgLTCUSDSellDrawCell
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
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 1
        OnClick = sgLTCUSDBuyClick
        OnDrawCell = sgLTCUSDBuyDrawCell
        ColWidths = (
          64
          71
          97)
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'LTC/RUR'
      ImageIndex = 4
      OnShow = TabSheet5Show
      ExplicitTop = 24
      ExplicitHeight = 411
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
        Left = 0
        Top = 16
        Width = 257
        Height = 399
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        OnClick = sgLTCRURSellClick
        OnDrawCell = sgLTCRURSellDrawCell
        ColWidths = (
          64
          71
          97)
      end
      object sgLTCRURBuy: TStringGrid
        Left = 263
        Top = 16
        Width = 257
        Height = 399
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 1
        OnClick = sgLTCRURBuyClick
        OnDrawCell = sgLTCRURBuyDrawCell
        ColWidths = (
          64
          71
          97)
      end
    end
    object TabSheet9: TTabSheet
      Caption = 'NMC/BTC'
      ImageIndex = 5
      ExplicitTop = 24
      ExplicitHeight = 411
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
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        OnClick = sgNMCBTCSellClick
        OnDrawCell = sgNMCBTCSellDrawCell
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
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 1
        OnClick = sgNMCBTCBuyClick
        OnDrawCell = sgNMCBTCBuyDrawCell
        ColWidths = (
          64
          71
          97)
      end
    end
    object TabSheet10: TTabSheet
      Caption = 'NMC/USD'
      ImageIndex = 6
      ExplicitTop = 24
      ExplicitHeight = 411
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
        Height = 399
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        OnClick = sgNMCUSDSellClick
        OnDrawCell = sgNMCUSDSellDrawCell
        ColWidths = (
          64
          71
          97)
      end
      object sgNMCUSDBuy: TStringGrid
        Left = 263
        Top = 16
        Width = 257
        Height = 399
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 1
        OnClick = sgNMCUSDBuyClick
        OnDrawCell = sgNMCUSDBuyDrawCell
        ColWidths = (
          64
          71
          97)
      end
    end
    object TabSheet11: TTabSheet
      Caption = 'NVC/BTC'
      ImageIndex = 7
      ExplicitTop = 24
      ExplicitHeight = 411
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
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        OnClick = sgNVCBTCSellClick
        OnDrawCell = sgNVCBTCSellDrawCell
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
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 1
        OnClick = sgNVCBTCBuyClick
        OnDrawCell = sgNVCBTCBuyDrawCell
        ColWidths = (
          64
          71
          97)
      end
    end
    object TabSheet12: TTabSheet
      Caption = 'NVC/USD'
      ImageIndex = 8
      ExplicitTop = 24
      ExplicitHeight = 411
      object Label34: TLabel
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
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        OnClick = sgNVCUSDSellClick
        OnDrawCell = sgNVCUSDSellDrawCell
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
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 1
        OnClick = sgNVCUSDBuyClick
        OnDrawCell = sgNVCUSDBuyDrawCell
        ColWidths = (
          64
          71
          97)
      end
    end
    object TabSheet13: TTabSheet
      Caption = 'TRC/BTC'
      ImageIndex = 9
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
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        OnClick = sgTRCBTCSellClick
        OnDrawCell = sgTRCBTCSellDrawCell
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
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 1
        OnClick = sgTRCBTCBuyClick
        OnDrawCell = sgTRCBTCBuyDrawCell
        ColWidths = (
          64
          71
          97)
      end
    end
    object TabSheet14: TTabSheet
      Caption = 'PPC/BTC'
      ImageIndex = 10
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
        Height = 14
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
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        OnClick = sgPPCBTCSellClick
        OnDrawCell = sgPPCBTCSellDrawCell
        ColWidths = (
          64
          71
          97)
      end
      object sgPPCBTCBuy: TStringGrid
        Left = 263
        Top = 18
        Width = 257
        Height = 399
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 1
        OnClick = sgPPCBTCBuyClick
        OnDrawCell = sgPPCBTCBuyDrawCell
        ColWidths = (
          64
          71
          97)
      end
    end
    object TabSheet15: TTabSheet
      Caption = 'XPM/BTC'
      ImageIndex = 11
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
        ColCount = 3
        DefaultColWidth = 50
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        OnClick = sgXPMBTCSellClick
        OnDrawCell = sgXPMBTCSellDrawCell
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
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 1
        OnClick = sgXPMBTCBuyClick
        OnDrawCell = sgXPMBTCBuyDrawCell
        ColWidths = (
          64
          71
          97)
      end
    end
  end
  object PageControl2: TPageControl
    Left = 4
    Top = 468
    Width = 797
    Height = 190
    ActivePage = TabSheet6
    TabOrder = 2
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
        Left = 688
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
        Left = -4
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
  end
  object Button2: TButton
    Left = 756
    Top = 143
    Width = 73
    Height = 25
    Caption = #1054#1090#1082#1088#1099#1090#1100
    TabOrder = 3
    OnClick = Button2Click
  end
  object cbOpenPair: TComboBox
    Left = 573
    Top = 51
    Width = 89
    Height = 21
    CharCase = ecLowerCase
    TabOrder = 4
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
    TabOrder = 5
    Text = '0'
    OnChange = EditPriceOpenChange
  end
  object cbTypeOpen: TComboBox
    Left = 756
    Top = 51
    Width = 49
    Height = 21
    Color = clRed
    TabOrder = 6
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
    TabOrder = 7
    Text = '0'
    OnChange = EditAmountOpenChange
  end
  object PageControl3: TPageControl
    Left = 536
    Top = 174
    Width = 353
    Height = 291
    ActivePage = TabSheet8
    TabOrder = 8
    object TabSheet8: TTabSheet
      Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1100' '#1087#1086' '#1079#1072#1082#1088#1099#1090#1080#1102
    end
  end
  object client: TIdTCPClient
    ConnectTimeout = 0
    Host = '127.0.0.1'
    IPVersion = Id_IPv4
    Port = 3738
    ReadTimeout = -1
    Left = 416
    Top = 128
  end
  object server: TIdTCPServer
    Active = True
    Bindings = <>
    DefaultPort = 3737
    OnExecute = serverExecute
    Left = 296
    Top = 136
  end
  object UpdateTimer: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = UpdateTimerTimer
    Left = 24
    Top = 208
  end
  object http1: TIdHTTP
    IOHandler = IdSSLIOHandlerSocketOpenSSL1
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 456
    Top = 128
  end
  object IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 56
    Top = 128
  end
  object StartThr: TTimer
    OnTimer = StartThrTimer
    Left = 288
    Top = 208
  end
  object tPlaySignal: TTimer
    Enabled = False
    Interval = 10
    OnTimer = tPlaySignalTimer
    Left = 40
    Top = 264
  end
  object http2: TIdHTTP
    IOHandler = IdSSLIOHandlerSocketOpenSSL2
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 456
    Top = 224
  end
  object IdSSLIOHandlerSocketOpenSSL2: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 181
    Top = 133
  end
  object IdSSLIOHandlerSocketOpenSSL3: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 173
    Top = 205
  end
  object http3: TIdHTTP
    IOHandler = IdSSLIOHandlerSocketOpenSSL3
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 456
    Top = 296
  end
  object IdSSLIOHandlerSocketOpenSSL4: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 165
    Top = 277
  end
  object http4: TIdHTTP
    IOHandler = IdSSLIOHandlerSocketOpenSSL4
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 456
    Top = 344
  end
end
