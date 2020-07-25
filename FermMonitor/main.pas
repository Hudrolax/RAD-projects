unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdBaseComponent, IdComponent,
  IdCustomTCPServer, IdTCPServer, IdContext, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    IdTCPServer1: TIdTCPServer;
    ListBox1: TListBox;
    Timer1: TTimer;
    procedure IdTCPServer1Execute(AContext: TIdContext);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

 type TFerm = record
   name:string;
   runminer:string;
   lastactive:TDateTime;
   ip:string;
 end;

var
  Form1: TForm1;
  FermList:array of TFerm;

implementation

{$R *.dfm}
procedure UpdateList();
var i:Integer;
begin
Form1.ListBox1.Clear;
 if Length(FermList)>0 then
  for i:=0 to Length(FermList)+1 do
    Form1.ListBox1.Items.Append(IntToStr(i+1)+'. '+FermList[i].name+' ('+FermList[i].runminer+') last action at '+DateToStr(FermList[i].lastactive)+' '+TimeToStr(FermList[i].lastactive)+' ['+FermList[i].ip+']');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SetLength(FermList,0);
end;

procedure TForm1.IdTCPServer1Execute(AContext: TIdContext);
var s, dateactive:string;
ferm:TFerm;
  i: Integer;
  UjeEst:bool;

begin
 s:= AContext.Connection.Socket.ReadLn();
 if Copy(s,1,1)='@' then
 begin
  ferm.name := '';
  dateactive:='';
  for i := 2 to Length(s) do
    if Copy(s,i,1)<>';' then ferm.name := ferm.name+Copy(s,i,1) else Break;
  for i := i+1 to Length(s) do
    if Copy(s,i,1)<>';' then ferm.runminer := ferm.runminer+Copy(s,i,1) else Break;
  for i := i+1 to Length(s) do
    if Copy(s,i,1)<>';' then dateactive := dateactive+Copy(s,i,1) else Break;

   try
     ferm.lastactive := StrToDateTime(dateactive);
    except
    end;

   ferm.ip := AContext.Connection.Socket.Binding.PeerIP;
    UjeEst:= False;
 if Length(FermList)>0 then
  for i:=0 to Length(FermList)-1 do
    if FermList[i].name = ferm.name then
    begin
     UjeEst := True;
     FermList[i] := ferm;
    end;

  if NOT UjeEst then
  begin
   SetLength(FermList,Length(FermList)+1);
   FermList[Length(FermList)-1] := ferm;
  end;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
   UpdateList();
end;

end.
