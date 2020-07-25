unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

function FilterValut(v:string): Boolean;
var
  f,f2: TextFile;
  s:string;
  k:Integer;
begin
  try
    try
      Result := true;
      AssignFile(f, 'boilenger2.csv');
      Reset(f);
      AssignFile(f2, 'boilenger2_'+v+'.csv');
      Rewrite(f2);
      k:=1;
      while not Eof(f) do
      begin
        Readln(f,s);
        if k>1 then
          begin
          if AnsiPos(v,s) > 0 then
            Writeln(f2,s);
          end
        else Writeln(f2,s);

        k:=k+1;
      end;

    except
      Result := false;
    end;
  finally
    CloseFile(f);
    CloseFile(f2);
  end;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  FilterValut('AUDCAD');
end;

end.

