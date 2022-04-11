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
    Chk1: TCheckBox;
    Chk2: TCheckBox;
    Lay1: TLayout;
    Rb1: TRadioButton;
    Rb2: TRadioButton;
    Rb3: TRadioButton;
    Txt1: TText;
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
        Login := F.EditLogin.Text;
        Password := F.EditPassword.Text;
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
  Chk1.IsChecked := Settings.Chk1;
  Chk2.IsChecked := Settings.Chk2;
  Rb1.IsChecked := Settings.radioIndex = 0;
  Rb2.IsChecked := Settings.radioIndex = 1;
  Rb3.IsChecked := Settings.radioIndex = 2;
end;

// Save UI components to settings
procedure TMainForm.SaveToSettings();
begin
  Settings.Chk1 := Chk1.IsChecked;
  Settings.Chk2 := Chk2.IsChecked;
  if Rb1.IsChecked then
    Settings.radioIndex := 0
  else if Rb2.IsChecked then
    Settings.radioIndex := 1
  else if Rb3.IsChecked then
    Settings.radioIndex := 2;
end;

end.
