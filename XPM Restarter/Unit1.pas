unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, TLHELP32, inifiles;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Timer2: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  exe_name,start_bat:string;
  Ini: TIniFile;
  Restart_interval:Integer;

implementation

{$R *.dfm}

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

function find_mine_process():boolean;
var
process: TStringList;
pcount,i:Integer;
begin
  Result:= false;
   process := TStringList.Create;
  process.Clear;
  process := GetProcess;
  pcount := 0;
  for i := 0 to process.Count - 1 do
    if process[i] = exe_name then
      pcount := pcount + 1;
  if pcount > 0 then
    Result:= true;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var f:TextFile;
begin
   AssignFile(f,'kill_miner.bat');
  Rewrite(f);
  Writeln(f,'taskkill.exe /F /IM '+exe_name);
  CloseFile(f);
  WinExec('kill_miner.bat',0);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   // Подгружаем настройки
  try
    Ini := TIniFile.Create(extractfilepath(paramstr(0))+'config.ini'); // создаем файл настроек
    exe_name := Ini.ReadString('Base','exe_miner','jhPrimeminer-T16v2.exe');
    Restart_interval := Ini.ReadInteger('Base','restart_interval',60);
    Ini.Free;
  except
    ShowMessage('Не могу загрузить настройки из config.ini');
  end;
  Restart_interval := Restart_interval*60000;
  Timer1.Interval := Restart_interval;
  Timer1.Enabled := True;
  Timer2.Enabled := True;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var f:TextFile;
begin
  AssignFile(f,'kill_miner.bat');
  Rewrite(f);
  Writeln(f,'taskkill.exe /F /IM '+exe_name);
  CloseFile(f);
  WinExec('kill_miner.bat',0);
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  if not find_mine_process() then
  begin
    WinExec('miner.bat',SW_SHOW);
  end;
end;

end.
