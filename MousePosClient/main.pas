unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, gvar, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Timer2: TTimer;
    client: TIdTCPClient;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if client.Connected then
    client.Disconnect;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  if FindProcess(ExtractFileName(GetModuleName(0))) then Exit;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  Form1.Visible := False;
  Timer2.Enabled := true;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var mpos:TPoint;
begin
  Timer2.Enabled := False;
  GetCursorPos(mpos);
  if not client.Connected then
  try
    client.Connect;
  except
  end;
  if client.Connected then
  begin
    client.Socket.WriteLn(IntToStr(mpos.X)+';'+IntToStr(mpos.Y));
  end;
  Timer2.Enabled := true;
end;

end.
