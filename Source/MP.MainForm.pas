unit MP.MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Layouts, FMX.Controls.Presentation;

type
  TMainForm = class(TForm)
    chk1: TCheckBox;
    chk2: TCheckBox;
    lay1: TLayout;
    rb1: TRadioButton;
    rb2: TRadioButton;
    rb3: TRadioButton;
    txt1: TText;
    procedure chk1Change(Sender: TObject);
  private
    procedure LoadFromSettings;
    procedure SaveToSettings;
    procedure TryLogin;
    function LoginCorrect(ALogin, APassword: string) : boolean;
  public
    procedure LoadSettings;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  MainForm: TMainForm;

implementation

uses
  MP.Settings,
  MP.LoginForm;

{$R *.fmx}

{ TMainForm }

procedure TMainForm.LoadSettings;
begin
  if Settings = nil then
    Settings := TMyProgSettings.Create;
  if not FileExists(Settings.getDefaultSettingsFilename()) then
    Settings.SaveToFile();

  Settings.LoadFromFile();
  LoadFromSettings();
end;

// load UI components from loaded settings
procedure TMainForm.chk1Change(Sender: TObject);
begin
  SaveToSettings();
end;

constructor TMainForm.Create(AOwner: TComponent);
begin
  inherited;
  LoadSettings();

  TryLogin();
  if Application.Terminated then
    exit;
end;

destructor TMainForm.Destroy;
begin
  Settings.SaveToFile();
  inherited;
end;

function TMainForm.LoginCorrect(ALogin, APassword : string) : boolean;
begin
  result := (ALogin = 'admin') and (APassword = '123');
end;

procedure TMainForm.TryLogin();
var
  f : TLoginForm;
  login, password : string;
begin
  f := TLoginForm.Create(NIL);
  try
    while not Application.Terminated do
    begin
      if f.ShowModal = mrOK then
      begin
        login := f.eLogin.Text;
        password := f.ePassword.Text;
        if LoginCorrect(login, password) then
          Break;
      end
      else
        Application.Terminate;
    end;
  finally
    f.Free;
  end;
end;

procedure TMainForm.LoadFromSettings();
begin
  chk1.IsChecked := Settings.chk1;
  chk2.IsChecked := Settings.chk2;
  rb1.IsChecked := settings.radioIndex = 0;
  rb2.IsChecked := settings.radioIndex = 1;
  rb3.IsChecked := settings.radioIndex = 2;
end;


// Save UI components to settings
procedure TMainForm.SaveToSettings();
begin
  Settings.chk1 := chk1.IsChecked;
  Settings.chk2 := chk2.IsChecked;
  if rb1.IsChecked then
    settings.radioIndex := 0
  else
  if rb2.IsChecked then
    settings.radioIndex := 1
  else
  if rb3.IsChecked then
    settings.radioIndex := 2;
end;

end.
