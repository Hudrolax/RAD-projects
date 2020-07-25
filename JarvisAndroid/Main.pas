unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Platform, FMX.Memo, IdBaseComponent, IdComponent, IdTCPConnection, IdGlobal,
  IdTCPClient, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, FMX.Controls.Presentation, FMX.Edit, System.Notification,
  FMX.ScrollBox;

type
  TFormMain = class(TForm)
    ButtonListen: TButton;
    LabelResult: TLabel;
    StyleBook1: TStyleBook;
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    LabelStatus: TLabel;
    Timer1: TTimer;
    Edit1: TEdit;
    SendButton: TButton;
    NotificationCenter1: TNotificationCenter;
    Memo1: TMemo;
    procedure ButtonListenClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SendButtonClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
  private
    { Private declarations }
  public
     function HandleAppEvent(AAppEvent: TApplicationEvent; AContext: TObject): Boolean;
  end;

var
  FormMain: TFormMain;
  JarvisIsActiveScreen:Boolean;
  StatusKeyboard: boolean = false;
implementation

uses Androidapi.JNIBridge, Androidapi.JNI.Os, Androidapi.JNI.JavaTypes,
  Androidapi.Helpers, FMX.Helpers.Android, android.speech;
{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiTb.fmx ANDROID}
{$R *.NmXhdpiPh.fmx ANDROID}

procedure Log(s:string);
begin
  FormMain.Memo1.Lines.Clear;
  FormMain.Memo1.Lines.Append(s);
end;

function TFormMain.HandleAppEvent(AAppEvent: TApplicationEvent; AContext: TObject): Boolean;
begin
  if AAppEvent = TApplicationEvent.BecameActive then
    begin
     JarvisIsActiveScreen := True;
     NotificationCenter1.CancelAll;
     Timer1.Enabled := false;
     Timer1.Interval:=500;
     Timer1.Enabled := True;
    end
   else begin
    JarvisIsActiveScreen := False;
    Timer1.Enabled := false;
    Timer1.Interval:=10000;
    Timer1.Enabled := True;
   end;
  Result := True;
end;

procedure SendToServer(TextToServer:string);
var
  hnd: TIdIOHandlerStack;
  client: TIdTCPClient;
begin
  client := TIdTCPClient.Create();
  client.Host := 'hud.net.ru';
  client.Port := 27020;
  client.ReadTimeout := 1000;
  client.ConnectTimeout := 3000;
  hnd := TIdIOHandlerStack.Create();
  hnd.MaxLineLength := 10000000;
  client.IOHandler := hnd;
  try
    try
      client.Connect;
    except
      Log('Ошибка связи с сервером!');
      Exit;
    end;
   client.IOHandler.DefStringEncoding := IndyTextEncoding(TEncoding.GetEncoding(1251));
    if client.Connected then
   begin
    try
      client.Socket.WriteLn(TextToServer);
    except
      Log('Не смог отправить команду...');
    end;
   client.Disconnect;
   end;
  finally
    FreeAndNil(hnd);
    FreeAndNil(client);
  end;
end;

function ErrorMessage(Error: Integer): string;
begin
  case Error of
    TJSpeechRecognizer_ERROR_AUDIO: Result := 'Audio recording error.';
    TJSpeechRecognizer_ERROR_CLIENT: Result := 'Other client side errors.';
    TJSpeechRecognizer_ERROR_INSUFFICIENT_PERMISSIONS: Result := 'Insufficient permissions.';
    TJSpeechRecognizer_ERROR_NETWORK: Result := 'Other network related errors.';
    TJSpeechRecognizer_ERROR_NETWORK_TIMEOUT: Result := 'Network operation timed out.';
    TJSpeechRecognizer_ERROR_NO_MATCH: Result := 'No recognition result matched.';
    TJSpeechRecognizer_ERROR_RECOGNIZER_BUSY: Result := 'RecognitionService busy.';
    TJSpeechRecognizer_ERROR_SERVER: Result := 'Server sends error status.';
    TJSpeechRecognizer_ERROR_SPEECH_TIMEOUT: Result := 'No speech input.';
    else Result := 'Unknown error ' + IntToStr(Error);
  end;
end;

type
  TRecognitionListener = class(TJavaLocal, JRecognitionListener)
    procedure onBeginningOfSpeech; cdecl;
    procedure onBufferReceived(Buffer: TJavaArray<Byte>); cdecl;
    procedure onEndOfSpeech; cdecl;
    procedure onError(Error: Integer); cdecl;
    procedure onEvent(EventType: Integer; Params: JBundle); cdecl;
    procedure onPartialResults(PartialResults: JBundle); cdecl;
    procedure onReadyForSpeech(Params: JBundle); cdecl;
    procedure onResults(Results: JBundle); cdecl;
    procedure onRmsChanged(RmsdB: Single); cdecl;
  end;

procedure TRecognitionListener.onBeginningOfSpeech;
begin
  FormMain.ButtonListen.Enabled := False;
  FormMain.LabelStatus.Text := 'Beginning of speech';
end;

procedure TRecognitionListener.onBufferReceived(Buffer: TJavaArray<Byte>);
begin
end;

procedure TRecognitionListener.onEndOfSpeech;
begin
  FormMain.LabelStatus.Text := 'End of speech';
  FormMain.ButtonListen.Enabled := True;
end;

procedure TRecognitionListener.onError(Error: Integer);
begin
  FormMain.LabelStatus.Text := 'Error: ' + ErrorMessage(Error);
end;

procedure TRecognitionListener.onEvent(EventType: Integer; Params: JBundle);
begin
end;

procedure TRecognitionListener.onPartialResults(PartialResults: JBundle);
begin
end;

procedure TRecognitionListener.onReadyForSpeech(Params: JBundle);
begin
  FormMain.LabelStatus.Text := 'Ready for speech';
end;

procedure TRecognitionListener.onResults(Results: JBundle);
var
  ArrayList: JArrayList;
  I: Integer;
  Text,TextToServer: string;
begin
  Text := '';
  TextToServer := '';
  ArrayList := Results.getStringArrayList(StringToJString(TJSpeechRecognizer_RESULTS_RECOGNITION));
  for I := 0 to ArrayList.size - 1 do
    begin
     Text := Text + JStringToString(ArrayList.get(I).toString) + sLineBreak;
     TextToServer := TextToServer + JStringToString(ArrayList.get(I).toString)+';'
    end;

  FormMain.LabelResult.Text := Text;
  FormMain.LabelStatus.Text := 'Results';

  SendToServer(TextToServer);
end;

procedure TRecognitionListener.onRmsChanged(RmsdB: Single);
begin
end;

var
  SpeechRecognizer: JSpeechRecognizer;
  RecognitionListener: JRecognitionListener;

procedure TFormMain.ButtonListenClick(Sender: TObject);
begin
  timer1.Enabled := false;
  FormMain.ButtonListen.Enabled := false;
  FormMain.LabelResult.Text := '';
  FormMain.LabelStatus.Text := '';

  if not TJSpeechRecognizer.JavaClass.isRecognitionAvailable(SharedActivityContext) then
  begin
    ShowMessage('Speech recognition is not available');
    Exit;
  end;

  CallInUiThread(
    procedure
    begin
      if SpeechRecognizer = nil then
      begin
        SpeechRecognizer := TJSpeechRecognizer.JavaClass.createSpeechRecognizer(SharedActivityContext);
        RecognitionListener := TRecognitionListener.Create;
        SpeechRecognizer.setRecognitionListener(RecognitionListener);
      end;
      SpeechRecognizer.startListening(TJRecognizerIntent.JavaClass.getVoiceDetailsIntent(SharedActivityContext));
    end);
  FormMain.ButtonListen.Enabled := true;
  timer1.Enabled := true;
end;

procedure TFormMain.FormCreate(Sender: TObject);
var aFMXApplicationEventService: IFMXApplicationEventService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXApplicationEventService, IInterface(aFMXApplicationEventService)) then
    aFMXApplicationEventService.SetApplicationEventHandler(HandleAppEvent);
end;

procedure TFormMain.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
    if Key = vkHardwareBack then
     begin
      if not StatusKeyboard then
        Key := 0;
     end
    else if Key = vkVolumeUp then
       begin
        SendToServer('vol_up');
        Key := 0;
       end
       else if Key = vkVolumeDown then
        begin
         SendToServer('vol_dn');
         Key := 0;
        end
end;

procedure TFormMain.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  StatusKeyboard := False;
end;

procedure TFormMain.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  StatusKeyboard := True;
end;

procedure TFormMain.SendButtonClick(Sender: TObject);
begin
  SendToServer(Edit1.Text);
  Edit1.Text := '';
end;

procedure TFormMain.Timer1Timer(Sender: TObject);
var
  hnd: TIdIOHandlerStack;
  client: TIdTCPClient;
  answer:string;
  Notification : TNotification;
begin
  timer1.Enabled := false;
  client := TIdTCPClient.Create();
  client.Host := 'hud.net.ru';
  client.Port := 27020;
  client.ReadTimeout := 5000;
  client.ConnectTimeout := 5000;
  hnd := TIdIOHandlerStack.Create();
  hnd.MaxLineLength := 10000000;
  client.IOHandler := hnd;
  try
    try
      client.Connect;
    except
    end;
   client.IOHandler.DefStringEncoding := IndyTextEncoding(TEncoding.GetEncoding(1251));
   answer:= '';
   if client.Connected then
   begin
    try
      client.Socket.WriteLn('s');
      answer := client.Socket.ReadLn();
      if (answer <> 'n') and (answer<>'') then
        begin
          Log(answer);

          // Выводим нотификацию
          if not JarvisIsActiveScreen then
          begin
            Notification := FormMain.NotificationCenter1.CreateNotification;
            NotificationCenter1.ApplicationIconBadgeNumber:=1;
            Notification.Number := 1;
            Notification.Name := 'Jarvis';
            Notification.AlertBody :=answer;
            Notification.EnableSound := true;
            NotificationCenter1.PresentNotification(Notification);
            Notification.DisposeOf;
          end;
        end;
    except
    end;
   client.Disconnect;
   end;
  finally
    FreeAndNil(hnd);
    FreeAndNil(client);
  end;
  timer1.Enabled := true;
end;

end.
