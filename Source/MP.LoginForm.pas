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
    ImageLogo: TImage;
    EditLogin: TEdit;
    TextLogin: TText;
    EditPassword: TEdit;
    TextPassword: TText;
    ButtonLogin: TSpeedButton;
    ButtonClose: TSpeedButton;
    Layout1: TLayout;
    CheckBoxShowRecentUsername: TCheckBox;
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
  EditLogin.Text := Settings.Login.UserName;
  CheckBoxShowRecentUsername.IsChecked := Settings.Login.ShowRecent;
end;

procedure TLoginForm.SaveToSettings;
begin
  if CheckBoxShowRecentUsername.IsChecked then
    Settings.Login.UserName := EditLogin.Text
  else
    Settings.Login.UserName := '';
  Settings.Login.ShowRecent := CheckBoxShowRecentUsername.IsChecked;
end;

end.
