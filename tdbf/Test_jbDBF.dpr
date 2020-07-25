program Test_jbDBF;

uses
  Forms,
  Test_jbDBF1 in 'Test_jbDBF1.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  //Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
