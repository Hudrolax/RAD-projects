unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, System.DateUtils, gvar;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Timer2: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var process:TStringList;
pcount,i:Integer;
begin
 process := TStringList.Create;
 process.Clear;
 process := GetProcess;
 pcount := 0;
 for i := 0 to process.Count - 1 do
   if process[i] = 'BotController.exe' then
     pcount := pcount + 1;
 if pcount > 1 then
   Application.Terminate;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Timer1.Enabled := true;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var f:TextFile;
s:string;
r:Double;
process:TStringList;
pcount,i:Integer;
begin
  Timer1.Enabled := False;
  if FileExists('timestamp.t') then
  try
    r:=0;
    AssignFile(f,'timestamp.t');
    Reset(f);
    Readln(f,s);
    CloseFile(f);
    r:= DateTimeToUnix(Now) - DateTimeToUnix(StrToDateTime(s));
    if r > 300 then
    try
      process := TStringList.Create;
      process.Clear;
      process := GetProcess;
      pcount := 0;
      for i := 0 to process.Count - 1 do
        if process[i] = 'btce_bot.exe' then
          pcount := pcount + 1;

      AssignFile(f,'restart.bat');
      rewrite(f);
      if pcount > 0 then
      begin
       Writeln(f,'taskkill.exe /F /IM btce_bot.exe');
       Writeln(f,'ping -n 10 -w 1 127.0.0.1 > nul ');
      end;
      Writeln(f,'btce_bot.exe');
      CloseFile(f);
      WinExec('restart.bat',0);
    except
    end;
  Except
  end;
  Timer1.Enabled := True;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  Timer2.Enabled := false;
  Form1.Visible := false;
end;

end.
