unit MP.MainForm;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.Controls.Presentation;

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
    function LoginCorrect(ALogin, APassword: string): boolean;
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
  if not FileExists(Settings.GetDefaultSettingsFilename()) then
  begin
    ForceDirectories(Settings.GetSettingsFolder());
    Settings.SaveToFile();
  end;

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

function TMainForm.LoginCorrect(ALogin, APassword: string): boolean;
begin
  Result := (ALogin = 'admin') and (APassword = '123');
end;

procedure TMainForm.TryLogin();
var
  F: TLoginForm;
  Login, Password: string;
begin
  F := TLoginForm.Create(NIL);
  try
    while not Application.Terminated do
    begin
      if F.ShowModal = mrOK then
      begin
        Login := F.edtLogin.Text;
        Password := F.edtLogin.Text;
        if LoginCorrect(Login, Password) then
          Break;
      end
      else
        Application.Terminate;
    end;
  finally
    F.Free;
  end;
end;

procedure TMainForm.LoadFromSettings();
begin
  chk1.IsChecked := Settings.Chk1;
  chk1.IsChecked := Settings.Chk2;
  rb1.IsChecked := Settings.RadioIndex = 0;
  rb2.IsChecked := Settings.RadioIndex = 1;
  rb3.IsChecked := Settings.RadioIndex = 2;
end;

// Save UI components state to settings
procedure TMainForm.SaveToSettings();
begin
  Settings.Chk1 := chk1.IsChecked;
  Settings.Chk2 := chk1.IsChecked;
  if rb1.IsChecked then
    Settings.radioIndex := 0
  else if rb2.IsChecked then
    Settings.radioIndex := 1
  else if rb3.IsChecked then
    Settings.radioIndex := 2;
end;

end.
