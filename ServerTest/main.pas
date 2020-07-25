unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdGlobal, IdContext, IdBaseComponent, IdComponent,
  IdCustomTCPServer, IdTCPServer, Vcl.StdCtrls, TlHelp32, Vcl.ExtCtrls, gvar;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    server: TIdTCPServer;
    Edit1: TEdit;
    Button1: TButton;
    Timer1: TTimer;
    procedure serverExecute(AContext: TIdContext);
    procedure serverConnect(AContext: TIdContext);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  const path = 'C:\jarivs\';
  FileData = path+'toandroid.jarvis';
  FileFlag = path+'toandroid.jf';

var
  Form1: TForm1;
  gpath,toclient_global:string;

implementation

{$R *.dfm}
procedure SendCustomMessage(s:string);
  var f:TextFile;
begin
    AssignFile(f,path+'fromedit1.jarvis');

  if FileExists(path+'fromedit1.jarvis') then
   try
     Append(f);
    Writeln(f,s);
    CloseFile(f);
   except
   end
  else
    try
    rewrite(f);
    Writeln(f,s);
    CloseFile(f);
    except
    end;

  try
    AssignFile(f,path+'fromedit1.jf');
    rewrite(f);
    CloseFile(f);
  except
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  SendCustomMessage(Edit1.Text);
  SendEmail('From Jarvis',Edit1.Text);
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

procedure TForm1.FormCreate(Sender: TObject);
var
  process: TStringList;
  i, pcount: Integer;
begin
  gpath := extractfilepath(paramstr(0));

  // Завершам работу, если копия уже запущена
  process := TStringList.Create;
  process.Clear;
  process := GetProcess;
  pcount := 0;
  for i := 0 to process.Count - 1 do
    if process[i] = path+'servAndroid.exe' then
      pcount := pcount + 1;
  if pcount > 1 then
    Application.Terminate;

end;

procedure TForm1.serverConnect(AContext: TIdContext);
begin
  AContext.Connection.IOHandler.ConnectTimeout := 10000;
  AContext.Connection.IOHandler.SendBufferSize := 163840;
  AContext.Connection.IOHandler.DefStringEncoding := IndyTextEncoding(TEncoding.GetEncoding(1251));
end;

procedure ParseCMD(s:string);
begin

end;

procedure SendCMDToDC(s:string);
var f:TextFile;
getflag:boolean;
answer,jcmd:string;
begin
  if s='s' then
  begin
   AssignFile(f,path+'toandroid.s');
   Rewrite(f);
   Writeln(f,s);
   CloseFile(f);
   // flag...
   AssignFile(f,path+'toandroid.fs');
   Rewrite(f);
   CloseFile(f);
  end
  else
    begin
      AssignFile(f,path+'toandroid.txt');
      Rewrite(f);
      Writeln(f,s);
      CloseFile(f);
      // flag...
      AssignFile(f,path+'toandroid.f');
      Rewrite(f);
      CloseFile(f);
    end;

end;

procedure TForm1.serverExecute(AContext: TIdContext);
var
  s,s2,toclient,FileData,FileFlag:string;
  f:TextFile;
begin
 s:= AContext.Connection.Socket.ReadLn();
 SendCMDToDC(s);
 if s<>'s' then
 begin
   ListBox1.Items.Append(s);
 end;

 if ((AnsiPos('сервер',s)>0) or (AnsiPos('server',s)>0)) and ((AnsiPos('андроид',s)>0) or (AnsiPos('android',s)>0)) then
   SendCustomMessage('Сервер андроида в порядке '+TimeToStr(Now));

 // Сообщения андроиду
 toclient := '';
 if toclient_global <> '' then
  begin
    toclient :=  toclient_global;
    toclient_global := '';
  end;

 // Сообщение из Edit1
 if FileExists(path+'fromedit1.jarvis') and FileExists(path+'fromedit1.jf') then
 begin
     try
      AssignFile(f,path+'fromedit1.jarvis');
      reset(f);
      while not Eof(f) do
       begin
         Readln(f,toclient);
         toclient := toclient + sLineBreak;
       end;
      CloseFile(f);
     except
     end;
     DeleteFile(path+'fromedit1.jarvis');
     DeleteFile(path+'fromedit1.jf');

 end;

 if toclient = '' then toclient := 'n';
 AContext.Connection.Socket.WriteLn(toclient);
 toclient:='';
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var f:textfile;
message_text,s,s2:string;
begin
  Timer1.Enabled := false;
 if FileExists(FileData) and FileExists(FileFlag) then
 begin
     try
      message_text := '';
      AssignFile(f,FileData);
      reset(f);
      Readln(f,s2);
      while not Eof(f) do
       begin
        Readln(f,s);
        message_text := message_text + s +  sLineBreak;
       end;

      if s2='online' then toclient_global := message_text else SendEmail('From Jarvis',message_text);

      CloseFile(f);
     except
     end;

     try
      CloseFile(f);
     except

     end;
     DeleteFile(FileData);
     DeleteFile(FileFlag);
 end;
 Timer1.Enabled := true;
end;

end.
