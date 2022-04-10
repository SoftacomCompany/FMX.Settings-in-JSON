program MyProg;

uses
  System.StartUpCopy,
  FMX.Forms,
  MP.MainForm in 'MP.MainForm.pas' {MainForm},
  MP.Settings in 'MP.Settings.pas',
  MP.LoginForm in 'MP.LoginForm.pas' {LoginForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
