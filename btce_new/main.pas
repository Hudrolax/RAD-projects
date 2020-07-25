unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.DateUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, gvar, SyncObjs,
  Vcl.ComCtrls, Vcl.Menus, inifiles, Vcl.ExtCtrls, Math;

type
  TForm1 = class(TForm)
    edtCommLine: TEdit;
    btnSendButton: TButton;
    Console: TRichEdit;
    procedure edtCommLineKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnSendButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

TWorkThr = class(tthread)
  private
    { Private declarations }
  protected
    procedure execute; override;
    function ErrorResponse(answer:string):Boolean;
  end;

var
  Form1: TForm1;
  WorkThr:TWorkThr;
  Ini: TIniFile;
  ActiveStrateg,AcceptLogging:Boolean;
  PrevTradesString:string;

implementation

{$R *.dfm}
procedure Log(s: string=''; past_time:integer=0);
var
  f: TextFile;
  s1: string;
begin
  if s = '' then
    Exit;

  if Form1.Console.Lines.Count > 1000 then
    Form1.Console.Clear;
  if past_time = 0 then
   s1 := GetDateT + ': ' + s
  else s1 := s;
  Form1.Console.Lines.Append(s1);
  SendMessage(Form1.Console.Handle, EM_SCROLL, SB_LINEDOWN, 0);


  try
    AssignFile(f, exename+'_log.txt');
    if FileExists(exename+'_log.txt') then
     Append(f)
     else
    Rewrite(f);
    Writeln(f, s1);
    CloseFile(f);
  except
    Form1.Console.Lines.Append('!!! Ошибка записи '+exename+'_log.txt на диск!');
    SendMessage(Form1.Console.Handle, EM_SCROLL, SB_LINEDOWN, 0);
  end;
end;

function TWorkThr.ErrorResponse(answer:string):boolean;
begin
  Result := False;
  if answer = 'Connection error' then
     begin
       Synchronize(procedure
                begin
                 Log('!!! Ошибка подключения к btceproxy. Убедитесь, что он запущен...');
                end);
      Sleep(5000);
      Result := True;
     end
    else
    if answer = '' then
     begin {Synchronize(procedure
                begin
                 Log('!!! Ошибка запроса данных с btc-e.com (btceproxy)...');
                end);}
    //  Sleep(3000);
      Result := True;
     end
    else
    if AnsiPos('invalid nonce parameter', answer)>0 then
    begin Synchronize(procedure
                begin
                 Log('Error: '+answer+'... auto retry in 3 sec...');
                end);
      Sleep(3000);
      Result := True;
    end;
end;

procedure TWorkThr.Execute;
const BaseLotPercent = 30; {в процентах от Депо%}
      Comission = 0.2; {в процентах от Цены рыночной %}

var answer:WideString;
sleeptime,i,j,k,loops,LastSellCount,LastBuyCount:Integer;
SummTemp,LastSellPrice,LastBuyPrice,LastBuyAmount,LastSellAmount,SummAmountB, SummAmountS, SummPrice:Extended;
EstOrder,EstD:Boolean;
NoneCloseVolBuy,NoneCloseVolSell:Extended;
NoneCloseSummBuy,NoneCloseSummSell:Extended;
BaseOrderVolume,ProfitForDeal, VolUpSell,VolUpBuy, VolSellPrice, VolBuyPrice:Extended;
BaseLot:integer;
s:string;
f:TextFile;
label
  EndWhileLabel;
begin
loops:=0;
While not Terminated do
  begin
   try
      AssignFile(f,'timestamp.t');
      Rewrite(f);
      writeln(f,DateTimeToStr(Now));
      CloseFile(f);
    except
    end;

   sleeptime := 3000;
   // ******************* Получение стаканов ордеров ***************************
   if NOT GetPrice then
   begin
    Synchronize(procedure
                begin
                  Log('!!! Ошибка сетевого доступа к BTC-E.COM (GetPrice)... auto retry after 15 sec...');
                end);
    sleeptime := 1000;
    goto EndWhileLabel;
   end;
   // ******************** Получение балансов **********************************
    answer := '';
    answer := SendMessageToClient('getInfo');
    if NOT ErrorResponse(answer) then GetInfoParse(answer) else begin goto EndWhileLabel; end;

    // ******************* Получение активных ордеров **************************
    answer := '';
    answer := SendMessageToClient('ActiveOrders');
    if NOT ErrorResponse(answer) then ParseActiveOrders(answer);
    // ******************* Получение истории сделок **************************
    answer := '';
    //answer := SendMessageToClient('TradeHistory&pair=ltc_usd&order=DESC&since='+inttostr(DateTimeToUnix(StrToDateTime('12.08.2014 00.00.00'))-100800));
    answer := SendMessageToClient('TradeHistory&pair=btc_usd&count=500');
    if NOT ErrorResponse(answer) then ParseTradeHistory(answer);

    if Length(CourseSignal)>0 then
     for i := 0 to Length(CourseSignal)-1 do
      if (CourseSignal[i].pair = 'btc_usd') and (not CourseSignal[i].deleted) then
        if CourseSignal[i].TekCourse < CourseSignal[i].level then // на рост
          begin
            if BidsBTCUSD[0].price >= CourseSignal[i].level then
            begin
              SendEmail('BTC '+Floattostr(RoundTo(BidsBTCUSD[0].price,-1)),'');
              CourseSignal[i].deleted := true;
            end;
          end
        else // на спад
        begin
          if AsksBTCUSD[0].price <= CourseSignal[i].level then
            begin
              SendEmail('BTC '+Floattostr(RoundTo(AsksBTCUSD[0].price,-1)),'');
              CourseSignal[i].deleted := true;
            end;
        end;

    if not ActiveStrateg then goto EndWhileLabel; // Если не активна стратегия, то тестовый режим.

    // ****************** Начало стратегии ****************************
    //*****************************************************************
  if (Length(AsksLTCUSD)=0) or (Length(BidsLTCUSD)=0) then goto EndWhileLabel; // Данные запрошены некорректно, пропускаем цикл.

  CalculateLevels(); // Вычислим уровни максимумов и минимумов

  ProfitForDeal := Min1d.rate*100/Max1d.rate-100;
  if ProfitForDeal < 0 then ProfitForDeal := ProfitForDeal*-1;
  ProfitForDeal := RoundTo(ProfitForDeal - ProfitForDeal*30/100,-3);

  MaxVolBuy15 := 0;
  MaxVolSell15 := 0;
  for i :=Length(GlobalLTCUSD)-1 downto 0 do
    if GlobalLTCUSD[i].timestamp > DateTimeToUnix(Now)- 900 then
      if GlobalLTCUSD[i].typeOrder = 'bid' then
        MaxVolBuy15 := MaxVolBuy15 + GlobalLTCUSD[i].amount
      else
        MaxVolSell15 := MaxVolSell15 + GlobalLTCUSD[i].amount;



  // ******* Вычисление статистика за последние 6 минут
  SummAmountB := 0;
  SummAmountS := 0;
  SummPrice := 0;
  k:=0;
  for i:=Length(GlobalLTCUSD)-1 downto 0 do
    if GlobalLTCUSD[i].timestamp > DateTimeToUnix(Now)-360 then // За последние 6 минут
    begin
      if GlobalLTCUSD[i].typeOrder = 'bid' then
        SummAmountB := SummAmountB + GlobalLTCUSD[i].amount
      else SummAmountS := SummAmountS + GlobalLTCUSD[i].amount;
      SummPrice := SummPrice + GlobalLTCUSD[i].price{*GlobalLTCUSD[i].amount};
      k := k+1;
    end else Break;
   if k <> 0 then SummPrice := SummPrice/k{(SummAmountB+SummAmountS)};

   // Запись статистика в файл для анализа
   AssignFile(f,'trades.txt');
   if FileExists('trades.txt') then Append(f) else Rewrite(f);
   s:=DateTimeToStr(Now)+' - Buy '+IntToStr(Round(SummAmountB))+' Sell '+IntToStr(Round(SummAmountS))+
   ' Summ '+IntToStr(Round(SummAmountB+SummAmountS))+', price '+FloatToStr(RoundTo(SummPrice,-6))+' тек. цена '+FloatToStr(RoundTo(GlobalLTCUSD[Length(GlobalLTCUSD)-1].price,-6))+
   ' ('+FloatToStr(RoundTo((GlobalLTCUSD[Length(GlobalLTCUSD)-1].price-SummPrice)*100/GlobalLTCUSD[Length(GlobalLTCUSD)-1].price,-3))+'%)';

   // Тут оцениваем тренд


   // Тут продаем покупаем если обнаружен разворот
   if (GlobalLTCUSD[Length(GlobalLTCUSD)-1].price < Max4h.rate - Max4h.rate*0.8/100)
   and (Max4h.timestamp+360 >= DateTimeToUnix(now)) then
    begin
      if (LastSell2.timestamp < DateTimeToUnix(Now)-1800)
       and (Abs(LastSell2.rate - BidsLTCUSD[0].price) > BidsLTCUSD[0].price*0.5/100) and (Balance.LTC > 5.333) then
      begin
          //answer := SendOrder('ltc_usd','sell', BidsLTCUSD[Length(BidsLTCUSD)-1].price, 5.333);
          if AnsiPos('"success":1',answer)>0 then
            begin
              LastSell2.rate := BidsLTCUSD[0].price;
              LastSell2.timestamp := DateTimeToUnix(Now);
             if AcceptLogging then
                 Synchronize(procedure
                 begin
                   Log('Продал 5333 LTC по новой стратегии 2.');
                 end);
             end
           else
          begin
            if AcceptLogging then
                 Synchronize(procedure
                 begin
                   Log('Не могу продать по новой стратегии 2 - '+answer);
                 end);
           end;
      end;

      s := s+' (max '+FloatTostr(Max4h.rate)+') Тут бы я продал';
      if SummAmountB+SummAmountS > 1000 then s := s+'[!]';
      if SummAmountB < SummAmountS then s := s+'[$]';
    end;
       
   if (GlobalLTCUSD[Length(GlobalLTCUSD)-1].price > Min4h.rate + Min4h.rate*0.8/100)
   and (Min4h.timestamp+360 >= DateTimeToUnix(now)) then
    begin
      if (LastBuy2.timestamp < DateTimeToUnix(Now)-1800)
       and (Abs(LastBuy2.rate - AsksLTCUSD[0].price) > AsksLTCUSD[0].price*0.5/100) and (Balance.LTC > 5.333) then
      begin
         // answer := SendOrder('ltc_usd','buy', AsksLTCUSD[Length(AsksLTCUSD)-1].price , 5.333);
          if AnsiPos('"success":1',answer)>0 then
            begin
              LastBuy2.rate := AsksLTCUSD[0].price;
              LastBuy2.timestamp := DateTimeToUnix(Now);
             if AcceptLogging then
                 Synchronize(procedure
                 begin
                   Log('Купил 5333 LTC по новой стратегии 2.');
                 end);
             end
           else
          begin
            if AcceptLogging then
                 Synchronize(procedure
                 begin
                   Log('Не могу купить по новой стратегии 2 - '+answer);
                 end);
           end;
      end;

      s := s+' (min '+FloatTostr(Min4h.rate)+') Тут бы я купил';
      if SummAmountB+SummAmountS > 1000 then s := s+'[!]';
      if SummAmountB > SummAmountS then s := s+'[$]';
    end;

   
   if Copy(s,25,Length(s)-25) <> Copy(PrevTradesString,25,Length(PrevTradesString)-25) then
   begin
    Writeln(f, s);
    PrevTradesString := s;
   end;
   CloseFile(f);

  BaseLot := Trunc(BaseLotPercent*(Balance.LTC*TopPrice('ltc_usd','buy')+Balance.USD)/100/TopPrice('ltc_usd','buy'));

   // ***** Находим стены
   SummTemp:=0;
   for i:=0 to Length(AsksLTCUSD)-1 do
      SummTemp := SummTemp+AsksLTCUSD[i].Volume;
   SummTemp := SummTemp/Length(AsksLTCUSD);
   CS4.Enter;
   SetLength(AskWalls,0);
   CS4.Leave;
   for i:=0 to Length(AsksLTCUSD)-1 do
    if AsksLTCUSD[i].Volume > SummTemp*1.5 then
      begin
        CS4.Enter;
        SetLength(AskWalls,Length(AskWalls)+1);
        AskWalls[Length(AskWalls)-1].price := AsksLTCUSD[i].price;
        AskWalls[Length(AskWalls)-1].Volume := AsksLTCUSD[i].Volume;
        CS4.Leave;
      end;

   SummTemp:=0;
   for i:=0 to Length(BidsLTCUSD)-1 do
      SummTemp := SummTemp+BidsLTCUSD[i].Volume;
   SummTemp := SummTemp/Length(BidsLTCUSD);
   CS4.Enter;
   SetLength(BidWalls,0);
   CS4.Leave;
   for i:=0 to Length(BidsLTCUSD)-1 do
    if BidsLTCUSD[i].Volume > SummTemp then
      begin
        CS4.Enter;
        SetLength(BidWalls,Length(BidWalls)+1);
        BidWalls[Length(BidWalls)-1].price := BidsLTCUSD[i].price;
        BidWalls[Length(BidWalls)-1].Volume := BidsLTCUSD[i].Volume;
        CS4.Leave;
      end;
    // ***** нашли стены


    // Определяем цену, по которой нужно выставить ордера
    CS4.Enter;
    SellPrice:=0;
    BuyPrice :=0;
    CS4.Leave;
    NoneCloseVolBuy := 0;
    NoneCloseVolSell := 0;
    NoneCloseSummBuy := 0;
    NoneCloseSummSell := 0;
    k:=0;
    if Length(OrderHistory)>0 then
    for i := 0 to Length(OrderHistory)-1 do {Тут ищем не закрытые сделки, на основе взаимозачета, которые сейчас можно пробовать закрывать}
      // Если зависший ордер дальше, чем 0.07$ от текущей цены, то игнорируем его (не пытаемся вытащить, т.к. это безполезно)
      if OrderHistory[i].OType = 'buy' then
        begin
          if (OrderHistory[i].NonClosedAmount > 0.0001) and (OrderHistory[i].rate < AsksLTCUSD[0].price+0.1)
          and ( AnsiPos('0.0695',FloatToStr(Frac(OrderHistory[i].amount)))=0 ) then
          begin
            NoneCloseVolBuy := NoneCloseVolBuy+OrderHistory[i].NonClosedAmount;
            NoneCloseSummBuy := NoneCloseSummBuy + OrderHistory[i].NonClosedAmount * OrderHistory[i].rate;
          end;
          k:=k+1;
        end
      else  {*** SELL ***}
        begin
          if (OrderHistory[i].NonClosedAmount > 0.0001) and (OrderHistory[i].rate > BidsLTCUSD[0].price-0.1)
          and ( AnsiPos('0.0695',FloatToStr(Frac(OrderHistory[i].amount)))=0 ) then
          begin
            NoneCloseVolSell := NoneCloseVolSell+OrderHistory[i].NonClosedAmount;
            NoneCloseSummSell := NoneCloseSummSell + OrderHistory[i].NonClosedAmount * OrderHistory[i].rate;
          end;
          k:=k+1;
        end;

    balanceProc();

    // Цены последних сделок.
    LastBuyPrice := 0;
    LastSellPrice := 0;
    LastBuyCount := 0;
    LastSellCount := 0;
    LastBuyAmount := 0;
    LastSellAmount := 0;
    if Length(OrderHistory)-1 > 50 then
      begin
       for i := 0 to Length(OrderHistory)-1 do
       if OrderHistory[i].pair = 'ltc_usd' then
        begin
          if (OrderHistory[i].OType = 'buy') and (LastBuyCount<10) then
          begin
           LastBuyPrice:=LastBuyPrice+OrderHistory[i].rate*OrderHistory[i].amount;
           LastBuyAmount := LastBuyAmount + OrderHistory[i].amount;
           LastBuyCount := LastBuyCount+1;
           if LastBuyAmount > BaseLot then LastBuyCount := 10;
          end
          else if (OrderHistory[i].OType = 'sell') and (LastSellCount<10) then
          begin
           LastSellPrice:=LastSellPrice+OrderHistory[i].rate*OrderHistory[i].amount;
           LastSellAmount := LastSellAmount + OrderHistory[i].amount;
           LastSellCount := LastSellCount+1;
           if LastSellAmount > BaseLot then LastSellCount := 10;
          end;
          if (LastBuyCount>=10) and (LastSellCount>=10) then Break;
        end;
       LastBuyPrice := LastBuyPrice/LastBuyAmount;
       LastSellPrice := LastSellPrice/LastSellAmount;
      end
    else for i := Length(OrderHistory)-1 downto 0 do
      if OrderHistory[i].pair = 'ltc_usd' then
        begin
          if OrderHistory[i].OType = 'buy' then LastBuyPrice:=OrderHistory[i].rate
          else if OrderHistory[i].OType = 'sell' then LastSellPrice:=OrderHistory[i].rate;
        end;
    if (LastSellAmount > 30) and (BalanceUSDProc < 80) then
      MainBuyLevel := LastSellPrice-LastSellPrice*ProfitForDeal/100;
    if (LastBuyAmount > 30) and (BalanceUSDProc > 20) then
      MainSellLevel := LastBuyPrice+LastBuyPrice*ProfitForDeal/100;

      // Тут тянем Main уровни вслед за ценой, чтобы бот не потерялся при не выгодном движении
    if MainBuyLevel < BidsLTCUSD[0].price-BidsLTCUSD[0].price*ProfitForDeal/100 then
       MainBuyLevel := BidsLTCUSD[0].price-BidsLTCUSD[0].price*ProfitForDeal/100;

    if MainSellLevel > AsksLTCUSD[0].price+AsksLTCUSD[0].price*ProfitForDeal/100 then
       MainSellLevel := AsksLTCUSD[0].price+AsksLTCUSD[0].price*ProfitForDeal/100;

    // Если цена перепрыгнула уровень - возвращаем его на место
    if MainBuyLevel > BidsLTCUSD[0].price+BidsLTCUSD[0].price*Comission/100 then MainBuyLevel := BidsLTCUSD[0].price-BidsLTCUSD[0].price*ProfitForDeal/100;
    if MainSellLevel < AsksLTCUSD[0].price-AsksLTCUSD[0].price*Comission/100 then MainSellLevel := AsksLTCUSD[0].price+AsksLTCUSD[0].price*ProfitForDeal/100;

     // Тут Увеличиваем базовый отступ от текущей цены, если это необходимо
    // Чтобы не совершать подряд много сделок в одном направлении
     if BalanceUSDProc > 50 then
       MainSellLevel := (BalanceUSDProc - 0) * (MainSellLevel+MainSellLevel*ProfitForDeal/100 - MainSellLevel) / (50 - 0) + MainSellLevel
     else
       MainBuyLevel := (BalanceUSDProc - 0) * (MainBuyLevel-MainBuyLevel*ProfitForDeal/100 - MainBuyLevel) / (50 - 0) + MainBuyLevel;


   // Ставим цену так, чтобы перекрыть зависшие ордера, которые вычислялись в коде выше
    if NoneCloseVolBuy>0.5 then
     begin
      if NoneCloseSummBuy/NoneCloseVolBuy > MainSellLevel then
      begin
       MainSellLevel := NoneCloseSummBuy/NoneCloseVolBuy;
       MainSellLevel := MainSellLevel+MainSellLevel*Comission*2/100;
      end;
     end;
    if NoneCloseVolSell>0.5 then
     begin
      if NoneCloseSummSell/NoneCloseVolSell < MainBuyLevel then
      begin
       MainBuyLevel := NoneCloseSummSell/NoneCloseVolSell;
       MainBuyLevel := MainBuyLevel-MainBuyLevel*Comission*2/100;
      end;
     end;

    VolSellPrice := MainSellLevel;
    VolBuyPrice := MainBuyLevel;
    VolUpSell := 0;
    VolUpBuy := 0;
    for i := 0 to Length(AsksLTCUSD)-1 do
      if AsksLTCUSD[i].price < MainSellLevel then
        begin
          VolUpSell := VolUpSell + AsksLTCUSD[i].Volume;
          VolSellPrice := AsksLTCUSD[i].price;
          if (VolUpSell >= 3000) then Break;
        end else Break;
    for i := 0 to Length(BidsLTCUSD)-1 do
      if BidsLTCUSD[i].price > MainBuyLevel then
        begin
          VolUpBuy := VolUpBuy + BidsLTCUSD[i].Volume;
          VolBuyPrice := BidsLTCUSD[i].price;
          if (VolUpBuy >= 2000) then Break;
        end else Break;

    if (VolUpSell > 1000) and (MainSellLevel > VolSellPrice)then MainSellLevel := VolSellPrice;
    if (VolUpBuy > 1500) and (MainBuyLevel < VolBuyPrice)then MainBuyLevel := VolBuyPrice;

    // Ищем, какая стена подойдет для выставления нашего ордера, исходя из предыдущих расчетов
    for i := 0 to Length(AskWalls)-1 do
      if ((AskWalls[i].price >= AsksLTCUSD[0].price+AsksLTCUSD[0].price*Comission/100) and (AskWalls[i].price >= MainSellLevel)) or ((SellPrice = 0) and (i = Length(AskWalls)-1 )) then
         begin
          CS4.Enter;
          SellPrice:=AskWalls[i].price-0.00005;
          CS4.Leave;
          Break;
         end;
    if SellPrice = 0 then SellPrice := LastBuyPrice+LastBuyPrice*ProfitForDeal/100;

    for i := 0 to Length(BidWalls)-1 do
      if ((BidWalls[i].price <= BidsLTCUSD[0].price-BidsLTCUSD[0].price*Comission/100) and (BidWalls[i].price <= MainBuyLevel)) or ((BuyPrice = 0) and (i = Length(AskWalls)-1 )) then
        begin
         CS4.Enter;
         BuyPrice:=BidWalls[i].price+0.00005;
         CS4.Leave;
         Break;
        end;
    if BuyPrice = 0 then BuyPrice := LastSellPrice-LastSellPrice*ProfitForDeal/100;

    // Отменим ордера, если они не подходят той цене, которую мы расчитали
    if Length(ActiveOrders)>0 then
      for i:=0 to Length(ActiveOrders)-1 do
        if (ActiveOrders[i].pair = 'ltc_usd') and (((ActiveOrders[i].OType = 'sell') and (abs(ActiveOrders[i].rate-SellPrice)>0.0000001)) or
        ((ActiveOrders[i].OType = 'buy') and (abs(ActiveOrders[i].rate-BuyPrice)>0.0000001))) then
        begin
          if AnsiPos('"success":1',SendMessageToClient('CancelOrder&order_id=' + ActiveOrders[i].order_id))>0 then
          begin
            if AcceptLogging then
                Synchronize(procedure
                begin
                  Log('Отменил ордер '+ActiveOrders[i].OType+' с ID '+ActiveOrders[i].order_id+' цена '+Floattostr(ActiveOrders[i].rate)+', объем '+Floattostr(ActiveOrders[i].amount));
                end);
          end
          else
           begin
            if AcceptLogging then
                Synchronize(procedure
                begin
                  Log('!!! Не могу отменить ордер с ID '+ActiveOrders[i].order_id);
                end);
           end;
        end;

     // ******************* Получение активных ордеров еще раз**************************
    answer := '';
    answer := SendMessageToClient('ActiveOrders');
    if NOT ErrorResponse(answer) then ParseActiveOrders(answer);

    // *****Дополнительная стратегия******
    // *********** Sell
    EstD := True;
    for i := 0 to Length(OrderHistory)-1 do
      if OrderHistory[i].timestamp > Min12h.timestamp then
       if (OrderHistory[i].OType = 'sell') and (Abs(OrderHistory[i].rate - BidsLTCUSD[0].price) < BidsLTCUSD[0].price*0.5/100) then
         EstD := false;
    if false then
      if (Max5m.timestamp < Min5m.timestamp) and (BidsLTCUSD[0].price > Max12h.rate-Min12h.rate/2) then
        begin
          BaseOrderVolume := RoundTo((BalanceUSDProc - 50) * (Balance.LTC/3 - 1) / (0 - 50) + 1,-8);
          if BaseOrderVolume < 0 then BaseOrderVolume := 1;
          answer := SendOrder('btc_usd','sell', BidsLTCUSD[Length(BidsLTCUSD)-1].price, BaseOrderVolume);
          if AnsiPos('"success":1',answer)>0 then
            begin
             if AcceptLogging then
                 Synchronize(procedure
                 begin
                   Log('Продал 1 LTC по новой стратегии.');
                 end);
             end
           else
          begin
            if AcceptLogging then
                 Synchronize(procedure
                 begin
                   Log('Не могу продать по новой стратегии - '+answer);
                 end);
           end;
         end;
    // *********** Buy
    EstD := True;
    for i := 0 to Length(OrderHistory)-1 do
      if OrderHistory[i].timestamp < Max12h.timestamp then
        if (OrderHistory[i].OType = 'buy') and (Abs(OrderHistory[i].rate - AsksLTCUSD[0].price) < AsksLTCUSD[0].price*0.5/100) then
           EstD := false;
    if false then
      if (Max5m.timestamp > Min5m.timestamp) and (AsksLTCUSD[0].price < Max12h.rate-Min12h.rate/2) then
        begin
          BaseOrderVolume := RoundTo((BalanceUSDProc - 50) * (Balance.LTC/3 - 1) / (100 - 50) + 1,-8);
          if BaseOrderVolume < 0 then BaseOrderVolume := 1;
          answer := SendOrder('btc_usd','buy', AsksLTCUSD[Length(AsksLTCUSD)-1].price, BaseOrderVolume);
          if AnsiPos('"success":1',answer)>0 then
            begin
             if AcceptLogging then
                 Synchronize(procedure
                 begin
                   Log('Купил 1 LTC по новой стратегии.');
                 end);
             end
           else
          begin
            if AcceptLogging then
                 Synchronize(procedure
                 begin
                   Log('Не могу купить по новой стратегии - '+answer);
                 end);
           end;
         end;

    // ************* Выставляем ордера по новой ********************
    // ******* Sell ******************
    BaseOrderVolume := (BalanceUSDProc - 100) * (BaseLot - 0.1) / (30 - 100) + 0.1;

    EstOrder:=False;
    if Length(ActiveOrders)>0 then
      for i := 0 to Length(ActiveOrders)-1 do
        if ActiveOrders[i].OType = 'sell' then EstOrder:=True;
    // ********** Выставляем Sell **********
    LastBuyCount := 0;
    LastBuyAmount := 0;
    if Length(OrderHistory)-1 > 50 then
       for i := 0 to Length(OrderHistory)-1 do
       if OrderHistory[i].pair = 'btc_usd' then
        begin
          if (OrderHistory[i].OType = 'buy') and (LastBuyCount<10) then
          begin
           if OrderHistory[i].rate < SellPrice-SellPrice*ProfitForDeal/100 then
             LastBuyAmount := LastBuyAmount + OrderHistory[i].amount;

           LastBuyCount := LastBuyCount+1;
          end;
          if LastBuyCount>=10 then Break;
        end;

    if (BaseOrderVolume > LastBuyAmount) and (LastBuyAmount>0.1) then BaseOrderVolume := LastBuyAmount;
    if Balance.btc < BaseOrderVolume then BaseOrderVolume := Balance.btc/3;

    if (NOT EstOrder) and (Balance.btc >= BaseOrderVolume) then
    //if not (SummAmountS*10 < SummAmountB) then
    begin
      SellPrice := RoundTo(SellPrice,-6);
      BaseOrderVolume := RoundTo(BaseOrderVolume,-8);
      answer := SendOrder('btc_usd','sell', SellPrice, BaseOrderVolume);
     if AnsiPos('"success":1',answer)>0 then
     begin
        s:='';
       if NoneCloseVolBuy>0.5 then s:=' . Вытягиваю Buy. Зависло '+Floattostr(NoneCloseVolBuy)+'.';
       if AcceptLogging then
                 Synchronize(procedure
                 begin
                   Log('Выставил ордер Sell по цене '+FloatToStr(SellPrice)+s+'. USD '+IntTostr(BalanceUSDProc)+'%');
                 end);
     end
     else
     begin
       if AcceptLogging then
                 Synchronize(procedure
                 begin
                   Log('Не могу выставить ордер Sell - '+answer);
                 end);
      end;
    end;

    // ********** Выставляем Buy **********
    BaseOrderVolume := (BalanceUSDProc - 0) * (BaseLot - 0.1) / (70 - 0) + 0.1;

    EstOrder:=False;
    if Length(ActiveOrders)>0 then
      for i := 0 to Length(ActiveOrders)-1 do
        if ActiveOrders[i].OType = 'buy' then EstOrder:=True;

    LastSellCount := 0;
    LastSellAmount := 0;
    if Length(OrderHistory)-1 > 50 then
       for i := 0 to Length(OrderHistory)-1 do
       if OrderHistory[i].pair = 'btc_usd' then
        begin
          if (OrderHistory[i].OType = 'sell') and (LastSellCount<10) then
          begin
           if OrderHistory[i].rate > BuyPrice+BuyPrice*ProfitForDeal/100 then
             LastSellAmount := LastSellAmount + OrderHistory[i].amount;

           LastSellCount := LastSellCount+1;
          end;
          if LastSellCount>=10 then Break;
        end;

    if (BaseOrderVolume > LastSellAmount) and (LastSellAmount>0.1) then BaseOrderVolume := LastSellAmount;
    if Balance.USD < BaseOrderVolume*BuyPrice then BaseOrderVolume := BaseOrderVolume/3;

    if (NOT EstOrder) and (Balance.USD >= BaseOrderVolume*BuyPrice) then
    //if not (SummAmountB*10 < SummAmountS) then
    begin
      BuyPrice := RoundTo(BuyPrice,-6);
      BaseOrderVolume := RoundTo(BaseOrderVolume,-8);
      answer := SendOrder('btc_usd','buy', BuyPrice, BaseOrderVolume);
      if AnsiPos('"success":1',answer)>0 then
      begin
       s:='';
       if NoneCloseVolSell>0.5 then s:=' . Вытягиваю Sell. Зависло '+Floattostr(NoneCloseVolSell)+'.';
       if AcceptLogging then
                 Synchronize(procedure
                 begin
                   Log('Выставил ордер Buy по цене '+FloatToStr(BuyPrice)+s+'. USD '+IntTostr(BalanceUSDProc)+'%');
                 end);
      end
      else
      begin
       if AcceptLogging then
                 Synchronize(procedure
                 begin
                   Log('Не могу выставить Buy ордер - '+answer);
                 end);
      end;
    end;



   EndWhileLabel:loops := loops+1;
   Synchronize(procedure
                begin
                  Form1.Caption := 'BTC-e BOT - loops '+inttostr(loops)+' (Profit for deal '+Floattostr(ProfitForDeal)+'%)';
                end);

    for i := 1 to sleeptime do
    begin
      if Terminated then Exit;
      Sleep(1);
    end;
  end;
end;


procedure showbalances();
begin
  CS2.Enter;
  try
    Log(' ',1);
    Log('Balances:',1);
    Log('USD: '+FloatToStrF(Balance.USD, ffgeneral, 8, 4),1);
    Log('EUR: '+FloatToStrF(Balance.EUR, ffgeneral, 8, 4),1);
    Log('RUR: '+FloatToStrF(Balance.RUR, ffgeneral, 8, 4),1);
    Log('BTC: '+FloatToStrF(Balance.BTC, ffgeneral, 8, 8),1);
    Log('LTC: '+FloatToStrF(Balance.LTC, ffgeneral, 8, 8),1);
    Log('NMC: '+FloatToStrF(Balance.NMC, ffgeneral, 8, 8),1);
    Log('NVC: '+FloatToStrF(Balance.NVC, ffgeneral, 8, 8),1);
    Log('TRC: '+FloatToStrF(Balance.TRC, ffgeneral, 8, 8),1);
    Log('PPC: '+FloatToStrF(Balance.PPC, ffgeneral, 8, 8),1);
    Log('FTC: '+FloatToStrF(Balance.FTC, ffgeneral, 8, 8),1);
    Log('XPM: '+FloatToStrF(Balance.XPM, ffgeneral, 8, 8),1);
    Log(' ',1);
  finally
    CS2.Leave;
  end;
end;

procedure showinfo();
begin
  try
    Log(' ',1);
    Log('Global history from '+DateTimeToStr(UnixToDateTime(GlobalbtcUSD[0].timestamp)),1);
    Log(' ',1);
    Log('5m Max и Min уровни:',1);
    Log('_______________________',1);
    Log('Max5m: '+FloatToStr(Max5m.rate)+' - '+DateTimeToStr(UnixToDateTime(Max5m.timestamp)),1);
    Log('Min5m: '+FloatToStr(Min5m.rate)+' - '+DateTimeToStr(UnixToDateTime(Min5m.timestamp)),1);
    Log('Цена изменилась на '+FloatToStr(RoundTo(Max5m.rate-Min5m.rate,-6))+'$ ('+FloatToStr(RoundTo(Max5m.rate*100/Min5m.rate-100,-3))+'%)',1);
    if Max5m.timestamp >= Min5m.timestamp then
      Log('Тренд восходящий!!',1)
    else Log('Тренд нисходящий((',1);
    Log(' ',1);
    Log('15m Max и Min уровни:',1);
    Log('_______________________',1);
    Log('Max15m: '+FloatToStr(Max15m.rate)+' - '+DateTimeToStr(UnixToDateTime(Max15m.timestamp)),1);
    Log('Min15m: '+FloatToStr(Min15m.rate)+' - '+DateTimeToStr(UnixToDateTime(Min15m.timestamp)),1);
    Log('Цена изменилась на '+FloatToStr(RoundTo(Max15m.rate-Min15m.rate,-6))+'$ ('+FloatToStr(RoundTo(Max15m.rate*100/Min15m.rate-100,-3))+'%)',1);
    if Max15m.timestamp >= Min15m.timestamp then
      Log('Тренд восходящий!!',1)
    else Log('Тренд нисходящий((',1);
    Log(' ',1);
    Log('30m Max и Min уровни:',1);
    Log('_______________________',1);
    Log('Max30m: '+FloatToStr(Max30m.rate)+' - '+DateTimeToStr(UnixToDateTime(Max30m.timestamp)),1);
    Log('Min30m: '+FloatToStr(Min30m.rate)+' - '+DateTimeToStr(UnixToDateTime(Min30m.timestamp)),1);
    Log('Цена изменилась на '+FloatToStr(RoundTo(Max30m.rate-Min30m.rate,-6))+'$ ('+FloatToStr(RoundTo(Max30m.rate*100/Min30m.rate-100,-3))+'%)',1);
    if Max30m.timestamp >= Min30m.timestamp then
      Log('Тренд восходящий!!',1)
    else Log('Тренд нисходящий((',1);
    Log(' ',1);
    Log('1H Max и Min уровни:',1);
    Log('_______________________',1);
    Log('Max1h: '+FloatToStr(Max1h.rate)+' - '+DateTimeToStr(UnixToDateTime(Max1h.timestamp)),1);
    Log('Min1h: '+FloatToStr(Min1h.rate)+' - '+DateTimeToStr(UnixToDateTime(Min1h.timestamp)),1);
    Log('Цена изменилась на '+FloatToStr(RoundTo(Max1h.rate-Min1h.rate,-6))+'$ ('+FloatToStr(RoundTo(Max1h.rate*100/Min1h.rate-100,-3))+'%)',1);
    if Max1h.timestamp >= Min1h.timestamp then
      Log('Тренд восходящий!!',1)
    else Log('Тренд нисходящий((',1);
    Log(' ',1);
    Log('4H Max и Min уровни:',1);
    Log('_______________________',1);
    Log('Max4h: '+FloatToStr(Max4h.rate)+' - '+DateTimeToStr(UnixToDateTime(Max4h.timestamp)),1);
    Log('Min4h: '+FloatToStr(Min4h.rate)+' - '+DateTimeToStr(UnixToDateTime(Min4h.timestamp)),1);
    Log('Цена изменилась на '+FloatToStr(RoundTo(Max4h.rate-Min4h.rate,-6))+'$ ('+FloatToStr(RoundTo(Max4h.rate*100/Min4h.rate-100,-3))+'%)',1);
    if Max4h.timestamp >= Min4h.timestamp then
      Log('Тренд восходящий!!',1)
    else Log('Тренд нисходящий((',1);
    Log(' ',1);
    Log('1D Max и Min уровни:',1);
    Log('_______________________',1);
    Log('Max1d: '+FloatToStr(Max1d.rate)+' - '+DateTimeToStr(UnixToDateTime(Max1d.timestamp)),1);
    Log('Min1d: '+FloatToStr(Min1d.rate)+' - '+DateTimeToStr(UnixToDateTime(Min1d.timestamp)),1);
    Log('Цена изменилась на '+FloatToStr(RoundTo(Max1d.rate-Min1d.rate,-6))+'$ ('+FloatToStr(RoundTo(Max1d.rate*100/Min1d.rate-100,-3))+'%)',1);
    if Max1d.timestamp >= Min1d.timestamp then
      Log('Тренд восходящий!!',1)
    else Log('Тренд нисходящий((',1);
    Log(' ',1);
    Log('За 15 мин объемы: ',1);
    Log('Продаж '+IntToStr(Round(MaxVolSell15)),1);
    Log('Покупок '+IntToStr(Round(MaxVolBuy15)),1);
  finally
  end;
end;

procedure ShowPriceTOP(pair:string = 'btc_usd');
begin
  CS1.Enter;
  try
   if (Length(BidsbtcUSD)>0) and (Length(AsksbtcUSD)>0) then
     Log('Покупка: '+FloatToStrF(BidsbtcUSD[0].price, ffgeneral, 8, 4)+', Продажа: '+FloatToStrF(AsksbtcUSD[0].price, ffgeneral, 8, 4))
   else Log('Ошибка запроса стакана цен.');
  finally
   CS1.Leave;
  end;
end;

procedure ShowPriceOrders(pair:string = 'btc_usd');
begin
  CS4.Enter;
  try
    Log(' ',1);
    Log('Целевые цены ордеров:',1);
    LOG('Sell: '+FloatToStrF(SellPrice, ffgeneral, 8, 8)+' ,Buy: '+FloatToStrF(BuyPrice, ffgeneral, 8, 8),1);
  finally
    CS4.Leave;
  end;
end;

procedure ShowActiveOrders(pair:string = 'btc_usd');
var i:Integer;
begin
  CS3.Enter;
  try
  if Length(ActiveOrders)>0 then
   begin
    Log(' ',1);
    Log('Активные ордера:',1);
    for i:=0 to Length(ActiveOrders)-1 do
      Log(' '+inttostr(i+1)+'. '+'ID:'+ActiveOrders[i].order_id+', pair: '+ActiveOrders[i].pair+', type: '+ActiveOrders[i].OType+', volume: '+FloatToStrF(ActiveOrders[i].amount, ffgeneral, 8, 8)+', price: '+FloatToStrF(ActiveOrders[i].rate, ffgeneral, 8, 8),1);
    Log(' ',1);
   end
  else Log('Активных ордеров нет.');
  finally
    CS3.Leave;
  end;
end;

procedure SendMessageTC(s:string);
var answer:widestring;
begin
  Log(s,1);
  answer := SendMessageToClient(s);
  Log(' ',1);
  Log(answer,1);
end;

procedure ShowWalls;
var i:Integer;
begin
  CS4.Enter;
  try
  if (Length(AskWalls)>0) and (Length(AskWalls)>0) then
    begin
      Log(' ',1);
      Log('Стены на продажу:',1);
      for i:= Length(AskWalls)-1 downto 0 do
        Log('price: '+FloatToStrF(AskWalls[i].price, ffgeneral, 8, 8)+'  vol: '+Inttostr(Trunc(AskWalls[i].Volume)),1);
      Log(' ',1);
      Log('Стены на покупку:',1);
      for i:= 0 to Length(BidWalls)-1 do
        Log('price: '+FloatToStrF(BidWalls[i].price, ffgeneral, 8, 8)+'  vol: '+Inttostr(Trunc(BidWalls[i].Volume)),1);
    end;
  finally
    CS4.Leave;
  end;
end;

procedure ShowHistory();
var i:Integer;
begin
  CS5.Enter;
  try
    Log('История сделок:',1);
    if Length(OrderHistory)>0 then
    for i := 0 to Length(OrderHistory)-1 do
      Log(IntToStr(i)+'. '+OrderHistory[i].OType+', '+Floattostr(OrderHistory[i].amount)+', '+Floattostr(OrderHistory[i].rate),1);
  finally
    CS5.Leave;
  end;
end;

procedure SetSignal(str:string);
begin
  if (str <> '') and (IsDigit(str)) then
    begin
      SetLength(CourseSignal,Length(CourseSignal)+1);
      CourseSignal[Length(CourseSignal)-1].level := StrToFloat(str);
      CourseSignal[Length(CourseSignal)-1].TekCourse := BidsBTCUSD[0].price;
      CourseSignal[Length(CourseSignal)-1].pair := 'btc_usd';
      CourseSignal[Length(CourseSignal)-1].deleted := false;
      SaveCourseSignal;
      Log('Установлен сигнал на цену '+str);
    end else Log('Не верный формат команды!',0);
end;

procedure ShowSignals();
var i:Integer;
del:string;
begin
  if Length(CourseSignal)>0 then
    for i := 0 to Length(CourseSignal)-1 do
      begin
        if CourseSignal[i].deleted then del:='deleted' else del:='active';

        Log(FloatToStr(CourseSignal[i].level)+', '+del+', '+FloatToStr(CourseSignal[i].TekCourse),0);
      end
  else Log('Активных сигналов нет',0);
end;

procedure ParseCommand(command:string);
begin
  LastCommand:=command;
  if command='exit' then
   begin
    Log('Получена команда выхода.');
    Application.Terminate;
   end
  else
  if command='topprice' then ShowPriceTOP() else
  if command='deletesignal' then begin SetLength(CourseSignal,0); Log('Сигналы очищены',0) end else
  if (command='showsignals') or (command='showsignal') then ShowSignals() else
  if AnsiPos('signal ',command)>0 then SetSignal(Copy(command,8,Length(command)-7)) else
  if (command='showinfo') or (command='info') then showinfo() else
  if command='nolog' then AcceptLogging:= NOT AcceptLogging else
  if command='history' then SaveToXLS() else
  if AnsiPos('history ',command)>0 then SaveToXLS(Copy(command,9,Length(command)-8)) else
  if command='active' then ActiveStrateg:=True else
  if command='priceorders' then ShowPriceOrders() else
  if command='clear' then Form1.Console.Clear else
  if command='start' then begin WorkThr.Resume; Log('Рабочий поток запущен.'); end else
  if command='stop' then begin WorkThr.Suspend; Log('Рабочий поток остановлен.'); end else
  if (command='orders') or (command='order') then ShowActiveOrders() else
  if (command='balance') or (command='balances') then showbalances else
  if AnsiPos('cancel',command)>0 then
    begin
      if IsDigit(Copy(command,8,Length(command)-7)) then
        if AnsiPos('"success":1',SendMessageToClient('CancelOrder&order_id=' + Copy(command,8,Length(command)-7)))>0 then
          Log('Ордер '+Copy(command,8,Length(command)-7)+' отменен.');

    end
  else
  if AnsiPos('send',command)>0 then
  begin
   SendMessageTC(Copy(command,6,Length(command)-5));
  end
  else
  if command='walls' then ShowWalls
  else
  Log('Неизвестная команда.');

  Form1.edtCommLine.Text := '';
end;

procedure TForm1.edtCommLineKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_RETURN then ParseCommand(edtCommLine.Text);
  if Key=VK_UP then edtCommLine.Text := LastCommand;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  edtCommLine.SetFocus;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var f:TextFile;
  k:file of TGlobalOrderHistory;
  MF:file of TMaxMin;
  i:Integer;
begin
 if not FileExists('config.ini') then
 try
  Ini:=TiniFile.Create(extractfilepath(paramstr(0))+'config.ini'); //Создаем файл настроек
  ini.WriteString('Base','btceproxy_ip','127.0.0.1');
  ini.WriteInteger('Base','btceproxy_port',3738);
  Ini.Free
 except
   end;

 try
  AssignFile(f,'mainprices.dat');
  rewrite(f);
  Writeln(f,FloatToStr(MainBuyLevel));
  Writeln(f,FloatToStr(MainSellLevel));
  Finally
  CloseFile(f);
 End;

 try
  AssignFile(MF,'MaxMin.dat');
  rewrite(MF);
  Write(MF,Max5m);
  Write(MF,Min5m);
  Write(MF,Max15m);
  Write(MF,Min15m);
  Write(MF,Max30m);
  Write(MF,Min30m);
  Write(MF,Max1h);
  Write(MF,Min1h);
  Write(MF,Max4h);
  Write(MF,Min4h);
  Write(MF,Max6h);
  Write(MF,Min6h);
  Write(MF,Max12h);
  Write(MF,Min12h);
  Write(MF,Max1d);
  Write(MF,Min1d);
  Finally
  CloseFile(MF);
 End;

 try
  AssignFile(MF,'LastBuySell2.dat');
  rewrite(MF);
  Write(MF,LastBuy2);
  Write(MF,LastSell2);
  CloseFile(MF);
 except
 end;

  if Length(GlobalbtcUSD)>0 then
  begin
    AssignFile(k,'history.dat');
    rewrite(k);
    for I := 0 to Length(GlobalbtcUSD)-1 do
      Write(k,GlobalbtcUSD[i]);
    CloseFile(k);
  end;

  SaveCourseSignal;

  AssignFile(f,'1.bat');
  rewrite(f);
  Writeln(f,'taskkill.exe /F /IM BotController.exe');
  CloseFile(f);
  WinExec('1.bat',0);
  Sleep(300);
  DeleteFile('1.bat');
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var i:Integer;
begin
  Log('Получена команда выхода.');

  // Отменим все ордера перед выходом
//    if Length(ActiveOrders)>0 then
//      for I := 0 to Length(ActiveOrders)-1 do
//        if (ActiveOrders[i].pair = 'btc_usd') then
//          if AnsiPos('"success":1',SendMessageToClient('CancelOrder&order_id=' + ActiveOrders[i].order_id))>0 then
//            Log('Отменил ордер с ID '+ActiveOrders[i].order_id+' цена '+Floattostr(ActiveOrders[i].rate)+', объем '+Floattostr(ActiveOrders[i].amount))
//          else
//            Log('!!! Не могу отменить ордер с ID '+ActiveOrders[i].order_id);

  try
    WorkThr.Terminate;
    if not WorkThr.Suspended then WorkThr.WaitFor;
    FreeAndNil(WorkThr);
  except
  end;
  CS1.Free;
  CS2.Free;
  CS3.Free;
  CS4.Free;
  CS5.Free;

  SetLength(VirtualOrders, 0);
  SetLength(ActiveOrders, 0);
  SetLength(OrderHistory, 0);
  SetLength(CancelOrdersList, 0);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i, pcount: Integer;
  process: TStringList;
  f:textfile;
  s:string;
  k:file of TGlobalOrderHistory;
  MF:file of TMaxMin;
begin
  try
      AssignFile(f,'timestamp.t');
      Rewrite(f);
      writeln(f,DateTimeToStr(Now));
      CloseFile(f);
    except
    end;

  // Завершам работу, если копия уже запущена
  gpath := extractfilepath(paramstr(0));
  exename:=ExtractFileName(Application.ExeName);
  process := TStringList.Create;
  process.Clear;
  process := GetProcess;
  pcount := 0;
  for i := 0 to process.Count - 1 do
    if process[i] = exename then
      pcount := pcount + 1;
  if pcount > 1 then
    Application.Terminate;

   // Подгружаем настройки
  try
    Ini := TIniFile.Create(gpath+'config.ini'); // создаем файл настроек
    proxy_ip := ini.ReadString('Base','btceproxy_ip','hud.net.ru');
    proxy_port := ini.ReadInteger('Base','btceproxy_port',3738);
    Ini.Free;
  except
    ShowMessage('Не могу загрузить настройки из config.ini');
    Exit;
  end;

  CS1 := TCriticalSection.Create;
  CS2 := TCriticalSection.Create;
  CS3 := TCriticalSection.Create;
  CS4 := TCriticalSection.Create;
  CS5 := TCriticalSection.Create;

  LastBuy2.rate := 0;
  LastBuy2.timestamp := 0;
  LastSell2.rate := 0;
  LastSell2.timestamp := 0;

  WinExec('BotController.exe',0);

  if FileExists('mainprices.dat') then
   try
    AssignFile(f,'mainprices.dat');
    reset(f);
    Readln(f,s);
    MainBuyLevel := StrToFloatDef(s,0);
    Readln(f,s);
    MainSellLevel := StrToFloatDef(s,0);
    CloseFile(f);
    except
    end;

  if FileExists('MaxMin.dat') then
   try
    AssignFile(MF,'MaxMin.dat');
    reset(MF);
    Read(MF,Max5m);
    Read(MF,Min5m);
    Read(MF,Max15m);
    Read(MF,Min15m);
    Read(MF,Max30m);
    Read(MF,Min30m);
    Read(MF,Max1h);
    Read(MF,Min1h);
    Read(MF,Max4h);
    Read(MF,Min4h);
    Read(MF,Max6h);
    Read(MF,Min6h);
    Read(MF,Max12h);
    Read(MF,Min12h);
    Read(MF,Max1d);
    Read(MF,Min1d);
    CloseFile(MF);
    except
    end;

  if FileExists('LastBuySell2.dat') then
   try
    AssignFile(MF,'LastBuySell2.dat');
    reset(MF);
    Read(MF,LastBuy2);
    Read(MF,LastSell2);
    CloseFile(MF);
    except
    end;

  if FileExists('history.dat') then
    try
      AssignFile(k, 'history.dat');
      Reset(k);
      SetLength(GlobalbtcUSD, FileSize(k));
      i := 0;
      while not Eof(k) do
      begin
        Seek(k, i);
        read(k, GlobalbtcUSD[i]);
        i := i + 1;
      end;
      CloseFile(k);
    except
    end;

  LoadCourseSignal();
    
  AcceptLogging := true;
    
  Log('Привет! Начинаем работу.');
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  WorkThr:=TWorkThr.Create(True);
  WorkThr.FreeOnTerminate := False;
  WorkThr.Priority := tpNormal;
  WorkThr.Resume;

  Log('Рабочий поток запущен.');
end;

procedure TForm1.btnSendButtonClick(Sender: TObject);
begin
  ParseCommand(edtCommLine.Text);
end;

end.
