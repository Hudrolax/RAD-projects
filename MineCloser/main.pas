unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Timer1Timer(Sender: TObject);
var CloseMine:Boolean;
f:TextFile;
s:string;
begin
  CloseMine := False;
  if FileExists('UPSEVENT.CSV') then
  begin
   AssignFile(f,'UPSEVENT.CSV');
   try
    Reset(f);
    while not Eof(f) do
      begin
       readln(f,s);
       if AnsiPos('¬ходное питание отключено',s)>0 then
        CloseMine := True
       else if AnsiPos('¬ходное питание восстановлено',s)>0 then
        CloseMine := False;
      end;
   finally
    CloseFile(f);
   end;
   if CloseMine then
   begin
     AssignFile(f,'closemine.bat');
     Rewrite(f);
     Writeln(f,'taskkill.exe /F /IM NsGpuCNMiner.exe');
     CloseFile(f);
     WinExec('closemine.bat',0);
   end;
  end;

end;

end.
