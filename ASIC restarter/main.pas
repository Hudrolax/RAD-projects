unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,
  IdExplicitTLSClientServerBase,
  IdMessageClient, IdSMTPBase, IdSMTP, IdMessage, IdHTTP, Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Label1: TLabel;
    Button1: TButton;
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ComFile: THandle;
  SecondForStart:integer;

implementation

{$R *.dfm}
function OpenCOMPort: Boolean;
begin
  ComFile := CreateFile(PChar('COM10'),
    GENERIC_READ or GENERIC_WRITE,
    0,
    nil,
    OPEN_EXISTING,
    FILE_ATTRIBUTE_NORMAL,
    0);

  if ComFile = INVALID_HANDLE_VALUE then
    Result := False
  else
    Result := True;
end;

function SetupCOMPort: Boolean;
const
  RxBufferSize = 256;
  TxBufferSize = 256;
var
  DCB: TDCB;
  Config: string;
  CommTimeouts: TCommTimeouts;
begin
  Result := True;

  if not SetupComm(ComFile, RxBufferSize, TxBufferSize) then
    Result := False;

  if not GetCommState(ComFile, DCB) then
    Result := False;

  Config := 'baud=9600 parity=n data=8 stop=1';

  if not BuildCommDCB(@Config[1], DCB) then
    Result := False;

  if not SetCommState(ComFile, DCB) then
    Result := False;

  with CommTimeouts do
  begin
    ReadIntervalTimeout         := 0;
    ReadTotalTimeoutMultiplier  := 0;
    ReadTotalTimeoutConstant    := 1000;
    WriteTotalTimeoutMultiplier := 0;
    WriteTotalTimeoutConstant   := 1000;
  end;

  if not SetCommTimeouts(ComFile, CommTimeouts) then
    Result := False;
end;

procedure SendText(s: string);
var
  BytesWritten: DWORD;
begin
  s := s + #13 + #10;
  WriteFile(ComFile, PChar(s)^, Length(s), BytesWritten, nil);
end;

Function ReadText: string;
var
  d: array[1..80] of Char;
  s: string;
  BytesRead, i: Dword;
begin
  Result := '';
  if not ReadFile(ComFile, d, SizeOf(d), BytesRead, nil) then
  begin
    { Raise an exception }
  end;
  s := '';
  for i := 1 to BytesRead do s := s + d[I];
  Result := s;
end;


procedure CloseCOMPort;
begin
  CloseHandle(ComFile);
end;

procedure TForm1.Button1Click(Sender: TObject);
const
CommPort = 'COM10';
var TimeoutBuffer: PCOMMTIMEOUTS;
NumberWritten: cardinal;
rtn:Boolean;
s: string;
begin
  ComFile := CreateFile(PChar(CommPort), GENERIC_WRITE + GENERIC_READ,
0, nil, OPEN_EXISTING,
FILE_ATTRIBUTE_NORMAL,0);
//
//GetMem(TimeoutBuffer, sizeof(COMMTIMEOUTS));
//GetCommTimeouts (ComFile, TimeoutBuffer^);
//TimeoutBuffer.ReadIntervalTimeout := 300;
//TimeoutBuffer.ReadTotalTimeoutMultiplier := 300;
//TimeoutBuffer.ReadTotalTimeoutConstant := 300;
//SetCommTimeouts (ComFile, TimeoutBuffer^);
//
//FreeMem(TimeoutBuffer, sizeof(COMMTIMEOUTS));

s:='$KE,REL,1,1' + #13 + #10;
rtn:=WriteFile(ComFile, PChar(s)^,Length(s), NumberWritten, nil);
Sleep(500);
s:='$KE,REL,1,0' + #13 + #10;
rtn:=WriteFile(ComFile, PChar(s)^,Length(s), NumberWritten, nil);
closehandle(ComFile);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  GetStr: WideString;
  http: TIdHTTP;
  i,EnabledChips:Integer;
  OneChipIsDead:Boolean;
begin
  Timer1.Enabled := False;
  try
    http := TIdHTTP.Create();
    http.ReadTimeout := 5000;
    try
     GetStr := http.Get('http://192.168.18.70/miner.php?ref=0&rig=0');
    except
     Sleep(5000);
     Timer1.Enabled := True;
     Exit;
    end;
  finally
    FreeAndNil(http);
  end;
  EnabledChips := 0;
  OneChipIsDead := false;
  for i:=1 to Length(GetStr)-1 do
    if Copy(GetStr,i,3) = '>Y<' then
    begin
     EnabledChips := EnabledChips + 1;
     SecondForStart := 0;
    end;
  for i:=1 to Length(GetStr)-1 do
    if (Copy(GetStr,i,6) = '>Dead<') or (Copy(GetStr,i,6) = '>Sick<') then
    begin
     OneChipIsDead := True;
     SecondForStart := 0;
    end;
  for I := 1 to Length(GetStr)-1 do
    if Copy(GetStr,i,29) = 'ERR: socket connect(0) failed' then
      SecondForStart := SecondForStart+1;


  GetStr:='';
  if (OneChipIsDead) or (EnabledChips < 12) or (SecondForStart >= 10) then
  begin
    ShowMessage('Проблемы с ASIC!!!');
    Label1.Caption := 'ASIC завис!';
    Label1.Font.Color := clRed;
    Exit;
  end;

  Label1.Caption := 'ASIC работает нормально';
  Label1.Font.Color := clGreen;
  Timer1.Enabled := True;
end;

end.
