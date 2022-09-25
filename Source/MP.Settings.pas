unit MP.Settings;

interface

uses
  System.Classes,
  System.Types,
  System.SysUtils,
  System.IOUtils,
  XSuperObject;

type
  TLoginSettings = record
    UserName: string;
    ShowRecent: Boolean;
  end;

  TMyProgSettings = class
  public
    Chk1: Boolean;
    Chk2: Boolean;
    RadioIndex: integer;
    Login: TLoginSettings;
    class function GetSettingsFolder(): string;
    class function GetDefaultSettingsFilename(): string;
    constructor Create();
    procedure LoadFromFile(AFileName: string = '');
    procedure SaveToFile(AFileName: string = '');
  end;

var
  Settings: TMyProgSettings;

implementation

{ TMyProgSettings }

constructor TMyProgSettings.Create;
begin
  Chk1 := True;
  Chk2 := False;
  RadioIndex := 0;
end;

class function TMyProgSettings.GetDefaultSettingsFilename: string;
begin
  Result := TPath.Combine(GetSettingsFolder(), 'init.json');
end;

class function TMyProgSettings.GetSettingsFolder: string;
begin
{$IFDEF MACOS}
  Result := TPath.Combine(TPath.GetLibraryPath(), 'MyProg');
{$ELSE}
  Result := TPath.Combine(TPath.GetHomePath(), 'MyProg');
{$ENDIF}
end;

procedure TMyProgSettings.LoadFromFile(AFileName: string = '');
var
  Json: string;
begin
  if AFileName = '' then
    AFileName := GetDefaultSettingsFilename();

  if not FileExists(AFileName) then
    exit;

  Json := TFile.ReadAllText(AFileName, TEncoding.UTF8);
  AssignFromJSON(Json); // magic method from XSuperObject's helper
end;

procedure TMyProgSettings.SaveToFile(AFileName: string = '');
var
  Json: string;
begin
  if AFileName = '' then
    AFileName := GetDefaultSettingsFilename();

  Json := AsJSON(true); // magic method from XSuperObject's helper too
  TFile.WriteAllText(AFileName, Json, TEncoding.UTF8);
end;

end.
