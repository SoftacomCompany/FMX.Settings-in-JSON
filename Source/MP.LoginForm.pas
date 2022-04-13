unit MP.LoginForm;

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
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Controls.Presentation,
  FMX.Edit,
  FMX.Layouts;

type
  TLoginForm = class(TForm)
    imgLogo: TImage;
    edtLogin: TEdit;
    txtLogin: TText;
    edtPassword: TEdit;
    txtPassword: TText;
    btnLogin: TSpeedButton;
    btnClose: TSpeedButton;
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
  edtLogin.Text := Settings.Login.UserName;
  chkShowRecentUsername.IsChecked := Settings.Login.ShowRecent;
end;

procedure TLoginForm.SaveToSettings;
begin
  if chkShowRecentUsername.IsChecked then
    Settings.Login.UserName := edtLogin.Text
  else
    Settings.Login.UserName := '';
  Settings.Login.ShowRecent := chkShowRecentUsername.IsChecked;
end;

end.
