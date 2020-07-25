program invert;

uses
  Windows,
  Messages,
  SysUtils;

var
 WND:HWND;
 Atom_Start,Atom_Stop,Atom_Fix, Atom_Close:Word;
 Working:boolean = false;
 Finished:boolean = false;
 Sleep_Time:integer;
 DelayTime, LastTime:integer;
 msg : TMsg;
 MousePos:TPoint;
 NewMousePos:TPoint;
 Fixed:boolean;
 FixedPos:TPoint;

function WndProc(hWnd: HWND; Msg: UINT;  wParam: WPARAM;  lParam: LPARAM): LRESULT; stdcall;
begin
 case (Msg) of
   WM_CLOSE:
     begin
       PostQuitMessage(0);
     end;
   WM_HOTKEY: begin
       Result := 0;
       if wParam = Atom_Start then begin
         Working:=true;
         GetCursorPos(MousePos);
       end
       else
       if wParam = Atom_Stop then
         Working:=false
       else
       if wParam = Atom_Close then
         Finished:=true
       else
       if wParam = Atom_Fix then begin
         Fixed:=true;
         GetCursorPos(FixedPos);
       end;
      end;
   else
     Result := DefWindowProc(hWnd, Msg, wParam, lParam);
 end;
end;

Function CreateHotKeyWnd:HWND;
var
 h_Instance : HINST;
 wndClass : TWndClass;
begin
 h_Instance := GetModuleHandle(nil);
 ZeroMemory(@wndClass, SizeOf(wndClass));

 with wndClass do
 begin
   style         := CS_OWNDC	;
   lpfnWndProc   := @WndProc;        // Set the window procedure to our func WndProc
   hInstance     := h_Instance;
   hCursor       := LoadCursor(0, IDC_ARROW);
   lpszClassName := 'InvertMouseWindowClass';
 end;

 Windows.RegisterClass(wndClass);

 Result:=CreateWindow('InvertMouseWindowClass','Invert Mouse',WS_BORDER,0,0,0,0,0,0,h_Instance,nil);
end;

begin
 Sleep_Time:=StrToInt(ParamStr(1));
 WND:=CreateHotKeyWnd;
 Atom_Start:=GlobalAddAtom('Hot Key Start Inverting');
 Atom_Stop:=GlobalAddAtom('Hot Key Stop Inverting');
 Atom_Close:=GlobalAddAtom('Hot Key Close Program');
 Atom_Fix:=GlobalAddAtom('Hot Key Fix Mouse Position');
 RegisterHotKey(WND,Atom_Start,MOD_ALT,VK_F11);
 RegisterHotKey(WND,Atom_Stop,MOD_ALT,VK_F12);
 RegisterHotKey(WND,Atom_Close,MOD_ALT,VK_F9);
 RegisterHotKey(WND,Atom_Fix,MOD_ALT,VK_F10);
 LastTime:=GetTickCount;

 while not finished do
 begin
   if (PeekMessage(msg, 0, 0, 0, PM_REMOVE)) then begin
     if (msg.message = WM_QUIT) then
       finished := True
     else begin
     	TranslateMessage(msg);
       DispatchMessage(msg);
     end;
   end;
   DelayTime:=GetTickCount()-LastTime;
   LastTime:=GetTickCount();
   if Delaytime<Sleep_Time then
     Sleep(Sleep_time-Delaytime);
   if Working then begin
     GetCursorPos(NewMousePos);
     if not Fixed or (NewMousePos.Y<>FixedPos.Y) then begin
       NewMousePos.Y:=MousePos.Y-(NewMousePos.Y-MousePos.Y);
       SetCursorPos(NewMousePos.X,NewMousePos.Y);
     end;
     MousePos:=NewMousePos;
   end;
 end;

 GlobalDeleteAtom(Atom_Start);
 GlobalDeleteAtom(Atom_Stop);
 GlobalDeleteAtom(Atom_Close);
 GlobalDeleteAtom(Atom_Fix);
 DestroyWindow(WND);
end.
