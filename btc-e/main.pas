unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdContext, IdCustomTCPServer,
  IdTCPServer, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  Vcl.StdCtrls, Data.DBXJSON, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdHTTP,
  gvar, System.DateUtils, MMSystem, VCLTee.TeEngine, VCLTee.Series,
  VCLTee.TeeProcs, VCLTee.Chart, inifiles, VCLTee.TeeGDIPlus;

type
  TForm1 = class(TForm)
    server: TIdTCPServer;
    Label1: TLabel;
    Label2: TLabel;
    BTCBalanceLabel: TLabel;
    Label3: TLabel;
    LTCBalanceLabel: TLabel;
    Label5: TLabel;
    RURBalanceLabel: TLabel;
    UpdateTimer: TTimer;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    sgBTCUSDsell: TStringGrid;
    sgBTCUSDbuy: TStringGrid;
    sgBTCRURsell: TStringGrid;
    sgBTCRURbuy: TStringGrid;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    TabSheet3: TTabSheet;
    sgLTCBTCSell: TStringGrid;
    sgLTCBTCBuy: TStringGrid;
    Label9: TLabel;
    Label10: TLabel;
    TabSheet4: TTabSheet;
    Label11: TLabel;
    sgLTCUSDSell: TStringGrid;
    Label12: TLabel;
    sgLTCUSDBuy: TStringGrid;
    TabSheet5: TTabSheet;
    sgLTCRURSell: TStringGrid;
    Label13: TLabel;
    sgLTCRURBuy: TStringGrid;
    Label14: TLabel;
    PageControl2: TPageControl;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    sgActiveOrders: TStringGrid;
    Button1: TButton;
    chCancelAllOrders: TCheckBox;
    chSelectedPair: TCheckBox;
    StartThr: TTimer;
    Button2: TButton;
    tPlaySignal: TTimer;
    sgHistory: TStringGrid;
    chActiveCurrent: TCheckBox;
    chHistoryActive: TCheckBox;
    cbOpenPair: TComboBox;
    Label15: TLabel;
    EditPriceOpen: TEdit;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    cbTypeOpen: TComboBox;
    Label19: TLabel;
    EditAmountOpen: TEdit;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    PageControl3: TPageControl;
    TabSheet8: TTabSheet;
    Label24: TLabel;
    NVCBalanceLabel: TLabel;
    Label25: TLabel;
    TRCBalanceLabel: TLabel;
    Label26: TLabel;
    FTCBalanceLabel: TLabel;
    Label27: TLabel;
    USDBalanceLabel: TLabel;
    TabSheet9: TTabSheet;
    TabSheet10: TTabSheet;
    TabSheet11: TTabSheet;
    TabSheet12: TTabSheet;
    TabSheet13: TTabSheet;
    TabSheet14: TTabSheet;
    TabSheet15: TTabSheet;
    Label28: TLabel;
    sgNMCBTCSell: TStringGrid;
    Label29: TLabel;
    sgNMCBTCBuy: TStringGrid;
    Label30: TLabel;
    sgNMCUSDSell: TStringGrid;
    Label31: TLabel;
    sgNMCUSDBuy: TStringGrid;
    Label32: TLabel;
    sgNVCBTCSell: TStringGrid;
    Label33: TLabel;
    sgNVCBTCBuy: TStringGrid;
    Label34: TLabel;
    sgNVCUSDSell: TStringGrid;
    Label35: TLabel;
    sgNVCUSDBuy: TStringGrid;
    Label36: TLabel;
    sgTRCBTCSell: TStringGrid;
    Label37: TLabel;
    sgTRCBTCBuy: TStringGrid;
    Label38: TLabel;
    sgPPCBTCSell: TStringGrid;
    Label39: TLabel;
    sgPPCBTCBuy: TStringGrid;
    Label40: TLabel;
    sgXPMBTCSell: TStringGrid;
    Label41: TLabel;
    sgXPMBTCBuy: TStringGrid;
    chk1: TCheckBox;
    chk2: TCheckBox;
    edt1: TEdit;
    ts1: TTabSheet;
    sgVirtualOrders: TStringGrid;
    Button3: TButton;
    TabSheet16: TTabSheet;
    Label42: TLabel;
    EditCourseLvl: TEdit;
    Label43: TLabel;
    cbCoursePair: TComboBox;
    btnAddSignalCourse: TButton;
    TabSheet17: TTabSheet;
    sgSignalTab: TStringGrid;
    Button4: TButton;
    Button5: TButton;
    ListBox1: TListBox;
    Button6: TButton;
    TabSheet18: TTabSheet;
    sgTradeHistory: TStringGrid;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    TabSheet19: TTabSheet;
    StringGrid1: TStringGrid;
    chTrailBox: TCheckBox;
    TrailDelta: TEdit;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    TrailStep: TEdit;
    Label52: TLabel;
    edtMultiAverge: TEdit;
    FlashTimer: TTimer;
    cbOpenReverseOrder: TCheckBox;
    TabSheet20: TTabSheet;
    sgStrateg1: TStringGrid;
    Button7: TButton;
    Strateg1Type: TEdit;
    cbStrateg1: TCheckBox;
    Str1Delta: TEdit;
    Label53: TLabel;
    Str1Step: TEdit;
    Label54: TLabel;
    Label55: TLabel;
    Str2Delta: TEdit;
    Str2Step: TEdit;
    Label56: TLabel;
    Button8: TButton;
    Label57: TLabel;
    TrailFirstStep: TEdit;
    procedure serverExecute(AContext: TIdContext);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure UpdateTimerTimer(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure StartThrTimer(Sender: TObject);
    procedure PageControl1DrawTab(Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure tPlaySignalTimer(Sender: TObject);
    procedure chActiveCurrentClick(Sender: TObject);
    procedure chHistoryActiveClick(Sender: TObject);
    procedure sgBTCUSDsellDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgBTCUSDsellClick(Sender: TObject);
    procedure cbTypeOpenChange(Sender: TObject);
    procedure EditAmountOpenChange(Sender: TObject);
    procedure EditPriceOpenChange(Sender: TObject);
    procedure cbOpenPairChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure LTCBalanceLabelClick(Sender: TObject);
    procedure BTCBalanceLabelClick(Sender: TObject);
    procedure RURBalanceLabelClick(Sender: TObject);
    procedure Label24Click(Sender: TObject);
    procedure NVCBalanceLabelClick(Sender: TObject);
    procedure TRCBalanceLabelClick(Sender: TObject);
    procedure FTCBalanceLabelClick(Sender: TObject);
    procedure USDBalanceLabelClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure sgActiveOrdersClick(Sender: TObject);
    procedure btnAddSignalCourseClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure sgTradeHistoryDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure chk1Click(Sender: TObject);
    procedure chk2Click(Sender: TObject);
    procedure chTrailBoxClick(Sender: TObject);
    procedure sgVirtualOrdersDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgVirtualOrdersClick(Sender: TObject);
    procedure FlashTimerTimer(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure cbStrateg1Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TSendZapros = class(tthread)
  private
    { private declarations }
  protected
    procedure execute; override;
  end;

  TGetPrice = class(tthread)
  private
    { private declarations }
  protected
    procedure execute; override;
  end;

  T2GetPrice = class(tthread)
  private
    { private declarations }
  protected
    procedure execute; override;
  end;

  T3GetPrice = class(tthread)
  private
    { private declarations }
  protected
    procedure execute; override;
  end;

  T4GetPrice = class(tthread)
  private
    { private declarations }
  protected
    procedure execute; override;
  end;

  T5GetPrice = class(tthread)
  private
    { private declarations }
  protected
    procedure execute; override;
  end;

  T6GetPrice = class(tthread)
  private
    { private declarations }
  protected
    procedure execute; override;
  end;

  T7GetPrice = class(tthread)
  private
    { private declarations }
  protected
    procedure execute; override;
  end;

  T8GetPrice = class(tthread)
  private
    { private declarations }
  protected
    procedure execute; override;
  end;

  T9GetPrice = class(tthread)
  private
    { private declarations }
  protected
    procedure execute; override;
  end;

  T10GetPrice = class(tthread)
  private
    { private declarations }
  protected
    procedure execute; override;
  end;

  T11GetPrice = class(tthread)
  private
    { private declarations }
  protected
    procedure execute; override;
  end;

  T12GetPrice = class(tthread)
  private
    { private declarations }
  protected
    procedure execute; override;
  end;

  T1GetHistory = class(tthread)
  private
    { private declarations }
  protected
    procedure execute; override;
  end;

  T2GetHistory = class(tthread)
  private
    { private declarations }
  protected
    procedure execute; override;
  end;

var
  Form1: TForm1;
  ActivePair: string;
  TryOpenCount: Integer; // Попытки отправить ордер

  TGetPrice1: TGetPrice;
  TGetPrice2: T2GetPrice;
  TGetPrice3: T3GetPrice;
  TGetPrice4: T4GetPrice;
  TGetPrice5: T5GetPrice;
  TGetPrice6: T6GetPrice;
  TGetPrice7: T7GetPrice;
  TGetPrice8: T8GetPrice;
  TGetPrice9: T9GetPrice;
  TGetPrice10: T10GetPrice;
  TGetPrice11: T11GetPrice;
  TGetPrice12: T12GetPrice;
  TSendZapros1: TSendZapros;
  TGetHistory1: T1GetHistory;
  TGetHistory2: T2GetHistory;
  CancelOrdersList: array of string;
  StopFlag, LoadedOrders, LoadedFiles: Boolean;
  SP_BTCUSD, SP_BTCRUR, SP_LTCBTC, SP_LTCUSD, SP_LTCRUR, SP_NMCBTC, SP_NMCUSD: real;
  SP_NVCBTC, SP_NVCUSD, SP_TRCBTC, SP_PPCBTC, SP_XPMBTC: real;
  Ini: TIniFile;
  GlobalSelectedOrder: string;
  NZHistory1, NZFirstZapros: Boolean;
  GoFlash, Flash: Boolean;

implementation

procedure Log(s: string);
var
  f: TextFile;
  s1: string;
begin
  if s = '' then
    Exit;

  if Form1.ListBox1.Items.Count > 500 then
    Form1.ListBox1.Clear;
  s1 := GetDateT + ': ' + s;
  Form1.ListBox1.Items.Append(s1);
  Form1.ListBox1.TopIndex := Form1.ListBox1.Items.Count - 1;

  AssignFile(f, 'log.txt');
  if FileExists('log.txt') then
    Append(f)
  else
    Rewrite(f);
  Writeln(f, s1);
  CloseFile(f);

end;

procedure PlaySignal();
begin
  if Form1.tPlaySignal.Interval = 10 then
    Form1.tPlaySignal.Enabled := True;

  if NOT Form1.Active then
    GoFlash := True;

end;

procedure ControlSignal();
var
  i, j: Integer;
begin
  if not LoadedFiles then
    Exit;

  for i := 0 to Length(CourseSignal) - 1 do
    if NOT CourseSignal[i].deleted then
    begin
      if CourseSignal[i].pair = 'btc_usd' then
        if (CourseSignal[i].TekCourse < CourseSignal[i].level) then
        begin
          if BidsBTCUSD[0].price > CourseSignal[i].level then
          begin
            PlaySignal();
            Log(CourseSignal[i].pair + ' - Курс достиг уровня ' + FloatToStr(CourseSignal[i].level));
            SendEmail('Course_signal',CourseSignal[i].pair + ' - course level at ' + FloatToStr(CourseSignal[i].level));
            CourseSignal[i].deleted := True;
            Continue;
          end;
        end
        else
        begin
          if AsksBTCUSD[0].price < CourseSignal[i].level then
          begin
            PlaySignal();
            Log(CourseSignal[i].pair + ' - Курс достиг уровня ' + FloatToStr(CourseSignal[i].level));
            SendEmail('Course_signal',CourseSignal[i].pair + ' - course level at ' + FloatToStr(CourseSignal[i].level));
            CourseSignal[i].deleted := True;
            Continue;
          end;
        end;

      if CourseSignal[i].pair = 'btc_rur' then
        if (CourseSignal[i].TekCourse < CourseSignal[i].level) then
        begin
          if BidsBTCRUR[0].price > CourseSignal[i].level then
          begin
            PlaySignal();
            Log(CourseSignal[i].pair + ' - Курс достиг уровня ' + FloatToStr(CourseSignal[i].level));
            SendEmail('Course_signal',CourseSignal[i].pair + ' - course level at ' + FloatToStr(CourseSignal[i].level));
            CourseSignal[i].deleted := True;
            Continue;
          end;
        end
        else
        begin
          if AsksBTCRUR[0].price < CourseSignal[i].level then
          begin
            PlaySignal();
            Log(CourseSignal[i].pair + ' - Курс достиг уровня ' + FloatToStr(CourseSignal[i].level));
            SendEmail('Course_signal',CourseSignal[i].pair + ' - course level at ' + FloatToStr(CourseSignal[i].level));
            CourseSignal[i].deleted := True;
            Continue;
          end;
        end;

      if CourseSignal[i].pair = 'ltc_btc' then
        if (CourseSignal[i].TekCourse < CourseSignal[i].level) then
        begin
          if BidsLTCBTC[0].price > CourseSignal[i].level then
          begin
            PlaySignal();
            Log(CourseSignal[i].pair + ' - Курс достиг уровня ' + FloatToStr(CourseSignal[i].level));
            SendEmail('Course_signal',CourseSignal[i].pair + ' - course level at ' + FloatToStr(CourseSignal[i].level));
            CourseSignal[i].deleted := True;
            Continue;
          end;
        end
        else
        begin
          if AsksLTCBTC[0].price < CourseSignal[i].level then
          begin
            PlaySignal();
            Log(CourseSignal[i].pair + ' - Курс достиг уровня ' + FloatToStr(CourseSignal[i].level));
            SendEmail('Course_signal',CourseSignal[i].pair + ' - course level at ' + FloatToStr(CourseSignal[i].level));
            CourseSignal[i].deleted := True;
            Continue;
          end;
        end;

      if CourseSignal[i].pair = 'ltc_usd' then
        if (CourseSignal[i].TekCourse < CourseSignal[i].level) then
        begin
          if BidsLTCUSD[0].price > CourseSignal[i].level then
          begin
            PlaySignal();
            Log(CourseSignal[i].pair + ' - Курс достиг уровня ' + FloatToStr(CourseSignal[i].level));
            SendEmail('Course_signal',CourseSignal[i].pair + ' - course level at ' + FloatToStr(CourseSignal[i].level));
            CourseSignal[i].deleted := True;
            Continue;
          end;
        end
        else
        begin
          if AsksLTCUSD[0].price < CourseSignal[i].level then
          begin
            PlaySignal();
            Log(CourseSignal[i].pair + ' - Курс достиг уровня ' + FloatToStr(CourseSignal[i].level));
            SendEmail('Course_signal',CourseSignal[i].pair + ' - course level at ' + FloatToStr(CourseSignal[i].level));
            CourseSignal[i].deleted := True;
            Continue;
          end;
        end;

      if CourseSignal[i].pair = 'ltc_rur' then
        if (CourseSignal[i].TekCourse < CourseSignal[i].level) then
        begin
          if BidsLTCRUR[0].price > CourseSignal[i].level then
          begin
            PlaySignal();
            Log(CourseSignal[i].pair + ' - Курс достиг уровня ' + FloatToStr(CourseSignal[i].level));
            SendEmail('Course_signal',CourseSignal[i].pair + ' - course level at ' + FloatToStr(CourseSignal[i].level));
            CourseSignal[i].deleted := True;
            Continue;
          end;
        end
        else
        begin
          if AsksLTCRUR[0].price < CourseSignal[i].level then
          begin
            PlaySignal();
            Log(CourseSignal[i].pair + ' - Курс достиг уровня ' + FloatToStr(CourseSignal[i].level));
            SendEmail('Course_signal',CourseSignal[i].pair + ' - course level at ' + FloatToStr(CourseSignal[i].level));
            CourseSignal[i].deleted := True;
            Continue;
          end;
        end;

      if CourseSignal[i].pair = 'nmc_btc' then
        if (CourseSignal[i].TekCourse < CourseSignal[i].level) then
        begin
          if BidsNMCBTC[0].price > CourseSignal[i].level then
          begin
            PlaySignal();
            Log(CourseSignal[i].pair + ' - Курс достиг уровня ' + FloatToStr(CourseSignal[i].level));
            SendEmail('Course_signal',CourseSignal[i].pair + ' - course level at ' + FloatToStr(CourseSignal[i].level));
            CourseSignal[i].deleted := True;
            Continue;
          end;
        end
        else
        begin
          if AsksNMCBTC[0].price < CourseSignal[i].level then
          begin
            PlaySignal();
            Log(CourseSignal[i].pair + ' - Курс достиг уровня ' + FloatToStr(CourseSignal[i].level));
            SendEmail('Course_signal',CourseSignal[i].pair + ' - course level at ' + FloatToStr(CourseSignal[i].level));
            CourseSignal[i].deleted := True;
            Continue;
          end;
        end;

      if CourseSignal[i].pair = 'nmc_usd' then
        if (CourseSignal[i].TekCourse < CourseSignal[i].level) then
        begin
          if BidsNMCUSD[0].price > CourseSignal[i].level then
          begin
            PlaySignal();
            Log(CourseSignal[i].pair + ' - Курс достиг уровня ' + FloatToStr(CourseSignal[i].level));
            SendEmail('Course_signal',CourseSignal[i].pair + ' - course level at ' + FloatToStr(CourseSignal[i].level));
            CourseSignal[i].deleted := True;
            Continue;
          end;
        end
        else
        begin
          if AsksNMCUSD[0].price < CourseSignal[i].level then
          begin
            PlaySignal();
            Log(CourseSignal[i].pair + ' - Курс достиг уровня ' + FloatToStr(CourseSignal[i].level));
            SendEmail('Course_signal',CourseSignal[i].pair + ' - course level at ' + FloatToStr(CourseSignal[i].level));
            CourseSignal[i].deleted := True;
            Continue;
          end;
        end;

      if CourseSignal[i].pair = 'nvc_btc' then
        if (CourseSignal[i].TekCourse < CourseSignal[i].level) then
        begin
          if BidsNVCBTC[0].price > CourseSignal[i].level then
          begin
            PlaySignal();
            Log(CourseSignal[i].pair + ' - Курс достиг уровня ' + FloatToStr(CourseSignal[i].level));
            SendEmail('Course_signal',CourseSignal[i].pair + ' - course level at ' + FloatToStr(CourseSignal[i].level));
            CourseSignal[i].deleted := True;
            Continue;
          end;
        end
        else
        begin
          if AsksNVCBTC[0].price < CourseSignal[i].level then
          begin
            PlaySignal();
            Log(CourseSignal[i].pair + ' - Курс достиг уровня ' + FloatToStr(CourseSignal[i].level));
            SendEmail('Course_signal',CourseSignal[i].pair + ' - course level at ' + FloatToStr(CourseSignal[i].level));
            CourseSignal[i].deleted := True;
            Continue;
          end;
        end;

      if CourseSignal[i].pair = 'nvc_usd' then
        if (CourseSignal[i].TekCourse < CourseSignal[i].level) then
        begin
          if BidsNVCUSD[0].price > CourseSignal[i].level then
          begin
            PlaySignal();
            Log(CourseSignal[i].pair + ' - Курс достиг уровня ' + FloatToStr(CourseSignal[i].level));
            SendEmail('Course_signal',CourseSignal[i].pair + ' - course level at ' + FloatToStr(CourseSignal[i].level));
            CourseSignal[i].deleted := True;
            Continue;
          end;
        end
        else
        begin
          if AsksNVCUSD[0].price < CourseSignal[i].level then
          begin
            PlaySignal();
            Log(CourseSignal[i].pair + ' - Курс достиг уровня ' + FloatToStr(CourseSignal[i].level));
            SendEmail('Course_signal',CourseSignal[i].pair + ' - course level at ' + FloatToStr(CourseSignal[i].level));
            CourseSignal[i].deleted := True;
            Continue;
          end;
        end;

      if CourseSignal[i].pair = 'trc_btc' then
        if (CourseSignal[i].TekCourse < CourseSignal[i].level) then
        begin
          if BidsTRCBTC[0].price > CourseSignal[i].level then
          begin
            PlaySignal();
            Log(CourseSignal[i].pair + ' - Курс достиг уровня ' + FloatToStr(CourseSignal[i].level));
            SendEmail('Course_signal',CourseSignal[i].pair + ' - course level at ' + FloatToStr(CourseSignal[i].level));
            CourseSignal[i].deleted := True;
            Continue;
          end;
        end
        else
        begin
          if AsksTRCBTC[0].price < CourseSignal[i].level then
          begin
            PlaySignal();
            Log(CourseSignal[i].pair + ' - Курс достиг уровня ' + FloatToStr(CourseSignal[i].level));
            SendEmail('Course_signal',CourseSignal[i].pair + ' - course level at ' + FloatToStr(CourseSignal[i].level));
            CourseSignal[i].deleted := True;
            Continue;
          end;
        end;

      if CourseSignal[i].pair = 'ppc_btc' then
        if (CourseSignal[i].TekCourse < CourseSignal[i].level) then
        begin
          if BidsPPCBTC[0].price > CourseSignal[i].level then
          begin
            PlaySignal();
            Log(CourseSignal[i].pair + ' - Курс достиг уровня ' + FloatToStr(CourseSignal[i].level));
            SendEmail('Course_signal',CourseSignal[i].pair + ' - course level at ' + FloatToStr(CourseSignal[i].level));
            CourseSignal[i].deleted := True;
            Continue;
          end;
        end
        else
        begin
          if AsksPPCBTC[0].price < CourseSignal[i].level then
          begin
            PlaySignal();
            Log(CourseSignal[i].pair + ' - Курс достиг уровня ' + FloatToStr(CourseSignal[i].level));
            SendEmail('Course_signal',CourseSignal[i].pair + ' - course level at ' + FloatToStr(CourseSignal[i].level));
            CourseSignal[i].deleted := True;
            Continue;
          end;
        end;

      if CourseSignal[i].pair = 'xpm_btc' then
        if (CourseSignal[i].TekCourse < CourseSignal[i].level) then
        begin
          if BidsXPMBTC[0].price > CourseSignal[i].level then
          begin
            PlaySignal();
            Log(CourseSignal[i].pair + ' - Курс достиг уровня ' + FloatToStr(CourseSignal[i].level));
            SendEmail('Course_signal',CourseSignal[i].pair + ' - course level at ' + FloatToStr(CourseSignal[i].level));
            CourseSignal[i].deleted := True;
            Continue;
          end;
        end
        else
        begin
          if AsksXPMBTC[0].price < CourseSignal[i].level then
          begin
            PlaySignal();
            Log(CourseSignal[i].pair + ' - Курс достиг уровня ' + FloatToStr(CourseSignal[i].level));
            SendEmail('Course_signal',CourseSignal[i].pair + ' - course level at ' + FloatToStr(CourseSignal[i].level));
            CourseSignal[i].deleted := True;
            Continue;
          end;
        end;
    end;

  // Очищаем массив, если все помечены на удаление
  j := 0;
  for i := 0 to Length(CourseSignal) - 1 do
    if CourseSignal[i].deleted then
      j := j + 1;
  if Length(CourseSignal) = j then
    SetLength(CourseSignal, 0);
end;

procedure UpdateSumm();
begin
  if IsDigit(Form1.EditPriceOpen.Text) and IsDigit(Form1.EditAmountOpen.Text) then
  begin
    Form1.Label21.caption := FloatToStr(strtofloat(To4kToZap(Form1.EditPriceOpen.Text)) * strtofloat(To4kToZap(Form1.EditAmountOpen.Text)) * 0.998) +
      ' ' + Form1.Label17.caption;

    Form1.Label23.caption := FloatToStr(strtofloat(To4kToZap(Form1.EditPriceOpen.Text)) * strtofloat(To4kToZap(Form1.EditAmountOpen.Text)) * 0.002) +
      ' ' + Form1.Label17.caption;
  end;
end;

procedure CustomWork();
var
  price: real;
  i, k: Integer;
  ColorBar: TColor;
begin
  // k := 1;
  // SetLength(Candle60, 1);
  // for i := Length(GlobalLTCRUR) - 1 downto 0 do
  // if GlobalLTCRUR[i].timestamp >= GlobalLTCRUR[Length(GlobalLTCRUR) - 1].timestamp - 660 then
  // begin
  // if GlobalLTCRUR[i].timestamp > GlobalLTCRUR[Length(GlobalLTCRUR) - 1].timestamp - 600 + k * 60 then
  // begin
  // k := k + 1;
  // SetLength(Candle60, Length(Candle60) + 1);
  // end;
  //
  // Candle60[k - 1].period := 60;
  // Candle60[k - 1].OpenTime := GlobalLTCRUR[Length(GlobalLTCRUR) - 1].timestamp - 660 + 60 * k;
  // if GlobalLTCRUR[i].price > Candle60[k - 1].max then
  // Candle60[k - 1].max := GlobalLTCRUR[i].price;
  // if Candle60[k - 1].min = 0 then
  // Candle60[k - 1].min := GlobalLTCRUR[i].price;
  // if GlobalLTCRUR[i].price < Candle60[k - 1].min then
  // Candle60[k - 1].min := GlobalLTCRUR[i].price;
  // if GlobalLTCRUR[i].typeOrder = 'ask' then
  // Candle60[k - 1].volume_sell := Candle60[k - 1].volume_sell + GlobalLTCRUR[i].amount;
  // if GlobalLTCRUR[i].typeOrder = 'bid' then
  // Candle60[k - 1].volume_buy := Candle60[k - 1].volume_buy + GlobalLTCRUR[i].amount;
  // end;
  //
  // with Form1 do
  // begin
  // Chart1.Series[0].Clear;
  // StringGrid1.RowCount := Length(Candle60) + 1;
  // for i := 0 to Length(Candle60) - 1 do
  // begin
  // StringGrid1.Cells[0, i + 1] := IntToStr(i + 1);
  // StringGrid1.Cells[1, i + 1] := DateTimeToStr(UnixToDateTime(Candle60[i].OpenTime));
  // StringGrid1.Cells[2, i + 1] := FloatToStr(Candle60[i].max);
  // StringGrid1.Cells[3, i + 1] := FloatToStr(Candle60[i].min);
  // StringGrid1.Cells[4, i + 1] := FloatToStr(Candle60[i].volume_buy);
  // StringGrid1.Cells[5, i + 1] := FloatToStr(Candle60[i].volume_sell);
  //
  // if Candle60[i].volume_buy - Candle60[i].volume_sell > 0 then
  // ColorBar := clGreen
  // else
  // ColorBar := clRed;
  //
  // Chart1.Series[0].AddXY(-600 + 60 * i, Candle60[i].volume_buy - Candle60[i].volume_sell, '', ColorBar);
  // end;
  // end;
end;

procedure ControlStrateg1();
var
  i, j, Step1Count: Integer;
  alldeleted, Find2stepOrder: Boolean;
  LengthVO: Integer;
  NewRate, TopPriceL: real;
begin
  alldeleted := True;
  for i := 0 to Length(Strateg1) - 1 do
    if NOT Strateg1[i].deleted then
    begin
      Find2stepOrder := False;
      // найдем вторичный ордер
      for j := 0 to Length(VirtualOrders) - 1 do
        if (not VirtualOrders[j].deleted) and (VirtualOrders[j].pair = Strateg1[i].pair) and (VirtualOrders[j].comment = 'Strateg1('+IntToStr(i)+')') and
          (NOT VirtualOrders[j].MakeReverseOrder) then
          Find2stepOrder := True;
      // Нашли вторичный ордер по стратегии, значит первичные надо удалить

      if Find2stepOrder then // Нашли вторичный ордер
      begin
        for j := 0 to Length(VirtualOrders) - 1 do
          if (not VirtualOrders[j].deleted) and (VirtualOrders[j].pair = Strateg1[i].pair) and (VirtualOrders[j].comment = 'Strateg1('+IntToStr(i)+')') and
            (VirtualOrders[j].MakeReverseOrder) then
          begin
            VirtualOrders[j].deleted := True;
            // Удалим первичные ордера, если найден вторичный
            Log('Сработал вторичный ордер Strateg1 ' + Strateg1[i].pair + ', удаляю первичные.');
          end
      end
      else
      begin
        Step1Count := 0;
        for j := 0 to Length(VirtualOrders) - 1 do
          if (not VirtualOrders[j].deleted) and (VirtualOrders[j].pair = Strateg1[i].pair) and
            (VirtualOrders[j].MakeReverseOrder) and (VirtualOrders[j].comment = 'Strateg1('+IntToStr(i)+')') then
            Step1Count := Step1Count + 1;

        if Step1Count = 0 then // Создадим первичные ордера
        begin
          LengthVO := Length(VirtualOrders);
          SetLength(VirtualOrders, LengthVO + 1);
          if Strateg1[i].SType = 0 then
          begin
            TopPriceL := TopPrice(Strateg1[i].pair, 'sell');
            VirtualOrders[LengthVO].OType := 'buy';
            VirtualOrders[LengthVO].rate := TopPriceL - Strateg1[i].delta1F1;
            VirtualOrders[LengthVO].min_rate := TopPriceL - Strateg1[i].delta1F1;
          end
          else if Strateg1[i].SType = 1 then
          begin
            TopPriceL := TopPrice(Strateg1[i].pair, 'buy');
            VirtualOrders[LengthVO].OType := 'sell';
            VirtualOrders[LengthVO].rate := TopPriceL + Strateg1[i].delta1F1;
            VirtualOrders[LengthVO].min_rate := TopPriceL + Strateg1[i].delta1F1;
          end;

          VirtualOrders[LengthVO].area := 'trail_order';
          VirtualOrders[LengthVO].pair := Strateg1[i].pair;
          VirtualOrders[LengthVO].amount := Strateg1[i].lot;
          VirtualOrders[LengthVO].step := Strateg1[i].step1F2; // Шаг первичного во второй фазе
          VirtualOrders[LengthVO].stepF1 := Strateg1[i].step1F1; // Шаг первичного в первой фазе
          VirtualOrders[LengthVO].step2 := Strateg1[i].step2; // Шаг вторичного
          VirtualOrders[LengthVO].MultiAverge := Strateg1[i].multi;
          VirtualOrders[LengthVO].delta := Strateg1[i].delta1F2; // Дельта первичного фаза 2
          VirtualOrders[LengthVO].deltaF1 := Strateg1[i].delta1F1; // Дельта первичного фаза 1
          VirtualOrders[LengthVO].delta2 := Strateg1[i].delta2; // дельта вторичного
          VirtualOrders[LengthVO].first_step := Strateg1[i].first_step; // дельта вторичного
          VirtualOrders[LengthVO].MakeReverseOrder := True;
          VirtualOrders[LengthVO].comment := 'Strateg1('+IntToStr(i)+')';

          Log('Создал первичный ордер Strateg1 ' + Strateg1[i].pair);
        end
        else if Step1Count = 1 then // Есть ордер первой стадии, протрейлим
          for j := 0 to Length(VirtualOrders) - 1 do
            if (not VirtualOrders[j].deleted) and (VirtualOrders[j].pair = Strateg1[i].pair) and (VirtualOrders[j].comment = 'Strateg1('+IntToStr(i)+')') and
              (VirtualOrders[j].MakeReverseOrder) then
              if VirtualOrders[j].OType = 'buy' then
              begin
                TopPriceL := TopPrice(Strateg1[i].pair, 'sell');

                NewRate := VirtualOrders[j].rate + VirtualOrders[j].stepF1;
                if (NewRate <= TopPriceL - VirtualOrders[j].deltaF1) then
                // Можно трейлить
                begin
                  Log('Передвинул Stage1 Ордер Sell c ' + FloatToStr(VirtualOrders[j].rate) + ' на ' + FloatToStr(NewRate));
                  VirtualOrders[j].rate := NewRate;
                  VirtualOrders[j].min_rate := NewRate;
                end
              end
              else if VirtualOrders[j].OType = 'sell' then
              begin
                TopPriceL := TopPrice(Strateg1[i].pair, 'buy');

                NewRate := VirtualOrders[j].rate - VirtualOrders[j].stepF1;
                if (NewRate >= TopPriceL + VirtualOrders[j].deltaF1) then
                // Можно трейлить
                begin
                  Log('Передвинул Stage1 Ордер Sell c ' + FloatToStr(VirtualOrders[j].rate) + ' на ' + FloatToStr(NewRate));
                  VirtualOrders[j].rate := NewRate;
                  VirtualOrders[j].min_rate := NewRate;
                end;
              end;
      end;

      alldeleted := False;
    end;

  if alldeleted then
    SetLength(Strateg1, 0);

  SaveVirtualOrders();
end;

procedure ControlSkupka();
var
  i: Integer;
begin
  // Пока еще не сделал
end;

procedure CancelOrder(order_id: string);
begin
  SetLength(CancelOrdersList, Length(CancelOrdersList) + 1);
  CancelOrdersList[Length(CancelOrdersList) - 1] := order_id;
end;

procedure ControlVirtualOrder();
var
  i, j, k: Integer;
  Ltopprice: real;
  VNewRate, VAmount, ComplateRate, AvergeAmount: real;
  ResultTrail: string;
  logmessage:string;
begin
  if (not LoadedFiles) or (Length(VirtualOrders) = 0) then
    Exit;

  // while not MojnoBrat do
  // sleep(10);

  for i := 0 to Length(VirtualOrders) - 1 do
  begin
    // Выставляем отложенные ордера по привязкам
    if (not VirtualOrders[i].deleted) and (VirtualOrders[i].area = 'after_order') then
      for j := 0 to Length(OrderHistory) - 1 do
        if VirtualOrders[i].AfterOrderID = OrderHistory[j].order_id then
        begin
          Log('Пробую выставить отложенный ордер.');
          logmessage := SendOrder(VirtualOrders[i].pair, VirtualOrders[i].OType, VirtualOrders[i].rate, VirtualOrders[i].amount, True);
          Log(logmessage);
          VirtualOrders[i].deleted := True;
          SendEmail('After Order',logmessage);
          PlaySignal;
        end;
    // *************** TreilingStop перестановка и исполнение ордеров*****************
    if (not VirtualOrders[i].deleted) and (VirtualOrders[i].area = 'trail_order') then
    begin
      ResultTrail := '';
      if VirtualOrders[i].OType = 'sell' then
      begin
        if VirtualOrders[i].pair = 'ltc_rur' then
          ResultTrail := TrailOrder(VirtualOrders[i], BidsLTCRUR, GlobalLTCRUR)
        else if VirtualOrders[i].pair = 'btc_rur' then
          ResultTrail := TrailOrder(VirtualOrders[i], BidsBTCRUR, GlobalBTCRUR)
        else if VirtualOrders[i].pair = 'btc_usd' then
          ResultTrail := TrailOrder(VirtualOrders[i], BidsBTCUSD, GlobalBTCUSD)
        else if VirtualOrders[i].pair = 'ltc_btc' then
          ResultTrail := TrailOrder(VirtualOrders[i], BidsLTCBTC, GlobalLTCBTC)
        else if VirtualOrders[i].pair = 'ltc_usd' then
          ResultTrail := TrailOrder(VirtualOrders[i], BidsLTCUSD, GlobalLTCUSD)
        else if VirtualOrders[i].pair = 'nmc_btc' then
          ResultTrail := TrailOrder(VirtualOrders[i], BidsNMCBTC, GlobalNMCBTC)
        else if VirtualOrders[i].pair = 'nmc_usd' then
          ResultTrail := TrailOrder(VirtualOrders[i], BidsNMCUSD, GlobalNMCUSD)
        else if VirtualOrders[i].pair = 'nvc_btc' then
          ResultTrail := TrailOrder(VirtualOrders[i], BidsNVCBTC, GlobalNVCBTC)
        else if VirtualOrders[i].pair = 'nvc_usd' then
          ResultTrail := TrailOrder(VirtualOrders[i], BidsNVCUSD, GlobalNVCUSD)
        else if VirtualOrders[i].pair = 'trc_btc' then
          ResultTrail := TrailOrder(VirtualOrders[i], BidsTRCBTC, GlobalTRCBTC)
        else if VirtualOrders[i].pair = 'ppc_btc' then
          ResultTrail := TrailOrder(VirtualOrders[i], BidsPPCBTC, GlobalPPCBTC)
        else if VirtualOrders[i].pair = 'xpm_btc' then
          ResultTrail := TrailOrder(VirtualOrders[i], BidsXPMBTC, GlobalXPMBTC);

      end
      else if VirtualOrders[i].OType = 'buy' then
      begin
        if VirtualOrders[i].pair = 'ltc_rur' then
          ResultTrail := TrailOrder(VirtualOrders[i], AsksLTCRUR, GlobalLTCRUR)
        else if VirtualOrders[i].pair = 'btc_rur' then
          ResultTrail := TrailOrder(VirtualOrders[i], AsksBTCRUR, GlobalBTCRUR)
        else if VirtualOrders[i].pair = 'btc_usd' then
          ResultTrail := TrailOrder(VirtualOrders[i], AsksBTCUSD, GlobalBTCUSD)
        else if VirtualOrders[i].pair = 'ltc_btc' then
          ResultTrail := TrailOrder(VirtualOrders[i], AsksLTCBTC, GlobalLTCBTC)
        else if VirtualOrders[i].pair = 'ltc_usd' then
          ResultTrail := TrailOrder(VirtualOrders[i], AsksLTCUSD, GlobalLTCUSD)
        else if VirtualOrders[i].pair = 'nmc_btc' then
          ResultTrail := TrailOrder(VirtualOrders[i], AsksNMCBTC, GlobalNMCBTC)
        else if VirtualOrders[i].pair = 'nmc_usd' then
          ResultTrail := TrailOrder(VirtualOrders[i], AsksNMCUSD, GlobalNMCUSD)
        else if VirtualOrders[i].pair = 'nvc_btc' then
          ResultTrail := TrailOrder(VirtualOrders[i], AsksNVCBTC, GlobalNVCBTC)
        else if VirtualOrders[i].pair = 'nvc_usd' then
          ResultTrail := TrailOrder(VirtualOrders[i], AsksNVCUSD, GlobalNVCUSD)
        else if VirtualOrders[i].pair = 'trc_btc' then
          ResultTrail := TrailOrder(VirtualOrders[i], AsksTRCBTC, GlobalTRCBTC)
        else if VirtualOrders[i].pair = 'ppc_btc' then
          ResultTrail := TrailOrder(VirtualOrders[i], AsksPPCBTC, GlobalPPCBTC)
        else if VirtualOrders[i].pair = 'xpm_btc' then
          ResultTrail := TrailOrder(VirtualOrders[i], AsksXPMBTC, GlobalXPMBTC);
      end;
      Log(ResultTrail);
      if AnsiPos('Исполнен ордер по Trailing Stop', ResultTrail) > 0 then
        begin
          SendEmail('Trailing Order','Trailing Stop order executed: '+ResultTrail);
          PlaySignal;
        end;

    end;
    // *******************************************************************************

    // Перевыставляем ордер по верхней цене в стакане
    if (not VirtualOrders[i].deleted) and (VirtualOrders[i].area = 'top_price') and (VirtualOrders[i].order_id <> '') and
      (AnsiPos('wait', VirtualOrders[i].order_id) <= 0) then
    begin
      // Удаляем ордер, если цена не максимальная
      for j := 0 to Length(ActiveOrders) - 1 do
        if ActiveOrders[j].order_id = VirtualOrders[i].order_id then
        begin
          if ActiveOrders[j].pair = 'btc_usd' then
            if SP_BTCUSD < 0.6 then
              Continue;
          if ActiveOrders[j].pair = 'btc_rur' then
            if SP_BTCRUR < 0.6 then
              Continue;
          if ActiveOrders[j].pair = 'ltc_btc' then
            if SP_LTCBTC < 0.6 then
              Continue;
          if ActiveOrders[j].pair = 'ltc_usd' then
            if SP_LTCUSD < 0.6 then
              Continue;
          if ActiveOrders[j].pair = 'ltc_rur' then
            if SP_LTCRUR < 0.6 then
              Continue;

          if TopPrice(ActiveOrders[j].pair, ActiveOrders[j].OType, 0.00001) = TopPrice(ActiveOrders[j].pair, ReverseOrderType(ActiveOrders[j].OType))
          then
            Continue;

          if (ActiveOrders[j].OType = 'sell') and (ActiveOrders[j].rate > TopPrice(ActiveOrders[j].pair, 'sell')) then
          begin
            VirtualOrders[i].order_id := '';
            VirtualOrders[i].amount := ActiveOrders[j].amount;
            CancelOrder(ActiveOrders[j].order_id);
          end;

          if (ActiveOrders[j].OType = 'buy') and (ActiveOrders[j].rate < TopPrice(ActiveOrders[j].pair, 'buy')) then
          begin
            VirtualOrders[i].order_id := '';
            VirtualOrders[i].amount := ActiveOrders[j].amount;
            CancelOrder(ActiveOrders[j].order_id);
          end;
        end;
    end;

    // Откроем ордер по виртуальному "По верхней цене отложенный"
    if (not VirtualOrders[i].deleted) and (VirtualOrders[i].area = 'top_price') AND (VirtualOrders[i].order_id = '') AND
      (VirtualOrders[i].AfterOrderID = '') then
    begin
      Ltopprice := TopPrice(VirtualOrders[i].pair, VirtualOrders[i].OType, 0.00001);
      if VirtualOrders[j].pair = 'btc_usd' then
        if SP_BTCUSD < 0.6 then
          Continue;
      if VirtualOrders[j].pair = 'btc_rur' then
        if SP_BTCRUR < 0.6 then
          Continue;
      if VirtualOrders[j].pair = 'ltc_btc' then
        if SP_LTCBTC < 0.6 then
          Continue;
      if VirtualOrders[j].pair = 'ltc_usd' then
        if SP_LTCUSD < 0.6 then
          Continue;
      if VirtualOrders[j].pair = 'ltc_rur' then
        if SP_LTCRUR < 0.6 then
          Continue;

      VirtualOrders[i].order_id := 'wait' + FloatToStr(Ltopprice);
      Log(SendOrder(VirtualOrders[i].pair, VirtualOrders[i].OType, Ltopprice, VirtualOrders[i].amount, True));
      Log('Открываю ордер по виртуальному.');
    end;

    // Удалим виртуальный ордер after_order, если он сработал
    if (not VirtualOrders[i].deleted) AND (VirtualOrders[i].order_id <> '') AND (VirtualOrders[i].area = 'after_order') then
      for j := 0 to Length(OrderHistory) - 1 do
        if VirtualOrders[i].order_id = OrderHistory[j].order_id then
          VirtualOrders[i].deleted := True;
  end;

  // Очищаем массив, если все виртуальные ордеры помечены на удаление
  j := 0;
  for i := 0 to Length(VirtualOrders) - 1 do
    if VirtualOrders[i].deleted then
      j := j + 1;
  if Length(VirtualOrders) = j then
    SetLength(VirtualOrders, 0);
  SaveVirtualOrders();
end;

procedure ZaprosSend();
var
  i, j, k: Integer;
  OrderEst: Boolean;
begin
  try
    if not LoadedFiles then
      Exit;
    // ************ Отмена ордеров ****************
    for i := 0 to Length(CancelOrdersList) - 1 do
    begin
      OrderEst := False;
      while not LoadedOrders do
        sleep(10);

      if Length(ActiveOrders) > 0 then
        for j := 0 to Length(ActiveOrders) - 1 do
          if CancelOrdersList[i] = ActiveOrders[j].order_id then
          begin
            // Найдем и удалим виртуальные ордера, связанные с удаляемым
            for k := 0 to Length(VirtualOrders) - 1 do
              if (VirtualOrders[k].AfterOrderID = ActiveOrders[j].order_id) or (VirtualOrders[k].order_id = ActiveOrders[j].order_id) then
                VirtualOrders[k].deleted := True;

            OrderEst := True;
            SendMessageToClient('CancelOrder&order_id=' + ActiveOrders[j].order_id, True);
            Log('Отменяю ордер ' + ActiveOrders[j].order_id + '.');
            sleep(2000);
          end;
      if NOT OrderEst then
        CancelOrdersList[i] := '';
    end;

    OrderEst := False;
    for i := 0 to Length(CancelOrdersList) - 1 do
      if CancelOrdersList[i] <> '' then
        OrderEst := True;
    if (NOT OrderEst) and (Length(CancelOrdersList) > 0) then
      SetLength(CancelOrdersList, 0);

    sleep(100);
    SendMessageToClient('getInfo');
    sleep(100);
    SendMessageToClient('TradeHistory&count=100');
    sleep(100);
    SendMessageToClient('ActiveOrders');
  except

  end;
end;

procedure GetPrice2();
var
  GetStr: WideString;
  http: TIdHTTP;
  ssl: TIdSSLIOHandlerSocketOpenSSL;
begin
  try

    http := TIdHTTP.Create();
    ssl := TIdSSLIOHandlerSocketOpenSSL.Create();
    http.IOHandler := ssl;
    http.ReadTimeout := 5000;
    ssl.ReadTimeout := 5000;
    try
      // ****************** NVC/USD ************************************
      GetStr := http.Get('https://btc-e.com/api/2/nvc_usd/depth');
      ParseDepth(AsksNVCUSD, BidsNVCUSD, GetStr);
      sleep(50);

      if Length(AsksNVCUSD) > 0 then
        SP_NVCUSD := 100 - (BidsNVCUSD[0].price * 100 / AsksNVCUSD[0].price);

      Form1.TabSheet12.caption := 'NVC/USD ' + OkrugStr(FloatToStr(SP_NVCUSD), 2) + '%';
    Except

    end;
  finally
    http.Free;
    ssl.Free;
  end;
end;

procedure GetPrice12();
var
  GetStr: WideString;
  http: TIdHTTP;
  ssl: TIdSSLIOHandlerSocketOpenSSL;
begin
  try
    http := TIdHTTP.Create();
    ssl := TIdSSLIOHandlerSocketOpenSSL.Create();
    http.IOHandler := ssl;
    http.ReadTimeout := 5000;
    ssl.ReadTimeout := 5000;
    try
      // ****************** NVC/BTC ************************************
      GetStr := http.Get('https://btc-e.com/api/2/nvc_btc/depth');
      ParseDepth(AsksNVCBTC, BidsNVCBTC, GetStr);

      if Length(AsksNVCBTC) > 0 then
        SP_NVCBTC := 100 - (BidsNVCBTC[0].price * 100 / AsksNVCBTC[0].price);

      Form1.TabSheet11.caption := 'NVC/BTC ' + OkrugStr(FloatToStr(SP_NVCBTC), 2) + '%';
    Except

    end;
  finally
    http.Free;
    ssl.Free;
  end;
end;

procedure GetPrice11();
var
  GetStr: WideString;
  http: TIdHTTP;
  ssl: TIdSSLIOHandlerSocketOpenSSL;
begin
  try
    http := TIdHTTP.Create();
    ssl := TIdSSLIOHandlerSocketOpenSSL.Create();
    http.IOHandler := ssl;
    http.ReadTimeout := 5000;
    ssl.ReadTimeout := 5000;
    try
      // ****************** NMC/USD ************************************
      GetStr := http.Get('https://btc-e.com/api/2/nmc_usd/depth');
      ParseDepth(AsksNMCUSD, BidsNMCUSD, GetStr);

      if Length(AsksNMCUSD) > 0 then
        SP_NMCUSD := 100 - (BidsNMCUSD[0].price * 100 / AsksNMCUSD[0].price);

      Form1.TabSheet10.caption := 'NMC/USD ' + OkrugStr(FloatToStr(SP_NMCUSD), 2) + '%';
    Except

    end;
  finally
    http.Free;
    ssl.Free;
  end;
end;

procedure GetPrice10();
var
  GetStr: WideString;
  http: TIdHTTP;
  ssl: TIdSSLIOHandlerSocketOpenSSL;
begin
  try
    http := TIdHTTP.Create();
    ssl := TIdSSLIOHandlerSocketOpenSSL.Create();
    http.IOHandler := ssl;
    http.ReadTimeout := 5000;
    ssl.ReadTimeout := 5000;
    try
      // ****************** NMC/BTC ************************************
      GetStr := http.Get('https://btc-e.com/api/2/nmc_btc/depth');
      ParseDepth(AsksNMCBTC, BidsNMCBTC, GetStr);

      if Length(AsksNMCBTC) > 0 then
        SP_NMCBTC := 100 - (BidsNMCBTC[0].price * 100 / AsksNMCBTC[0].price);

      Form1.TabSheet9.caption := 'NMC/BTC ' + OkrugStr(FloatToStr(SP_NMCBTC), 2) + '%';
    Except

    end;
  finally
    http.Free;
    ssl.Free;
  end;
end;

procedure GetPrice3();
var
  GetStr: WideString;
  http: TIdHTTP;
  ssl: TIdSSLIOHandlerSocketOpenSSL;
begin
  try
    http := TIdHTTP.Create();
    ssl := TIdSSLIOHandlerSocketOpenSSL.Create();
    http.IOHandler := ssl;
    http.ReadTimeout := 5000;
    ssl.ReadTimeout := 5000;
    try
      // ****************** XPM/BTC ************************************
      GetStr := http.Get('https://btc-e.com/api/2/xpm_btc/depth');
      ParseDepth(AsksXPMBTC, BidsXPMBTC, GetStr);
      sleep(50);

      if Length(AsksXPMBTC) > 0 then
        SP_XPMBTC := 100 - (BidsXPMBTC[0].price * 100 / AsksXPMBTC[0].price);

      Form1.TabSheet15.caption := 'XPM/BTC ' + OkrugStr(FloatToStr(SP_XPMBTC), 2) + '%';
    Except

    end;
  finally
    http.Free;
    ssl.Free;
  end;
end;

procedure GetPrice9();
var
  GetStr: WideString;
  http: TIdHTTP;
  ssl: TIdSSLIOHandlerSocketOpenSSL;
begin
  try
    http := TIdHTTP.Create();
    ssl := TIdSSLIOHandlerSocketOpenSSL.Create();
    http.IOHandler := ssl;
    http.ReadTimeout := 5000;
    ssl.ReadTimeout := 5000;
    try
      // ****************** PPC/BTC ************************************
      GetStr := http.Get('https://btc-e.com/api/2/ppc_btc/depth');
      ParseDepth(AsksPPCBTC, BidsPPCBTC, GetStr);
      sleep(50);

      if Length(AsksPPCBTC) > 0 then
        SP_PPCBTC := 100 - (BidsPPCBTC[0].price * 100 / AsksPPCBTC[0].price);

      Form1.TabSheet14.caption := 'PPC/BTC ' + OkrugStr(FloatToStr(SP_PPCBTC), 2) + '%';
    Except

    end;
  finally
    http.Free;
    ssl.Free;
  end;
end;

procedure GetPrice8();
var
  GetStr: WideString;
  http: TIdHTTP;
  ssl: TIdSSLIOHandlerSocketOpenSSL;
begin
  try
    http := TIdHTTP.Create();
    ssl := TIdSSLIOHandlerSocketOpenSSL.Create();
    http.IOHandler := ssl;
    http.ReadTimeout := 5000;
    ssl.ReadTimeout := 5000;
    try
      // ****************** TRC/BTC ************************************
      GetStr := http.Get('https://btc-e.com/api/2/trc_btc/depth');
      ParseDepth(AsksTRCBTC, BidsTRCBTC, GetStr);

      if Length(AsksTRCBTC) > 0 then
        SP_TRCBTC := 100 - (BidsTRCBTC[0].price * 100 / AsksTRCBTC[0].price);

      Form1.TabSheet13.caption := 'TRC/BTC ' + OkrugStr(FloatToStr(SP_TRCBTC), 2) + '%';
    Except

    end;
  finally
    http.Free;
    ssl.Free;
  end;
end;

procedure GetPrice4();
var
  GetStr: WideString;
  http: TIdHTTP;
  ssl: TIdSSLIOHandlerSocketOpenSSL;
begin
  try
    http := TIdHTTP.Create();
    ssl := TIdSSLIOHandlerSocketOpenSSL.Create();
    http.IOHandler := ssl;
    http.ReadTimeout := 5000;
    ssl.ReadTimeout := 5000;
    try
      // ****************** LTC/RUR ************************************
      GetStr := http.Get('https://btc-e.com/api/2/ltc_%20rur/depth');
      ParseDepth(AsksLTCRUR, BidsLTCRUR, GetStr);
      sleep(50);

      if Length(AsksLTCRUR) > 0 then
        SP_LTCRUR := 100 - (BidsLTCRUR[0].price * 100 / AsksLTCRUR[0].price);

      Form1.TabSheet5.caption := 'LTC/RUR ' + OkrugStr(FloatToStr(SP_LTCRUR), 2) + '%';
    Except

    end;
  finally
    http.Free;
    ssl.Free;
  end;
end;

procedure GetPrice7();
var
  GetStr: WideString;
  http: TIdHTTP;
  ssl: TIdSSLIOHandlerSocketOpenSSL;
begin
  try
    http := TIdHTTP.Create();
    ssl := TIdSSLIOHandlerSocketOpenSSL.Create();
    http.IOHandler := ssl;
    http.ReadTimeout := 5000;
    ssl.ReadTimeout := 5000;
    try
      // ****************** LTC/USD ************************************
      GetStr := http.Get('https://btc-e.com/api/2/ltc_usd/depth');
      ParseDepth(AsksLTCUSD, BidsLTCUSD, GetStr);

      if Length(AsksLTCUSD) > 0 then
        SP_LTCUSD := 100 - (BidsLTCUSD[0].price * 100 / AsksLTCUSD[0].price);

      Form1.TabSheet4.caption := 'LTC/USD ' + OkrugStr(FloatToStr(SP_LTCUSD), 2) + '%';
    Except

    end;
  finally
    http.Free;
    ssl.Free;
  end;
end;

procedure GetPrice6();
var
  GetStr: WideString;
  http: TIdHTTP;
  ssl: TIdSSLIOHandlerSocketOpenSSL;
begin
  try
    http := TIdHTTP.Create();
    ssl := TIdSSLIOHandlerSocketOpenSSL.Create();
    http.IOHandler := ssl;
    http.ReadTimeout := 5000;
    ssl.ReadTimeout := 5000;
    try
      // ****************** LTC/BTC ************************************
      GetStr := http.Get('https://btc-e.com/api/2/ltc_btc/depth');
      ParseDepth(AsksLTCBTC, BidsLTCBTC, GetStr);

      if Length(AsksLTCBTC) > 0 then
        SP_LTCBTC := 100 - (BidsLTCBTC[0].price * 100 / AsksLTCBTC[0].price);

      Form1.TabSheet3.caption := 'LTC/BTC ' + OkrugStr(FloatToStr(SP_LTCBTC), 2) + '%';
    Except

    end;
  finally
    http.Free;
    ssl.Free;
  end;
end;

procedure GetPrice5();
var
  GetStr: WideString;
  http: TIdHTTP;
  ssl: TIdSSLIOHandlerSocketOpenSSL;
begin
  try
    http := TIdHTTP.Create();
    ssl := TIdSSLIOHandlerSocketOpenSSL.Create();
    http.IOHandler := ssl;
    http.ReadTimeout := 5000;
    ssl.ReadTimeout := 5000;
    try
      // ****************** BTC/USD ************************************
      GetStr := http.Get('https://btc-e.com/api/2/btc_usd/depth');
      ParseDepth(AsksBTCUSD, BidsBTCUSD, GetStr);

      // ****************** Расчет процента спредов по парам ********************
      if Length(AsksBTCUSD) > 0 then
        SP_BTCUSD := 100 - (BidsBTCUSD[0].price * 100 / AsksBTCUSD[0].price);

      Form1.TabSheet1.caption := 'BTC/USD ' + OkrugStr(FloatToStr(SP_BTCUSD), 2) + '%';
    Except

    end;
  finally
    http.Free;
    ssl.Free;
  end;
end;

procedure GetPrice();
var
  GetStr: WideString;
  http: TIdHTTP;
  ssl: TIdSSLIOHandlerSocketOpenSSL;
begin
  try
    http := TIdHTTP.Create();
    ssl := TIdSSLIOHandlerSocketOpenSSL.Create();
    http.IOHandler := ssl;
    http.ReadTimeout := 5000;
    ssl.ReadTimeout := 5000;
    try
      // ****************** BTC/RUR ************************************
      GetStr := http.Get('https://btc-e.com/api/2/btc_rur/depth');
      ParseDepth(AsksBTCRUR, BidsBTCRUR, GetStr);
      sleep(50);

      // ****************** Расчет процента спредов по парам ********************
      if Length(AsksBTCRUR) > 0 then
        SP_BTCRUR := 100 - (BidsBTCRUR[0].price * 100 / AsksBTCRUR[0].price);

      Form1.TabSheet2.caption := 'BTC/RUR ' + OkrugStr(FloatToStr(SP_BTCRUR), 2) + '%';
    Except

    end;
  finally
    http.Free;
    ssl.Free;
  end;
end;

procedure GetHistory1();
var
  GetStr: WideString;
  http: TIdHTTP;
  ssl: TIdSSLIOHandlerSocketOpenSSL;
  limit: string;
begin
  try
    NZHistory1 := True;
    http := TIdHTTP.Create();
    ssl := TIdSSLIOHandlerSocketOpenSSL.Create();
    http.IOHandler := ssl;
    http.ReadTimeout := 5000;
    ssl.ReadTimeout := 5000;

    if NZFirstZapros then
      limit := '?limit=2000'
    else
      limit := '?limit=20';

    try
    //  GetStr := http.Get('https://btc-e.com/api/3/trades/ltc_rur' + limit);
     // ParseHistory(GlobalLTCRUR, GetStr, 'ltc_rur');
    Except
    end;

    try
     // GetStr := http.Get('https://btc-e.com/api/3/trades/btc_rur' + limit);
     // ParseHistory(GlobalBTCRUR, GetStr, 'btc_rur');
    Except
    end;

    try
    //  GetStr := http.Get('https://btc-e.com/api/3/trades/ltc_btc' + limit);
     // ParseHistory(GlobalLTCBTC, GetStr, 'ltc_btc');
    Except
    end;

    try
//      GetStr := http.Get('https://btc-e.com/api/3/trades/ltc_usd' + limit);
//      ParseHistory(GlobalLTCUSD, GetStr, 'ltc_usd');
    Except
    end;

    try
//      GetStr := http.Get('https://btc-e.com/api/3/trades/btc_usd' + limit);
//      ParseHistory(GlobalBTCUSD, GetStr, 'btc_usd');
    Except
    end;

    if NZFirstZapros then
      limit := '?limit=2000'
    else
      limit := '?limit=10';

    try
     // GetStr := http.Get('https://btc-e.com/api/3/trades/nmc_btc' + limit);
     // ParseHistory(GlobalNMCBTC, GetStr, 'nmc_btc');
    Except
    end;

    try
     // GetStr := http.Get('https://btc-e.com/api/3/trades/nmc_usd' + limit);
     // ParseHistory(GlobalNMCUSD, GetStr, 'nmc_usd');
    Except
    end;

    try
     // GetStr := http.Get('https://btc-e.com/api/3/trades/nvc_btc' + limit);
     // ParseHistory(GlobalNVCBTC, GetStr, 'nvc_btc');
    Except
    end;

    try
     // GetStr := http.Get('https://btc-e.com/api/3/trades/nvc_usd' + limit);
     // ParseHistory(GlobalNVCUSD, GetStr, 'nvc_usd');
    Except
    end;

    try
     // GetStr := http.Get('https://btc-e.com/api/3/trades/trc_btc' + limit);
     // ParseHistory(GlobalTRCBTC, GetStr, 'trc_btc');
    Except
    end;

    try
     // GetStr := http.Get('https://btc-e.com/api/3/trades/ppc_btc' + limit);
     // ParseHistory(GlobalPPCBTC, GetStr, 'ppc_btc');
    Except
    end;

    try
     // GetStr := http.Get('https://btc-e.com/api/3/trades/xpm_btc' + limit);
     // ParseHistory(GlobalXPMBTC, GetStr, 'xpm_btc');
    Except
    end;

  finally
    http.Free;
    ssl.Free;
    NZHistory1 := False;
    NZFirstZapros := False;
  end;
end;

procedure GetHistory2();
var
  GetStr: WideString;
  http: TIdHTTP;
  ssl: TIdSSLIOHandlerSocketOpenSSL;
  limit: string;
begin
  // try
  // http := TIdHTTP.Create();
  // ssl := TIdSSLIOHandlerSocketOpenSSL.Create();
  // http.IOHandler := ssl;
  // try
  // if Length(GlobalNMCUSD) = 0 then
  // limit := '?limit=2000'
  // else
  // limit := '?limit=20';
  //
  // GetStr := http.Get('https://btc-e.com/api/3/trades/nmc_usd' + limit);
  // ParseHistory(GlobalNMCUSD, GetStr, 'nmc_usd');
  // Except
  // end;
  //
  // try
  // if Length(GlobalNVCBTC) = 0 then
  // limit := '?limit=2000'
  // else
  // limit := '?limit=20';
  //
  // GetStr := http.Get('https://btc-e.com/api/3/trades/nvc_btc' + limit);
  // ParseHistory(GlobalNVCBTC, GetStr, 'nvc_btc');
  // Except
  // end;
  //
  // try
  // if Length(GlobalNVCUSD) = 0 then
  // limit := '?limit=2000'
  // else
  // limit := '?limit=20';
  //
  // GetStr := http.Get('https://btc-e.com/api/3/trades/nvc_usd' + limit);
  // ParseHistory(GlobalNVCUSD, GetStr, 'nvc_usd');
  // Except
  // end;
  //
  // try
  // if Length(GlobalTRCBTC) = 0 then
  // limit := '?limit=2000'
  // else
  // limit := '?limit=20';
  //
  // GetStr := http.Get('https://btc-e.com/api/3/trades/trc_btc' + limit);
  // ParseHistory(GlobalTRCBTC, GetStr);
  // Except
  // end;
  //
  // try
  // if Length(GlobalPPCBTC) = 0 then
  // limit := '?limit=2000'
  // else
  // limit := '?limit=20';
  //
  // GetStr := http.Get('https://btc-e.com/api/3/trades/ppc_btc' + limit);
  // ParseHistory(GlobalPPCBTC, GetStr);
  // Except
  // end;
  //
  // try
  // if Length(GlobalXPMBTC) = 0 then
  // limit := '?limit=2000'
  // else
  // limit := '?limit=20';
  //
  // GetStr := http.Get('https://btc-e.com/api/3/trades/xpm_btc' + limit);
  // ParseHistory(GlobalXPMBTC, GetStr);
  // Except
  // end;
  // finally
  // http.Free;
  // ssl.Free;
  // end;
end;

{ TSendZapros }
procedure TSendZapros.execute;
begin
  ZaprosSend();
end;

{ T2GetPrice }
procedure T2GetPrice.execute;
begin
  GetPrice2();
end;

{ T3GetPrice }
procedure T3GetPrice.execute;
begin
  GetPrice3();
end;

{ T4GetPrice }
procedure T4GetPrice.execute;
begin
  GetPrice4();
end;

{ T5GetPrice }
procedure T5GetPrice.execute;
begin
  GetPrice5();
end;

{ T6GetPrice }
procedure T6GetPrice.execute;
begin
  GetPrice6();
end;

{ T7GetPrice }
procedure T7GetPrice.execute;
begin
  GetPrice7();
end;

{ T8GetPrice }
procedure T8GetPrice.execute;
begin
  GetPrice8();
end;

{ T9GetPrice }
procedure T9GetPrice.execute;
begin
  GetPrice9();
end;

procedure T10GetPrice.execute;
begin
  GetPrice10();
end;

{ T10GetPrice }
procedure T11GetPrice.execute;
begin
  GetPrice11();
end;

{ T11GetPrice }
procedure T12GetPrice.execute;
begin
  GetPrice12();
end;

{ T1GetHistory }
procedure T1GetHistory.execute;
begin
  GetHistory1();
end;

{ T2GetHistory }
procedure T2GetHistory.execute;
begin
  GetHistory2();
end;

{ TGetPrice }
procedure TGetPrice.execute;
begin
  // while not StopFlag do
  // try
  GetPrice();
  // finally
  // Sleep(1000);
  // end;
end;

{$R *.dfm}

// Закрытие формы
procedure TForm1.BTCBalanceLabelClick(Sender: TObject);
begin
  EditAmountOpen.Text := BTCBalanceLabel.caption;
end;


procedure TForm1.btnAddSignalCourseClick(Sender: TObject);
var
  TekCourse: real;
begin
  if not LoadedFiles then
    Exit;
  SetLength(CourseSignal, Length(CourseSignal) + 1);
  CourseSignal[Length(CourseSignal) - 1].level := strtofloat(To4kToZap(EditCourseLvl.Text));
  CourseSignal[Length(CourseSignal) - 1].pair := cbCoursePair.Text;
  if cbCoursePair.Text = 'btc_usd' then
    TekCourse := (AsksBTCUSD[0].price + BidsBTCUSD[0].price) / 2
  else if cbCoursePair.Text = 'btc_rur' then
    TekCourse := (AsksBTCRUR[0].price + BidsBTCRUR[0].price) / 2
  else if cbCoursePair.Text = 'ltc_usd' then
    TekCourse := (AsksLTCUSD[0].price + BidsLTCUSD[0].price) / 2
  else if cbCoursePair.Text = 'ltc_rur' then
    TekCourse := (AsksLTCRUR[0].price + BidsLTCRUR[0].price) / 2
  else if cbCoursePair.Text = 'nmc_btc' then
    TekCourse := (AsksNMCBTC[0].price + BidsNMCBTC[0].price) / 2
  else if cbCoursePair.Text = 'nmc_usd' then
    TekCourse := (AsksNMCUSD[0].price + BidsNMCUSD[0].price) / 2
  else if cbCoursePair.Text = 'nvc_btc' then
    TekCourse := (AsksNVCBTC[0].price + BidsNVCBTC[0].price) / 2
  else if cbCoursePair.Text = 'nvc_usd' then
    TekCourse := (AsksNVCUSD[0].price + BidsNVCUSD[0].price) / 2
  else if cbCoursePair.Text = 'trc_btc' then
    TekCourse := (AsksTRCBTC[0].price + BidsTRCBTC[0].price) / 2
  else if cbCoursePair.Text = 'ppc_btc' then
    TekCourse := (AsksPPCBTC[0].price + BidsPPCBTC[0].price) / 2
  else if cbCoursePair.Text = 'xpm_btc' then
    TekCourse := (AsksXPMBTC[0].price + BidsXPMBTC[0].price) / 2;

  CourseSignal[Length(CourseSignal) - 1].TekCourse := TekCourse;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i: Integer;
begin
  if chCancelAllOrders.Checked then
  begin
    while not LoadedOrders do
      sleep(10);

    for i := 0 to Length(ActiveOrders) - 1 do
    begin
      CancelOrder(ActiveOrders[i].order_id);
    end;
    chCancelAllOrders.Checked := False;
    ShowMessage('Все ордера поставлены в очередь на отмену!');
    Exit;
  end;

  if chSelectedPair.Checked then
  begin
    while not LoadedOrders do
      sleep(10);

    for i := 0 to Length(ActiveOrders) - 1 do
      if ActiveOrders[i].pair = sgActiveOrders.Cells[7, sgActiveOrders.Row] then
      begin
        CancelOrder(ActiveOrders[i].order_id);
      end;

    chSelectedPair.Checked := False;
    ShowMessage('Все ордера пары ' + sgActiveOrders.Cells[7, sgActiveOrders.Row] + ' поставлены в очередь на отмену!');
    Exit;
  end;

  CancelOrder(sgActiveOrders.Cells[1, sgActiveOrders.Row]);
  Log('Ордер ' + sgActiveOrders.Cells[1, sgActiveOrders.Row] + ' поставлен в очередь на отмену!');
end;

procedure TForm1.FlashTimerTimer(Sender: TObject);
begin
  if GoFlash then
  begin
    FlashWindow(Form1.Handle, Flash);
    FlashWindow(Application.Handle, Flash);
    Flash := not Flash;
  end;
end;


procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  f: TextFile;
  i: Integer;
begin
  StopFlag := True;
  StartThr.Enabled := False;
  sleep(2000);
  SaveVirtualOrders();
  SaveCourseSignal();
  SaveStrateg();

  SetLength(VirtualOrders, 0);
  SetLength(ActiveOrders, 0);
  SetLength(OrderHistory, 0);
  SetLength(CancelOrdersList, 0);

  try
    AssignFile(f, 't.bat');
    Rewrite(f);
    CloseFile(f);
  finally
  end;

  try
    AssignFile(f, 't2.bat');
    Rewrite(f);
    CloseFile(f);
  finally
  end;
  sleep(500);
end;

// Открытие формы
procedure TForm1.FormCreate(Sender: TObject);
var
  i, k, pcount: Integer;
  VO: file of TVirtualOrder;
  SF: file of TTCourseSignal;
  OH: file of TGlobalOrderHistory;
  FS1: file of TStrateg1;
  process: TStringList;
begin
  // Завершам работу, если копия уже запущена
  gpath := extractfilepath(paramstr(0));
  process := TStringList.Create;
  process.Clear;
  process := GetProcess;
  pcount := 0;
  for i := 0 to process.Count - 1 do
    if process[i] = gpath+'TradeBot.exe' then
      pcount := pcount + 1;
  if pcount > 1 then
    Application.Terminate;

  SetLength(VirtualOrders, 0);
  SetLength(CourseSignal, 0);
  SetLength(GlobalBTCUSD, 0);
  NZFirstZapros := True;

  // Подгружаем настройки
  try
    Ini := TIniFile.Create(gpath+'config.ini'); // создаем файл настроек

    Ini.Free;
  except
    ShowMessage('Не могу загрузить настройки из config.ini');
    Exit;
  end;

  LoadedFiles := False;
  if FileExists(gpath+'course_signals.dat') then
    try
      AssignFile(SF, gpath+'course_signals.dat');
      Reset(SF);
      SetLength(CourseSignal, FileSize(SF));
      k := 0;
      while not Eof(SF) do
      begin
        Seek(SF, k);
        read(SF, CourseSignal[k]);
        k := k + 1;
      end;
      CloseFile(SF);
    except
    end;

  if FileExists(gpath+'virtual_orders.dat') then
    try
      AssignFile(VO, gpath+'virtual_orders.dat');
      Reset(VO);
      SetLength(VirtualOrders, FileSize(VO));
      k := 0;
      while not Eof(VO) do
      begin
        Seek(VO, k);
        read(VO, VirtualOrders[k]);
        k := k + 1;
      end;
      CloseFile(VO);
    except
    end;

  if FileExists(gpath+'strateg1.dat') then
    try
      AssignFile(FS1, gpath+'strateg1.dat');
      Reset(FS1);
      SetLength(Strateg1, FileSize(FS1));
      k := 0;
      while not Eof(FS1) do
      begin
        Seek(FS1, k);
        read(FS1, Strateg1[k]);
        k := k + 1;
      end;
      CloseFile(FS1);
    except
    end;

  // if FileExists('HistoryBTCUSD.dat') then
  // try
  // AssignFile(OH, 'HistoryBTCUSD.dat');
  // Reset(OH);
  // SetLength(GlobalBTCUSD, FileSize(OH));
  // k := 0;
  // while not Eof(OH) do
  // begin
  // Seek(OH, k);
  // read(OH, GlobalBTCUSD[k]);
  // k := k + 1;
  // end;
  // CloseFile(OH);
  // except
  // end;

  LoadedFiles := True;

  WinExec('btceproxy.exe', 0);
  WinExec('btceproxy2.exe', 0);
  LoadedOrders := True;
  UpdateTimer.Enabled := True;

  // BTC/USD
  sgBTCUSDsell.Cells[0, 0] := 'Price';
  sgBTCUSDsell.Cells[1, 0] := 'BTC';
  sgBTCUSDsell.Cells[2, 0] := 'USD';

  sgBTCUSDbuy.Cells[0, 0] := 'Price';
  sgBTCUSDbuy.Cells[1, 0] := 'BTC';
  sgBTCUSDbuy.Cells[2, 0] := 'USD';

  // BTC/RUR
  sgBTCRURsell.Cells[0, 0] := 'Price';
  sgBTCRURsell.Cells[1, 0] := 'BTC';
  sgBTCRURsell.Cells[2, 0] := 'RUR';

  sgBTCRURbuy.Cells[0, 0] := 'Price';
  sgBTCRURbuy.Cells[1, 0] := 'BTC';
  sgBTCRURbuy.Cells[2, 0] := 'RUR';

  // LTC/BTC
  sgLTCBTCSell.Cells[0, 0] := 'Price';
  sgLTCBTCSell.Cells[1, 0] := 'LTC';
  sgLTCBTCSell.Cells[2, 0] := 'BTC';

  sgLTCBTCBuy.Cells[0, 0] := 'Price';
  sgLTCBTCBuy.Cells[1, 0] := 'LTC';
  sgLTCBTCBuy.Cells[2, 0] := 'BTC';

  // LTC/USD
  sgLTCUSDSell.Cells[0, 0] := 'Price';
  sgLTCUSDSell.Cells[1, 0] := 'LTC';
  sgLTCUSDSell.Cells[2, 0] := 'USD';

  sgLTCUSDBuy.Cells[0, 0] := 'Price';
  sgLTCUSDBuy.Cells[1, 0] := 'LTC';
  sgLTCUSDBuy.Cells[2, 0] := 'USD';

  // LTC/RUR
  sgLTCRURSell.Cells[0, 0] := 'Price';
  sgLTCRURSell.Cells[1, 0] := 'LTC';
  sgLTCRURSell.Cells[2, 0] := 'RUR';

  sgLTCRURBuy.Cells[0, 0] := 'Price';
  sgLTCRURBuy.Cells[1, 0] := 'LTC';
  sgLTCRURBuy.Cells[2, 0] := 'RUR';

  // NMC/BTC
  sgNMCBTCSell.Cells[0, 0] := 'Price';
  sgNMCBTCSell.Cells[1, 0] := 'NMC';
  sgNMCBTCSell.Cells[2, 0] := 'BTC';

  sgNMCBTCBuy.Cells[0, 0] := 'Price';
  sgNMCBTCBuy.Cells[1, 0] := 'NMC';
  sgNMCBTCBuy.Cells[2, 0] := 'BTC';

  // NMC/USD
  sgNMCUSDSell.Cells[0, 0] := 'Price';
  sgNMCUSDSell.Cells[1, 0] := 'NMC';
  sgNMCUSDSell.Cells[2, 0] := 'USD';

  sgNMCUSDBuy.Cells[0, 0] := 'Price';
  sgNMCUSDBuy.Cells[1, 0] := 'NMC';
  sgNMCUSDBuy.Cells[2, 0] := 'USD';

  // NVC/BTC
  sgNVCBTCSell.Cells[0, 0] := 'Price';
  sgNVCBTCSell.Cells[1, 0] := 'NVC';
  sgNVCBTCSell.Cells[2, 0] := 'BTC';

  sgNVCBTCBuy.Cells[0, 0] := 'Price';
  sgNVCBTCBuy.Cells[1, 0] := 'NVC';
  sgNVCBTCBuy.Cells[2, 0] := 'BTC';

  // NVC/USD
  sgNVCUSDSell.Cells[0, 0] := 'Price';
  sgNVCUSDSell.Cells[1, 0] := 'NVC';
  sgNVCUSDSell.Cells[2, 0] := 'USD';

  sgNVCUSDBuy.Cells[0, 0] := 'Price';
  sgNVCUSDBuy.Cells[1, 0] := 'NVC';
  sgNVCUSDBuy.Cells[2, 0] := 'USD';

  // TRC/BTC
  sgTRCBTCSell.Cells[0, 0] := 'Price';
  sgTRCBTCSell.Cells[1, 0] := 'TRC';
  sgTRCBTCSell.Cells[2, 0] := 'BTC';

  sgTRCBTCBuy.Cells[0, 0] := 'Price';
  sgTRCBTCBuy.Cells[1, 0] := 'TRC';
  sgTRCBTCBuy.Cells[2, 0] := 'BTC';

  // PPC/BTC
  sgPPCBTCSell.Cells[0, 0] := 'Price';
  sgPPCBTCSell.Cells[1, 0] := 'PPC';
  sgPPCBTCSell.Cells[2, 0] := 'BTC';

  sgPPCBTCBuy.Cells[0, 0] := 'Price';
  sgPPCBTCBuy.Cells[1, 0] := 'PPC';
  sgPPCBTCBuy.Cells[2, 0] := 'BTC';

  // XPM/BTC
  sgXPMBTCSell.Cells[0, 0] := 'Price';
  sgXPMBTCSell.Cells[1, 0] := 'XPM';
  sgXPMBTCSell.Cells[2, 0] := 'BTC';

  sgXPMBTCBuy.Cells[0, 0] := 'Price';
  sgXPMBTCBuy.Cells[1, 0] := 'XPM';
  sgXPMBTCBuy.Cells[2, 0] := 'BTC';

  // Активные ордера
  sgActiveOrders.Cells[0, 0] := '№';
  sgActiveOrders.Cells[1, 0] := 'order_id';
  sgActiveOrders.Cells[2, 0] := 'Тип';
  sgActiveOrders.Cells[3, 0] := 'Цена';
  sgActiveOrders.Cells[4, 0] := 'Кол-во';
  sgActiveOrders.Cells[5, 0] := 'Всего';
  sgActiveOrders.Cells[6, 0] := 'Дата';
  sgActiveOrders.Cells[7, 0] := 'Пара';

  // История ордеров
  sgHistory.Cells[0, 0] := '№';
  sgHistory.Cells[1, 0] := 'order_id';
  sgHistory.Cells[2, 0] := 'Тип';
  sgHistory.Cells[3, 0] := 'Цена';
  sgHistory.Cells[4, 0] := 'Кол-во';
  sgHistory.Cells[5, 0] := 'Всего';
  sgHistory.Cells[6, 0] := 'Дата';
  sgHistory.Cells[7, 0] := 'Пара';

  // Виртуальные ордера
  sgVirtualOrders.Cells[0, 0] := '№';
  sgVirtualOrders.Cells[1, 0] := 'после id';
  sgVirtualOrders.Cells[2, 0] := 'Тип';
  sgVirtualOrders.Cells[3, 0] := 'Цена';
  sgVirtualOrders.Cells[4, 0] := 'main Цена';
  sgVirtualOrders.Cells[5, 0] := 'Кол-во';
  sgVirtualOrders.Cells[6, 0] := 'Всего';
  sgVirtualOrders.Cells[7, 0] := 'order_id';
  sgVirtualOrders.Cells[8, 0] := 'Пара';
  sgVirtualOrders.Cells[9, 0] := 'delta';
  sgVirtualOrders.Cells[10, 0] := 'step';
  sgVirtualOrders.Cells[11, 0] := 'Area';
  sgVirtualOrders.Cells[12, 0] := 'comment';
  // Сигналы
  sgSignalTab.Cells[0, 0] := '№';
  sgSignalTab.Cells[1, 0] := 'Уровень';
  sgSignalTab.Cells[2, 0] := 'Пара';

  // История торгов
  sgTradeHistory.Cells[0, 0] := '№';
  sgTradeHistory.Cells[1, 0] := 'Тип';
  sgTradeHistory.Cells[2, 0] := 'Цена';
  sgTradeHistory.Cells[3, 0] := 'Кол-во';
  sgTradeHistory.Cells[4, 0] := 'ID';
  sgTradeHistory.Cells[5, 0] := 'Дата';

  // Strateg1
  sgStrateg1.Cells[0, 0] := '№';
  sgStrateg1.Cells[1, 0] := 'pair';
  sgStrateg1.Cells[2, 0] := 'Type';
  sgStrateg1.Cells[3, 0] := 'dRate';
  sgStrateg1.Cells[4, 0] := 'lot';
  sgStrateg1.Cells[5, 0] := 'delta';
  sgStrateg1.Cells[6, 0] := 'step';
  sgStrateg1.Cells[7, 0] := 'multi';

  StartThr.Enabled := True; // Запускаем потоки
  FlashTimer.Enabled := True;

  Log('Добрый день! Начинаем работу.');
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  GoFlash := False;
end;

procedure TForm1.FTCBalanceLabelClick(Sender: TObject);
begin
  EditAmountOpen.Text := FTCBalanceLabel.caption;
end;

procedure TForm1.Label24Click(Sender: TObject);
begin
  EditAmountOpen.Text := NVCBalanceLabel.caption;
end;

procedure TForm1.LTCBalanceLabelClick(Sender: TObject);
begin
  EditAmountOpen.Text := LTCBalanceLabel.caption;
end;

procedure TForm1.NVCBalanceLabelClick(Sender: TObject);
begin
  EditAmountOpen.Text := NVCBalanceLabel.caption;
end;

procedure TForm1.PageControl1DrawTab(Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect; Active: Boolean);
begin
  with Control do
  begin
    // begin
    // Canvas.Font.Color:=clBlue;
    // Canvas.Font.Style := [fsBold];
    // Canvas.TextOut(Rect.Left+2,Rect.Top+2,TabSheet1.Caption);
    // end;

    // if TabIndex=1 then
    // begin
    // Canvas.Brush.Color := clGreen;
    // Canvas.FillRect(Rect);
    // end;
  end;
end;

procedure TForm1.RURBalanceLabelClick(Sender: TObject);
begin
  EditAmountOpen.Text := RURBalanceLabel.caption;
end;

// Расшифровываем инфо о балансе
procedure GetInfoParse(s: string);
var
  OReturn: TJSONObject;
  i: Integer;
begin
  OReturn := TJSONObject.Create;
  try
    OReturn := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(s), 0) as TJSONObject;
    // if OReturn.Get('success').JsonValue.Value = '0' then
    // Log('GetInfoParse: ' + s);
    OReturn := OReturn.Get('return').JsonValue as TJSONObject;
    OReturn := OReturn.Get('funds').JsonValue as TJSONObject;
    if Assigned(OReturn) then
      for i := 0 to OReturn.Size - 1 do
      begin
        if OReturn.Get(i).JsonString.Value = 'btc' then
          Balance.BTC := strtofloat(OReturn.Get(i).JsonValue.Value);
        if OReturn.Get(i).JsonString.Value = 'ltc' then
          Balance.LTC := strtofloat(OReturn.Get(i).JsonValue.Value);
        if OReturn.Get(i).JsonString.Value = 'rur' then
          Balance.RUR := strtofloat(OReturn.Get(i).JsonValue.Value);
        if OReturn.Get(i).JsonString.Value = 'usd' then
          Balance.USD := strtofloat(OReturn.Get(i).JsonValue.Value);
        if OReturn.Get(i).JsonString.Value = 'nmc' then
          Balance.NMC := strtofloat(OReturn.Get(i).JsonValue.Value);
        if OReturn.Get(i).JsonString.Value = 'nvc' then
          Balance.NVC := strtofloat(OReturn.Get(i).JsonValue.Value);
        if OReturn.Get(i).JsonString.Value = 'trc' then
          Balance.TRC := strtofloat(OReturn.Get(i).JsonValue.Value);
        if OReturn.Get(i).JsonString.Value = 'ppc' then
          Balance.PPC := strtofloat(OReturn.Get(i).JsonValue.Value);
        if OReturn.Get(i).JsonString.Value = 'ftc' then
          Balance.FTC := strtofloat(OReturn.Get(i).JsonValue.Value);
        if OReturn.Get(i).JsonString.Value = 'xpm' then
          Balance.XPM := strtofloat(OReturn.Get(i).JsonValue.Value);
        if OReturn.Get(i).JsonString.Value = 'eur' then
          Balance.EUR := strtofloat(OReturn.Get(i).JsonValue.Value);
      end;
  finally
    OReturn.Free;
  end;
end;

// Расшифровываем инфо о Активных ордерах
procedure ParseActiveOrders(s: string);
var
  OReturn, OOrder: TJSONObject;
  i: Integer;
begin
  OReturn := TJSONObject.Create;
  OOrder := TJSONObject.Create;
  try
    try
      OReturn := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(s), 0) as TJSONObject;

      if OReturn.Get('success').JsonValue.Value = '1' then
      begin
        // LoadedOrders := false;
        // SetLength(ActiveOrders, 0)
      end
      else if OReturn.Get('error').JsonValue.Value = 'no orders' then
      begin
        LoadedOrders := True;
        SetLength(ActiveOrders, 0)
      end
      else
        Exit;

      OReturn := OReturn.Get('return').JsonValue as TJSONObject;
      if Assigned(OReturn) then
      begin
        SetLength(ActiveOrders, OReturn.Size);
        for i := 0 to OReturn.Size - 1 do // Идем по ордерам
        begin
          // SetLength(ActiveOrders, Length(ActiveOrders) + 1);
          ActiveOrders[i].order_id := OReturn.Get(i).JsonString.Value;
          OOrder := OReturn.Get(ActiveOrders[i].order_id).JsonValue as TJSONObject;
          ActiveOrders[i].pair := OOrder.Get('pair').JsonValue.Value;
          ActiveOrders[i].OType := OOrder.Get('type').JsonValue.Value;
          ActiveOrders[i].amount := strtofloat(OOrder.Get('amount').JsonValue.Value);
          ActiveOrders[i].rate := strtofloat(OOrder.Get('rate').JsonValue.Value);
          ActiveOrders[i].timestamp := StrToInt(OOrder.Get('timestamp_created').JsonValue.Value);
          ActiveOrders[i].status := StrToInt(OOrder.Get('status').JsonValue.Value);
        end;
      end
    Except

    end;
  finally
    LoadedOrders := True;
    OReturn.Free;
    OOrder.Free;
  end;
end;

// Расшифровываем инфо Истории Ордеров
procedure ParseTradeHistory(s: string);
var
  OReturn, OOrder: TJSONObject;
  i: Integer;
  OrdNumber: string;
begin
  OReturn := TJSONObject.Create;
  OOrder := TJSONObject.Create;
  try
    try
      OReturn := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(s), 0) as TJSONObject;

      OReturn := OReturn.Get('return').JsonValue as TJSONObject;
      if Assigned(OReturn) then
      begin
        SetLength(OrderHistory, OReturn.Size);
        for i := 0 to OReturn.Size - 1 do // Идем по ордерам
        begin
          OrdNumber := OReturn.Get(i).JsonString.Value;
          OOrder := OReturn.Get(OrdNumber).JsonValue as TJSONObject;
          OrderHistory[i].order_id := OOrder.Get('order_id').JsonValue.Value;
          OrderHistory[i].pair := OOrder.Get('pair').JsonValue.Value;
          OrderHistory[i].OType := OOrder.Get('type').JsonValue.Value;
          OrderHistory[i].amount := strtofloat(OOrder.Get('amount').JsonValue.Value);
          OrderHistory[i].rate := strtofloat(OOrder.Get('rate').JsonValue.Value);
          OrderHistory[i].timestamp := StrToInt(OOrder.Get('timestamp').JsonValue.Value);
          OrderHistory[i].is_you_order := StrToInt(OOrder.Get('is_your_order').JsonValue.Value);
        end;
      end;
    Except

    end;
  finally
    OReturn.Free;
    OOrder.Free;
  end;
end;

// Расшифровываем инфо Истории Ордеров
procedure ParseTradeAnswer(Method: string; s: string);
var
  OReturn: TJSONObject;
  i, j: Integer;
  OrdNumber, price: string;
  Ltopprice: real;
begin
  // if not LoadedFiles then Exit;

  OReturn := TJSONObject.Create;
  try
    try
      OReturn := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(s), 0) as TJSONObject;

      sleep(50);
      if OReturn.Get('success').JsonValue.Value = '0' then
      begin
        Log('Ошибка открытия ' + Method + s);
        if TryOpenCount < 12 then
        begin
          sleep(1000);
          SendMessageToClient(Method, True);
          TryOpenCount := TryOpenCount + 1;
        end
        else
        begin
          TryOpenCount := 0;
          Log('Ордер не выставлен!!! ' + Method + ' ' + s);
        end;
      end
      else
      begin
        Log('Открыт ордер ' + Method);
        TryOpenCount := 0;
        OReturn := OReturn.Get('return').JsonValue as TJSONObject;
        for i := 0 to Length(VirtualOrders) - 1 do
          if (NOT VirtualOrders[i].deleted) AND (VirtualOrders[i].AfterOrderID = '') then
          begin
            price := '';
            for j := AnsiPos('rate=', Method) + 5 to Length(Method) do
              if Copy(Method, j, 1) <> '&' then
                price := price + Copy(Method, j, 1)
              else
                Break;
            price := To4kToZap(price);
            // ShowMessage(price);
            if VirtualOrders[i].order_id = 'wait' + price then
            begin
              VirtualOrders[i].order_id := OReturn.Get('order_id').JsonValue.Value;
              // if VirtualOrders[i].Children_price <> 0 then
              // begin
              // SetLength(VirtualOrders, Length(VirtualOrders) + 1);
              // if VirtualOrders[i].OType = 'sell' then
              // VirtualOrders[Length(VirtualOrders) - 1].OType := 'buy'
              // else VirtualOrders[Length(VirtualOrders) - 1].OType := 'sell';
              //
              // VirtualOrders[Length(VirtualOrders) - 1].pair := VirtualOrders[i].pair;
              // VirtualOrders[Length(VirtualOrders) - 1].amount := VirtualOrders[i].amount;
              // if VirtualOrders[i].Children_price = 9999999 then
              // if VirtualOrders[i].OType = 'sell' then
              // begin
              // LTopPrice := TopPrice(VirtualOrders[i].pair,'buy');
              // if LTopPrice>StrToFloat(Price)*0.994 then LTopPrice:= StrToFloat(Price)*0.994;
              //
              // VirtualOrders[Length(VirtualOrders) - 1].rate := LTopPrice+0.00001;
              // end
              // else
              // begin
              // LTopPrice := TopPrice(VirtualOrders[i].pair,'sell');
              // if LTopPrice<StrToFloat(Price)*1.006 then LTopPrice:= StrToFloat(Price)*1.006;
              //
              // VirtualOrders[Length(VirtualOrders) - 1].rate := LTopPrice-0.00001;;
              // end
              //
              // else
              // VirtualOrders[Length(VirtualOrders) - 1].rate := VirtualOrders[i].Children_price;
              //
              // VirtualOrders[Length(VirtualOrders) - 1].AfterOrderID := VirtualOrders[i].order_id;
              // end;
            end;
          end;
      end;
    Except

    end;
  finally
    OReturn.Free;
  end;
end;

// Получаем сообщение с биржи
procedure TForm1.serverExecute(AContext: TIdContext);
var
  s, AnswerOnMethod: WideString;
  PosJSON: Integer;
begin
  s := AContext.Connection.Socket.ReadLn;
  PosJSON := AnsiPos('{', s);
  AnswerOnMethod := Copy(s, 1, PosJSON - 1);
  s := Copy(s, PosJSON, Length(s) - PosJSON + 1);
  if AnsiPos('getInfo', AnswerOnMethod) > 0 then
    GetInfoParse(s)
  else if AnsiPos('ActiveOrders', AnswerOnMethod) > 0 then
    ParseActiveOrders(s)
  else if AnsiPos('TradeHistory', AnswerOnMethod) > 0 then
    ParseTradeHistory(s)
  else if AnsiPos('Trade', AnswerOnMethod) > 0 then
    ParseTradeAnswer(AnswerOnMethod, s);
end;

procedure TForm1.sgActiveOrdersClick(Sender: TObject);
var
  i: Integer;
  id: string;
begin
  if (sgActiveOrders.Row <> 0) and (chk2.Checked) then
  begin
    edt1.Text := sgActiveOrders.Cells[1, sgActiveOrders.Row];
    id := sgActiveOrders.Cells[1, sgActiveOrders.Row];
    for i := 0 to Length(ActiveOrders) - 1 do
      if ActiveOrders[i].order_id = id then
      begin
        EditAmountOpen.Text := FloatToStr(ActiveOrders[i].amount * 0.998);
        EditPriceOpen.Text := FloatToStr(ActiveOrders[i].rate * 1.006);
      end;
  end;
end;

procedure TForm1.sgBTCUSDsellClick(Sender: TObject);
var
  i: Integer;
begin
  EditPriceOpen.Text := (Sender as TStringGrid).Cells[0, (Sender as TStringGrid).Row];
  EditAmountOpen.Text := (Sender as TStringGrid).Cells[1, (Sender as TStringGrid).Row];
  if Sender = sgBTCUSDsell then // BTC/USD sell
  begin
    cbOpenPair.Text := 'btc_usd';
    cbTypeOpen.Text := 'buy';
    cbTypeOpen.Color := clBlue;
    cbTypeOpen.Font.Color := clBlack;
  end
  else if Sender = sgBTCUSDbuy then // BTC/USD buy
  begin
    cbOpenPair.Text := 'btc_usd';
    cbTypeOpen.Text := 'sell';
    cbTypeOpen.Color := clRed;
    cbTypeOpen.Font.Color := clWhite;
  end
  else if Sender = sgBTCRURsell then // BTC/RUR sell
  begin
    cbOpenPair.Text := 'btc_rur';
    cbTypeOpen.Text := 'buy';
    cbTypeOpen.Color := clBlue;
    cbTypeOpen.Font.Color := clBlack;
  end
  else if Sender = sgBTCRURbuy then // BTC/RUR buy
  begin
    cbOpenPair.Text := 'btc_rur';
    cbTypeOpen.Text := 'sell';
    cbTypeOpen.Color := clRed;
    cbTypeOpen.Font.Color := clWhite;
  end
  else if Sender = sgLTCBTCSell then // LTC/BTC sell
  begin
    cbOpenPair.Text := 'ltc_btc';
    cbTypeOpen.Text := 'buy';
    cbTypeOpen.Color := clBlue;
    cbTypeOpen.Font.Color := clBlack;
  end
  else if Sender = sgLTCBTCBuy then // LTC/BTC buy
  begin
    cbOpenPair.Text := 'ltc_btc';
    cbTypeOpen.Text := 'sell';
    cbTypeOpen.Color := clRed;
    cbTypeOpen.Font.Color := clWhite;
  end
  else if Sender = sgLTCUSDSell then // LTC/USD sell
  begin
    cbOpenPair.Text := 'ltc_usd';
    cbTypeOpen.Text := 'buy';
    cbTypeOpen.Color := clBlue;
    cbTypeOpen.Font.Color := clBlack;
  end
  else if Sender = sgLTCUSDBuy then // LTC/USD buy
  begin
    cbOpenPair.Text := 'ltc_usd';
    cbTypeOpen.Text := 'sell';
    cbTypeOpen.Color := clRed;
    cbTypeOpen.Font.Color := clWhite;
  end
  else if Sender = sgLTCRURSell then // LTC/RUR sell
  begin
    cbOpenPair.Text := 'ltc_rur';
    cbTypeOpen.Text := 'buy';
    cbTypeOpen.Color := clBlue;
    cbTypeOpen.Font.Color := clBlack;
  end
  else if Sender = sgLTCRURBuy then // LTC/RUR buy
  begin
    cbOpenPair.Text := 'ltc_rur';
    cbTypeOpen.Text := 'sell';
    cbTypeOpen.Color := clRed;
    cbTypeOpen.Font.Color := clWhite;
  end
  else if Sender = sgNMCBTCSell then // NMC/BTC sell
  begin
    cbOpenPair.Text := 'nmc_btc';
    cbTypeOpen.Text := 'buy';
    cbTypeOpen.Color := clBlue;
    cbTypeOpen.Font.Color := clBlack;
  end
  else if Sender = sgNMCBTCBuy then // NMC/BTC buy
  begin
    cbOpenPair.Text := 'nmc_btc';
    cbTypeOpen.Text := 'sell';
    cbTypeOpen.Color := clRed;
    cbTypeOpen.Font.Color := clWhite;
  end
  else if Sender = sgNMCUSDSell then // NMC/USD sell
  begin
    cbOpenPair.Text := 'nmc_usd';
    cbTypeOpen.Text := 'buy';
    cbTypeOpen.Color := clBlue;
    cbTypeOpen.Font.Color := clBlack;
  end
  else if Sender = sgNMCUSDBuy then // NMC/USD buy
  begin
    cbOpenPair.Text := 'nmc_usd';
    cbTypeOpen.Text := 'sell';
    cbTypeOpen.Color := clRed;
    cbTypeOpen.Font.Color := clWhite;
  end
  else if Sender = sgNVCBTCSell then // NVC/BTC sell
  begin
    cbOpenPair.Text := 'nvc_btc';
    cbTypeOpen.Text := 'buy';
    cbTypeOpen.Color := clBlue;
    cbTypeOpen.Font.Color := clBlack;
  end
  else if Sender = sgNVCBTCBuy then // NVC/BTC buy
  begin
    cbOpenPair.Text := 'nvc_btc';
    cbTypeOpen.Text := 'sell';
    cbTypeOpen.Color := clRed;
    cbTypeOpen.Font.Color := clWhite;
  end
  else if Sender = sgNVCUSDSell then // NVC/USD sell
  begin
    cbOpenPair.Text := 'nvc_usd';
    cbTypeOpen.Text := 'buy';
    cbTypeOpen.Color := clBlue;
    cbTypeOpen.Font.Color := clBlack;
  end
  else if Sender = sgNVCUSDBuy then // NVC/USD buy
  begin
    cbOpenPair.Text := 'nvc_usd';
    cbTypeOpen.Text := 'sell';
    cbTypeOpen.Color := clRed;
    cbTypeOpen.Font.Color := clWhite;
  end
  else if Sender = sgTRCBTCSell then // TRC/BTC sell
  begin
    cbOpenPair.Text := 'trc_btc';
    cbTypeOpen.Text := 'buy';
    cbTypeOpen.Color := clBlue;
    cbTypeOpen.Font.Color := clBlack;
  end
  else if Sender = sgTRCBTCBuy then // TRC/BTC buy
  begin
    cbOpenPair.Text := 'trc_btc';
    cbTypeOpen.Text := 'sell';
    cbTypeOpen.Color := clRed;
    cbTypeOpen.Font.Color := clWhite;
  end
  else if Sender = sgPPCBTCSell then // PPC/BTC sell
  begin
    cbOpenPair.Text := 'ppc_btc';
    cbTypeOpen.Text := 'buy';
    cbTypeOpen.Color := clBlue;
    cbTypeOpen.Font.Color := clBlack;
  end
  else if Sender = sgPPCBTCBuy then // PPC/BTC buy
  begin
    cbOpenPair.Text := 'ppc_btc';
    cbTypeOpen.Text := 'sell';
    cbTypeOpen.Color := clRed;
    cbTypeOpen.Font.Color := clWhite;
  end
  else if Sender = sgXPMBTCSell then // XPM/BTC sell
  begin
    cbOpenPair.Text := 'xpm_btc';
    cbTypeOpen.Text := 'buy';
    cbTypeOpen.Color := clBlue;
    cbTypeOpen.Font.Color := clBlack;
  end
  else if Sender = sgXPMBTCBuy then // XPM/BTC buy
  begin
    cbOpenPair.Text := 'xpm_btc';
    cbTypeOpen.Text := 'sell';
    cbTypeOpen.Color := clRed;
    cbTypeOpen.Font.Color := clWhite;
  end;

  UpdateSumm;
end;

procedure TForm1.sgBTCUSDsellDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  i: Integer;
begin
  while not LoadedOrders do
    sleep(10);

  if Sender = sgBTCUSDsell then // BTC/USD sell
  begin
    if ARow <> 0 then
    begin
      if Length(ActiveOrders) > 0 then
        for i := 0 to Length(ActiveOrders) - 1 do
          if (ActiveOrders[i].pair = 'btc_usd') and (ActiveOrders[i].OType = 'sell') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(ActiveOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clRed;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;

      if Length(VirtualOrders) > 0 then
        for i := 0 to Length(VirtualOrders) - 1 do
          if (VirtualOrders[i].pair = 'btc_usd') and (VirtualOrders[i].OType = 'buy') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(VirtualOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clBlue;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
    end;
  end
  else if Sender = sgBTCUSDbuy then // BTC/USD buy
  begin
    if ARow <> 0 then
    begin
      if Length(ActiveOrders) > 0 then
        for i := 0 to Length(ActiveOrders) - 1 do
          if (ActiveOrders[i].pair = 'btc_usd') and (ActiveOrders[i].OType = 'buy') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(ActiveOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clRed;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
      if Length(VirtualOrders) > 0 then
        for i := 0 to Length(VirtualOrders) - 1 do
          if (VirtualOrders[i].pair = 'btc_usd') and (VirtualOrders[i].OType = 'sell') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(VirtualOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clBlue;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
    end;
  end
  else if Sender = sgBTCRURsell then // BTC/RUR sell
  begin
    if ARow <> 0 then
    begin
      if Length(ActiveOrders) > 0 then
        for i := 0 to Length(ActiveOrders) - 1 do
          if (ActiveOrders[i].pair = 'btc_rur') and (ActiveOrders[i].OType = 'sell') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(ActiveOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clRed;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
      if Length(VirtualOrders) > 0 then
        for i := 0 to Length(VirtualOrders) - 1 do
          if (VirtualOrders[i].pair = 'btc_rur') and (VirtualOrders[i].OType = 'buy') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(VirtualOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clBlue;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
    end;

  end
  else if Sender = sgBTCRURbuy then // BTC/RUR buy
  begin
    if ARow <> 0 then
    begin
      if Length(ActiveOrders) > 0 then
        for i := 0 to Length(ActiveOrders) - 1 do
          if (ActiveOrders[i].pair = 'btc_rur') and (ActiveOrders[i].OType = 'buy') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(ActiveOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clRed;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
      if Length(VirtualOrders) > 0 then
        for i := 0 to Length(VirtualOrders) - 1 do
          if (VirtualOrders[i].pair = 'btc_rur') and (VirtualOrders[i].OType = 'sell') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(VirtualOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clBlue;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
    end;
  end
  else if Sender = sgLTCBTCSell then // LTC/BTC sell
  begin
    if ARow <> 0 then
    begin
      if Length(ActiveOrders) > 0 then
        for i := 0 to Length(ActiveOrders) - 1 do
          if (ActiveOrders[i].pair = 'ltc_btc') and (ActiveOrders[i].OType = 'sell') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(ActiveOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clRed;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
      if Length(VirtualOrders) > 0 then
        for i := 0 to Length(VirtualOrders) - 1 do
          if (VirtualOrders[i].pair = 'ltc_btc') and (VirtualOrders[i].OType = 'buy') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(VirtualOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clBlue;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
    end;
  end
  else if Sender = sgLTCBTCBuy then // LTC/BTC buy
  begin
    if ARow <> 0 then
    begin
      if Length(ActiveOrders) > 0 then
        for i := 0 to Length(ActiveOrders) - 1 do
          if (ActiveOrders[i].pair = 'ltc_btc') and (ActiveOrders[i].OType = 'buy') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(ActiveOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clRed;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
      if Length(VirtualOrders) > 0 then
        for i := 0 to Length(VirtualOrders) - 1 do
          if (VirtualOrders[i].pair = 'ltc_btc') and (VirtualOrders[i].OType = 'sell') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(VirtualOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clBlue;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
    end;
  end
  else if Sender = sgLTCUSDSell then // LTC/USD sell
  begin
    if ARow <> 0 then
    begin
      if Length(ActiveOrders) > 0 then
        for i := 0 to Length(ActiveOrders) - 1 do
          if (ActiveOrders[i].pair = 'ltc_usd') and (ActiveOrders[i].OType = 'sell') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(ActiveOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clRed;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
      if Length(VirtualOrders) > 0 then
        for i := 0 to Length(VirtualOrders) - 1 do
          if (VirtualOrders[i].pair = 'ltc_usd') and (VirtualOrders[i].OType = 'buy') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(VirtualOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clBlue;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
    end;
  end
  else if Sender = sgLTCUSDBuy then // LTC/USD buy
  begin
    if ARow <> 0 then
    begin
      if Length(ActiveOrders) > 0 then
        for i := 0 to Length(ActiveOrders) - 1 do
          if (ActiveOrders[i].pair = 'ltc_usd') and (ActiveOrders[i].OType = 'buy') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(ActiveOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clRed;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;

      if Length(VirtualOrders) > 0 then
        for i := 0 to Length(VirtualOrders) - 1 do
          if (VirtualOrders[i].pair = 'ltc_usd') and (VirtualOrders[i].OType = 'sell') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(VirtualOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clBlue;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
    end;
  end
  else if Sender = sgLTCRURSell then // LTC/RUR sell
  begin
    if ARow <> 0 then
    begin
      if Length(ActiveOrders) > 0 then
        for i := 0 to Length(ActiveOrders) - 1 do
          if (ActiveOrders[i].pair = 'ltc_rur') and (ActiveOrders[i].OType = 'sell') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(ActiveOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clRed;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
      if Length(VirtualOrders) > 0 then
        for i := 0 to Length(VirtualOrders) - 1 do
          if (VirtualOrders[i].pair = 'ltc_rur') and (VirtualOrders[i].OType = 'buy') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(VirtualOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clBlue;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
    end;
  end
  else if Sender = sgLTCRURBuy then // LTC/RUR buy
  begin
    if ARow <> 0 then
    begin
      if Length(ActiveOrders) > 0 then
        for i := 0 to Length(ActiveOrders) - 1 do
          if (ActiveOrders[i].pair = 'ltc_rur') and (ActiveOrders[i].OType = 'buy') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(ActiveOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clRed;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;

      if Length(VirtualOrders) > 0 then
        for i := 0 to Length(VirtualOrders) - 1 do
          if (VirtualOrders[i].pair = 'ltc_rur') and (VirtualOrders[i].OType = 'sell') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(VirtualOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clBlue;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
    end;
  end
  else if Sender = sgNMCBTCSell then // NMC/BTC sell
  begin
    if ARow <> 0 then
    begin
      if Length(ActiveOrders) > 0 then
        for i := 0 to Length(ActiveOrders) - 1 do
          if (ActiveOrders[i].pair = 'nmc_btc') and (ActiveOrders[i].OType = 'sell') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(ActiveOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clRed;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;

      if Length(VirtualOrders) > 0 then
        for i := 0 to Length(VirtualOrders) - 1 do
          if (VirtualOrders[i].pair = 'nmc_btc') and (VirtualOrders[i].OType = 'buy') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(VirtualOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clBlue;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
    end;
  end
  else if Sender = sgNMCBTCBuy then // NMC/BTC buy
  begin
    if ARow <> 0 then
    begin
      if Length(ActiveOrders) > 0 then
        for i := 0 to Length(ActiveOrders) - 1 do
          if (ActiveOrders[i].pair = 'nmc_btc') and (ActiveOrders[i].OType = 'buy') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(ActiveOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clRed;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;

      if Length(VirtualOrders) > 0 then
        for i := 0 to Length(VirtualOrders) - 1 do
          if (VirtualOrders[i].pair = 'nmc_btc') and (VirtualOrders[i].OType = 'sell') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(VirtualOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clBlue;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
    end;
  end
  else if Sender = sgNMCUSDSell then // NMC/USD sell
  begin
    if ARow <> 0 then
    begin
      if Length(ActiveOrders) > 0 then
        for i := 0 to Length(ActiveOrders) - 1 do
          if (ActiveOrders[i].pair = 'nmc_usd') and (ActiveOrders[i].OType = 'sell') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(ActiveOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clRed;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;

      if Length(VirtualOrders) > 0 then
        for i := 0 to Length(VirtualOrders) - 1 do
          if (VirtualOrders[i].pair = 'nmc_usd') and (VirtualOrders[i].OType = 'buy') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(VirtualOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clBlue;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
    end;
  end
  else if Sender = sgNMCUSDBuy then // NMC/USD buy
  begin
    if ARow <> 0 then
    begin
      if Length(ActiveOrders) > 0 then
        for i := 0 to Length(ActiveOrders) - 1 do
          if (ActiveOrders[i].pair = 'nmc_usd') and (ActiveOrders[i].OType = 'buy') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(ActiveOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clRed;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
      if Length(VirtualOrders) > 0 then
        for i := 0 to Length(VirtualOrders) - 1 do
          if (VirtualOrders[i].pair = 'nmc_usd') and (VirtualOrders[i].OType = 'sell') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(VirtualOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clBlue;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
    end;
  end
  else if Sender = sgNVCBTCSell then // NVC/BTC sell
  begin
    if ARow <> 0 then
    begin
      if Length(ActiveOrders) > 0 then
        for i := 0 to Length(ActiveOrders) - 1 do
          if (ActiveOrders[i].pair = 'nvc_btc') and (ActiveOrders[i].OType = 'sell') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(ActiveOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clRed;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;

      if Length(VirtualOrders) > 0 then
        for i := 0 to Length(VirtualOrders) - 1 do
          if (VirtualOrders[i].pair = 'nvc_btc') and (VirtualOrders[i].OType = 'buy') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(VirtualOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clBlue;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
    end;
  end
  else if Sender = sgNVCBTCBuy then // NVC/BTC buy
  begin
    if ARow <> 0 then
    begin
      if Length(ActiveOrders) > 0 then
        for i := 0 to Length(ActiveOrders) - 1 do
          if (ActiveOrders[i].pair = 'nvc_btc') and (ActiveOrders[i].OType = 'buy') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(ActiveOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clRed;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
      if Length(VirtualOrders) > 0 then
        for i := 0 to Length(VirtualOrders) - 1 do
          if (VirtualOrders[i].pair = 'nvc_btc') and (VirtualOrders[i].OType = 'sell') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(VirtualOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clBlue;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
    end;
  end
  else if Sender = sgNVCUSDSell then // NVC/USD sell
  begin
    if ARow <> 0 then
    begin
      if Length(ActiveOrders) > 0 then
        for i := 0 to Length(ActiveOrders) - 1 do
          if (ActiveOrders[i].pair = 'nvc_usd') and (ActiveOrders[i].OType = 'sell') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(ActiveOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clRed;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
      if Length(VirtualOrders) > 0 then
        for i := 0 to Length(VirtualOrders) - 1 do
          if (VirtualOrders[i].pair = 'nvc_usd') and (VirtualOrders[i].OType = 'buy') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(VirtualOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clBlue;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
    end;
  end
  else if Sender = sgNVCUSDBuy then // NVC/USD buy
  begin
    if ARow <> 0 then
    begin
      if Length(ActiveOrders) > 0 then
        for i := 0 to Length(ActiveOrders) - 1 do
          if (ActiveOrders[i].pair = 'nvc_usd') and (ActiveOrders[i].OType = 'buy') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(ActiveOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clRed;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;

      if Length(VirtualOrders) > 0 then
        for i := 0 to Length(VirtualOrders) - 1 do
          if (VirtualOrders[i].pair = 'nvc_usd') and (VirtualOrders[i].OType = 'sell') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(VirtualOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clBlue;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
    end;
  end
  else if Sender = sgTRCBTCSell then // TRC/BTC sell
  begin
    if ARow <> 0 then
    begin
      if Length(ActiveOrders) > 0 then
        for i := 0 to Length(ActiveOrders) - 1 do
          if (ActiveOrders[i].pair = 'trc_btc') and (ActiveOrders[i].OType = 'sell') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(ActiveOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clRed;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;

      if Length(VirtualOrders) > 0 then
        for i := 0 to Length(VirtualOrders) - 1 do
          if (VirtualOrders[i].pair = 'trc_btc') and (VirtualOrders[i].OType = 'buy') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(VirtualOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clBlue;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
    end;
  end
  else if Sender = sgTRCBTCBuy then // TRC/BTC buy
  begin
    if ARow <> 0 then
    begin
      if Length(ActiveOrders) > 0 then
        for i := 0 to Length(ActiveOrders) - 1 do
          if (ActiveOrders[i].pair = 'trc_btc') and (ActiveOrders[i].OType = 'buy') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(ActiveOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clRed;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;

      if Length(VirtualOrders) > 0 then
        for i := 0 to Length(VirtualOrders) - 1 do
          if (VirtualOrders[i].pair = 'trc_btc') and (VirtualOrders[i].OType = 'sell') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(VirtualOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clBlue;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
    end;
  end
  else if Sender = sgPPCBTCSell then // PPC/BTC sell
  begin
    if ARow <> 0 then
    begin
      if Length(ActiveOrders) > 0 then
        for i := 0 to Length(ActiveOrders) - 1 do
          if (ActiveOrders[i].pair = 'ppc_btc') and (ActiveOrders[i].OType = 'sell') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(ActiveOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clRed;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;

      if Length(VirtualOrders) > 0 then
        for i := 0 to Length(VirtualOrders) - 1 do
          if (VirtualOrders[i].pair = 'ppc_btc') and (VirtualOrders[i].OType = 'buy') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(VirtualOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clBlue;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
    end;
  end
  else if Sender = sgPPCBTCBuy then // PPC/BTC buy
  begin
    if ARow <> 0 then
    begin
      if Length(ActiveOrders) > 0 then
        for i := 0 to Length(ActiveOrders) - 1 do
          if (ActiveOrders[i].pair = 'ppc_btc') and (ActiveOrders[i].OType = 'buy') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(ActiveOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clRed;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;

      if Length(VirtualOrders) > 0 then
        for i := 0 to Length(VirtualOrders) - 1 do
          if (VirtualOrders[i].pair = 'ppc_btc') and (VirtualOrders[i].OType = 'sell') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(VirtualOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clBlue;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
    end;
  end
  else if Sender = sgXPMBTCSell then // XPM/BTC sell
  begin
    if ARow <> 0 then
    begin
      if Length(ActiveOrders) > 0 then
        for i := 0 to Length(ActiveOrders) - 1 do
          if (ActiveOrders[i].pair = 'xpm_btc') and (ActiveOrders[i].OType = 'sell') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(ActiveOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clRed;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;

      if Length(VirtualOrders) > 0 then
        for i := 0 to Length(VirtualOrders) - 1 do
          if (VirtualOrders[i].pair = 'xpm_btc') and (VirtualOrders[i].OType = 'buy') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(VirtualOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clBlue;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
    end;
  end
  else if Sender = sgXPMBTCBuy then // XPM/BTC buy
  begin
    if ARow <> 0 then
    begin
      if Length(ActiveOrders) > 0 then
        for i := 0 to Length(ActiveOrders) - 1 do
          if (ActiveOrders[i].pair = 'xpm_btc') and (ActiveOrders[i].OType = 'buy') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(ActiveOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clRed;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
      if Length(VirtualOrders) > 0 then
        for i := 0 to Length(VirtualOrders) - 1 do
          if (VirtualOrders[i].pair = 'xpm_btc') and (VirtualOrders[i].OType = 'sell') and
            ((Sender as TStringGrid).Cells[0, ARow] = FloatToStr(VirtualOrders[i].rate)) then
          Begin
            (Sender as TStringGrid).Canvas.Brush.Color := clBlue;
            (Sender as TStringGrid).Canvas.FrameRect(Rect);
          end;
    end;
  end;
end;

procedure TForm1.sgTradeHistoryDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if ACol = 1 then
    if sgTradeHistory.Cells[1, ARow] = 'sell' then
      with sgTradeHistory do
      begin
        Canvas.Font.Color := clRed;
        Canvas.Font.Style := [fsBold];
        Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, Cells[ACol, ARow]);
        Exit;
      end
    else if sgTradeHistory.Cells[1, ARow] = 'buy' then
      with sgTradeHistory do
      begin
        Canvas.Font.Color := clGreen;
        Canvas.Font.Style := [fsBold];
        Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, Cells[ACol, ARow]);
        Exit;
      end
end;

procedure TForm1.sgVirtualOrdersDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if ARow <> 0 then
    if (sgVirtualOrders.Cells[11, ARow] = 'trail_order') then
    Begin
      if sgVirtualOrders.Cells[3, ARow] = sgVirtualOrders.Cells[4, ARow] then
      begin
        sgVirtualOrders.Canvas.Brush.Color := clGray;
        sgVirtualOrders.Canvas.FrameRect(Rect);
        Exit
      end
      else if sgVirtualOrders.Cells[2, ARow] = 'buy' then
      begin
        sgVirtualOrders.Canvas.Brush.Color := clBlue;
        sgVirtualOrders.Canvas.FrameRect(Rect);
        Exit
      end
      else if sgVirtualOrders.Cells[2, ARow] = 'sell' then
      begin
        sgVirtualOrders.Canvas.Brush.Color := clRed;
        sgVirtualOrders.Canvas.FrameRect(Rect);
        Exit
      end
    end;
end;

procedure FloodSGPair(sg: TStringGrid; PairArray: array of TDepth);
var
  i: Integer;
begin
  sg.RowCount := 31;
  try
    for i := 0 to Length(PairArray) - 1 do
    begin
      if i > 60 then
        Break;

      sg.Cells[0, i + 1] := OkrugStr(FloatToStr(PairArray[i].price), 8);
      sg.Cells[1, i + 1] := OkrugStr(FloatToStr(PairArray[i].Volume), 8);
      sg.Cells[2, i + 1] := OkrugStr(FloatToStr(PairArray[i].price * PairArray[i].Volume), 5);
    end;
  finally
  end;
end;

procedure FloodSGHistory(PairArray: TTGlobalOrderHistory);
var
  i, k: Integer;
  Ordertype: string;
  SellVol10, BuyVol10: real;
begin
  if Length(PairArray) > 0 then
  begin
    Form1.sgTradeHistory.RowCount := Length(PairArray) + 1;
    k := 1;
    for i := Length(PairArray) - 1 downto 0 do
    begin
      if PairArray[i].typeOrder = 'ask' then
        Ordertype := 'sell'
      else
        Ordertype := 'buy';

      Form1.sgTradeHistory.Cells[0, k] := IntToStr(k);
      Form1.sgTradeHistory.Cells[1, k] := Ordertype;
      Form1.sgTradeHistory.Cells[2, k] := FloatToStr(PairArray[i].price);
      Form1.sgTradeHistory.Cells[3, k] := FloatToStr(PairArray[i].amount);
      Form1.sgTradeHistory.Cells[4, k] := PairArray[i].tid;
      Form1.sgTradeHistory.Cells[5, k] := DateTimeToStr(UnixToDateTime(PairArray[i].timestamp + 14400)); // GMT+4
      k := k + 1;
      if k > 500 then
        Break;

    end;

    // ShowMessage(DateTimeToStr(now));
    for i := Length(PairArray) - 1 downto 0 do
      if PairArray[i].timestamp > PairArray[Length(PairArray) - 1].timestamp - 600 then
      begin
        if PairArray[i].typeOrder = 'ask' then
          SellVol10 := SellVol10 + PairArray[i].amount;
        if PairArray[i].typeOrder = 'bid' then
          BuyVol10 := BuyVol10 + PairArray[i].amount;
      end;

    Form1.Label44.caption := FloatToStr(SellVol10);
    Form1.Label45.caption := FloatToStr(BuyVol10);
    Form1.Label46.caption := FloatToStr(BuyVol10 - SellVol10);
    if BuyVol10 - SellVol10 < 0 then
      Form1.Label46.Font.Color := clRed
    else
      Form1.Label46.Font.Color := clGreen;

  end;
end;

// Обновляем табличные части
procedure UpdateSG();
var
  i, k: Integer;
  j, SRVirt: Integer;
  Valuta1, Valuta2: string;
  Volume: real;
begin
  if not LoadedFiles then
    Exit;

  // ******************** BTC/USD *******************************
  FloodSGPair(Form1.sgBTCUSDsell, AsksBTCUSD);
  FloodSGPair(Form1.sgBTCUSDbuy, BidsBTCUSD);
  // Form1.Chart1.ClearChart;
  // for i := Length(GlobalBTCUSD)-1 downto 0 do
  // Form1.Chart1.SeriesList.First.AddXY(GlobalBTCUSD[i].price,i,'',clGreen);
  // Form1.Chart1.SeriesList.First.Active := true;

  // ******************** BTC/RUR *******************************
//  FloodSGPair(Form1.sgBTCRURsell, AsksBTCRUR);
//  FloodSGPair(Form1.sgBTCRURbuy, BidsBTCRUR);
//  // ******************** LTC/BTC *******************************
//  FloodSGPair(Form1.sgLTCBTCSell, AsksLTCBTC);
//  FloodSGPair(Form1.sgLTCBTCBuy, BidsLTCBTC);
//  // ******************** LTC/USD *******************************
  FloodSGPair(Form1.sgLTCUSDSell, AsksLTCUSD);
  FloodSGPair(Form1.sgLTCUSDBuy, BidsLTCUSD);
//  // ******************** LTC/RUR *******************************
//  FloodSGPair(Form1.sgLTCRURSell, AsksLTCRUR);
//  FloodSGPair(Form1.sgLTCRURBuy, BidsLTCRUR);
//  // ******************** NMC/BTC *******************************
//  FloodSGPair(Form1.sgNMCBTCSell, AsksNMCBTC);
//  FloodSGPair(Form1.sgNMCBTCBuy, BidsNMCBTC);
//  // ******************** NMC/USD *******************************
//  FloodSGPair(Form1.sgNMCUSDSell, AsksNMCUSD);
//  FloodSGPair(Form1.sgNMCUSDBuy, BidsNMCUSD);
//  // ******************** NVC/BTC *******************************
//  FloodSGPair(Form1.sgNVCBTCSell, AsksNVCBTC);
//  FloodSGPair(Form1.sgNVCBTCBuy, BidsNVCBTC);
//  // ******************** NVC/USD *******************************
//  FloodSGPair(Form1.sgNVCUSDSell, AsksNVCUSD);
//  FloodSGPair(Form1.sgNVCUSDBuy, BidsNVCUSD);
//  // ******************** TRC/BTC *******************************
//  FloodSGPair(Form1.sgTRCBTCSell, AsksTRCBTC);
//  FloodSGPair(Form1.sgTRCBTCBuy, BidsTRCBTC);
//  // ******************** PPC/BTC *******************************
//  FloodSGPair(Form1.sgPPCBTCSell, AsksPPCBTC);
//  FloodSGPair(Form1.sgPPCBTCBuy, BidsPPCBTC);
//  // ******************** PPC/BTC *******************************
//  FloodSGPair(Form1.sgXPMBTCSell, AsksXPMBTC);
//  FloodSGPair(Form1.sgXPMBTCBuy, BidsXPMBTC);

  // ******************** sgHistory *******************************
  if ActivePair = 'btc_usd' then
    FloodSGHistory(GlobalBTCUSD)
  else if ActivePair = 'btc_rur' then
    FloodSGHistory(GlobalBTCRUR)
  else if ActivePair = 'ltc_btc' then
    FloodSGHistory(GlobalLTCBTC)
  else if ActivePair = 'ltc_usd' then
    FloodSGHistory(GlobalLTCUSD)
  else if ActivePair = 'ltc_rur' then
    FloodSGHistory(GlobalLTCRUR)
  else if ActivePair = 'nmc_btc' then
    FloodSGHistory(GlobalNMCBTC)
  else if ActivePair = 'nmc_usd' then
    FloodSGHistory(GlobalNMCUSD)
  else if ActivePair = 'nvc_btc' then
    FloodSGHistory(GlobalNVCBTC)
  else if ActivePair = 'nvc_usd' then
    FloodSGHistory(GlobalNVCUSD)
  else if ActivePair = 'trc_btc' then
    FloodSGHistory(GlobalTRCBTC)
  else if ActivePair = 'ppc_btc' then
    FloodSGHistory(GlobalPPCBTC)
  else if ActivePair = 'xpm_btc' then
    FloodSGHistory(GlobalXPMBTC);

  // ******************** ActiveOrders *******************************
  while not LoadedOrders do
    sleep(10);

  try
    Form1.sgActiveOrders.RowCount := Length(ActiveOrders) + 1;
    for i := 1 to Form1.sgActiveOrders.RowCount - 1 do
      for j := 0 to Form1.sgActiveOrders.ColCount - 1 do
        Form1.sgActiveOrders.Cells[j, i] := '';
    k := 1;
    for i := 0 to Length(ActiveOrders) - 1 do
      if (ActiveOrders[i].pair = ActivePair) or (not Form1.chActiveCurrent.Checked) then
      begin
        Valuta1 := Valute1FromPair(ActiveOrders[i].pair);
        Valuta2 := Valute2FromPair(ActiveOrders[i].pair);

        Form1.sgActiveOrders.Cells[0, k] := IntToStr(k);
        Form1.sgActiveOrders.Cells[1, k] := ActiveOrders[i].order_id;
        Form1.sgActiveOrders.Cells[2, k] := ActiveOrders[i].OType;
        Form1.sgActiveOrders.Cells[3, k] := FloatToStr(ActiveOrders[i].rate) + ' ' + Valuta1;
        Form1.sgActiveOrders.Cells[4, k] := FloatToStr(ActiveOrders[i].amount) + ' ' + Valuta2;
        Form1.sgActiveOrders.Cells[5, k] := FloatToStr(ActiveOrders[i].rate * ActiveOrders[i].amount) + ' ' + Valuta1;
        Form1.sgActiveOrders.Cells[6, k] := DateTimeToStr(UnixToDateTime(ActiveOrders[i].timestamp + 14400));
        // GMT+4 (Russia)
        Form1.sgActiveOrders.Cells[7, k] := ActiveOrders[i].pair;
        k := k + 1;
      end;
  finally

  end;

  // ******************** OrdersHistory *******************************
  try
    for i := 1 to Form1.sgHistory.RowCount - 1 do
      for j := 0 to Form1.sgHistory.ColCount - 1 do
        Form1.sgHistory.Cells[j, i] := '';

    k := 1;
    Form1.sgHistory.RowCount := 30;
    for i := 0 to Length(OrderHistory) - 1 do
      if (OrderHistory[i].pair = ActivePair) or (not Form1.chHistoryActive.Checked) then
      begin
        Valuta1 := Valute1FromPair(OrderHistory[i].pair);
        Valuta2 := Valute2FromPair(OrderHistory[i].pair);

        Form1.sgHistory.Cells[0, k] := IntToStr(i + 1);
        Form1.sgHistory.Cells[1, k] := OrderHistory[i].order_id;
        Form1.sgHistory.Cells[2, k] := OrderHistory[i].OType;
        Form1.sgHistory.Cells[3, k] := FloatToStr(OrderHistory[i].rate) + ' ' + Valuta1;
        Form1.sgHistory.Cells[4, k] := FloatToStr(OrderHistory[i].amount) + ' ' + Valuta2;
        Form1.sgHistory.Cells[5, k] := FloatToStr(OrderHistory[i].rate * OrderHistory[i].amount) + ' ' + Valuta1;
        Form1.sgHistory.Cells[6, k] := DateTimeToStr(UnixToDateTime(OrderHistory[i].timestamp + 14400));
        // GMT+4 (Russia)
        Form1.sgHistory.Cells[7, k] := OrderHistory[i].pair;
        k := k + 1;
      end;
  finally

  end;

  // Виртуальный ордера
  try
    Form1.sgVirtualOrders.RowCount := Length(VirtualOrders) + 1;
    for i := 1 to Form1.sgVirtualOrders.RowCount - 1 do
      for j := 0 to Form1.sgVirtualOrders.ColCount - 1 do
        Form1.sgVirtualOrders.Cells[j, i] := '';
    k := 1;
    if Length(VirtualOrders) > 0 then
      for i := 0 to Length(VirtualOrders) - 1 do
        if not VirtualOrders[i].deleted then
        begin
          Valuta1 := Valute1FromPair(VirtualOrders[i].pair);
          Valuta2 := Valute2FromPair(VirtualOrders[i].pair);

          Form1.sgVirtualOrders.Cells[0, k] := IntToStr(i);
          Form1.sgVirtualOrders.Cells[1, k] := VirtualOrders[i].AfterOrderID;
          Form1.sgVirtualOrders.Cells[2, k] := VirtualOrders[i].OType;
          Form1.sgVirtualOrders.Cells[3, k] := FloatToStr(VirtualOrders[i].rate) + ' ' + Valuta1;
          Form1.sgVirtualOrders.Cells[4, k] := FloatToStr(VirtualOrders[i].min_rate) + ' ' + Valuta1;
          Form1.sgVirtualOrders.Cells[5, k] := FloatToStr(VirtualOrders[i].amount) + ' ' + Valuta2;
          Form1.sgVirtualOrders.Cells[6, k] := FloatToStr(VirtualOrders[i].rate * VirtualOrders[i].amount) + ' ' + Valuta1;
          if VirtualOrders[i].MakeReverseOrder then
            Form1.sgVirtualOrders.Cells[7, k] := 'R flag'
          else
            Form1.sgVirtualOrders.Cells[7, k] := VirtualOrders[i].order_id;

          Form1.sgVirtualOrders.Cells[8, k] := VirtualOrders[i].pair;
          Form1.sgVirtualOrders.Cells[9, k] := FloatToStr(VirtualOrders[i].delta);
          Form1.sgVirtualOrders.Cells[10, k] := FloatToStr(VirtualOrders[i].step);
          Form1.sgVirtualOrders.Cells[11, k] := VirtualOrders[i].area;
          Form1.sgVirtualOrders.Cells[12, k] := VirtualOrders[i].comment;
          k := k + 1;
        end;
    Form1.sgVirtualOrders.RowCount := k;
  finally
  end;

  // Расчет остатка для текущего трейла
  SRVirt := Form1.sgVirtualOrders.Row;
  if Length(VirtualOrders) > 0 then
  begin
    for i := 0 to Length(VirtualOrders) - 1 do
      if (IntToStr(i) = Form1.sgVirtualOrders.Cells[0, SRVirt]) AND (VirtualOrders[i].area = 'trail_order') then
      begin
        Volume := VolumeUpPrice(VirtualOrders[i].rate, VirtualOrders[i].pair, ReverseOrderType(VirtualOrders[i].OType));
        Form1.Label48.caption := FloatToStr(Volume);
        Form1.Label49.caption := FloatToStr(Volume - (VirtualOrders[i].amount + AvergeLastXAmount(VirtualOrders[i].pair,
          ReverseOrderType(VirtualOrders[i].OType), VirtualOrders[i].MultiAverge)) * VirtualOrders[i].MultiAverge);
        Break;
      end
      else
        with Form1 do
        begin
          Label48.caption := '0';
          Label49.caption := '0';
        end;
  end
  else
    with Form1 do
    begin
      Label48.caption := '0';
      Label49.caption := '0';
    end;

  try
    // Сигналы
    Form1.sgSignalTab.RowCount := Length(CourseSignal) + 1;
    for i := 1 to Form1.sgSignalTab.RowCount - 1 do
      for j := 0 to Form1.sgSignalTab.ColCount - 1 do
        Form1.sgSignalTab.Cells[j, i] := '';
    k := 1;
    if Length(CourseSignal) > 0 then
      for i := 0 to Length(CourseSignal) - 1 do
        if not CourseSignal[i].deleted then
        begin
          Form1.sgSignalTab.Cells[0, k] := IntToStr(i + 1);
          Form1.sgSignalTab.Cells[1, k] := FloatToStr(CourseSignal[i].level);
          Form1.sgSignalTab.Cells[2, k] := CourseSignal[i].pair;
          k := k + 1;
        end;
    Form1.sgSignalTab.RowCount := k;
  finally

  end;

  // Strategy1
  Form1.sgStrateg1.RowCount := Length(Strateg1) + 1;
  for i := 1 to Form1.sgStrateg1.RowCount - 1 do
    for j := 0 to Form1.sgStrateg1.ColCount - 1 do
      Form1.sgStrateg1.Cells[j, i] := '';
  k := 1;
  if Length(Strateg1) > 0 then
    for i := 0 to Length(Strateg1) - 1 do
      if not Strateg1[i].deleted then
      begin
        Form1.sgStrateg1.Cells[0, k] := IntToStr(i);
        Form1.sgStrateg1.Cells[1, k] := Strateg1[i].pair;
        Form1.sgStrateg1.Cells[2, k] := IntToStr(Strateg1[i].SType);
        Form1.sgStrateg1.Cells[3, k] := FloatToStr(Strateg1[i].rate);
        Form1.sgStrateg1.Cells[4, k] := FloatToStr(Strateg1[i].lot);
        Form1.sgStrateg1.Cells[5, k] := FloatToStr(Strateg1[i].delta1F1);
        Form1.sgStrateg1.Cells[6, k] := FloatToStr(Strateg1[i].step1F1);

        k := k + 1;
      end;

  if ActivePair = 'btc_usd' then
    Form1.Label17.caption := 'USD'
  else if ActivePair = 'btc_rur' then
    Form1.Label17.caption := 'RUR'
  else if ActivePair = 'ltc_btc' then
    Form1.Label17.caption := 'BTC'
  else if ActivePair = 'ltc_usd' then
    Form1.Label17.caption := 'USD'
  else if ActivePair = 'ltc_rur' then
    Form1.Label17.caption := 'RUR'
  else if ActivePair = 'nmc_btc' then
    Form1.Label17.caption := 'BTC'
  else if ActivePair = 'nmc_usd' then
    Form1.Label17.caption := 'USD'
  else if ActivePair = 'nvc_btc' then
    Form1.Label17.caption := 'BTC'
  else if ActivePair = 'nvc_usd' then
    Form1.Label17.caption := 'USD'
  else if ActivePair = 'trc_btc' then
    Form1.Label17.caption := 'BTC'
  else if ActivePair = 'ppc_btc' then
    Form1.Label17.caption := 'BTC'
  else if ActivePair = 'ftc_btc' then
    Form1.Label17.caption := 'BTC'
  else if ActivePair = 'xpm_btc' then
    Form1.Label17.caption := 'BTC'
end;

procedure TForm1.sgVirtualOrdersClick(Sender: TObject);
begin
  UpdateSG;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i: Integer;
  kolvo: Integer;
  amount: real;
begin
  if not LoadedFiles then
    Exit;

  if NOT(IsDigit(EditPriceOpen.Text) and IsDigit(EditAmountOpen.Text) and IsDigit(TrailDelta.Text) and IsDigit(TrailStep.Text) AND
    (IsDigit(Strateg1Type.Text))) then
  begin
    ShowMessage('Проверьте реквизиты!');
    Exit;
  end;

  if chk1.Checked then // по верхней цене
    if IsDigit(EditPriceOpen.Text) and IsDigit(EditAmountOpen.Text) then
    begin
      amount := strtofloat(To4kToZap(EditAmountOpen.Text));
      SetLength(VirtualOrders, Length(VirtualOrders) + 1);
      VirtualOrders[Length(VirtualOrders) - 1].area := 'top_price';
      VirtualOrders[Length(VirtualOrders) - 1].pair := cbOpenPair.Text;
      VirtualOrders[Length(VirtualOrders) - 1].OType := cbTypeOpen.Text;
      VirtualOrders[Length(VirtualOrders) - 1].amount := amount;
      VirtualOrders[Length(VirtualOrders) - 1].rate := 0;
      VirtualOrders[Length(VirtualOrders) - 1].order_id := '';
      VirtualOrders[Length(VirtualOrders) - 1].AfterOrderID := '';
      if chk2.Checked then
      begin
        if EditPriceOpen.Text = '0' then
          VirtualOrders[Length(VirtualOrders) - 1].Children_price := 9999999
        else
          VirtualOrders[Length(VirtualOrders) - 1].Children_price := strtofloat(To4kToZap(EditPriceOpen.Text));;
        chk2.Checked := False;
      end;

      chk1.Checked := False;
      Log('Ордер будет открываться по верхней цене в стакане до завершения.');
      SaveVirtualOrders();
      Exit;
    end;

  if chk2.Checked then
    if IsDigit(EditPriceOpen.Text) and IsDigit(EditAmountOpen.Text) then
    begin
      SetLength(VirtualOrders, Length(VirtualOrders) + 1);
      VirtualOrders[Length(VirtualOrders) - 1].area := 'after_price';
      VirtualOrders[Length(VirtualOrders) - 1].pair := cbOpenPair.Text;
      VirtualOrders[Length(VirtualOrders) - 1].OType := cbTypeOpen.Text;
      VirtualOrders[Length(VirtualOrders) - 1].amount := strtofloat(To4kToZap(EditAmountOpen.Text));
      VirtualOrders[Length(VirtualOrders) - 1].rate := strtofloat(To4kToZap(EditPriceOpen.Text));
      VirtualOrders[Length(VirtualOrders) - 1].AfterOrderID := edt1.Text;
      SaveVirtualOrders();
      UpdateSG;
      Log('Виртуальный ордер создан.');
      chk2.Checked := False;
      Exit;
    end;

  if chTrailBox.Checked then
    if IsDigit(EditPriceOpen.Text) and IsDigit(EditAmountOpen.Text) and IsDigit(TrailDelta.Text) and IsDigit(TrailStep.Text) then
    begin
      if TrailDelta.Text = '0' then
      begin
        ShowMessageUser('Нельзя трейлить с нулевым отступом!');
        Exit;
      end;

      SetLength(VirtualOrders, Length(VirtualOrders) + 1);
      VirtualOrders[Length(VirtualOrders) - 1].area := 'trail_order';
      VirtualOrders[Length(VirtualOrders) - 1].pair := cbOpenPair.Text;
      VirtualOrders[Length(VirtualOrders) - 1].OType := cbTypeOpen.Text;
      VirtualOrders[Length(VirtualOrders) - 1].amount := strtofloat(To4kToZap(EditAmountOpen.Text));
      VirtualOrders[Length(VirtualOrders) - 1].rate := strtofloat(To4kToZap(EditPriceOpen.Text));
      VirtualOrders[Length(VirtualOrders) - 1].min_rate := strtofloat(To4kToZap(EditPriceOpen.Text));
      VirtualOrders[Length(VirtualOrders) - 1].step := strtofloat(To4kToZap(TrailStep.Text));
      VirtualOrders[Length(VirtualOrders) - 1].delta := strtofloat(To4kToZap(TrailDelta.Text));
      VirtualOrders[Length(VirtualOrders) - 1].MultiAverge := StrToInt(edtMultiAverge.Text);
      VirtualOrders[Length(VirtualOrders) - 1].first_step := strtofloat(To4kToZap(TrailFirstStep.Text));
      if cbOpenReverseOrder.Checked then
        VirtualOrders[Length(VirtualOrders) - 1].MakeReverseOrder := True
      else
        VirtualOrders[Length(VirtualOrders) - 1].MakeReverseOrder := False;
      SaveVirtualOrders();
      UpdateSG;
      Log('Виртуальный ордер создан.');
      chk2.Checked := False;
      chTrailBox.Checked := False;
      cbOpenReverseOrder.Checked := False;
      Exit;
    end;

  if cbStrateg1.Checked then
  begin
    SetLength(Strateg1, Length(Strateg1) + 1);
    Strateg1[Length(Strateg1) - 1].pair := cbOpenPair.Text;
    Strateg1[Length(Strateg1) - 1].SType := StrToInt(To4kToZap(Strateg1Type.Text));
    Strateg1[Length(Strateg1) - 1].rate := strtofloat(To4kToZap(EditPriceOpen.Text));
    Strateg1[Length(Strateg1) - 1].lot := strtofloat(To4kToZap(EditAmountOpen.Text));
    Strateg1[Length(Strateg1) - 1].delta1F1 := strtofloat(To4kToZap(Str1Delta.Text));
    Strateg1[Length(Strateg1) - 1].step1F1 := strtofloat(To4kToZap(Str1Step.Text));
    Strateg1[Length(Strateg1) - 1].multi := StrToInt(To4kToZap(edtMultiAverge.Text));
    Strateg1[Length(Strateg1) - 1].delta1F2 := strtofloat(To4kToZap(Str2Delta.Text));
    Strateg1[Length(Strateg1) - 1].step1F2 := strtofloat(To4kToZap(Str2Step.Text));
    Strateg1[Length(Strateg1) - 1].delta2 := strtofloat(To4kToZap(TrailDelta.Text));
    Strateg1[Length(Strateg1) - 1].step2 := strtofloat(To4kToZap(TrailStep.Text));
    Strateg1[Length(Strateg1) - 1].first_step := strtofloat(To4kToZap(TrailFirstStep.Text));
    Log('Стратегия добавлена.');
    SaveStrateg();
    Exit;
  end;

  if IsDigit(EditPriceOpen.Text) and IsDigit(EditAmountOpen.Text) then
  begin
    Log(SendOrder(cbOpenPair.Text, cbTypeOpen.Text, strtofloat(To4kToZap(EditPriceOpen.Text)), strtofloat(To4kToZap(EditAmountOpen.Text)), True));
  end
  else
    ShowMessage('Проверьте реквизиты!');
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  i, j: Integer;
begin
  if not LoadedFiles then
    Exit;
  if Length(VirtualOrders) > 0 then

    for i := 0 to Length(VirtualOrders) - 1 do
      if IntToStr(i) = sgVirtualOrders.Cells[0, sgVirtualOrders.Row] then
        VirtualOrders[i].deleted := True;
  SaveVirtualOrders();
  UpdateSG;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  i, j: Integer;
begin
  if not LoadedFiles then
    Exit;

  for i := 0 to Length(CourseSignal) - 1 do
    if (FloatToStr(CourseSignal[i].level) = sgSignalTab.Cells[1, sgSignalTab.Row]) and (CourseSignal[i].pair = sgSignalTab.Cells[2, sgSignalTab.Row])
    then
      CourseSignal[i].deleted := True;
  UpdateSG;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  if IsDigit(EditPriceOpen.Text) and IsDigit(EditAmountOpen.Text) then
  begin
    if cbOpenPair.Text = 'btc_usd' then
      if SP_BTCUSD < 0.6 then
      begin
        ShowMessage('Слишком маленький сперд!');
        Exit
      end;
    if cbOpenPair.Text = 'btc_rur' then
      if SP_BTCRUR < 0.6 then
      begin
        ShowMessage('Слишком маленький сперд!');
        Exit
      end;
    if cbOpenPair.Text = 'ltc_btc' then
      if SP_LTCBTC < 0.6 then
      begin
        ShowMessage('Слишком маленький сперд!');
        Exit
      end;
    if cbOpenPair.Text = 'ltc_usd' then
      if SP_LTCUSD < 0.6 then
      begin
        ShowMessage('Слишком маленький сперд!');
        Exit
      end;
    if cbOpenPair.Text = 'ltc_rur' then
      if SP_LTCRUR < 0.6 then
      begin
        ShowMessage('Слишком маленький сперд!');
        Exit
      end;

    if TopPrice(cbOpenPair.Text, cbTypeOpen.Text, 0.00001) = TopPrice(cbOpenPair.Text, ReverseOrderType(cbTypeOpen.Text)) then
    begin
      ShowMessage('Уперлись в противоположный ордер!!!');
      Exit;
    end;

    Log(SendOrder(cbOpenPair.Text, cbTypeOpen.Text, TopPrice(cbOpenPair.Text, cbTypeOpen.Text, 0.00001),
      strtofloat(To4kToZap(EditAmountOpen.Text)), True));
  end
  else
    ShowMessage('Проверьте реквизиты!');
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  ListBox1.Clear;
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  i: Integer;
begin
  if Length(Strateg1) > 0 then
    for i := 0 to Length(Strateg1) - 1 do
      if IntToStr(i) = sgStrateg1.Cells[0, sgStrateg1.Row] then
        Strateg1[i].deleted := True;
  SaveStrateg();
  UpdateSG;
end;

procedure TForm1.Button8Click(Sender: TObject);
var i:Integer;
begin
  if not LoadedFiles then
    Exit;
  if Length(VirtualOrders) > 0 then
    for i := 0 to Length(VirtualOrders) - 1 do
      if IntToStr(i) = sgVirtualOrders.Cells[0, sgVirtualOrders.Row] then
        VirtualOrders[i].comment := '';
  UpdateSG;
end;

procedure TForm1.cbOpenPairChange(Sender: TObject);
begin
  UpdateSG;
  UpdateSumm;
end;

procedure TForm1.cbStrateg1Click(Sender: TObject);
begin
  if cbStrateg1.Checked then
  begin
    cbOpenReverseOrder.Checked := False;
    chTrailBox.Checked := False;
    chk1.Checked := False;
    chk2.Checked := False;
  end;
end;

procedure TForm1.cbTypeOpenChange(Sender: TObject);
begin
  if cbTypeOpen.Text = 'sell' then
  begin
    cbTypeOpen.Color := clRed;
    cbTypeOpen.Font.Color := clBlack;
  end
  else
  begin
    cbTypeOpen.Color := clBlue;
    cbTypeOpen.Font.Color := clWhite;
  end;
end;

procedure TForm1.chActiveCurrentClick(Sender: TObject);
begin
  UpdateSG;
end;

procedure TForm1.chHistoryActiveClick(Sender: TObject);
begin
  UpdateSG;
end;

procedure TForm1.chk1Click(Sender: TObject);
begin
  if chk1.Checked then
  begin
    chk2.Checked := False;
    chTrailBox.Checked := False;
  end;
end;

procedure TForm1.chk2Click(Sender: TObject);
begin
  if chk2.Checked then
  begin
    chk1.Checked := False;
    chTrailBox.Checked := False;
  end;
end;

procedure TForm1.chTrailBoxClick(Sender: TObject);
begin
  if chTrailBox.Checked then
  begin
    chk1.Checked := False;
    chk2.Checked := False;
  end;
end;

procedure TForm1.EditAmountOpenChange(Sender: TObject);
begin
  UpdateSumm;
end;

procedure TForm1.EditPriceOpenChange(Sender: TObject);
begin
  UpdateSumm;
end;

procedure TForm1.TabSheet1Show(Sender: TObject);
begin
  if (Sender = TabSheet1) then
    ActivePair := 'btc_usd'
  else if (Sender = TabSheet2) then
    ActivePair := 'btc_rur'
  else if (Sender = TabSheet3) then
    ActivePair := 'ltc_btc'
  else if (Sender = TabSheet4) then
    ActivePair := 'ltc_usd'
  else if (Sender = TabSheet5) then
    ActivePair := 'ltc_rur'
  else if (Sender = TabSheet9) then
    ActivePair := 'nmc_btc'
  else if (Sender = TabSheet10) then
    ActivePair := 'nmc_usd'
  else if (Sender = TabSheet11) then
    ActivePair := 'nvc_btc'
  else if (Sender = TabSheet12) then
    ActivePair := 'nvc_usd'
  else if (Sender = TabSheet13) then
    ActivePair := 'trc_btc'
  else if (Sender = TabSheet14) then
    ActivePair := 'ppc_btc'
  else if (Sender = TabSheet15) then
    ActivePair := 'xpm_btc';

  cbOpenPair.Text := ActivePair;
  GlobalSelectedOrder := '';
  UpdateSG;
end;

procedure TForm1.tPlaySignalTimer(Sender: TObject);
begin
  if tPlaySignal.Interval = 28000 then
  begin
    tPlaySignal.Enabled := False;
    tPlaySignal.Interval := 10;
    Exit;
  end;
  tPlaySignal.Interval := 28000;
  //Log('try play signal');
  PlaySound('music1.wav', 0, SND_ASYNC);
end;

procedure TForm1.TRCBalanceLabelClick(Sender: TObject);
begin
  EditAmountOpen.Text := TRCBalanceLabel.caption;
end;

procedure TForm1.StartThrTimer(Sender: TObject);
begin
  if not LoadedFiles then
    Exit;

  // try
  // if TGetPrice1.Finished then
  // TGetPrice1.Free;
  // except
  // end;
//  TGetPrice1 := TGetPrice.Create(True);
//  TGetPrice1.FreeOnTerminate := True;
//  TGetPrice1.priority := tpNormal;
//  TGetPrice1.Resume;

  // try
  // if TGetPrice2.Finished then
  // TGetPrice2.Free;
  // except
  // end;
//  TGetPrice2 := T2GetPrice.Create(True);
//  TGetPrice2.FreeOnTerminate := True;
//  TGetPrice2.priority := tpNormal;
//  TGetPrice2.Resume;

  // try
  // if TGetPrice3.Finished then
  // TGetPrice3.Free;
  // except
  // end;
//  TGetPrice3 := T3GetPrice.Create(True);
//  TGetPrice3.FreeOnTerminate := True;
//  TGetPrice3.priority := tpNormal;
//  TGetPrice3.Resume;

  // try
  // if TGetPrice4.Finished then
  // TGetPrice4.Free;
  // except
  // end;
//  TGetPrice4 := T4GetPrice.Create(True);
//  TGetPrice4.FreeOnTerminate := True;
//  TGetPrice4.priority := tpNormal;
//  TGetPrice4.Resume;

  // try
  // if TGetPrice5.Finished then
  // TGetPrice5.Free;
  // except
  // end;



    TGetPrice5 := T5GetPrice.Create(True);
    TGetPrice5.FreeOnTerminate := True;
    TGetPrice5.priority := tpNormal;
    TGetPrice5.Resume;


  // try
  // if TGetPrice6.Finished then
  // TGetPrice6.Free;
  // except
  // end;
//  TGetPrice6 := T6GetPrice.Create(True);
//  TGetPrice6.FreeOnTerminate := True;
//  TGetPrice6.priority := tpNormal;
//  TGetPrice6.Resume;

  // try
  // if TGetPrice7.Finished then
  // TGetPrice7.Free;
  // except
  // end;
  TGetPrice7 := T7GetPrice.Create(True);
  TGetPrice7.FreeOnTerminate := True;
  TGetPrice7.priority := tpNormal;
  TGetPrice7.Resume;

  // try
  // if TGetPrice8.Finished then
  // TGetPrice8.Free;
  // except
  // end;
//  TGetPrice8 := T8GetPrice.Create(True);
//  TGetPrice8.FreeOnTerminate := True;
//  TGetPrice8.priority := tpNormal;
//  TGetPrice8.Resume;

  // try
  // if TGetPrice9.Finished then
  // TGetPrice9.Free;
  // except
  // end;
//  TGetPrice9 := T9GetPrice.Create(True);
//  TGetPrice9.FreeOnTerminate := True;
//  TGetPrice9.priority := tpNormal;
//  TGetPrice9.Resume;

  // try
  // if TGetPrice10.Finished then
  // TGetPrice10.Free;
  // except
  // end;
//  TGetPrice10 := T10GetPrice.Create(True);
//  TGetPrice10.FreeOnTerminate := True;
//  TGetPrice10.priority := tpNormal;
//  TGetPrice10.Resume;

  // try
  // if TGetPrice11.Finished then
  // TGetPrice11.Free;
  // except
  // end;
//  TGetPrice11 := T11GetPrice.Create(True);
//  TGetPrice11.FreeOnTerminate := True;
//  TGetPrice11.priority := tpNormal;
//  TGetPrice11.Resume;

  // try
  // if TGetPrice12.Finished then
  // TGetPrice12.Free;
  // except
  // end;
//  TGetPrice12 := T12GetPrice.Create(True);
//  TGetPrice12.FreeOnTerminate := True;
//  TGetPrice12.priority := tpNormal;
//  TGetPrice12.Resume;

  // try
  // if TSendZapros1.Finished then
  // TSendZapros1.Free;
  // except
  // end;
  TSendZapros1 := TSendZapros.Create(True);
  TSendZapros1.FreeOnTerminate := True;
  TSendZapros1.priority := tpNormal;
  TSendZapros1.Resume;

//  if not NZHistory1 then
//  begin
//    TGetHistory1 := T1GetHistory.Create(True);
//    TGetHistory1.FreeOnTerminate := True;
//    TGetHistory1.priority := tpNormal;
//    TGetHistory1.Resume;
//  end;

  // TGetHistory2 := T2GetHistory.Create(True);
  // TGetHistory2.FreeOnTerminate := True;
  // TGetHistory2.priority := tpNormal;
  // TGetHistory2.Resume;
end;

// Таймер 1
procedure TForm1.UpdateTimerTimer(Sender: TObject);
begin
  // Интерфейс
  BTCBalanceLabel.caption := FloatToStr(Balance.BTC);
  LTCBalanceLabel.caption := FloatToStr(Balance.LTC);
  RURBalanceLabel.caption := OkrugStr(FloatToStr(Balance.RUR), 3);
  NVCBalanceLabel.caption := FloatToStr(Balance.NVC);
  TRCBalanceLabel.caption := FloatToStr(Balance.TRC);
  FTCBalanceLabel.caption := FloatToStr(Balance.FTC);
  USDBalanceLabel.caption := FloatToStr(Balance.USD);

  if not LoadedFiles then
    Exit;

  if MojnoBrat then
    UpdateSG();

  ControlVirtualOrder();
  ControlSignal();
  ControlStrateg1();
  CustomWork;
end;

procedure TForm1.USDBalanceLabelClick(Sender: TObject);
begin
  EditAmountOpen.Text := USDBalanceLabel.caption;
end;

end.
