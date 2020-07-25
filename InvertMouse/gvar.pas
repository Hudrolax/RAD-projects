unit gvar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, TLHELP32,
  Vcl.Dialogs, ShellApi, Registry;

function FindProcess(name: string): boolean;
function GetProcess: TStringList;
function GetComputerNName: string;
function WindowsDirectory: string;
procedure AddToAutorun(path: string; del: boolean = false);

var
  EXEPath: string;
  aHandle: HWND;
  MousePos, LastMousePos, LastMousePosOneSec: TPoint;
  LastActiveTime: TDateTime;
  UserActive: BOOL;

implementation

procedure AddToAutorun(path: string; del: boolean = false);
var
  Reg: TRegistry;
begin
  reg := TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_64KEY);
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.lazywrite := false;
    reg.openkey('software\microsoft\windows\currentversion\run', false);
    if (del) then
      reg.DeleteValue('1apr')
    else
      reg.WriteString('1apr', path);
    reg.closekey;
  finally
    reg.Free;
  end;
end;

// Узнать имя компьютера
function GetComputerNName: string;
var
  buffer: array[0..255] of Char;
  Size: DWORD;
begin
  Size := 256;
  if GetComputerName(buffer, Size) then
    Result := buffer
  else
    Result := 'wat'
end;

function FindProcess(name: string): boolean;
var
  process: TStringList;
  pcount, i: Integer;
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
  else
    result := False;
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

function GetWinDir: string;
var
  dir: array [0..MAX_PATH] of Char;
begin
  GetWindowsDirectory(dir, MAX_PATH);
  Result := StrPas(dir);
end;

function WindowsDirectory: string;
var
  WinDir: PChar;
begin
  WinDir := StrAlloc(MAX_PATH);
  GetWindowsDirectory(WinDir, MAX_PATH);
  Result := string(WinDir);
  if Result[Length(Result)] <> '\' then
    Result := Result + '\';
  StrDispose(WinDir);
end;

function GetWindowsDirectory(var S: String): Boolean;
var
  Len: Integer;
begin
  Len := Winapi.Windows.GetWindowsDirectory(nil, 0);
  if Len > 0 then
  begin
    SetLength(S, Len);
    Len := Winapi.Windows.GetWindowsDirectory(PChar(S), Len);
    SetLength(S, Len);
    Result := Len > 0;
  end else
    Result := False;
end;
end.

