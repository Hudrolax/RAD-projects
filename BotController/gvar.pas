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
procedure ParseDepth(var ArrAsks, ArrBids: ATDepth; GetStr: string);
procedure ParseHistory(var HisArray: TTGlobalOrderHistory; GetStr: string; pair: string);
function TopPrice(pair: string; Order_type: string; plus: Extended = 0): Extended;
function ReverseOrderType(OType: string): string;
function StrToStrFloat(str: string): string;
function SendMessageToClient(msg: string):WideString;
function SendOrder(pair: string; type_order: string; rate: Extended; Volume: Extended): string;
function VolumeUpPrice(price: Extended; pair: string; OType: string): Extended;
function AvergeLastXAmount(pair: string; OType: string; x: Integer): Extended;
function AvergeForLast(var HistArray: TTGlobalOrderHistory; ot: string; x: Integer): Extended;
procedure SaveCourseSignal();
procedure SaveVirtualOrders();
procedure SendEmail(Subj:string; messag:string);
function GetPrice():Boolean;
procedure GetInfoParse(s: string);
procedure ParseActiveOrders(s: string);
procedure ParseTradeHistory(s: string);
procedure SaveToXLS(TimeStamp:string = '');
procedure balanceProc();

var
  AsksBTCUSD, BidsBTCUSD, AsksBTCRUR, BidsBTCRUR, AsksLTCBTC, BidsLTCBTC, AsksLTCUSD, BidsLTCUSD, AsksLTCRUR, BidsLTCRUR, AsksLTCEUR, BidsLTCEUR,
    AsksNMCBTC, BidsNMCBTC, AsksNMCUSD, BidsNMCUSD, AsksNVCBTC, BidsNVCBTC, AsksNVCUSD, BidsNVCUSD, AsksTRCBTC, BidsTRCBTC, AsksPPCBTC, BidsPPCBTC,
    AsksFTCBTC, BidsFTCBTC, AsksXPMBTC, BidsXPMBTC: ATDepth;
  ActiveOrders: array of TOrders;
  OrderHistory: array of TOrderHistory;

  VirtualOrders: array of TVirtualOrder;
  CourseSignal: array of TTCourseSignal;
  CancelOrdersList: array of string;
  BidWalls,AskWalls:array of TDepth; // массивы стенок

  GlobalBTCUSD, GlobalBTCRUR, GlobalLTCBTC, GlobalLTCUSD, GlobalLTCRUR, GlobalNMCBTC, GlobalNMCUSD, GlobalNVCBTC, GlobalNVCUSD, GlobalTRCBTC,
    GlobalPPCBTC, GlobalXPMBTC: TTGlobalOrderHistory;
  Balance: TBalance;
  gpath,exename, LastCommand, proxy_ip:string;
  proxy_port:Integer;
  SellPrice,BuyPrice:Extended;
  CS1{Для стаканов},CS2{Для GetInfo},CS3{Для ActiveOrders},CS4{Для Стенок},CS5{Для истории}: TCriticalSection;
  Vol100Sell,Vol100Buy:Extended;
  BalanceUSDProc:Integer;
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
      GetStr := http.Get('https://btc-e.com/api/2/ltc_usd/depth');
      ParseDepth(AsksLTCUSD, BidsLTCUSD, GetStr);
    Except
      Result := False;
    end;
  finally
    GetStr:='';
    FreeAndNil(http);
    FreeAndNil(ssl);
  end;
end;

// Отправляем сообщение на биржу
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
  { формируем тело сообщения }
  IdMessage1 := TIdMessage.Create;
  IdMessage1.From.Address := 'appakov@inbox.ru';
  IdMessage1.Recipients.EMailAddresses := 'nappakov@gmail.com';
  IdMessage1.Subject := UTF8Encode(Subj);
  IdMessage1.Body.Append(UTF8Encode(messag));
  IdMessage1.Date := now;

  { настройка компонентов перед отправкой }
  IdSMTP := TIdSMTP.Create(nil);

  IdSMTP.Host := 'smtp.mail.ru';
  IdSMTP.Port := 465;
  // обычно при использование ssl 495, 587 или стандартный 25
  IdSMTP.Username := 'appakov@inbox.ru';
  IdSMTP.Password := '111111';

  { это необходимо использовать для SSL }
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

  { отправляем письмо }
  IdSMTP.Connect();
  IdSMTP.Send(IdMessage1);
  IdSMTP.Disconnect;
  { очищаем память }
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

procedure ParseHistory(var HisArray: TTGlobalOrderHistory; GetStr: string; pair: string);
var
  OReturn, OElement: TJSONObject;
  Bpair: TJSONArray;
  i, j, k, zero: Integer;
  UjeEst: Boolean;
begin
  try
    OReturn := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(GetStr), 0) as TJSONObject;
    Bpair := OReturn.Get(pair).JsonValue as TJSONArray;
    if Length(HisArray) = 0 then
    begin
      SetLength(HisArray, Bpair.Size);
      k := 0;
      for i := Bpair.Size - 1 downto 0 do
      begin
        OElement := (Bpair.Get(i) as TJSONObject);
        HisArray[k].typeOrder := OElement.Get('type').JsonValue.Value;
        HisArray[k].price := StrToFloat(OElement.Get('price').JsonValue.Value);
        HisArray[k].amount := StrToFloat(OElement.Get('amount').JsonValue.Value);
        HisArray[k].tid := OElement.Get('tid').JsonValue.Value;
        HisArray[k].timestamp := StrToInt(OElement.Get('timestamp').JsonValue.Value);
        k := k + 1;
      end;
    end
    else
      for i := 0 to Bpair.Size - 1 do
      begin
        OElement := (Bpair.Get(i) as TJSONObject);
        UjeEst := false;
        zero := Length(HisArray) - 22;
        if zero < 0 then
          zero := 0;
        for j := zero to Length(HisArray) - 1 do
          if HisArray[j].tid = OElement.Get('tid').JsonValue.Value then
            UjeEst := true;
        if not UjeEst then
        begin
          SetLength(HisArray, Length(HisArray) + 1);
          HisArray[Length(HisArray) - 1].typeOrder := OElement.Get('type').JsonValue.Value;
          HisArray[Length(HisArray) - 1].price := StrToFloat(OElement.Get('price').JsonValue.Value);
          HisArray[Length(HisArray) - 1].amount := StrToFloat(OElement.Get('amount').JsonValue.Value);
          HisArray[Length(HisArray) - 1].tid := OElement.Get('tid').JsonValue.Value;
          HisArray[Length(HisArray) - 1].timestamp := StrToInt(OElement.Get('timestamp').JsonValue.Value);
        end;
      end;
  finally
   OReturn.Destroy;
  end;
end;

procedure ParseDepth(var ArrAsks, ArrBids: ATDepth; GetStr: string);
var
  OReturn: TJSONObject;
  OAsks, OBids: TJSONArray;
  i: Integer;
begin
  try
    OReturn := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(GetStr), 0) as TJSONObject;
    // ****************** Заполняем массив Asks ************************************
     if Assigned(OReturn) then
     try
     OAsks := OReturn.Get('asks').JsonValue as TJSONArray;
     CS1.Enter;
     try
       SetLength(ArrAsks, 0);
       SetLength(ArrAsks, OAsks.Size);
       for i := 0 to OAsks.Size - 1 do
       begin
        ArrAsks[i].price := StrToFloat((OAsks.Get(i) as TJSONArray).Get(0).Value);
        ArrAsks[i].Volume := StrToFloat((OAsks.Get(i) as TJSONArray).Get(1).Value);
       end;
     finally
      CS1.Leave;
     end;

      // ****************** Заполняем массив Bids ************************************
      OBids := OReturn.Get('bids').JsonValue as TJSONArray;
      CS1.Enter;
      try
       SetLength(ArrBids, 0);
       SetLength(ArrBids, OBids.Size);
       for i := 0 to OBids.Size - 1 do
       begin
         ArrBids[i].price := StrToFloat((OBids.Get(i) as TJSONArray).Get(0).Value);
         ArrBids[i].Volume := StrToFloat((OBids.Get(i) as TJSONArray).Get(1).Value);
       end;
      finally
        CS1.Leave;
      end;
      finally
      OReturn.Free;
     end;
  Except
      CS1.Enter;
      try
        SetLength(ArrAsks, 0);
        SetLength(ArrBids, 0);
        OReturn.Free;
      finally
        CS1.Leave;
      end;
  end;
end;

// Расшифровываем инфо Истории Ордеров
procedure ParseTradeHistory(s: string);
var
  OReturn, OOrder: TJSONObject;
  i,j: Integer;
  OrdNumber: string;
begin
 try
  OReturn := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(s), 0) as TJSONObject;
  OReturn := OReturn.Get('return').JsonValue as TJSONObject;
  if Assigned(OReturn) then
  begin
   CS5.Enter;
   try
    SetLength(OrderHistory, 0);
    Vol100Sell := 0;
    Vol100Buy := 0;
    j:=0;
    for i := 0 to OReturn.Size - 1 do // Идем по ордерам
    begin
     OrdNumber := OReturn.Get(i).JsonString.Value;
     OOrder := OReturn.Get(OrdNumber).JsonValue as TJSONObject;
     if AnsiPos('0695',OOrder.Get('amount').JsonValue.Value)>0 then Continue;
     if StrToInt(OOrder.Get('timestamp').JsonValue.Value)< 1407715200 then Continue; // Игнорим сделки до 11.08.2014

     SetLength(OrderHistory, Length(OrderHistory)+1);
     OrderHistory[j].order_id := OOrder.Get('order_id').JsonValue.Value;
     OrderHistory[j].pair := OOrder.Get('pair').JsonValue.Value;
     OrderHistory[j].OType := OOrder.Get('type').JsonValue.Value;
     OrderHistory[j].amount := strtofloat(OOrder.Get('amount').JsonValue.Value);
     OrderHistory[j].NonClosedAmount := OrderHistory[j].amount;
     OrderHistory[j].rate := strtofloat(OOrder.Get('rate').JsonValue.Value);
     OrderHistory[j].timestamp := StrToInt(OOrder.Get('timestamp').JsonValue.Value);
     OrderHistory[j].is_you_order := StrToInt(OOrder.Get('is_your_order').JsonValue.Value);

     if OrderHistory[j].OType = 'sell' then Vol100Sell:=Vol100Sell+OrderHistory[j].amount
      else Vol100Buy:=Vol100Buy+OrderHistory[j].amount;
      j:= j+1;
    end;
    Vol100Buy := Vol100Buy; // Временно!!!!!!!!!!!!!1
    OReturn.Free;

    if Length(OrderHistory)>0 then
    begin
      // Просчет парных закрытых сделок (********** ВЗАИМОЗАЧЕТ ************)
      for i := 0 to Length(OrderHistory)-1 do
        if (OrderHistory[i].OType = 'buy') and (OrderHistory[i].NonClosedAmount>0.0001) then
          for j := 0 to Length(OrderHistory)-1 do
            if (OrderHistory[j].OType = 'sell') and (OrderHistory[j].NonClosedAmount>0.0001)
             and (OrderHistory[i].rate < OrderHistory[j].rate-OrderHistory[j].rate*0.004)
            then
                 if OrderHistory[i].NonClosedAmount > OrderHistory[j].NonClosedAmount then
                  begin
                   OrderHistory[i].NonClosedAmount := OrderHistory[i].NonClosedAmount - OrderHistory[j].NonClosedAmount;
                   OrderHistory[j].NonClosedAmount := 0;
                   OrderHistory[i].CloseOrder := OrderHistory[i].CloseOrder + OrderHistory[j].order_id+', ';
                   OrderHistory[j].CloseOrder := OrderHistory[j].CloseOrder + OrderHistory[i].order_id+', ';
                  end
                 else
                  begin
                   OrderHistory[j].NonClosedAmount := OrderHistory[j].NonClosedAmount - OrderHistory[i].NonClosedAmount;
                   OrderHistory[i].NonClosedAmount := 0;
                   OrderHistory[i].CloseOrder := OrderHistory[i].CloseOrder + OrderHistory[j].order_id+', ';
                   OrderHistory[j].CloseOrder := OrderHistory[j].CloseOrder + OrderHistory[i].order_id+', ';
                   Break;
                  end;
    end;
   finally
    CS5.Leave
   end;
  end;
 Except
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

// Возвращает размер файла
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
    // Русские
    if (copy(s, i, 1) = 'А') or (copy(s, i, 1) = 'а') then
      s1 := s1 + 'а'
    else if (copy(s, i, 1) = 'Б') or (copy(s, i, 1) = 'б') then
      s1 := s1 + 'б'
    else if (copy(s, i, 1) = 'В') or (copy(s, i, 1) = 'в') then
      s1 := s1 + 'в'
    else if (copy(s, i, 1) = 'Г') or (copy(s, i, 1) = 'г') then
      s1 := s1 + 'г'
    else if (copy(s, i, 1) = 'Д') or (copy(s, i, 1) = 'д') then
      s1 := s1 + 'д'
    else if (copy(s, i, 1) = 'Е') or (copy(s, i, 1) = 'е') then
      s1 := s1 + 'е'
    else if (copy(s, i, 1) = 'Ё') or (copy(s, i, 1) = 'ё') then
      s1 := s1 + 'ё'
    else if (copy(s, i, 1) = 'Ж') or (copy(s, i, 1) = 'ж') then
      s1 := s1 + 'ж'
    else if (copy(s, i, 1) = 'З') or (copy(s, i, 1) = 'з') then
      s1 := s1 + 'з'
    else if (copy(s, i, 1) = 'И') or (copy(s, i, 1) = 'и') then
      s1 := s1 + 'и'
    else if (copy(s, i, 1) = 'Й') or (copy(s, i, 1) = 'й') then
      s1 := s1 + 'й'
    else if (copy(s, i, 1) = 'К') or (copy(s, i, 1) = 'к') then
      s1 := s1 + 'к'
    else if (copy(s, i, 1) = 'Л') or (copy(s, i, 1) = 'л') then
      s1 := s1 + 'л'
    else if (copy(s, i, 1) = 'М') or (copy(s, i, 1) = 'м') then
      s1 := s1 + 'м'
    else if (copy(s, i, 1) = 'Н') or (copy(s, i, 1) = 'н') then
      s1 := s1 + 'н'
    else if (copy(s, i, 1) = 'О') or (copy(s, i, 1) = 'о') then
      s1 := s1 + 'о'
    else if (copy(s, i, 1) = 'П') or (copy(s, i, 1) = 'п') then
      s1 := s1 + 'п'
    else if (copy(s, i, 1) = 'Р') or (copy(s, i, 1) = 'р') then
      s1 := s1 + 'р'
    else if (copy(s, i, 1) = 'С') or (copy(s, i, 1) = 'с') then
      s1 := s1 + 'с'
    else if (copy(s, i, 1) = 'Т') or (copy(s, i, 1) = 'т') then
      s1 := s1 + 'т'
    else if (copy(s, i, 1) = 'У') or (copy(s, i, 1) = 'у') then
      s1 := s1 + 'у'
    else if (copy(s, i, 1) = 'Ф') or (copy(s, i, 1) = 'ф') then
      s1 := s1 + 'ф'
    else if (copy(s, i, 1) = 'Х') or (copy(s, i, 1) = 'х') then
      s1 := s1 + 'х'
    else if (copy(s, i, 1) = 'Ц') or (copy(s, i, 1) = 'ц') then
      s1 := s1 + 'ц'
    else if (copy(s, i, 1) = 'Ч') or (copy(s, i, 1) = 'ч') then
      s1 := s1 + 'ч'
    else if (copy(s, i, 1) = 'Ш') or (copy(s, i, 1) = 'ш') then
      s1 := s1 + 'ш'
    else if (copy(s, i, 1) = 'Щ') or (copy(s, i, 1) = 'щ') then
      s1 := s1 + 'щ'
    else if (copy(s, i, 1) = 'Ь') or (copy(s, i, 1) = 'ь') then
      s1 := s1 + 'ь'
    else if (copy(s, i, 1) = 'Ы') or (copy(s, i, 1) = 'ы') then
      s1 := s1 + 'ы'
    else if (copy(s, i, 1) = 'Ъ') or (copy(s, i, 1) = 'ъ') then
      s1 := s1 + 'ъ'
    else if (copy(s, i, 1) = 'Э') or (copy(s, i, 1) = 'э') then
      s1 := s1 + 'э'
    else if (copy(s, i, 1) = 'Ю') or (copy(s, i, 1) = 'ю') then
      s1 := s1 + 'ю'
    else if (copy(s, i, 1) = 'Я') or (copy(s, i, 1) = 'я') then
      s1 := s1 + 'я'
    else
      // Англицкие
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
        // Служебные символы
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
        else if (copy(s, i, 1) = '№') or (copy(s, i, 1) = '№') then
          s1 := s1 + '№'
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
          // Цифры
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
    else if copy(s, i, 1) = '.' then
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

// Проверка строки на дату
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

// Узнать имя компьютера
function GetComputerNName: string;
var
  buffer: array [0 .. 255] of Char;
  Size: DWORD;
begin
  Size := 256;
  if GetComputerName(buffer, Size) then
    Result := buffer
  else
    Result := 'Нет'
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
        if AsksBTCUSD[i].price <= price then // Считаем объем выше новой цены
          Result := Result + AsksBTCUSD[i].Volume;
    end
    else if pair = 'btc_rur' then
    begin
      for i := 0 to Length(AsksBTCRUR) - 1 do
        if AsksBTCRUR[i].price <= price then // Считаем объем выше новой цены
          Result := Result + AsksBTCRUR[i].Volume;
    end
    else if pair = 'ltc_btc' then
    begin
      for i := 0 to Length(AsksLTCBTC) - 1 do
        if AsksLTCBTC[i].price <= price then // Считаем объем выше новой цены
          Result := Result + AsksLTCBTC[i].Volume;
    end
    else if pair = 'ltc_usd' then
    begin
      for i := 0 to Length(AsksLTCUSD) - 1 do
        if AsksLTCUSD[i].price <= price then // Считаем объем выше новой цены
          Result := Result + AsksLTCUSD[i].Volume;
    end
    else if pair = 'ltc_rur' then
    begin
      for i := 0 to Length(AsksLTCRUR) - 1 do
        if AsksLTCRUR[i].price <= price then // Считаем объем выше новой цены
          Result := Result + AsksLTCRUR[i].Volume;
    end
    else if pair = 'nmc_btc' then
    begin
      for i := 0 to Length(AsksNMCBTC) - 1 do
        if AsksNMCBTC[i].price <= price then // Считаем объем выше новой цены
          Result := Result + AsksNMCBTC[i].Volume;
    end
    else if pair = 'nmc_usd' then
    begin
      for i := 0 to Length(AsksNMCUSD) - 1 do
        if AsksNMCUSD[i].price <= price then // Считаем объем выше новой цены
          Result := Result + AsksNMCUSD[i].Volume;
    end
    else if pair = 'nvc_btc' then
    begin
      for i := 0 to Length(AsksNVCBTC) - 1 do
        if AsksNVCBTC[i].price <= price then // Считаем объем выше новой цены
          Result := Result + AsksNVCBTC[i].Volume;
    end
    else if pair = 'nvc_usd' then
    begin
      for i := 0 to Length(AsksNVCUSD) - 1 do
        if AsksNVCUSD[i].price <= price then // Считаем объем выше новой цены
          Result := Result + AsksNVCUSD[i].Volume;
    end
    else if pair = 'trc_btc' then
    begin
      for i := 0 to Length(AsksTRCBTC) - 1 do
        if AsksTRCBTC[i].price <= price then // Считаем объем выше новой цены
          Result := Result + AsksTRCBTC[i].Volume;
    end
    else if pair = 'ppc_btc' then
    begin
      for i := 0 to Length(AsksPPCBTC) - 1 do
        if AsksPPCBTC[i].price <= price then // Считаем объем выше новой цены
          Result := Result + AsksPPCBTC[i].Volume;
    end
    else if pair = 'xpm_btc' then
    begin
      for i := 0 to Length(AsksXPMBTC) - 1 do
        if AsksXPMBTC[i].price <= price then // Считаем объем выше новой цены
          Result := Result + AsksXPMBTC[i].Volume;
    end;
  end
  else if OType = 'buy' then
  begin
    if pair = 'btc_usd' then
    begin
      for i := 0 to Length(BidsBTCUSD) - 1 do
        if BidsBTCUSD[i].price >= price then // Считаем объем выше новой цены
          Result := Result + BidsBTCUSD[i].Volume;
    end
    else if pair = 'btc_rur' then
    begin
      for i := 0 to Length(BidsBTCRUR) - 1 do
        if BidsBTCRUR[i].price >= price then // Считаем объем выше новой цены
          Result := Result + BidsBTCRUR[i].Volume;
    end
    else if pair = 'ltc_btc' then
    begin
      for i := 0 to Length(BidsLTCBTC) - 1 do
        if BidsLTCBTC[i].price >= price then // Считаем объем выше новой цены
          Result := Result + BidsLTCBTC[i].Volume;
    end
    else if pair = 'ltc_usd' then
    begin
      for i := 0 to Length(BidsLTCUSD) - 1 do
        if BidsLTCUSD[i].price >= price then // Считаем объем выше новой цены
          Result := Result + BidsLTCUSD[i].Volume;
    end
    else if pair = 'ltc_rur' then
    begin
      for i := 0 to Length(BidsLTCRUR) - 1 do
        if BidsLTCRUR[i].price >= price then // Считаем объем выше новой цены
          Result := Result + BidsLTCRUR[i].Volume;
    end
    else if pair = 'nmc_btc' then
    begin
      for i := 0 to Length(BidsNMCBTC) - 1 do
        if BidsNMCBTC[i].price >= price then // Считаем объем выше новой цены
          Result := Result + BidsNMCBTC[i].Volume;
    end
    else if pair = 'nmc_usd' then
    begin
      for i := 0 to Length(BidsNMCUSD) - 1 do
        if BidsNMCUSD[i].price >= price then // Считаем объем выше новой цены
          Result := Result + BidsNMCUSD[i].Volume;
    end
    else if pair = 'nvc_btc' then
    begin
      for i := 0 to Length(BidsNVCBTC) - 1 do
        if BidsNVCBTC[i].price >= price then // Считаем объем выше новой цены
          Result := Result + BidsNVCBTC[i].Volume;
    end
    else if pair = 'nvc_usd' then
    begin
      for i := 0 to Length(BidsNVCUSD) - 1 do
        if BidsNVCUSD[i].price >= price then // Считаем объем выше новой цены
          Result := Result + BidsNVCUSD[i].Volume;
    end
    else if pair = 'trc_btc' then
    begin
      for i := 0 to Length(BidsTRCBTC) - 1 do
        if BidsTRCBTC[i].price >= price then // Считаем объем выше новой цены
          Result := Result + BidsTRCBTC[i].Volume;
    end
    else if pair = 'ppc_btc' then
    begin
      for i := 0 to Length(BidsPPCBTC) - 1 do
        if BidsPPCBTC[i].price >= price then // Считаем объем выше новой цены
          Result := Result + BidsPPCBTC[i].Volume;
    end
    else if pair = 'xpm_btc' then
    begin
      for i := 0 to Length(BidsXPMBTC) - 1 do
        if BidsXPMBTC[i].price >= price then // Считаем объем выше новой цены
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

// Расшифровываем инфо о балансе
procedure GetInfoParse(s: string);
var
  OReturn: TJSONObject;
  i: Integer;
begin
  try
    CS2.Enter;
    try
      OReturn := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(s), 0) as TJSONObject;
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
      CS2.Leave;
      OReturn.Free;
    end;
  except
    CS2.Enter;
    Balance.BTC := 0;
    Balance.LTC := 0;
    Balance.NMC := 0;
    Balance.NVC := 0;
    Balance.TRC := 0;
    Balance.PPC := 0;
    Balance.FTC := 0;
    Balance.XPM := 0;
    Balance.USD := 0;
    Balance.RUR := 0;
    Balance.EUR := 0;
    CS2.Leave;
  end;
end;

// Расшифровываем инфо о Активных ордерах
procedure ParseActiveOrders(s: string);
var
  OReturn, OOrder: TJSONObject;
  i: Integer;
begin
 try
    CS3.Enter;
    try
      SetLength(ActiveOrders, 0);
    finally
      CS3.Leave;
    end;

    OReturn := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(s), 0) as TJSONObject;
    if Assigned(OReturn) then
    begin
     if OReturn.Get('success').JsonValue.Value = '0' then
     begin
      OReturn.Free;
      Exit;
     end;
     OReturn := OReturn.Get('return').JsonValue as TJSONObject;
    end;
    if Assigned(OReturn) then
    begin
     CS3.Enter;
     try
      SetLength(ActiveOrders, OReturn.Size);
      for i := 0 to OReturn.Size - 1 do // Идем по ордерам
      begin
       ActiveOrders[i].order_id := OReturn.Get(i).JsonString.Value;
       OOrder := OReturn.Get(ActiveOrders[i].order_id).JsonValue as TJSONObject;
       ActiveOrders[i].pair := OOrder.Get('pair').JsonValue.Value;
       ActiveOrders[i].OType := OOrder.Get('type').JsonValue.Value;
       ActiveOrders[i].amount := strtofloat(OOrder.Get('amount').JsonValue.Value);
       ActiveOrders[i].rate := strtofloat(OOrder.Get('rate').JsonValue.Value);
       ActiveOrders[i].timestamp := StrToInt(OOrder.Get('timestamp_created').JsonValue.Value);
       ActiveOrders[i].status := StrToInt(OOrder.Get('status').JsonValue.Value);
      end;
     finally
      CS3.Leave;
     end;
     OReturn.Free;
    end;
 except
   CS3.Enter;
   try
    SetLength(ActiveOrders, 0);
   finally
    CS3.Leave;
   end;
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
   Sheet.name:='Данные_из_Delphi';
   j:=6;
   k:=6;
   sheet.cells[1,2]:='Ореда Buy';
   sheet.cells[1,10]:='Ореда Sell';

   sheet.cells[2,1]:='дата';
   sheet.Columns[1].ColumnWidth := 16;
   sheet.cells[2,2]:='ID';
   sheet.Columns[2].ColumnWidth := 10;
   sheet.cells[2,3]:='Всего Vol';
   sheet.cells[2,4]:='Цена';
   sheet.Columns[4].ColumnWidth := 10;
   sheet.cells[2,5]:='Сумма';
   sheet.Columns[5].ColumnWidth := 10;
   sheet.cells[2,6]:='NoneClosedVol';
   sheet.cells[2,7]:='ClosedID';

   sheet.cells[2,9]:='дата';
   sheet.Columns[9].ColumnWidth := 16;
   sheet.cells[2,10]:='ID';
   sheet.Columns[10].ColumnWidth := 10;
   sheet.cells[2,11]:='Всего Vol';
   sheet.Columns[11].ColumnWidth := 10;
   sheet.cells[2,12]:='Цена';
   sheet.Columns[12].ColumnWidth := 10;
   sheet.cells[2,13]:='Сумма';
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
    if (OrderHistory[i].timestamp+14400 >= DateTimeToUnix(ts)) or (TimeStamp='') then
     if OrderHistory[i].OType = 'buy' then
      begin
        sheet.cells[j,1]:=UnixToDateTime(OrderHistory[i].timestamp+14400);
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
        sheet.cells[k,9]:=UnixToDateTime(OrderHistory[i].timestamp+14400);
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

   sheet.cells[3,15]:='разница =';
   sheet.cells[3,16]:=SummRateBuy-SummRateSell;

   sheet.cells[4,14]:='разница сред цены=';
   sheet.cells[4,16]:=SummRateSell/SummVolSell-SummRateBuy/SummVolBuy;

   sheet.cells[5,14]:='прибыль=';
   prib := (SummRateSell/SummVolSell-SummRateBuy/SummVolBuy)*(SummVolBuy+SummVolSell)/2;
   sheet.cells[5,16]:= prib-prib*0.004;

   sheet.Range[sheet.cells[1,1],sheet.cells[(Length(OrderHistory) div 2)+30,15]].Borders.LineStyle := 1;

   ExlApp.DisplayAlerts := False;
   try
    //формат xls 97-2003 если установлен 2003 Excel
     ExlApp.Workbooks[1].saveas('e:\btcebot\temp.xls', -4143);
   except
    //формат xls 97-2003 если установлен 2007-2010 Excel
    ExlApp.Workbooks[1].saveas('e:\btcebot\temp.xls', -4143);
    end;

   ExlApp.Quit;
  finally
   CS5.Leave;
  end;
end;

procedure balanceProc();
var LTCTemp:Extended;
begin
  LTCTemp := Balance.LTC*TopPrice('ltc_usd','buy');
  //if LTCTemp > Balance.USD then BalanceUSDProc := Trunc(Balance.USD*100/LTCTemp)
 // else
 BalanceUSDProc := Trunc(Balance.USD*100/(Balance.USD+LTCTemp));
end;

end.
