unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs,
 gvar;

type
  TMineController = class(TService)
    procedure ServiceExecute(Sender: TService);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  MineController: TMineController;

implementation

{$R *.dfm}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  MineController.Controller(CtrlCode);
end;

function TMineController.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;


procedure TMineController.ServiceExecute(Sender: TService);
var f:textfile;
Mouse:TPoint;
begin
  EXEPath:=extractfilepath(paramstr(0));
 // ProverkaRegZadaniy();

  while NOT StopSignal do
  begin
   GetCursorPos(Mouse);
   assignfile(f,'c:\123.txt');
   rewrite(f);
   writeln(f,TimeToStr(time)+' X:'+inttostr(Mouse.X)+' Y:'+inttostr(Mouse.Y));
   CloseFile(f);

   sleep(500);
  end;
end;

procedure TMineController.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  StopSignal := true;
end;

end.
