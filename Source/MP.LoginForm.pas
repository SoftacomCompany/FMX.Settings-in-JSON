unit MP.LoginForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Edit, FMX.Layouts;

type
  TLoginForm = class(TForm)
    imgLogo: TImage;
    eLogin: TEdit;
    txtLogin: TText;
    ePassword: TEdit;
    txtPassword: TText;
    blogin: TSpeedButton;
    bClose: TSpeedButton;
    lay1: TLayout;
    chkShowRecentUsername: TCheckBox;
  private
    { Private declarations }
  public
    procedure LoadFromSettings;
    procedure SaveToSettings;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;


implementation

uses
  MP.Settings;

{$R *.fmx}

{ TLoginForm }

constructor TLoginForm.Create(AOwner: TComponent);
begin
  inherited;
  LoadFromSettings();
end;

destructor TLoginForm.Destroy;
begin
  SaveToSettings();
  inherited;
end;

procedure TLoginForm.LoadFromSettings;
begin
  eLogin.Text := settings.login.username;
  chkShowRecentUsername.IsChecked := Settings.login.showRecent;
end;

procedure TLoginForm.SaveToSettings;
begin
  if chkShowRecentUsername.IsChecked then
    settings.login.username := eLogin.Text
  else
    settings.login.username := '';
  Settings.login.showRecent := chkShowRecentUsername.IsChecked;
end;

end.
