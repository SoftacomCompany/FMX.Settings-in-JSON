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
    procedure LoadFromFile(AFilename: string = '');
    procedure SaveToFile(AFilename: string = '');
  end;

var
  Settings: TMyProgSettings;

implementation

{ TMyProgSettings }

constructor TMyProgSettings.Create;
begin
  Chk1 := true;
  Chk2 := false;
  RadioIndex := 0;
end;

class function TMyProgSettings.GetDefaultSettingsFilename: string;
begin
  Result := Tpath.Combine(GetSettingsFolder(), 'init.json');
end;

class function TMyProgSettings.GetSettingsFolder: string;
begin
{$IFDEF MACOS}
  Result := Tpath.Combine(Tpath.GetLibraryPath, 'MyProg');
{$ELSE}
  Result := Tpath.Combine(Tpath.GetHomePath, 'MyProg');
{$ENDIF}
end;

procedure TMyProgSettings.LoadFromFile(AFilename: string = '');
var
  Json: string;
begin
  if AFilename = '' then
    AFilename := GetDefaultSettingsFilename();

  if not FileExists(AFilename) then
    exit;

  Json := TFile.ReadAllText(AFilename, TEncoding.UTF8);
  AssignFromJSON(Json); // magic method from XSuperObject's helper
end;

procedure TMyProgSettings.SaveToFile(AFilename: string = '');
var
  Json: string;
begin
  if AFilename = '' then
    AFilename := GetDefaultSettingsFilename();

  Json := AsJSON(true); // magic method from XSuperObject's helper too
  TFile.WriteAllText(AFilename, Json, TEncoding.UTF8);
end;

end.
