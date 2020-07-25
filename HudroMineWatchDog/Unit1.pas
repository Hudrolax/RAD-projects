unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, gvar, System.IniFiles,
  Vcl.ExtCtrls, ShellApi;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    Timer1: TTimer;
    TestMinerTimer: TTimer;
    StartMinerTimer: TTimer;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TestMinerTimerTimer(Sender: TObject);
    procedure StartMinerTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
  // Объявление записи клиента
  TFileS = record
    name: string[18];
    date: TDateTime;
  end;

type
  // Объявление записи клиента
  TError = record
    date: TDateTime;
    gpu: string;
    ErrorString: string;
  end;

type
  // Объявление записи клиента
  TErrorList = record
    gpu: string;
    errors: Integer;
  end;

var
  Form1: TForm1;
  FileArray: array of TFileS;
  PathForLogs: string;
  RigName: string;
  _Error: TError;
  MinerExeFile: string;
  StartBatFile: string;
  Ini: Tinifile; //необходимо создать объект, чтоб потом с ним работать
  ArrayOfErrors: array of TError;

implementation

{$R *.dfm}
procedure booblesort2(var A: array of TErrorList);
var
  i, n: Integer;
  tmp: TErrorList;
  Sort: Boolean;
  min, max: Integer;
begin
  min := 0;
  max := Length(A) - 1;
  Sort := True;
  n := 0;
  while Sort do
  begin
    Sort := False;
    for i := min to max - 1 - n do
      if A[i].gpu > A[i + 1].gpu then
      begin
        Sort := True;
        tmp := A[i];
        A[i] := A[i + 1];
        A[i + 1] := tmp;
      end;
    n := n + 1;
  end;
end;

function GetMyVersion:string;
type
  TVerInfo=packed record
    Nevazhno: array[0..47] of byte; // ненужные нам 48 байт
    Minor,Major,Build,Release: word; // а тут версия
  end;
var
  s:TResourceStream;
  v:TVerInfo;
begin
  result:='';
  try
    s:=TResourceStream.Create(HInstance,'#1',RT_VERSION); // достаём ресурс
    if s.Size>0 then begin
      s.Read(v,SizeOf(v)); // читаем нужные нам байты
      result:=Format('%d.%d.%d.%d', [v.Major, v.Minor, v.Release, v.Build]);
    end;
  s.Free;
  except;
   end;
end;

procedure booblesort(var A: array of TFileS);
var
  i, n: Integer;
  tmp: TFileS;
  Sort: Boolean;
  min, max: Integer;
begin
  min := 0;
  max := Length(A) - 1;
  Sort := True;
  n := 0;
  while Sort do
  begin
    Sort := False;
    for i := min to max - 1 - n do
      if A[i].date > A[i + 1].date then
      begin
        Sort := True;
        tmp := A[i];
        A[i] := A[i + 1];
        A[i + 1] := tmp;
      end;
    n := n + 1;
  end;
end;

function ListOfError(vozvrat: boolean): integer;
var
  i, j, e: Integer;
  ErrorList: array of TErrorList;
  est: Boolean;
  f: TextFile;
begin
  if not vozvrat then
  begin
    while ProcessParseLog do
      Sleep(1); // Ждем, пока парсится лог
    ShowingListOfError := True;
  end;
  e := 0;
  Result := 0;
   // Найдем карту в массиве
  for i := 0 to Length(ArrayOfErrors) - 1 do
  begin
    if ArrayOfErrors[i].date < Now - 86400 then
      Continue; // Если ошибке больше суток - пропускаем

    est := false;
    for j := 0 to Length(ErrorList) - 1 do
      if ArrayOfErrors[i].gpu = ErrorList[j].gpu then
      begin
        est := True;
        ErrorList[j].errors := ErrorList[j].errors + 1;
        e := e + 1;
        Break;
      end;
    if not est then
    begin
      SetLength(ErrorList, Length(ErrorList) + 1);
      ErrorList[Length(ErrorList) - 1].gpu := ArrayOfErrors[i].gpu;
      ErrorList[Length(ErrorList) - 1].errors := 1;
      e := e + 1;
    end;
  end;

  for i := 0 to Length(ErrorList) - 1 do
    if ErrorList[i].errors > Result then
      Result := ErrorList[i].errors;

  if vozvrat then
    Exit;

  while ProcessParseLog do
    Sleep(1); // Ждем, пока парсится лог
  if e = 0 then
  begin
    ShowMessage('Ошибок GPU за последние сутки не найдено!');
    ShowingListOfError := False;
    Exit;
  end;
  booblesort2(ErrorList);
  // сохраним в файл
  AssignFile(f, PathForLogs + 'HudroWatchDogErrorList.txt');
  try
    Rewrite(f);
    Writeln(f, 'GPU Error (' + inttostr(e) + ') list on ' + GetDateT + ':');
    for i := 0 to Length(ErrorList) - 1 do
      Writeln(f, 'GPU #' + ErrorList[i].gpu + ': ' + inttostr(ErrorList[i].errors) + ' errors');
    CloseFile(f);
  except
    try
      CloseFile(f);
    except
    end;
  end;
  ShowingListOfError := False;
  if FileExists(PathForLogs + 'HudroWatchDogErrorList.txt') then
    ShellExecute(Form1.Handle, 'open', PWideChar(PathForLogs + 'HudroWatchDogErrorList.txt'), nil, nil, SW_SHOWNORMAL);
    //WinExec(PAnsiChar(AnsiString(PathForLogs+'HudroWatchDogErrorList.txt')), 0);
end;

procedure SaveErrorToArray(error: TError);
begin
  SetLength(ArrayOfErrors, Length(ArrayOfErrors) + 1);
  ArrayOfErrors[Length(ArrayOfErrors) - 1] := error;
end;

function ProcessCount(ProcessName: string): integer;
var
  i: integer;
  process: TStringList;
begin
  Result := 0;
  process := TStringList.Create;
  process.Clear;
  process := GetProcess;
  for i := 0 to process.Count - 1 do
    if process[i] = ProcessName then
      Result := Result + 1;
  process.Free;
end;

procedure ToLog(s: string);
var
  logfile: TextFile;
  FileName: string;
begin
  if s = '' then
    Exit;

  if Form1.ListBox1.Items.Count > 500 then
    Form1.ListBox1.Clear;

  Form1.ListBox1.Items.Append(GetDateT() + ': ' + s);
  FileName := ExtractFilePath(ParamStr(0)) + 'HudroWathDoglog.txt';
  AssignFile(logfile, FileName);
  try
    if FileExists(FileName) then
      Append(logfile)
    else
      Rewrite(logfile);
    Writeln(logfile, GetDateT() + ': ' + s);
    CloseFile(logfile);
  except
    Form1.ListBox1.Items.Append(GetDateT() + ': не могу записать собственный лог-файл HudroWathDoglog.txt!');
  end;

  try
    CloseFile(logfile);
  except
  end;
end;

procedure FindLogs();
var
  FindFile: TSearchRec;
  FullPathAndMask: string;
begin
  FullPathAndMask := PathForLogs + '*_log.txt';
  //Первый этап поиска
  if FindFirst(FullPathAndMask, faAnyFile, FindFile) = 0 //Параметры функции задают поиск на диске с: любых файлов
    then
  begin
    SetLength(FileArray, Length(FileArray) + 1);
    FileArray[Length(FileArray) - 1].name := FindFile.Name;
    FileArray[Length(FileArray) - 1].date := FileDateToDateTime(FindFile.Time);
//Второй этап поиска
    while FindNext(FindFile) = 0 do //Ищем другие файлы на диске, пока не произойдёт ошибка поиска
    begin
      SetLength(FileArray, Length(FileArray) + 1);
      FileArray[Length(FileArray) - 1].name := FindFile.Name;
      FileArray[Length(FileArray) - 1].date := FileDateToDateTime(FindFile.Time);
    end;
//Третий, завершающий этап поиска
    FindClose(FindFile); //Освобождаем память
  end;

  // Сортировка массива по дате
  booblesort(FileArray);
end;

procedure CloseMiner();
var
  f: TextFile;
begin
  ToLog('Пробую убить ' + MinerExeFile + ' ...');
  while ProcessCount(MinerExeFile) > 0 do
  begin
    try
      AssignFile(f, PathForLogs + 'kill.bat');
      Rewrite(f);
      Writeln(f, 'taskkill.exe /f /t /im ' + MinerExeFile);
      CloseFile(f);
      WinExec('kill.bat', 0);
    except
    end;
    try
      CloseFile(f);
    except
    end;
    Sleep(1000);
    DeleteFile(PathForLogs + 'kill.bat');
  end;
end;

function ParseLog(LogName: string): boolean;
var
  log_text: TextFile;
  text: string;
  PosOfError, i: Integer;
  KillFile: TextFile;
  StartUpInfo: TStartUpInfo;
  ProcessInfo: TProcessInformation;
begin
  while ShowingListOfError do
    Sleep(1); // Ждем, пока формируется листинг ошибок;

  Result := False;
  text := '';
  ProcessParseLog := True;

  AssignFile(log_text, PathForLogs + LogName);
  try
    Reset(log_text);
  except
    //Log('Не могу открыть файл ' + PathForLogs+LogName);
    ProcessParseLog := False;
    Exit;
  end;

  while not Eof(log_text) do
  begin
    ReadLn(log_text, text);
    PosOfError := AnsiPos('got incorrect share', text);

    if PosOfError > 0 then
    begin
      for i := 0 to Length(ArrayOfErrors) - 1 do
        if ArrayOfErrors[i].ErrorString = text then
        begin
          PosOfError := 93295841; // Если уже записывали ошибку из этой строки, то пропускаем
          break;
        end;

      if PosOfError = 93295841 then
        continue;

      _Error.date := Now;
      _Error.gpu := Copy(text, AnsiPos('#', text) + 1, 1);
      _Error.ErrorString := text;
      SaveErrorToArray(_Error);

      if ListOfError(true) >= ErrorsForRestartMiner then
      begin
        try
          CloseFile(log_text);
        except
        end;
          // Запишем в лог
        ToLog('Зависла карта #' + _Error.gpu);
        if SendEmailOnGPUFail then
          SendEmail(RigName + ' GPU #' + _Error.gpu + ' FAIL!', 'ACHTUNG!!! ' + RigName + ' GPU #' + _Error.gpu + ' FAIL!');

      // Закроем процесс майнинга
        DoNotCheckMiner := true;
        CloseMiner();
        if ProcessCount(MinerExeFile) = 0 then
        begin
        // удалим логи майнера
          ToLog('Убил. Удаляю логи...');
          for i := 0 to Length(FileArray) - 1 do
            DeleteFile(PathForLogs + FileArray[i].name);
          DeleteFile('temploghudro.txt');
          SetLength(ArrayOfErrors, 0); // Очистим список ошибок
          try
            Form1.StartMinerTimer.Interval := 1;
            Form1.StartMinerTimer.Enabled := True;
            Result := True;
          except
            ToLog('Не могу найти батник для запуска майнинга - ' + StartBatFile);
          end;
        end;
        Break;
      end;
    end;
  end;

  ProcessParseLog := False;
  try
    CloseFile(log_text);
  except
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ListOfError(false);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  NormalClose := True;
  if CloseMinerOnCloseWatchDog and NormalClose then
    CloseMiner();
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  NormalClose := False;

  if ProcessCount(ExtractFileName(ParamStr(0))) > 1 then
    Application.Terminate;
  Started := false;
  PathForLogs := ExtractFilePath(ParamStr(0));
  StartBatFile := 'start.bat';
  MinerExeFile := 'EthDcrMiner64.exe';
  RigName := 'TestRig';
  DoNotCheckMiner := False;

   //создали файл в директории программы
  if not FileExists(PathForLogs + 'HudroMineWatchDog.ini') then
  begin
    Ini := TiniFile.Create(PathForLogs + 'HudroMineWatchDog.ini');
    Ini.WriteString('General', 'PathForLogs', PathForLogs);
    Ini.WriteString('General', 'MinerStartBATFile', StartBatFile);
    Ini.WriteString('General', 'MinerExeFile', MinerExeFile);
    Ini.WriteString('General', 'RigName', RigName);
    Ini.WriteBool('General', 'StartMinerOnStartWatchDog', false);
    Ini.WriteInteger('General', 'StartMinerLatencyInSec', 5);
    Ini.WriteInteger('General', 'MinerStartFailTimer', 30);
    Ini.WriteBool('General', 'CloseMinerOnCloseWatchDog', false);
    Ini.WriteBool('General', 'AlwaysCheckMinerLunched', false);
    Ini.WriteInteger('General', 'ErrorsForRestartMiner', 10);

    Ini.WriteBool('EMail', 'SendEmailOnNotStartMiner', true);
    Ini.WriteBool('EMail', 'SendEmailOnGPUFail', false);
    Ini.WriteString('EMail', 'EmailSender', 'hudrolax@mail.ru');
    Ini.WriteString('EMail', 'EmailReceiver', 'hudro795@gmail.com');
    Ini.WriteString('EMail', 'EMailHost', 'smtp.mail.ru');
    Ini.WriteInteger('EMail', 'EMailPort', 465);
    Ini.WriteString('EMail', 'EMailUsername', 'hudrolax@mail.ru');
    Ini.WriteString('EMail', 'EMailPassword', 'password');
    Ini.WriteBool('EMail', 'EMailTested', false);
    Ini.Free;
    ShowMessage('Создал ini-файл. Вбей в него необходимые настройи и запусти снова!');
    Application.Terminate;
  end
  else
  begin
     //открываем файл
    Ini := TiniFile.Create(PathForLogs + 'HudroMineWatchDog.ini');
    PathForLogs := Ini.ReadString('General', 'PathForLogs', PathForLogs);
    StartBatFile := Ini.ReadString('General', 'MinerStartBATFile', StartBatFile);
    MinerExeFile := Ini.ReadString('General', 'MinerExeFile', MinerExeFile);
    RigName := Ini.ReadString('General', 'RigName', RigName);
    StartMinerOnStartWatchDog := Ini.ReadBool('General', 'StartMinerOnStartWatchDog', false);
    StartMinerLatencyInSec := Ini.ReadInteger('General', 'StartMinerLatencyInSec', 5);
    MinerStartFailTimer := Ini.ReadInteger('General', 'MinerStartFailTimer', 30);
    CloseMinerOnCloseWatchDog := Ini.ReadBool('General', 'CloseMinerOnCloseWatchDog', false);
    AlwaysCheckMinerLunched := Ini.ReadBool('General', 'AlwaysCheckMinerLunched', false);
    ErrorsForRestartMiner := Ini.ReadInteger('General', 'ErrorsForRestartMiner', 10);
    SendEmailOnNotStartMiner := Ini.ReadBool('EMail', 'SendEmailOnNotStartMiner', true);
    SendEmailOnGPUFail := Ini.ReadBool('EMail', 'SendEmailOnGPUFail', false);
    EmailSender := Ini.ReadString('EMail', 'EmailSender', 'hudrolax@mail.ru');
    EmailReceiver := Ini.ReadString('EMail', 'EmailReceiver', 'hudro795@gmail.com');
    EMailHost := Ini.ReadString('EMail', 'EMailHost', 'smtp.mail.ru');
    EMailPort := Ini.ReadInteger('EMail', 'EMailPort', 465);
    EMailUsername := Ini.ReadString('EMail', 'EMailUsername', 'hudrolax@mail.ru');
    EMailPassword := Ini.ReadString('EMail', 'EMailPassword', 'password');
    EMailTested := Ini.ReadBool('EMail', 'EMailTested', false);
    try
      if not EMailTested and (SendEmailOnNotStartMiner or SendEmailOnGPUFail) then
      begin
        SendEmail('Test from HudroWatchDog on rig ' + RigName, 'Test message');
      end;
      EMailTested := True;
    except
      EMailTested := False;
    end;
    Ini.Free;

    Ini := TiniFile.Create(PathForLogs + 'HudroMineWatchDog.ini');
    Ini.WriteString('General', 'PathForLogs', PathForLogs);
    Ini.WriteString('General', 'MinerStartBATFile', StartBatFile);
    Ini.WriteString('General', 'MinerExeFile', MinerExeFile);
    Ini.WriteString('General', 'RigName', RigName);
    Ini.WriteBool('General', 'StartMinerOnStartWatchDog', StartMinerOnStartWatchDog);
    Ini.WriteInteger('General', 'StartMinerLatencyInSec', StartMinerLatencyInSec);
    Ini.WriteInteger('General', 'MinerStartFailTimer', MinerStartFailTimer);
    Ini.WriteBool('General', 'CloseMinerOnCloseWatchDog', CloseMinerOnCloseWatchDog);
    Ini.WriteBool('General', 'AlwaysCheckMinerLunched', AlwaysCheckMinerLunched);
    Ini.WriteInteger('General', 'ErrorsForRestartMiner', ErrorsForRestartMiner);
    Ini.WriteBool('EMail', 'SendEmailOnNotStartMiner', SendEmailOnNotStartMiner);
    Ini.WriteBool('EMail', 'SendEmailOnGPUFail', SendEmailOnGPUFail);
    Ini.WriteString('EMail', 'EmailSender', EmailSender);
    Ini.WriteString('EMail', 'EmailReceiver', EmailReceiver);
    Ini.WriteString('EMail', 'EMailHost', EMailHost);
    Ini.WriteInteger('EMail', 'EMailPort', EMailPort);
    Ini.WriteString('EMail', 'EMailUsername', EMailUsername);
    Ini.WriteString('EMail', 'EMailPassword', EMailPassword);
    Ini.WriteBool('EMail', 'EMailTested', EMailTested);
    Ini.Free;
    Form1.TestMinerTimer.Interval := MinerStartFailTimer * 1000;

    if not FileExists(PathForLogs + MinerExeFile) then
    begin
      ShowMessage('Отсутствует EXE-файл майнера (или не верно указан в .ini) ' + PathForLogs + MinerExeFile);
      Application.Terminate;
    end;

    if (StartMinerOnStartWatchDog) then
      if ProcessCount(MinerExeFile) = 0 then
      begin
        ToLog('Жду ' + IntToStr(StartMinerLatencyInSec) + ' секунд перед запуском майнера...');
        Form1.StartMinerTimer.Interval := StartMinerLatencyInSec * 1000;
        Form1.StartMinerTimer.Enabled := True;
      end
      else
        ToLog('Майнер уже запущен.');

    Timer1.Enabled := True;
    Form1.Caption := 'HudroMineWatchDog v'+GetMyVersion;
  end;
end;

procedure TForm1.StartMinerTimerTimer(Sender: TObject);
begin
  StartMinerTimer.Enabled := False;
  ToLog('Запускаю майнер.');
  WinExec(PAnsiChar(AnsiString(PathForLogs + StartBatFile)), 0);
  Form1.TestMinerTimer.Enabled := true;
end;

procedure TForm1.TestMinerTimerTimer(Sender: TObject);
begin
  TestMinerTimer.Enabled := false;
  if ProcessCount(MinerExeFile) = 1 then
  begin
    ToLog('Майнер успешно запустился.');
    DoNotCheckMiner := false;
    Form1.Timer1.Enabled := True;
  end
  else
  begin
    ToLog('По какой-то причине не смог запустить майнер!!!.');
    if SendEmailOnNotStartMiner then
      SendEmail('Fail RESTART miner on rig ' + RigName, 'Fail Restart miner on rig ' + RigName);
  end;
  if AlwaysCheckMinerLunched then
    Form1.Timer1.Enabled := True;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  i: Integer;
begin
  form1.Timer1.Enabled := false;
  if not Started then
  begin
    Started := True;
    ToLog('WatchDog стартовал!');
  end;

  if ProcessCount(MinerExeFile) > 0 then
    form1.Timer1.Interval := 1000
  else
  begin
    ToLog('Не вижу запущенного майнера...');
    form1.Timer1.Interval := 10000;
    form1.Timer1.Enabled := true;
    Exit;
  end;

  FindLogs();
 // for i := Length(FileArray) - 1 downto 0 do
  //  if ParseLog(FileArray[i].name) then
    //  Break;
  // Читаем только последний лог файл и считаем количество ошибок в гпу
  if Length(FileArray) > 0 then
    ParseLog(FileArray[Length(FileArray) - 1].name);
  SetLength(FileArray, 0);

  if (not DoNotCheckMiner) and (AlwaysCheckMinerLunched) and (ProcessCount(MinerExeFile) = 0) then
  begin
    ToLog('По какой-то причине майнер не запущен. Пытаюсь запустить.');
    ToLog('Жду ' + IntToStr(StartMinerLatencyInSec) + ' секунд перед запуском майнера...');
    Form1.StartMinerTimer.Interval := StartMinerLatencyInSec * 1000;
    Form1.StartMinerTimer.Enabled := True;
    Exit;
  end;

  form1.Timer1.Enabled := true;
end;

end.

