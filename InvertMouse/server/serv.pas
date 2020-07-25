unit serv;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdContext, IdBaseComponent, IdComponent,
  IdCustomTCPServer, IdTCPServer, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm2 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    server: TIdTCPServer;
    ListBox1: TListBox;
    Timer1: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure serverExecute(AContext: TIdContext);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  mes:string;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
  mes := Edit1.Text;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  mes := '';
end;

procedure TForm2.serverExecute(AContext: TIdContext);
var s:string;
begin
  s:= AContext.Connection.Socket.ReadLn();
  if s<>'' then
  begin
    AContext.Connection.Socket.WriteLn(mes);
    if ListBox1.Items.IndexOf(s)<0 then ListBox1.Items.Append(s);
  end;
end;

procedure TForm2.Timer1Timer(Sender: TObject);
begin
  ListBox1.Clear;
end;

end.
