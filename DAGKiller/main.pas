unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Registry, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
function GetDAGpath: string;
var Reg: TRegistry;
begin
  reg:=TRegistry.Create;
  reg.RootKey:=HKEY_CURRENT_USER;
  reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders',
  false);
  Result:=reg.ReadString('AppData');
  Reg.Free;
  Result := Copy(Result,1,Length(Result)-8);
  Result := Result+'\Local\Ethash\';
end;

function KillDir(Dir: AnsiString): boolean;
var
  Sr: TSearchRec;
begin
{$I-}
  if (Dir <> '') and (Dir[length(Dir)] = '\') then
    Delete(Dir, length(dir), 1);
  if FindFirst(Dir + '\*.*', faDirectory + faHidden + faSysFile + faReadonly + faArchive, Sr) = 0 then
    repeat
      if (Sr.Name = '.') or (Sr.Name = '..') then
        continue;
      if (Sr.Attr and faDirectory <> faDirectory) then
      begin
       // if AnsiLowerCase(ExtractFileExt(sr.Name)) = '.tmp' then
      //  begin
          FileSetReadOnly(Dir + '\' + sr.Name, False);
          DeleteFile(Dir + '\' + sr.Name);
       // end
      end
      else
        KillDir(Dir + '\' + sr.Name);
    until FindNext(sr) <> 0;
  FindClose(sr);
//  RemoveDir(Dir); // Удалит пустой каталог
  KillDir := (FileGetAttr(Dir) = -1);
end;

function KillDAG():Boolean;
begin
 Result := KillDir(GetDAGpath);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 KillDAG;
end;

end.

