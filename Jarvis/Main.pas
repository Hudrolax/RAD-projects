unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, Vcl.ExtCtrls, IdAntiFreezeBase,
  Vcl.IdAntiFreeze, IdGlobal;

type
  TForm1 = class(TForm)
    client: TIdTCPClient;
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  Form1: TForm1;

implementation
{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  s: string;
begin
client.Connect;
client.IOHandler.DefStringEncoding := IndyTextEncoding(TEncoding.GetEncoding(1251));
  s:= Edit2.Text;
  // Отправка после вставки
  if (client.Connected) and (Form1.Edit2.Text <> '') then
    client.Socket.WriteLn(s);
  client.Disconnect;
  Edit2.Text := '';
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  // Отправка после вставки
  if client.Connected then
    client.Socket.WriteLn('test:'+edit1.Text);
  Edit1.Text:='';
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var RetrCmd:string;
begin
  if client.Connected then
  begin
    RetrCmd := client.Socket.ReadLn();
    if RetrCmd <> '' then
      ShowMessage(RetrCmd);
  end;
end;

end.
