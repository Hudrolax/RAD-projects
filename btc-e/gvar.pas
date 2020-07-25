unit Gvar;

interface

uses System.SysUtils, Types, Winapi.Windows, TLHELP32, Classes, StdCtrls,
  Data.DBXJSON, Winapi.Messages,
  Vcl.Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,
  IdExplicitTLSClientServerBase,
  IdMessageClient, IdSMTPBase, IdSMTP, IdMessage;


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
  end;

  TTradesPublic = record
    type_order: string[10];
    price: Extended;
    amount: Extended;
    tid: Integer;
    timestamp: Integer;
  end;

  TTSkupka = record
    pair: string[10];
    amount: Extended;
    rate: Extended;
    deleted: Boolean;
  end;

  TVirtualOrder = record
    area: string[20];
    pair: string[7];
    OType: string[4];
    amount: real;
    rate: real;
    min_rate: real;
    step: real;
    stepF1: real;
    step2: real;
    MultiAverge: Integer;
    AfterOrderID: string[10];
    order_id: string[50];
    Children_price: real;
    delta: real;
    deltaF1: Real;
    delta2: Real;
    MakeReverseOrder:Boolean;
    comment:string[50];
    deleted: Boolean;
    first_step:Real;
  end;

  TTCourseSignal = record
    level: real;
    TekCourse: real;
    pair: string[10];
    deleted: Boolean;
  end;

  TGlobalOrderHistory = record
    typeOrder: string[4];
    price: real;
    amount: real;
    tid: string[20];
    timestamp: Integer;
  end;

  TCandle = record
    period: Integer;
    OpenTime: Integer;
    max: real;
    min: real;
    volume_buy: real;
    volume_sell: real;
  end;

  TStrateg1 = record
    pair:string[10];
    SType:Integer;
    rate:real;
    lot:real;
    delta1F1:Real;
    step1F1:real;
    delta1F2:Real;
    step1F2:real;
    delta2:Real;
    step2:real;
    first_step:real;
    multi:Integer;
    deleted:Boolean;
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
function TopPrice(pair: string; Order_type: string; plus: real = 0): real;
function ReverseOrderType(OType: string): string;
function StrToStrFloat(str: string): string;
procedure SendMessageToClient(msg: string; trade: Boolean = false);
function SendOrder(pair: string; type_order: string; rate: Extended; Volume: Extended; trade: Boolean = true): string;
function TrailOrder(var VirtualOrder: TVirtualOrder; var Arr: ATDepth; ArrHistory: TTGlobalOrderHistory): string;
function VolumeUpPrice(price: real; pair: string; OType: string): real;
function AvergeLastXAmount(pair: string; OType: string; x: Integer): real;
function AvergeForLast(var HistArray: TTGlobalOrderHistory; ot: string; x: Integer): real;
procedure SaveStrateg();
procedure SaveCourseSignal();
procedure SaveVirtualOrders();
procedure SendEmail(Subj:string; messag:string);

var
  AsksBTCUSD, BidsBTCUSD, AsksBTCRUR, BidsBTCRUR, AsksLTCBTC, BidsLTCBTC, AsksLTCUSD, BidsLTCUSD, AsksLTCRUR, BidsLTCRUR, AsksLTCEUR, BidsLTCEUR,
    AsksNMCBTC, BidsNMCBTC, AsksNMCUSD, BidsNMCUSD, AsksNVCBTC, BidsNVCBTC, AsksNVCUSD, BidsNVCUSD, AsksTRCBTC, BidsTRCBTC, AsksPPCBTC, BidsPPCBTC,
    AsksFTCBTC, BidsFTCBTC, AsksXPMBTC, BidsXPMBTC: ATDepth;
  ActiveOrders: array of TOrders;
  OrderHistory: array of TOrderHistory;
  TradesBTCUSD: array of TTradesPublic;
  Skupka: array of TTSkupka;
  VirtualOrders: array of TVirtualOrder;
  CourseSignal: array of TTCourseSignal;
  MojnoBrat: Boolean;
  GlobalBTCUSD, GlobalBTCRUR, GlobalLTCBTC, GlobalLTCUSD, GlobalLTCRUR, GlobalNMCBTC, GlobalNMCUSD, GlobalNVCBTC, GlobalNVCUSD, GlobalTRCBTC,
    GlobalPPCBTC, GlobalXPMBTC: TTGlobalOrderHistory;
  Candle60: array of TCandle;
  Strateg1: array of TStrateg1;
  Balance: TBalance;
  gpath:string;

implementation

// Отправляем сообщение на биржу
procedure SendMessageToClient(msg: string; trade: Boolean = false);
var
  client: TIdTCPClient;
begin
  client := TIdTCPClient.Create();
  client.Host := '127.0.0.1';
  if trade then
    client.Port := 3739
  else
    client.Port := 3738;
  client.ReadTimeout := 5000;
  try
    client.Connect;
    if client.Connected then
    begin
      client.Socket.WriteLn(msg);
      client.Disconnect;
    end;
  finally
    client.Free;
  end;
end;

function SendOrder(pair: string; type_order: string; rate: Extended; Volume: Extended; trade: Boolean = true): string;
begin
  SendMessageToClient('Trade&pair=' + pair + '&type=' + type_order + '&rate=' + ZapToT4k(FloatToStr(rate)) + '&amount=' +
    ZapToT4k(FloatToStr(Volume)), trade);
  Result := 'Open ' + type_order + ' for pair ' + pair + ' at ' + FloatToStr(Volume) + ' price ' + FloatToStr(rate) + '.';
end;

procedure SendEmail(Subj:string; messag:string);
var
  IdMessage1:TIdMessage;
  IdSMTP: TIdSMTP;
  IdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
begin
  { формируем тело сообщения }
  IdMessage1 := TIdMessage.Create;
  IdMessage1.From.Address := 'hudrolax@mail.ru';
  IdMessage1.Recipients.EMailAddresses := 'hudro795@gmail.com';
  IdMessage1.Subject := UTF8Encode(Subj);
  IdMessage1.Body.Append(UTF8Encode(messag));
  IdMessage1.Date := now;

  { настройка компонентов перед отправкой }
  IdSMTP := TIdSMTP.Create(nil);

  IdSMTP.Host := 'smtp.mail.ru';
  IdSMTP.Port := 465;
  // обычно при использование ssl 495, 587 или стандартный 25
  IdSMTP.Username := 'hudrolax@mail.ru';
  IdSMTP.Password := 'Eremes2inholl7950295';

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

function TopPrice(pair: string; Order_type: string; plus: real = 0): real;
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
  OReturn := TJSONObject.Create;
  try
    OReturn := TJSONObject.Create;
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
    OReturn.Free;
  end;
end;

procedure ParseDepth(var ArrAsks, ArrBids: ATDepth; GetStr: string);
var
  OReturn: TJSONObject;
  OAsks, OBids: TJSONArray;
  i: Integer;
begin
  OReturn := TJSONObject.Create;
  try
    MojnoBrat := false;
    OReturn := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(GetStr), 0) as TJSONObject;
    // ****************** Заполняем массив Asks ************************************
    OAsks := OReturn.Get('asks').JsonValue as TJSONArray;
    SetLength(ArrAsks, OAsks.Size);
    for i := 0 to OAsks.Size - 1 do
    begin
      ArrAsks[i].price := StrToFloat((OAsks.Get(i) as TJSONArray).Get(0).Value);
      ArrAsks[i].Volume := StrToFloat((OAsks.Get(i) as TJSONArray).Get(1).Value);
    end;

    // ****************** Заполняем массив Bids ************************************
    OBids := OReturn.Get('bids').JsonValue as TJSONArray;
    SetLength(ArrBids, OBids.Size);
    for i := 0 to OBids.Size - 1 do
    begin
      ArrBids[i].price := StrToFloat((OBids.Get(i) as TJSONArray).Get(0).Value);
      ArrBids[i].Volume := StrToFloat((OBids.Get(i) as TJSONArray).Get(1).Value);
    end;
  finally
    MojnoBrat := true;
    OReturn.Free;
  end;
end;

function Valute1FromPair(pair: string): string;
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

function Valute2FromPair(pair: string): string;
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

function VolumeUpPrice(price: real; pair: string; OType: string): real;
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

function AvergeForLast(var HistArray: TTGlobalOrderHistory; ot: string; x: Integer): real;
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

function AvergeLastXAmount(pair: string; OType: string; x: Integer): real;
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

function TrailOrder(var VirtualOrder: TVirtualOrder; var Arr: ATDepth; ArrHistory: TTGlobalOrderHistory): string;
var
  i, j, k, LengthVO: Integer;
  VNewRate, VAmount, ComplateRate, AvergeAmount: real;
  temp_step:real;
begin
  if VirtualOrder.OType = 'sell' then // продаем
  begin
    VNewRate := Arr[0].price - VirtualOrder.delta;
    if (VirtualOrder.rate = VirtualOrder.min_rate) and (NOT VirtualOrder.MakeReverseOrder) then
    begin
      temp_step := VirtualOrder.first_step;
    end
    else
    begin
     temp_step := VirtualOrder.step;
    end;


    if VNewRate > VirtualOrder.rate + temp_step then
    begin
      VAmount := VolumeUpPrice(VNewRate, VirtualOrder.pair, 'buy');

      AvergeAmount := 0; //AvergeLastXAmount(VirtualOrder.pair, 'buy', 20);

      // ************** Двигаем виртуальный ордер ****************
      if VAmount > (VirtualOrder.amount + AvergeAmount) * VirtualOrder.MultiAverge then
      begin
        VirtualOrder.rate := VNewRate;
        Result := 'Переставляю Trail. Пара ' + VirtualOrder.pair + ', тип ' + VirtualOrder.OType + ', цена ' + FloatToStr(VNewRate) +
          ', верхняя цена ' + FloatToStr(Arr[0].price) + ', объем сверху ' + FloatToStr(VAmount);
      end;
    end;

    // ************** Исполняем виртуальный ордер ****************
    if (VirtualOrder.rate <> VirtualOrder.min_rate) then
    begin
      VAmount := VolumeUpPrice(VirtualOrder.rate, VirtualOrder.pair, 'buy');

      if (VAmount <= (VirtualOrder.amount + AvergeAmount) * VirtualOrder.MultiAverge) or (Arr[0].price <= VirtualOrder.rate) then
      // Если над целевой ценой осталось объема менее объема ордера+% - нахуй
      begin
        ComplateRate := VirtualOrder.rate;
        if Arr[Length(Arr) - 1].price < ComplateRate then
          ComplateRate := Arr[Length(Arr) - 1].price;
        SendOrder(VirtualOrder.pair, VirtualOrder.OType, ComplateRate, VirtualOrder.amount, true);
        Result := 'Исполнен ордер по Trailing Stop (' + VirtualOrder.pair + ', ' + VirtualOrder.OType + ')! Цена >= ' + FloatToStr(VirtualOrder.rate)
          + ', объем ' + FloatToStr(VirtualOrder.amount) + ', объем над ордером был ' + FloatToStr(VAmount);

        // Если есть флаг реверс-ордера - создаем его
        if VirtualOrder.MakeReverseOrder then
        begin
          LengthVO := Length(VirtualOrders);
          SetLength(VirtualOrders,LengthVO+1);
          VirtualOrders[LengthVO].area := 'trail_order';
          VirtualOrders[LengthVO].pair := VirtualOrder.pair;
          VirtualOrders[LengthVO].OType := ReverseOrderType(VirtualOrder.OType);
          VirtualOrders[LengthVO].amount := VirtualOrder.amount*0.998;
          if VirtualOrders[LengthVO].amount<0.1 then VirtualOrders[LengthVO].amount:=0.1;
          VirtualOrders[LengthVO].rate := VirtualOrder.rate*0.992;
          VirtualOrders[LengthVO].min_rate := VirtualOrder.rate*0.992;
          VirtualOrders[LengthVO].step := VirtualOrder.step2;
          VirtualOrders[LengthVO].first_step := VirtualOrder.first_step;
          VirtualOrders[LengthVO].MultiAverge := VirtualOrder.MultiAverge;
          VirtualOrders[LengthVO].delta := VirtualOrder.delta2;
          VirtualOrders[LengthVO].MakeReverseOrder := False;
          VirtualOrders[LengthVO].comment := VirtualOrder.comment;

          if VirtualOrders[LengthVO].pair = 'ltc_usd' then
            if Balance.LTC<0.1 then
            begin
              if Length(Strateg1)>0 then
                for i := 0 to Length(Strateg1)-1 do
                  if Strateg1[i].pair = VirtualOrders[LengthVO].pair then
                    Strateg1[i].deleted := True;

              if Length(VirtualOrders)>0 then
                for i := 0 to Length(VirtualOrders)-1 do
                  if (VirtualOrders[i].pair = VirtualOrders[LengthVO].pair)
                    and (AnsiPos('Strateg1',VirtualOrders[i].comment)>0) then
                    VirtualOrders[i].deleted := True;
            end;

          if VirtualOrders[LengthVO].pair = 'btc_usd' then
            if Balance.BTC<0.1 then
            begin
              if Length(Strateg1)>0 then
                for i := 0 to Length(Strateg1)-1 do
                  if Strateg1[i].pair = VirtualOrders[LengthVO].pair then
                    Strateg1[i].deleted := True;

              if Length(VirtualOrders)>0 then
                for i := 0 to Length(VirtualOrders)-1 do
                  if (VirtualOrders[i].pair = VirtualOrders[LengthVO].pair)
                    and (AnsiPos('Strateg1',VirtualOrders[i].comment)>0) then
                    VirtualOrders[i].deleted := True;
            end;

          if VirtualOrders[LengthVO].pair = 'ltc_rur' then
            if Balance.LTC<0.1 then
            begin
              if Length(Strateg1)>0 then
                for i := 0 to Length(Strateg1)-1 do
                  if Strateg1[i].pair = VirtualOrders[LengthVO].pair then
                    Strateg1[i].deleted := True;

              if Length(VirtualOrders)>0 then
                for i := 0 to Length(VirtualOrders)-1 do
                  if (VirtualOrders[i].pair = VirtualOrders[LengthVO].pair)
                    and (AnsiPos('Strateg1',VirtualOrders[i].comment)>0) then
                    VirtualOrders[i].deleted := True;
            end;

          Result:= Result +' Создал противоположный ордер.';
        end;

        VirtualOrder.deleted := true;
      end;
    end;

  end
  else if VirtualOrder.OType = 'buy' then // продаем
  begin
    VNewRate := Arr[0].price + VirtualOrder.delta;
    if (VirtualOrder.rate = VirtualOrder.min_rate)
    and (NOT VirtualOrder.MakeReverseOrder) then
    begin
      temp_step := VirtualOrder.first_step;
    end
    else
    begin
     temp_step := VirtualOrder.step;
    end;

    if VNewRate < VirtualOrder.rate - temp_step then
    begin
      VAmount := VolumeUpPrice(VNewRate, VirtualOrder.pair, 'sell');

      AvergeAmount := AvergeLastXAmount(VirtualOrder.pair, 'sell', 20);

      // ************** Двигаем виртуальный ордер ****************
      if VAmount > (VirtualOrder.amount + AvergeAmount) * VirtualOrder.MultiAverge then
      begin
        VirtualOrder.rate := VNewRate;
        Result := 'Переставляю Trail. Пара ' + VirtualOrder.pair + ', тип ' + VirtualOrder.OType + ', цена ' + FloatToStr(VNewRate) +
          ', верхняя цена ' + FloatToStr(Arr[0].price) + ', объем сверху ' + FloatToStr(VAmount);
      end;
    end;

    // ************** Исполняем виртуальный ордер ****************
    if (VirtualOrder.rate <> VirtualOrder.min_rate) then
    begin
      VAmount := VolumeUpPrice(VirtualOrder.rate, VirtualOrder.pair, 'sell');

      if (VAmount <= (VirtualOrder.amount + AvergeAmount) * VirtualOrder.MultiAverge) or (Arr[0].price >= VirtualOrder.rate) then
      // Если над целевой ценой осталось объема менее объема ордера+% - нахуй
      begin
        ComplateRate := VirtualOrder.rate;
        if Arr[Length(Arr) - 1].price > ComplateRate then
          ComplateRate := Arr[Length(Arr) - 1].price;
        SendOrder(VirtualOrder.pair, VirtualOrder.OType, ComplateRate, VirtualOrder.amount, true);
        Result := 'Исполнен ордер по Trailing Stop (' + VirtualOrder.pair + ', ' + VirtualOrder.OType + ')! Цена >= ' + FloatToStr(VirtualOrder.rate)
          + ', объем ' + FloatToStr(VirtualOrder.amount) + ', объем над ордером был ' + FloatToStr(VAmount);

        // Если есть флаг реверс-ордера - создаем его
        if VirtualOrder.MakeReverseOrder then
        begin
          LengthVO := Length(VirtualOrders);
          SetLength(VirtualOrders,LengthVO+1);
          VirtualOrders[LengthVO].area := 'trail_order';
          VirtualOrders[LengthVO].pair := VirtualOrder.pair;
          VirtualOrders[LengthVO].OType := ReverseOrderType(VirtualOrder.OType);
          VirtualOrders[LengthVO].amount := VirtualOrder.amount*0.998;
          if VirtualOrders[LengthVO].amount<0.1 then VirtualOrders[LengthVO].amount:=0.1;
          VirtualOrders[LengthVO].rate := VirtualOrder.rate*1.008;
          VirtualOrders[LengthVO].min_rate := VirtualOrder.rate*1.008;
          VirtualOrders[LengthVO].step := VirtualOrder.step2;
          VirtualOrders[LengthVO].first_step := VirtualOrder.first_step;
          VirtualOrders[LengthVO].MultiAverge := VirtualOrder.MultiAverge;
          VirtualOrders[LengthVO].delta := VirtualOrder.delta2;
          VirtualOrders[LengthVO].MakeReverseOrder := False;
          VirtualOrders[LengthVO].comment := VirtualOrder.comment;

          if VirtualOrders[LengthVO].pair = 'ltc_usd' then
            if Balance.LTC<0.1 then
            begin
              if Length(Strateg1)>0 then
                for i := 0 to Length(Strateg1)-1 do
                  if Strateg1[i].pair = VirtualOrders[LengthVO].pair then
                    Strateg1[i].deleted := True;

              if Length(VirtualOrders)>0 then
                for i := 0 to Length(VirtualOrders)-1 do
                  if (VirtualOrders[i].pair = VirtualOrders[LengthVO].pair)
                    and (AnsiPos('Strateg1',VirtualOrders[i].comment)>0) then
                    VirtualOrders[i].deleted := True;
            end;

          if VirtualOrders[LengthVO].pair = 'btc_usd' then
            if Balance.BTC<0.1 then
            begin
              if Length(Strateg1)>0 then
                for i := 0 to Length(Strateg1)-1 do
                  if Strateg1[i].pair = VirtualOrders[LengthVO].pair then
                    Strateg1[i].deleted := True;

              if Length(VirtualOrders)>0 then
                for i := 0 to Length(VirtualOrders)-1 do
                  if (VirtualOrders[i].pair = VirtualOrders[LengthVO].pair)
                    and (AnsiPos('Strateg1',VirtualOrders[i].comment)>0) then
                    VirtualOrders[i].deleted := True;
            end;

          if VirtualOrders[LengthVO].pair = 'ltc_rur' then
            if Balance.LTC<0.1 then
            begin
              if Length(Strateg1)>0 then
                for i := 0 to Length(Strateg1)-1 do
                  if Strateg1[i].pair = VirtualOrders[LengthVO].pair then
                    Strateg1[i].deleted := True;

              if Length(VirtualOrders)>0 then
                for i := 0 to Length(VirtualOrders)-1 do
                  if (VirtualOrders[i].pair = VirtualOrders[LengthVO].pair)
                    and (AnsiPos('Strateg1',VirtualOrders[i].comment)>0) then
                    VirtualOrders[i].deleted := True;
            end;


          Result:= Result + ' Создал противоположный ордер.';
        end;

        VirtualOrder.deleted := true;
      end;
    end;

  end;
end;

procedure SaveStrateg();
var i:Integer;
    FS1: file of TStrateg1;
begin
if Length(Strateg1) > 0 then
    try
      AssignFile(FS1, 'strateg1.dat');
      Rewrite(FS1);
      for i := 0 to Length(Strateg1) - 1 do
        if NOT Strateg1[i].deleted then
          write(FS1, Strateg1[i]);
    finally
      CloseFile(FS1);
    end;
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

end.
