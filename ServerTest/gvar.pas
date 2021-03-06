unit Gvar;

interface

uses System.SysUtils, System.DateUtils, Types, Winapi.Windows, TLHELP32, Classes, StdCtrls,
  Data.DBXJSON, Winapi.Messages,
  Vcl.Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,
  IdExplicitTLSClientServerBase,
  IdMessageClient, IdSMTPBase, IdSMTP, IdMessage, IdHTTP, SyncObjs, ComObj;


type
  TBalance = record
    BTC: Extended;
    LTC: Extended;
    NMC: Extended;
    NVC: Extended;
    TRC: Extended;
    PPC: Extended;
    FTC: Extended;
    XPM: Extended;
    USD: Extended;
    RUR: Extended;
    EUR: Extended;
  end;

  TDepth = record
    price: Extended;
    Volume: Extended;
  end;

  ATDepth = array of TDepth;

  TOrders = record
    order_id: string[20];
    pair: string[10];
    OType: string[4];
    amount: Extended;
    rate: Extended;
    timestamp: Integer;
    status: Integer;
  end;

  TMaxMin = record
    rate: Extended;
    timestamp: Integer;
  end;

  TOrderHistory = record
    order_id: string[20];
    pair: string[10];
    OType: string[4];
    amount: Extended;
    rate: Extended;
    timestamp: Integer;
    is_you_order: Integer;
    CloseOrder: string[100];
    NonClosedAmount:Extended;
  end;

  TVirtualOrder = record
    area: string[20];
    pair: string[7];
    OType: string[4];
    amount: Extended;
    rate: Extended;
    min_rate: Extended;
    step: Extended;
    stepF1: Extended;
    step2: Extended;
    MultiAverge: Integer;
    AfterOrderID: string[10];
    order_id: string[50];
    Children_price: Extended;
    delta: Extended;
    deltaF1: Extended;
    delta2: Extended;
    MakeReverseOrder:Boolean;
    comment:string[50];
    deleted: Boolean;
    first_step:Extended;
    Next_Chance: Integer;
  end;

  TTCourseSignal = record
    level: Extended;
    TekCourse: Extended;
    pair: string[10];
    deleted: Boolean;
  end;

  TGlobalOrderHistory = record
    typeOrder: string[4];
    price: Extended;
    amount: Extended;
    tid: string[20];
    timestamp: Integer;
  end;

 TTGlobalOrderHistory = array of TGlobalOrderHistory;

function IsDigit(s: string): Boolean;
function IsDate(s: string): Boolean;
function GetComputerNName: string;
function alphamin(s: string): string;
function GetFileDate(FileName: string): string;
function GetDateT: string;
function GetProcess: TStringList;
function FileVersion(AFileName: string): string;
function GetFileSize(const FileName: string): longint;
function TimeBezTochek(k: TdateTime): string;
function DateBezTochek(k: TdateTime): string;
function ZapToT4k(s: string): string;
function To4kToZap(s: string): string;
function OkrugStr(s: string; amt: Integer): string;
function Valute1FromPair(pair: string): string;
function Valute2FromPair(pair: string): string;
function TopPrice(pair: string; Order_type: string; plus: Extended = 0): Extended;
function ReverseOrderType(OType: string): string;
function StrToStrFloat(str: string): string;
function SendMessageToClient(msg: string):WideString;
function SendOrder(pair: string; type_order: string; rate: Extended; Volume: Extended): string;
function VolumeUpPrice(price: Extended; pair: string; OType: string): Extended;
function AvergeLastXAmount(pair: string; OType: string; x: Integer): Extended;
function AvergeForLast(var HistArray: TTGlobalOrderHistory; ot: string; x: Integer): Extended;
procedure SaveCourseSignal();
procedure LoadCourseSignal();
procedure SaveVirtualOrders();
procedure SendEmail(Subj:string; messag:string);
function GetPrice():Boolean;
procedure SaveToXLS(TimeStamp:string = '');
procedure balanceProc();
procedure CalculateLevels();

var
  AsksBTCUSD, BidsBTCUSD, AsksBTCRUR, BidsBTCRUR, AsksLTCBTC, BidsLTCBTC, AsksLTCUSD, BidsLTCUSD, AsksLTCRUR, BidsLTCRUR, AsksLTCEUR, BidsLTCEUR,
    AsksNMCBTC, BidsNMCBTC, AsksNMCUSD, BidsNMCUSD, AsksNVCBTC, BidsNVCBTC, AsksNVCUSD, BidsNVCUSD, AsksTRCBTC, BidsTRCBTC, AsksPPCBTC, BidsPPCBTC,
    AsksFTCBTC, BidsFTCBTC, AsksXPMBTC, BidsXPMBTC: ATDepth;
  ActiveOrders: array of TOrders;
  OrderHistory: array of TOrderHistory;

  VirtualOrders: array of TVirtualOrder;
  CourseSignal: array of TTCourseSignal;
  CancelOrdersList: array of string;
  BidWalls,AskWalls:array of TDepth; // ������� ������

  GlobalBTCUSD, GlobalBTCRUR, GlobalLTCBTC, GlobalLTCUSD, GlobalLTCRUR, GlobalNMCBTC, GlobalNMCUSD, GlobalNVCBTC, GlobalNVCUSD, GlobalTRCBTC,
    GlobalPPCBTC, GlobalXPMBTC: TTGlobalOrderHistory;
  Balance: TBalance;
  gpath,exename, LastCommand, proxy_ip:string;
  proxy_port:Integer;
  SellPrice,BuyPrice:Extended;
  CS1{��� ��������},CS2{��� GetInfo},CS3{��� ActiveOrders},CS4{��� ������},CS5{��� �������}: TCriticalSection;
  Vol100Sell,Vol100Buy,MainSellLevel,MainBuyLevel:Extended;
  BalanceUSDProc:Integer;
  Min12h,Max12h,Min6h,Max6h,Min4h,Max4h,Min1d,Max1d,Min1h,Max1h,Min30m,Max30m,Min15m,Max15m,Min5m,Max5m:TMaxMin;
  LastBuy2,LastSell2:TMaxMin;
  MaxVolBuy15,MaxVolSell15:Extended;
implementation

function GetPrice():Boolean;
var
  GetStr: WideString;
  http: TIdHTTP;
  ssl: TIdSSLIOHandlerSocketOpenSSL;
begin
  Result := True;
  http := TIdHTTP.Create();
  ssl := TIdSSLIOHandlerSocketOpenSSL.Create();
  try
    http.IOHandler := ssl;
    http.ReadTimeout := 5000;
    ssl.ReadTimeout := 5000;
    try
      // ****************** LTC/USD ************************************
      GetStr := http.Get('https://btc-e.com/api/2/btc_usd/depth');
    Except
      Result := False;
    end;
  finally
    GetStr:='';
    FreeAndNil(http);
    FreeAndNil(ssl);
  end;
end;

// ���������� ��������� �� �����
function SendMessageToClient(msg: string):WideString;
var
  client: TIdTCPClient;
  hnd: TIdIOHandlerStack;
begin
  Result := '';
  client := TIdTCPClient.Create();
  client.Host := proxy_ip;
  client.Port := proxy_port;
  client.ReadTimeout := 5000;
  hnd := TIdIOHandlerStack.Create();
  hnd.MaxLineLength := 10000000;
  client.IOHandler := hnd;
  try
    try
     client.Connect;
    except
      Result := 'Connection error';
    end;

    try
      if client.Connected then
      begin
       client.Socket.WriteLn(msg);
       Result := client.Socket.ReadLn();
       client.Disconnect;
      end;
    Except
      Result := 'Connection error';
    end;
  finally
    FreeAndNil(client);
    FreeAndNil(hnd);
  end;
end;

function SendOrder(pair: string; type_order: string; rate: Extended; Volume: Extended): string;
begin
  Result := SendMessageToClient('Trade&pair=' + pair + '&type=' + type_order + '&rate=' + ZapToT4k(FloatToStr(rate)) + '&amount=' +
    ZapToT4k(FloatToStrF(Volume, ffgeneral, 8, 8)));
end;

procedure SendEmail(Subj:string; messag:string);
var
  IdMessage1:TIdMessage;
  IdSMTP: TIdSMTP;
  IdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
begin
  { ��������� ���� ��������� }
  IdMessage1 := TIdMessage.Create;
  IdMessage1.From.Address := 'hudrolax@mail.ru';
  IdMessage1.Recipients.EMailAddresses := 'hudro795@gmail.com';
  IdMessage1.Subject := UTF8Encode(Subj);
  IdMessage1.Body.Append(UTF8Encode(messag));
  IdMessage1.Date := now;

  { ��������� ����������� ����� ��������� }
  IdSMTP := TIdSMTP.Create(nil);

  IdSMTP.Host := 'smtp.mail.ru';
  IdSMTP.Port := 465;
  // ������ ��� ������������� ssl 495, 587 ��� ����������� 25
  IdSMTP.Username := 'hudrolax@mail.ru';
  IdSMTP.Password := 'Eremes2inholl7950295';

  { ��� ���������� ������������ ��� SSL }
  IdSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  IdSSLIOHandlerSocketOpenSSL.Destination := IdSMTP.Host + ':' +
    IntToStr(IdSMTP.Port);
  IdSSLIOHandlerSocketOpenSSL.Host := IdSMTP.Host;
  IdSSLIOHandlerSocketOpenSSL.Port := IdSMTP.Port;
  IdSSLIOHandlerSocketOpenSSL.DefaultPort := 0;
  IdSSLIOHandlerSocketOpenSSL.SSLOptions.Method := sslvTLSv1;
  IdSSLIOHandlerSocketOpenSSL.SSLOptions.Mode := sslmUnassigned;

  IdSMTP.IOHandler := IdSSLIOHandlerSocketOpenSSL;
  IdSMTP.UseTLS := utUseExplicitTLS;

  { ���������� ������ }
  IdSMTP.Connect();
  IdSMTP.Send(IdMessage1);
  IdSMTP.Disconnect;
  { ������� ������ }
  IdMessage1.Free;
  IdSSLIOHandlerSocketOpenSSL.Free;
  IdSMTP.Free;
end;

function ReverseOrderType(OType: string): string;
begin
  if OType = 'sell' then
    Result := 'buy'
  else
    Result := 'sell';
end;

function TopPrice(pair: string; Order_type: string; plus: Extended = 0): Extended;
begin
  Result := 0;
  if pair = 'btc_usd' then
  begin
    if Order_type = 'sell' then
      Result := AsksBTCUSD[0].price - plus;
    if Order_type = 'buy' then
      Result := BidsBTCUSD[0].price + plus;
    Exit;
  end;

  if pair = 'btc_rur' then
  begin
    if Order_type = 'sell' then
      Result := AsksBTCRUR[0].price - plus;
    if Order_type = 'buy' then
      Result := BidsBTCRUR[0].price + plus;
    Exit;
  end;

  if pair = 'ltc_btc' then
  begin
    if Order_type = 'sell' then
      Result := AsksLTCBTC[0].price - plus;
    if Order_type = 'buy' then
      Result := BidsLTCBTC[0].price + plus;
    Exit;
  end;

  if pair = 'ltc_usd' then
  begin
    if Order_type = 'sell' then
      Result := AsksLTCUSD[0].price - plus;
    if Order_type = 'buy' then
      Result := BidsLTCUSD[0].price + plus;
    Exit;
  end;

  if pair = 'ltc_rur' then
  begin
    if Order_type = 'sell' then
      Result := AsksLTCRUR[0].price - plus;
    if Order_type = 'buy' then
      Result := BidsLTCRUR[0].price + plus;
    Exit;
  end;

  if pair = 'nmc_btc' then
  begin
    if Order_type = 'sell' then
      Result := AsksNMCBTC[0].price - plus;
    if Order_type = 'buy' then
      Result := BidsNMCBTC[0].price + plus;
    Exit;
  end;

  if pair = 'nmc_usd' then
  begin
    if Order_type = 'sell' then
      Result := AsksNMCUSD[0].price - plus;
    if Order_type = 'buy' then
      Result := BidsNMCUSD[0].price + plus;
    Exit;
  end;

  if pair = 'nvc_btc' then
  begin
    if Order_type = 'sell' then
      Result := AsksNVCBTC[0].price - plus;
    if Order_type = 'buy' then
      Result := BidsNVCBTC[0].price + plus;
    Exit;
  end;

  if pair = 'nvc_usd' then
  begin
    if Order_type = 'sell' then
      Result := AsksNVCUSD[0].price - plus;
    if Order_type = 'buy' then
      Result := BidsNVCUSD[0].price + plus;
    Exit;
  end;

  if pair = 'trc_btc' then
  begin
    if Order_type = 'sell' then
      Result := AsksTRCBTC[0].price - plus;
    if Order_type = 'buy' then
      Result := BidsTRCBTC[0].price + plus;
    Exit;
  end;

  if pair = 'ppc_btc' then
  begin
    if Order_type = 'sell' then
      Result := AsksPPCBTC[0].price - plus;
    if Order_type = 'buy' then
      Result := BidsPPCBTC[0].price + plus;
    Exit;
  end;

  if pair = 'xpm_btc' then
  begin
    if Order_type = 'sell' then
      Result := AsksXPMBTC[0].price - plus;
    if Order_type = 'buy' then
      Result := BidsXPMBTC[0].price + plus;
    Exit;
  end;
end;

function Valute2FromPair(pair: string): string;
begin
  if pair = 'btc_usd' then
  begin
    Result := 'USD';
  end
  else if pair = 'btc_rur' then
  begin
    Result := 'RUR';
  end
  else if pair = 'ltc_btc' then
  begin
    Result := 'BTC';
  end
  else if pair = 'ltc_usd' then
  begin
    Result := 'USD';
  end
  else if pair = 'ltc_rur' then
  begin
    Result := 'RUR';
  end
  else if pair = 'ltc_eur' then
  begin
    Result := 'EUR';
  end
  else if pair = 'nmc_btc' then
  begin
    Result := 'BTC';
  end
  else if pair = 'nmc_usd' then
  begin
    Result := 'USD';
  end
  else if pair = 'nvc_btc' then
  begin
    Result := 'BTC';
  end
  else if pair = 'nmc_usd' then
  begin
    Result := 'USD';
  end
  else if pair = 'usd_rur' then
  begin
    Result := 'RUR';
  end
  else if pair = 'trc_btc' then
  begin
    Result := 'BTC';
  end
  else if pair = 'ppc_btc' then
  begin
    Result := 'BTC';
  end
  else if pair = 'ftc_btc' then
  begin
    Result := 'BTC';
  end
  else if pair = 'xpm_btc' then
  begin
    Result := 'BTC';
  end;
end;

function Valute1FromPair(pair: string): string;
begin
  if pair = 'btc_usd' then
  begin
    Result := 'BTC';
  end
  else if pair = 'btc_rur' then
  begin
    Result := 'BTC';
  end
  else if pair = 'ltc_btc' then
  begin
    Result := 'LTC';
  end
  else if pair = 'ltc_usd' then
  begin
    Result := 'LTC';
  end
  else if pair = 'ltc_rur' then
  begin
    Result := 'LTC';
  end
  else if pair = 'ltc_eur' then
  begin
    Result := 'LTC';
  end
  else if pair = 'nmc_btc' then
  begin
    Result := 'NMC';
  end
  else if pair = 'nmc_usd' then
  begin
    Result := 'NMC';
  end
  else if pair = 'nvc_btc' then
  begin
    Result := 'NVC';
  end
  else if pair = 'nmc_usd' then
  begin
    Result := 'NVC';
  end
  else if pair = 'usd_rur' then
  begin
    Result := 'USD';
  end
  else if pair = 'trc_btc' then
  begin
    Result := 'TRC';
  end
  else if pair = 'ppc_btc' then
  begin
    Result := 'PPC';
  end
  else if pair = 'ftc_btc' then
  begin
    Result := 'FTC';
  end
  else if pair = 'xpm_btc' then
  begin
    Result := 'XPM';
  end;
end;

function FileVersion(AFileName: string): string;
var
  szName: array [0 .. 255] of Char;
  P: Pointer;
  Value: Pointer;
  Len: UINT;
  GetTranslationString: string;
  FFileName: PChar;
  FValid: Boolean;
  FSize: DWORD;
  FHandle: DWORD;
  FBuffer: PChar;
begin
  try
    FFileName := StrPCopy(StrAlloc(Length(AFileName) + 1), AFileName);
    FValid := false;
    FSize := GetFileVersionInfoSize(FFileName, FHandle);
    if FSize > 0 then
      try
        GetMem(FBuffer, FSize);
        FValid := GetFileVersionInfo(FFileName, FHandle, FSize, FBuffer);
      except
        FValid := false;
        raise;
      end;
    Result := '';
    if FValid then
      VerQueryValue(FBuffer, '\VarFileInfo\Translation', P, Len)
    else
      P := nil;
    if P <> nil then
      GetTranslationString := IntToHex(MakeLong(HiWord(longint(P^)), LoWord(longint(P^))), 8);
    if FValid then
    begin
      StrPCopy(szName, '\StringFileInfo\' + GetTranslationString + '\FileVersion');
      if VerQueryValue(FBuffer, szName, Value, Len) then
        Result := StrPas(PChar(Value));
    end;
  finally
    try
      if FBuffer <> nil then
        FreeMem(FBuffer, FSize);
    except
    end;
    try
      StrDispose(FFileName);
    except
    end;
  end;
end;

// ���������� ������ �����
function GetFileSize(const FileName: string): longint;
var
  SearchRec: TSearchRec;
begin
  if FindFirst(ExpandFileName(FileName), faAnyFile, SearchRec) = 0 then
    Result := SearchRec.Size
  else
    Result := -1;
  FindClose(SearchRec.FindHandle);
end;

function GetProcess: TStringList;
const
  PROCESS_TERMINATE = $0001;
var
  Co: BOOL;
  FS: THandle;
  FP: TProcessEntry32;
begin
  Result := TStringList.Create;
  FS := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FP.dwSize := Sizeof(FP);
  Co := Process32First(FS, FP);
  while Integer(Co) <> 0 do
  begin
    Result.Add(FP.szExeFile);
    Co := Process32Next(FS, FP);
  end;
  CloseHandle(FS);
end;

function GetDateT: string;
begin
  Result := Datetostr(date) + ' ' + timetostr(time);
end;

function GetFileDate(FileName: string): string;
var
  FHandle: Integer;

begin
  FHandle := FileOpen(FileName, 0);
  try
    Result := DateTimeToStr(FileDateToDateTime(FileGetDate(FHandle)));
  finally
    FileClose(FHandle);
  end;
end;

function alphamin(s: string): string;
var
  i: Integer;
  s1: string;
begin
  s1 := '';
  alphamin := '';
  for i := 1 to Length(s) do
    // �������
    if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
      s1 := s1 + '�'
    else
      // ���������
      if (copy(s, i, 1) = 'Q') or (copy(s, i, 1) = 'q') then
        s1 := s1 + 'q'
      else if (copy(s, i, 1) = 'W') or (copy(s, i, 1) = 'w') then
        s1 := s1 + 'w'
      else if (copy(s, i, 1) = 'E') or (copy(s, i, 1) = 'e') then
        s1 := s1 + 'e'
      else if (copy(s, i, 1) = 'R') or (copy(s, i, 1) = 'r') then
        s1 := s1 + 'r'
      else if (copy(s, i, 1) = 'T') or (copy(s, i, 1) = 't') then
        s1 := s1 + 't'
      else if (copy(s, i, 1) = 'Y') or (copy(s, i, 1) = 'y') then
        s1 := s1 + 'y'
      else if (copy(s, i, 1) = 'U') or (copy(s, i, 1) = 'u') then
        s1 := s1 + 'u'
      else if (copy(s, i, 1) = 'I') or (copy(s, i, 1) = 'i') then
        s1 := s1 + 'i'
      else if (copy(s, i, 1) = 'O') or (copy(s, i, 1) = 'o') then
        s1 := s1 + 'o'
      else if (copy(s, i, 1) = 'P') or (copy(s, i, 1) = 'p') then
        s1 := s1 + 'p'
      else if (copy(s, i, 1) = 'A') or (copy(s, i, 1) = 'a') then
        s1 := s1 + 'a'
      else if (copy(s, i, 1) = 'S') or (copy(s, i, 1) = 's') then
        s1 := s1 + 's'
      else if (copy(s, i, 1) = 'D') or (copy(s, i, 1) = 'd') then
        s1 := s1 + 'd'
      else if (copy(s, i, 1) = 'F') or (copy(s, i, 1) = 'f') then
        s1 := s1 + 'f'
      else if (copy(s, i, 1) = 'G') or (copy(s, i, 1) = 'g') then
        s1 := s1 + 'g'
      else if (copy(s, i, 1) = 'H') or (copy(s, i, 1) = 'h') then
        s1 := s1 + 'h'
      else if (copy(s, i, 1) = 'J') or (copy(s, i, 1) = 'j') then
        s1 := s1 + 'j'
      else if (copy(s, i, 1) = 'K') or (copy(s, i, 1) = 'k') then
        s1 := s1 + 'k'
      else if (copy(s, i, 1) = 'L') or (copy(s, i, 1) = 'l') then
        s1 := s1 + 'l'
      else if (copy(s, i, 1) = 'Z') or (copy(s, i, 1) = 'z') then
        s1 := s1 + 'z'
      else if (copy(s, i, 1) = 'X') or (copy(s, i, 1) = 'x') then
        s1 := s1 + 'x'
      else if (copy(s, i, 1) = 'C') or (copy(s, i, 1) = 'c') then
        s1 := s1 + 'c'
      else if (copy(s, i, 1) = 'V') or (copy(s, i, 1) = 'v') then
        s1 := s1 + 'v'
      else if (copy(s, i, 1) = 'B') or (copy(s, i, 1) = 'b') then
        s1 := s1 + 'b'
      else if (copy(s, i, 1) = 'N') or (copy(s, i, 1) = 'n') then
        s1 := s1 + 'n'
      else if (copy(s, i, 1) = 'M') or (copy(s, i, 1) = 'm') then
        s1 := s1 + 'm'
      else
        // ��������� �������
        if (copy(s, i, 1) = ' ') or (copy(s, i, 1) = ' ') then
          s1 := s1 + ' '
        else if (copy(s, i, 1) = ',') or (copy(s, i, 1) = ',') then
          s1 := s1 + ','
        else if (copy(s, i, 1) = '.') or (copy(s, i, 1) = '.') then
          s1 := s1 + '.'
        else if (copy(s, i, 1) = '"') or (copy(s, i, 1) = '"') then
          s1 := s1 + '"'
        else if (copy(s, i, 1) = '[') or (copy(s, i, 1) = '[') then
          s1 := s1 + '['
        else if (copy(s, i, 1) = ']') or (copy(s, i, 1) = ']') then
          s1 := s1 + ']'
        else if (copy(s, i, 1) = '{') or (copy(s, i, 1) = '{') then
          s1 := s1 + '{'
        else if (copy(s, i, 1) = '}') or (copy(s, i, 1) = '}') then
          s1 := s1 + '}'
        else if (copy(s, i, 1) = '(') or (copy(s, i, 1) = '(') then
          s1 := s1 + '('
        else if (copy(s, i, 1) = ')') or (copy(s, i, 1) = ')') then
          s1 := s1 + ')'
        else if (copy(s, i, 1) = ':') or (copy(s, i, 1) = ':') then
          s1 := s1 + ':'
        else if (copy(s, i, 1) = '/') or (copy(s, i, 1) = '/') then
          s1 := s1 + '/'
        else if (copy(s, i, 1) = '\') or (copy(s, i, 1) = '\') then
          s1 := s1 + '\'
        else if (copy(s, i, 1) = '=') or (copy(s, i, 1) = '=') then
          s1 := s1 + '='
        else if (copy(s, i, 1) = '+') or (copy(s, i, 1) = '+') then
          s1 := s1 + '+'
        else if (copy(s, i, 1) = '-') or (copy(s, i, 1) = '-') then
          s1 := s1 + '-'
        else if (copy(s, i, 1) = '*') or (copy(s, i, 1) = '*') then
          s1 := s1 + '*'
        else if (copy(s, i, 1) = '%') or (copy(s, i, 1) = '%') then
          s1 := s1 + '%'
        else if (copy(s, i, 1) = '$') or (copy(s, i, 1) = '$') then
          s1 := s1 + '$'
        else if (copy(s, i, 1) = '#') or (copy(s, i, 1) = '#') then
          s1 := s1 + '#'
        else if (copy(s, i, 1) = '�') or (copy(s, i, 1) = '�') then
          s1 := s1 + '�'
        else if (copy(s, i, 1) = '@') or (copy(s, i, 1) = '@') then
          s1 := s1 + '@'
        else if (copy(s, i, 1) = '!') or (copy(s, i, 1) = '!') then
          s1 := s1 + '!'
        else if (copy(s, i, 1) = '^') or (copy(s, i, 1) = '^') then
          s1 := s1 + '^'
        else if (copy(s, i, 1) = '&') or (copy(s, i, 1) = '&') then
          s1 := s1 + '&'
        else if (copy(s, i, 1) = '>') or (copy(s, i, 1) = '>') then
          s1 := s1 + '>'
        else if (copy(s, i, 1) = '<') or (copy(s, i, 1) = '<') then
          s1 := s1 + '<'
        else if (copy(s, i, 1) = '`') or (copy(s, i, 1) = '`') then
          s1 := s1 + '`'
        else if (copy(s, i, 1) = '~') or (copy(s, i, 1) = '~') then
          s1 := s1 + '~'
        else if (copy(s, i, 1) = '  ') or (copy(s, i, 1) = '  ') then
          s1 := s1 + '  '
        else
          // �����
          if (copy(s, i, 1) = '0') then
            s1 := s1 + '0'
          else if (copy(s, i, 1) = '1') then
            s1 := s1 + '1'
          else if (copy(s, i, 1) = '2') then
            s1 := s1 + '2'
          else if (copy(s, i, 1) = '3') then
            s1 := s1 + '3'
          else if (copy(s, i, 1) = '4') then
            s1 := s1 + '4'
          else if (copy(s, i, 1) = '5') then
            s1 := s1 + '5'
          else if (copy(s, i, 1) = '6') then
            s1 := s1 + '6'
          else if (copy(s, i, 1) = '7') then
            s1 := s1 + '7'
          else if (copy(s, i, 1) = '8') then
            s1 := s1 + '8'
          else if (copy(s, i, 1) = '9') then
            s1 := s1 + '9';
  alphamin := s1;
end;

function IsDigit(s: string): Boolean;
var
  i, k: Integer;
begin
  IsDigit := false;
  k := 0;
  for i := 1 to Length(s) do
    if copy(s, i, 1) = '1' then
      k := k + 1
    else if copy(s, i, 1) = '2' then
      k := k + 1
    else if copy(s, i, 1) = '3' then
      k := k + 1
    else if copy(s, i, 1) = '4' then
      k := k + 1
    else if copy(s, i, 1) = '5' then
      k := k + 1
    else if copy(s, i, 1) = '6' then
      k := k + 1
    else if copy(s, i, 1) = '7' then
      k := k + 1
    else if copy(s, i, 1) = '8' then
      k := k + 1
    else if copy(s, i, 1) = '9' then
      k := k + 1
    else if copy(s, i, 1) = '0' then
      k := k + 1
    else if copy(s, i, 1) = ',' then
      k := k + 1;
  if (k = Length(s)) and (k <> 0) then
    IsDigit := true
  else
    IsDigit := false;
end;

function StrToStrFloat(str: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(str) do
    if IsDigit(copy(str, i, 1)) then
      Result := Result + copy(str, i, 1);
end;

// �������� ������ �� ����
function IsDate(s: string): Boolean;
var
  i: Integer;
begin
  if NOT IsDigit(copy(s, 1, 2)) then
    Result := false;
  if copy(s, 3, 1) <> '.' then
    Result := false;
  if NOT IsDigit(copy(s, 4, 2)) then
    Result := false;
  if copy(s, 6, 1) <> '.' then
    Result := false;
  if NOT IsDigit(copy(s, 7, 4)) then
    Result := false;
  if Length(s) > 10 then
    Result := false;
end;

// ������ ��� ����������
function GetComputerNName: string;
var
  buffer: array [0 .. 255] of Char;
  Size: DWORD;
begin
  Size := 256;
  if GetComputerName(buffer, Size) then
    Result := buffer
  else
    Result := '���'
end;

function DateBezTochek(k: TdateTime): string;
var
  i: Integer;
  ss, s: string;
begin
  s := Datetostr(k);
  for i := 1 to Length(s) do
    if (s[i] = '.') or (s[i] = ',') or (s[i] = ':') then
      Continue
    else
      ss := ss + s[i];
  Result := ss;
end;

function TimeBezTochek(k: TdateTime): string;
var
  i: Integer;
  ss, s: string;
begin
  s := timetostr(k);
  for i := 1 to Length(s) do
    if (s[i] = '.') or (s[i] = ',') or (s[i] = ':') then
      Continue
    else
      ss := ss + s[i];
  if Length(ss) = 5 then
    ss := '0' + ss;
  Result := ss;
end;

function ZapToT4k(s: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(s) do
    if copy(s, i, 1) = ',' then
      Result := Result + '.'
    else
      Result := Result + copy(s, i, 1);
end;

function To4kToZap(s: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(s) do
    if copy(s, i, 1) = '.' then
      Result := Result + ','
    else
      Result := Result + copy(s, i, 1);
end;

function OkrugStr(s: string; amt: Integer): string;
var
  i, k: Integer;
  zpt: Boolean;
begin
  k := 0;
  zpt := false;
  Result := '';
  for i := 1 to Length(s) do
  begin
    if copy(s, i, 1) = ',' then
      zpt := true;
    Result := Result + copy(s, i, 1);
    if zpt then
      k := k + 1;
    if k >= amt + 1 then
      Break;
  end;
end;

function VolumeUpPrice(price: Extended; pair: string; OType: string): Extended;
var
  i: Integer;
begin
  Result := 0;
  if OType = 'sell' then
  begin
    if pair = 'btc_usd' then
    begin
      for i := 0 to Length(AsksBTCUSD) - 1 do
        if AsksBTCUSD[i].price <= price then // ������� ����� ���� ����� ����
          Result := Result + AsksBTCUSD[i].Volume;
    end
    else if pair = 'btc_rur' then
    begin
      for i := 0 to Length(AsksBTCRUR) - 1 do
        if AsksBTCRUR[i].price <= price then // ������� ����� ���� ����� ����
          Result := Result + AsksBTCRUR[i].Volume;
    end
    else if pair = 'ltc_btc' then
    begin
      for i := 0 to Length(AsksLTCBTC) - 1 do
        if AsksLTCBTC[i].price <= price then // ������� ����� ���� ����� ����
          Result := Result + AsksLTCBTC[i].Volume;
    end
    else if pair = 'ltc_usd' then
    begin
      for i := 0 to Length(AsksLTCUSD) - 1 do
        if AsksLTCUSD[i].price <= price then // ������� ����� ���� ����� ����
          Result := Result + AsksLTCUSD[i].Volume;
    end
    else if pair = 'ltc_rur' then
    begin
      for i := 0 to Length(AsksLTCRUR) - 1 do
        if AsksLTCRUR[i].price <= price then // ������� ����� ���� ����� ����
          Result := Result + AsksLTCRUR[i].Volume;
    end
    else if pair = 'nmc_btc' then
    begin
      for i := 0 to Length(AsksNMCBTC) - 1 do
        if AsksNMCBTC[i].price <= price then // ������� ����� ���� ����� ����
          Result := Result + AsksNMCBTC[i].Volume;
    end
    else if pair = 'nmc_usd' then
    begin
      for i := 0 to Length(AsksNMCUSD) - 1 do
        if AsksNMCUSD[i].price <= price then // ������� ����� ���� ����� ����
          Result := Result + AsksNMCUSD[i].Volume;
    end
    else if pair = 'nvc_btc' then
    begin
      for i := 0 to Length(AsksNVCBTC) - 1 do
        if AsksNVCBTC[i].price <= price then // ������� ����� ���� ����� ����
          Result := Result + AsksNVCBTC[i].Volume;
    end
    else if pair = 'nvc_usd' then
    begin
      for i := 0 to Length(AsksNVCUSD) - 1 do
        if AsksNVCUSD[i].price <= price then // ������� ����� ���� ����� ����
          Result := Result + AsksNVCUSD[i].Volume;
    end
    else if pair = 'trc_btc' then
    begin
      for i := 0 to Length(AsksTRCBTC) - 1 do
        if AsksTRCBTC[i].price <= price then // ������� ����� ���� ����� ����
          Result := Result + AsksTRCBTC[i].Volume;
    end
    else if pair = 'ppc_btc' then
    begin
      for i := 0 to Length(AsksPPCBTC) - 1 do
        if AsksPPCBTC[i].price <= price then // ������� ����� ���� ����� ����
          Result := Result + AsksPPCBTC[i].Volume;
    end
    else if pair = 'xpm_btc' then
    begin
      for i := 0 to Length(AsksXPMBTC) - 1 do
        if AsksXPMBTC[i].price <= price then // ������� ����� ���� ����� ����
          Result := Result + AsksXPMBTC[i].Volume;
    end;
  end
  else if OType = 'buy' then
  begin
    if pair = 'btc_usd' then
    begin
      for i := 0 to Length(BidsBTCUSD) - 1 do
        if BidsBTCUSD[i].price >= price then // ������� ����� ���� ����� ����
          Result := Result + BidsBTCUSD[i].Volume;
    end
    else if pair = 'btc_rur' then
    begin
      for i := 0 to Length(BidsBTCRUR) - 1 do
        if BidsBTCRUR[i].price >= price then // ������� ����� ���� ����� ����
          Result := Result + BidsBTCRUR[i].Volume;
    end
    else if pair = 'ltc_btc' then
    begin
      for i := 0 to Length(BidsLTCBTC) - 1 do
        if BidsLTCBTC[i].price >= price then // ������� ����� ���� ����� ����
          Result := Result + BidsLTCBTC[i].Volume;
    end
    else if pair = 'ltc_usd' then
    begin
      for i := 0 to Length(BidsLTCUSD) - 1 do
        if BidsLTCUSD[i].price >= price then // ������� ����� ���� ����� ����
          Result := Result + BidsLTCUSD[i].Volume;
    end
    else if pair = 'ltc_rur' then
    begin
      for i := 0 to Length(BidsLTCRUR) - 1 do
        if BidsLTCRUR[i].price >= price then // ������� ����� ���� ����� ����
          Result := Result + BidsLTCRUR[i].Volume;
    end
    else if pair = 'nmc_btc' then
    begin
      for i := 0 to Length(BidsNMCBTC) - 1 do
        if BidsNMCBTC[i].price >= price then // ������� ����� ���� ����� ����
          Result := Result + BidsNMCBTC[i].Volume;
    end
    else if pair = 'nmc_usd' then
    begin
      for i := 0 to Length(BidsNMCUSD) - 1 do
        if BidsNMCUSD[i].price >= price then // ������� ����� ���� ����� ����
          Result := Result + BidsNMCUSD[i].Volume;
    end
    else if pair = 'nvc_btc' then
    begin
      for i := 0 to Length(BidsNVCBTC) - 1 do
        if BidsNVCBTC[i].price >= price then // ������� ����� ���� ����� ����
          Result := Result + BidsNVCBTC[i].Volume;
    end
    else if pair = 'nvc_usd' then
    begin
      for i := 0 to Length(BidsNVCUSD) - 1 do
        if BidsNVCUSD[i].price >= price then // ������� ����� ���� ����� ����
          Result := Result + BidsNVCUSD[i].Volume;
    end
    else if pair = 'trc_btc' then
    begin
      for i := 0 to Length(BidsTRCBTC) - 1 do
        if BidsTRCBTC[i].price >= price then // ������� ����� ���� ����� ����
          Result := Result + BidsTRCBTC[i].Volume;
    end
    else if pair = 'ppc_btc' then
    begin
      for i := 0 to Length(BidsPPCBTC) - 1 do
        if BidsPPCBTC[i].price >= price then // ������� ����� ���� ����� ����
          Result := Result + BidsPPCBTC[i].Volume;
    end
    else if pair = 'xpm_btc' then
    begin
      for i := 0 to Length(BidsXPMBTC) - 1 do
        if BidsXPMBTC[i].price >= price then // ������� ����� ���� ����� ����
          Result := Result + BidsXPMBTC[i].Volume;
    end;
  end
end;

function AvergeForLast(var HistArray: TTGlobalOrderHistory; ot: string; x: Integer): Extended;
var
  j, k: Integer;
begin
  Result := 0;
  k := 0;
  if Length(HistArray) > x + 3 then
    for j := Length(HistArray) - x + 4 to Length(HistArray) - 1 do
      if HistArray[j].typeOrder = ot then
      begin
        Result := Result + HistArray[j].amount;
        k := k + 1;
        if k > x then
          Break;
      end;
  if k > 0 then
    Result := Result / k;
end;

function AvergeLastXAmount(pair: string; OType: string; x: Integer): Extended;
var
  ot: string;
begin
  if OType = 'sell' then
    ot := 'ask'
  else if OType = 'buy' then
    ot := 'bid';

  if pair = 'btc_usd' then
  begin
    Result := AvergeForLast(GlobalBTCUSD, ot, x);
  end
  else if pair = 'btc_rur' then
  begin
    Result := AvergeForLast(GlobalBTCRUR, ot, x);
  end
  else if pair = 'ltc_btc' then
  begin
    Result := AvergeForLast(GlobalLTCBTC, ot, x);
  end
  else if pair = 'ltc_usd' then
  begin
    Result := AvergeForLast(GlobalLTCUSD, ot, x);
  end
  else if pair = 'nmc_btc' then
  begin
    Result := AvergeForLast(GlobalNMCBTC, ot, x);
  end
  else if pair = 'nmc_usd' then
  begin
    Result := AvergeForLast(GlobalNMCUSD, ot, x);
  end
  else if pair = 'nvc_btc' then
  begin
    Result := AvergeForLast(GlobalNVCBTC, ot, x);
  end
  else if pair = 'nvc_usd' then
  begin
    Result := AvergeForLast(GlobalNVCUSD, ot, x);
  end
  else if pair = 'trc_btc' then
  begin
    Result := AvergeForLast(GlobalTRCBTC, ot, x);
  end
  else if pair = 'ppc_btc' then
  begin
    Result := AvergeForLast(GlobalPPCBTC, ot, x);
  end
  else if pair = 'xpm_btc' then
  begin
    Result := AvergeForLast(GlobalXPMBTC, ot, x);
  end
  else;
end;

procedure SaveCourseSignal();
var i:Integer;
    SF: file of TTCourseSignal;
begin
  if Length(CourseSignal) > 0 then
    try
      AssignFile(SF, 'course_signals.dat');
      Rewrite(SF);
      for i := 0 to Length(CourseSignal) - 1 do
        if NOT CourseSignal[i].deleted then
          write(SF, CourseSignal[i]);
    finally
      CloseFile(SF);
    end
  else DeleteFile('course_signals.dat');
end;

procedure LoadCourseSignal();
var i:Integer;
    SF: file of TTCourseSignal;
begin
  if FileExists('course_signals.dat') then
    try
      AssignFile(SF, 'course_signals.dat');
      reset(SF);
      SetLength(CourseSignal,FileSize(SF));
      i := 0;
      while not Eof(SF) do
        begin
         Seek(SF, i);
         read(SF, CourseSignal[i]);
         i := i+1;
        end;
    finally
      CloseFile(SF);
    end;
end;

procedure SaveVirtualOrders();
  var i:Integer;
    VO: file of TVirtualOrder;
begin
  if Length(VirtualOrders) > 0 then
    try
      AssignFile(VO, 'virtual_orders.dat');
      Rewrite(VO);
      for i := 0 to Length(VirtualOrders) - 1 do
        if NOT VirtualOrders[i].deleted then
          write(VO, VirtualOrders[i]);
    finally
      CloseFile(VO);
    end;
end;

procedure SaveToXLS(TimeStamp:string = '');
const
       xlExcel9795 = $0000002B;
       xlExcel8 = 56;
var
  ExlApp, Sheet: OLEVariant;
  i,j,k:integer;
  SummVolBuy,SummRateBuy,SummVolSell,SummRateSell,prib:Extended;
  ts:TDateTime;
begin
  try
    CS5.Enter;
   if TimeStamp<>'' then ts := StrToDateTime(TimeStamp) else ts := StrToDateTime('11.08.2014 00:00:00');
   ExlApp := CreateOleObject('Excel.Application');
   ExlApp.Visible := false;
   ExlApp.Workbooks.Add;
   Sheet := ExlApp.Workbooks[1].WorkSheets[1];
   Sheet.name:='������_��_Delphi';
   j:=6;
   k:=6;
   sheet.cells[1,2]:='����� Buy';
   sheet.cells[1,10]:='����� Sell';

   sheet.cells[2,1]:='����';
   sheet.Columns[1].ColumnWidth := 16;
   sheet.cells[2,2]:='ID';
   sheet.Columns[2].ColumnWidth := 10;
   sheet.cells[2,3]:='����� Vol';
   sheet.cells[2,4]:='����';
   sheet.Columns[4].ColumnWidth := 10;
   sheet.cells[2,5]:='�����';
   sheet.Columns[5].ColumnWidth := 10;
   sheet.cells[2,6]:='NoneClosedVol';
   sheet.cells[2,7]:='ClosedID';

   sheet.cells[2,9]:='����';
   sheet.Columns[9].ColumnWidth := 16;
   sheet.cells[2,10]:='ID';
   sheet.Columns[10].ColumnWidth := 10;
   sheet.cells[2,11]:='����� Vol';
   sheet.Columns[11].ColumnWidth := 10;
   sheet.cells[2,12]:='����';
   sheet.Columns[12].ColumnWidth := 10;
   sheet.cells[2,13]:='�����';
   sheet.Columns[13].ColumnWidth := 10;
   sheet.cells[2,14]:='NoneClosedVol';
   sheet.cells[2,15]:='ClosedID';

   sheet.Columns[16].ColumnWidth := 10;

   SummVolBuy:=0;
   SummRateBuy:=0;
   SummVolSell:=0;
   SummRateSell:=0;
   for i:= 0 to Length(OrderHistory)-1 do
   begin
    if (OrderHistory[i].timestamp >= DateTimeToUnix(ts)) or (TimeStamp='') then
     if OrderHistory[i].OType = 'buy' then
      begin
        sheet.cells[j,1]:=UnixToDateTime(OrderHistory[i].timestamp);
        sheet.cells[j,2]:=OrderHistory[i].order_id;
        sheet.cells[j,3]:=OrderHistory[i].amount;
        sheet.cells[j,4]:=OrderHistory[i].rate;
        sheet.cells[j,5]:=OrderHistory[i].amount*OrderHistory[i].rate;
        if OrderHistory[i].NonClosedAmount > 0.0000001 then
          sheet.cells[j,6]:=OrderHistory[i].NonClosedAmount
        else sheet.cells[j,6]:=0;
        sheet.cells[j,7]:=OrderHistory[i].CloseOrder;

        SummVolBuy := SummVolBuy + OrderHistory[i].amount;
        SummRateBuy:= SummRateBuy + OrderHistory[i].rate*OrderHistory[i].amount;

        j := j+1;
      end
     else
      begin
        sheet.cells[k,9]:=UnixToDateTime(OrderHistory[i].timestamp);
        sheet.cells[k,10]:=OrderHistory[i].order_id;
        sheet.cells[k,11]:=OrderHistory[i].amount;
        sheet.cells[k,12]:=OrderHistory[i].rate;
        sheet.cells[k,13]:=OrderHistory[i].amount*OrderHistory[i].rate;
        if OrderHistory[i].NonClosedAmount > 0.0000001 then
           sheet.cells[k,14]:=OrderHistory[i].NonClosedAmount
        else sheet.cells[k,14]:=0;
        sheet.cells[k,15]:=OrderHistory[i].CloseOrder;

        SummVolSell := SummVolSell+OrderHistory[i].amount;
        SummRateSell:= SummRateSell + OrderHistory[i].rate*OrderHistory[i].amount;
        k:=k+1;
      end;
   end;

   sheet.cells[3,3]:=SummVolBuy;
   sheet.cells[3,4]:=SummRateBuy/SummVolBuy;
   sheet.cells[3,5]:=SummRateBuy;
   sheet.cells[3,11]:=SummVolSell;
   sheet.cells[3,12]:=SummRateSell/SummVolSell;
   sheet.cells[3,13]:=SummRateSell;

   sheet.cells[3,15]:='������� =';
   sheet.cells[3,16]:=SummRateBuy-SummRateSell;

   sheet.cells[4,14]:='������� ���� ����=';
   sheet.cells[4,16]:=SummRateSell/SummVolSell-SummRateBuy/SummVolBuy;

   sheet.cells[5,14]:='�������=';
   prib := (SummRateSell/SummVolSell-SummRateBuy/SummVolBuy)*(SummVolBuy+SummVolSell)/2;
   sheet.cells[5,16]:= prib-prib*0.004;

   sheet.Range[sheet.cells[1,1],sheet.cells[(Length(OrderHistory) div 2)+30,15]].Borders.LineStyle := 1;

   ExlApp.DisplayAlerts := False;
   try
    //������ xls 97-2003 ���� ���������� 2003 Excel
     ExlApp.Workbooks[1].saveas('e:\btcebot\temp.xls', -4143);
   except
    //������ xls 97-2003 ���� ���������� 2007-2010 Excel
    ExlApp.Workbooks[1].saveas('e:\btcebot\temp.xls', -4143);
    end;

   ExlApp.Quit;
  finally
   CS5.Leave;
  end;
end;

procedure balanceProc();
var btcTemp,btcActive,SummActive:Extended;
i:Integer;
begin
  btcActive := 0;
  SummActive := 0;
  if Length(ActiveOrders)>0 then
    for i := 0 to Length(ActiveOrders)-1 do
      if ActiveOrders[i].pair = 'btc_usd' then
        if ActiveOrders[i].OType = 'buy' then
          SummActive := SummActive + ActiveOrders[i].amount*ActiveOrders[i].rate
        else
          btcActive := btcActive + ActiveOrders[i].amount;

  btcTemp := (Balance.btc+btcActive)*TopPrice('btc_usd','buy');
  //if btcTemp > Balance.USD then BalanceUSDProc := Trunc(Balance.USD*100/btcTemp)
 // else
 BalanceUSDProc := Trunc((Balance.USD+SummActive)*100/(Balance.USD+SummActive+btcTemp));
end;

procedure CalculateLevels();
var i:Integer;
begin
  // ���������� ������
  // 5m
  if Max5m.timestamp < DateTimeToUnix(Now)-300 then
    begin
      Max5m.rate := GlobalbtcUSD[Length(GlobalbtcUSD)-1].price;
      Max5m.timestamp := GlobalbtcUSD[Length(GlobalbtcUSD)-1].timestamp;
    end;
  if Min5m.timestamp < DateTimeToUnix(Now)-300 then
    begin
      Min5m.rate := GlobalbtcUSD[Length(GlobalbtcUSD)-1].price;
      Min5m.timestamp := GlobalbtcUSD[Length(GlobalbtcUSD)-1].timestamp;
    end;
  // 15m
  if Max15m.timestamp < DateTimeToUnix(Now)-900 then
    begin
      Max15m.rate := GlobalbtcUSD[Length(GlobalbtcUSD)-1].price;
      Max15m.timestamp := GlobalbtcUSD[Length(GlobalbtcUSD)-1].timestamp;
    end;
  if Min15m.timestamp < DateTimeToUnix(Now)-900 then
    begin
      Min15m.rate := GlobalbtcUSD[Length(GlobalbtcUSD)-1].price;
      Min15m.timestamp := GlobalbtcUSD[Length(GlobalbtcUSD)-1].timestamp;
    end;
   // 30m
  if Max30m.timestamp < DateTimeToUnix(Now)-1800 then
    begin
      Max30m.rate := GlobalbtcUSD[Length(GlobalbtcUSD)-1].price;
      Max30m.timestamp := GlobalbtcUSD[Length(GlobalbtcUSD)-1].timestamp;
    end;
  if Min30m.timestamp < DateTimeToUnix(Now)-1800 then
    begin
      Min30m.rate := GlobalbtcUSD[Length(GlobalbtcUSD)-1].price;
      Min30m.timestamp := GlobalbtcUSD[Length(GlobalbtcUSD)-1].timestamp;
    end;
  // 1H
  if Max1h.timestamp < DateTimeToUnix(Now)-3600 then
    begin
      Max1h.rate := GlobalbtcUSD[Length(GlobalbtcUSD)-1].price;
      Max1h.timestamp := GlobalbtcUSD[Length(GlobalbtcUSD)-1].timestamp;
    end;
  if Min1h.timestamp < DateTimeToUnix(Now)-3600 then
    begin
      Min1h.rate := GlobalbtcUSD[Length(GlobalbtcUSD)-1].price;
      Min1h.timestamp := GlobalbtcUSD[Length(GlobalbtcUSD)-1].timestamp;
    end;
  // 4H
  if Max4h.timestamp < DateTimeToUnix(Now)-14400 then
    begin
      Max4h.rate := GlobalbtcUSD[Length(GlobalbtcUSD)-1].price;
      Max4h.timestamp := GlobalbtcUSD[Length(GlobalbtcUSD)-1].timestamp;
    end;
  if Min4h.timestamp < DateTimeToUnix(Now)-14400 then
    begin
      Min4h.rate := GlobalbtcUSD[Length(GlobalbtcUSD)-1].price;
      Min4h.timestamp := GlobalbtcUSD[Length(GlobalbtcUSD)-1].timestamp;
    end;
  // 6H
  if Max6h.timestamp < DateTimeToUnix(Now)-21600 then
    begin
      Max6h.rate := GlobalbtcUSD[Length(GlobalbtcUSD)-1].price;
      Max6h.timestamp := GlobalbtcUSD[Length(GlobalbtcUSD)-1].timestamp;
    end;
  if Min6h.timestamp < DateTimeToUnix(Now)-21600 then
    begin
      Min6h.rate := GlobalbtcUSD[Length(GlobalbtcUSD)-1].price;
      Min6h.timestamp := GlobalbtcUSD[Length(GlobalbtcUSD)-1].timestamp;
    end;
  // 12H
  if Max12h.timestamp < DateTimeToUnix(Now)-43200 then
    begin
      Max12h.rate := GlobalbtcUSD[Length(GlobalbtcUSD)-1].price;
      Max12h.timestamp := GlobalbtcUSD[Length(GlobalbtcUSD)-1].timestamp;
    end;
  if Min12h.timestamp < DateTimeToUnix(Now)-43200 then
    begin
      Min12h.rate := GlobalbtcUSD[Length(GlobalbtcUSD)-1].price;
      Min12h.timestamp := GlobalbtcUSD[Length(GlobalbtcUSD)-1].timestamp;
    end;
    // 1D
  if Max1d.timestamp < DateTimeToUnix(Now)-86400 then
    begin
      Max1d.rate := GlobalbtcUSD[Length(GlobalbtcUSD)-1].price;
      Max1d.timestamp := GlobalbtcUSD[Length(GlobalbtcUSD)-1].timestamp;
    end;
  if Min1d.timestamp < DateTimeToUnix(Now)-86400 then
    begin
      Min1d.rate := GlobalbtcUSD[Length(GlobalbtcUSD)-1].price;
      Min1d.timestamp := GlobalbtcUSD[Length(GlobalbtcUSD)-1].timestamp;
    end;

  // ��������� ������� ��������� � �������� 5m (5 ��������)
  for I := Length(GlobalbtcUSD)-1 downto 0 do
    if GlobalbtcUSD[i].timestamp >= DateTimeToUnix(Now)-300 then
    begin
     if GlobalbtcUSD[i].price > Max5m.rate then
     begin
      Max5m.rate := GlobalbtcUSD[i].price;
      Max5m.timestamp := GlobalbtcUSD[i].timestamp;
     end;
     if (Min5m.rate > GlobalbtcUSD[i].price) or (Min5m.rate = 0) then
     begin
      Min5m.rate := GlobalbtcUSD[i].price;
      Min5m.timestamp := GlobalbtcUSD[i].timestamp;
     end;
    end;

  // ��������� ������� ��������� � �������� 15m (15 ��������)
  for I := Length(GlobalbtcUSD)-1 downto 0 do
    if GlobalbtcUSD[i].timestamp >= DateTimeToUnix(Now)-900 then
    begin
     if GlobalbtcUSD[i].price > Max15m.rate then
     begin
      Max15m.rate := GlobalbtcUSD[i].price;
      Max15m.timestamp := GlobalbtcUSD[i].timestamp;
     end;
     if (Min15m.rate > GlobalbtcUSD[i].price) or (Min15m.rate = 0) then
     begin
      Min15m.rate := GlobalbtcUSD[i].price;
      Min15m.timestamp := GlobalbtcUSD[i].timestamp;
     end;
    end;

  // ��������� ������� ��������� � �������� 30m (30 ��������)
  for I := Length(GlobalbtcUSD)-1 downto 0 do
    if GlobalbtcUSD[i].timestamp >= DateTimeToUnix(Now)-1800 then
    begin
     if GlobalbtcUSD[i].price > Max30m.rate then
     begin
      Max30m.rate := GlobalbtcUSD[i].price;
      Max30m.timestamp := GlobalbtcUSD[i].timestamp;
     end;
     if (Min30m.rate > GlobalbtcUSD[i].price) or (Min30m.rate = 0) then
     begin
      Min30m.rate := GlobalbtcUSD[i].price;
      Min30m.timestamp := GlobalbtcUSD[i].timestamp;
     end;
    end;

  // ��������� ������� ��������� � �������� 1H (1� �������)
  for I := Length(GlobalbtcUSD)-1 downto 0 do
    if GlobalbtcUSD[i].timestamp >= DateTimeToUnix(Now)-3600 then
    begin
     if GlobalbtcUSD[i].price > Max1h.rate then
     begin
      Max1h.rate := GlobalbtcUSD[i].price;
      Max1h.timestamp := GlobalbtcUSD[i].timestamp;
     end;
     if (Min1h.rate > GlobalbtcUSD[i].price) or (Min1h.rate = 0) then
     begin
      Min1h.rate := GlobalbtcUSD[i].price;
      Min1h.timestamp := GlobalbtcUSD[i].timestamp;
     end;
    end;

  // ��������� ������� ��������� � �������� 4H (4� �������)
  for I := Length(GlobalbtcUSD)-1 downto 0 do
    if GlobalbtcUSD[i].timestamp >= DateTimeToUnix(Now)-14400 then
    begin
     if GlobalbtcUSD[i].price > Max4h.rate then
     begin
      Max4h.rate := GlobalbtcUSD[i].price;
      Max4h.timestamp := GlobalbtcUSD[i].timestamp;
     end;
     if (Min4h.rate > GlobalbtcUSD[i].price) or (Min4h.rate = 0) then
     begin
      Min4h.rate := GlobalbtcUSD[i].price;
      Min4h.timestamp := GlobalbtcUSD[i].timestamp;
     end;
    end;

  // ��������� ������� ��������� � �������� 6H (6� �������)
  for I := Length(GlobalbtcUSD)-1 downto 0 do
    if GlobalbtcUSD[i].timestamp >= DateTimeToUnix(Now)-21600 then
    begin
     if GlobalbtcUSD[i].price > Max6h.rate then
     begin
      Max6h.rate := GlobalbtcUSD[i].price;
      Max6h.timestamp := GlobalbtcUSD[i].timestamp;
     end;
     if (Min6h.rate > GlobalbtcUSD[i].price) or (Min6h.rate = 0) then
     begin
      Min6h.rate := GlobalbtcUSD[i].price;
      Min6h.timestamp := GlobalbtcUSD[i].timestamp;
     end;
    end;

  // ��������� ������� ��������� � �������� 12H (12� �������)
  for I := Length(GlobalbtcUSD)-1 downto 0 do
    if GlobalbtcUSD[i].timestamp >= DateTimeToUnix(Now)-43200 then
    begin
     if GlobalbtcUSD[i].price > Max12h.rate then
     begin
      Max12h.rate := GlobalbtcUSD[i].price;
      Max12h.timestamp := GlobalbtcUSD[i].timestamp;
     end;
     if (Min12h.rate > GlobalbtcUSD[i].price) or (Min12h.rate = 0) then
     begin
      Min12h.rate := GlobalbtcUSD[i].price;
      Min12h.timestamp := GlobalbtcUSD[i].timestamp;
     end;
    end;

   // ��������� ������� ��������� � �������� 1D (�������)
  for I := Length(GlobalbtcUSD)-1 downto 0 do
    if GlobalbtcUSD[i].timestamp >= DateTimeToUnix(Now)-86400 then
    begin
     if GlobalbtcUSD[i].price > Max1d.rate then
     begin
      Max1d.rate := GlobalbtcUSD[i].price;
      Max1d.timestamp := GlobalbtcUSD[i].timestamp;
     end;
     if (Min1d.rate > GlobalbtcUSD[i].price) or (Min1d.rate = 0) then
     begin
      Min1d.rate := GlobalbtcUSD[i].price;
      Min1d.timestamp := GlobalbtcUSD[i].timestamp;
     end;
    end;
end;

end.
