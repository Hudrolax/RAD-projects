unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdContext, IdBaseComponent, IdComponent,
  IdCustomTCPServer, IdTCPServer, IdGlobal;

type
  TForm1 = class(TForm)
    tcpserver1: TIdTCPServer;
    procedure tcpserver1Connect(AContext: TIdContext);
    procedure tcpserver1Execute(AContext: TIdContext);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.tcpserver1Connect(AContext: TIdContext);
begin
  AContext.Connection.IOHandler.ConnectTimeout := 10000;
  AContext.Connection.IOHandler.SendBufferSize := 163840;
  AContext.Connection.IOHandler.DefStringEncoding := IndyTextEncoding(TEncoding.GetEncoding(1251));
end;

procedure TForm1.tcpserver1Execute(AContext: TIdContext);
var s:string;
begin
  s:= AContext.Connection.Socket.ReadLn();
end;

end.
