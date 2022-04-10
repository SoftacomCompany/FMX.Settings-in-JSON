unit MP.Settings;

interface
uses
  System.Classes,
  System.Types,
  System.SysUtils,
  System.IOUtils,

  XSuperObject
  ;

type
  TLoginSettings = record
    username : string;
    showRecent : Boolean;
  end;

  TMyProgSettings = class
  private
  public
    chk1 : boolean;
    chk2 : boolean;
    radioIndex : integer;
    login : TLoginSettings;
    class function getSettingsFolder() : string;
    class function getDefaultSettingsFilename() : string;
    constructor Create();
    procedure LoadFromFile(AFilename : string = '');
    procedure SaveToFile(AFilename : string = '');
  end;

var
  Settings : TMyProgSettings;

implementation

{ TMyProgSettings }

constructor TMyProgSettings.Create;
begin
  chk1 := true;
  chk2 := false;
  radioIndex := 0;
end;

class function TMyProgSettings.getDefaultSettingsFilename: string;
begin
  result := IncludeTrailingPathDelimiter(getSettingsFolder) + 'init.json';
end;

class function TMyProgSettings.getSettingsFolder: string;
begin
  {$IFDEF MACOS}
  result := IncludeTrailingPathDelimiter(Tpath.GetLibraryPath) + 'MyProg';
  {$ELSE}
  result := IncludeTrailingPathDelimiter(TPath.GetHomePath) + 'MyProg';
  {$ENDIF}
end;

procedure TMyProgSettings.LoadFromFile(AFilename: string = '');
var
  json : string;
begin
  if AFilename = '' then
    AFilename := getDefaultSettingsFilename();

  if not FileExists(AFilename) then
    exit;

  json := TFile.ReadAllText(AFilename, TEncoding.UTF8);
  AssignFromJSON(json); // magic method from XSuperObject's helper
end;

procedure TMyProgSettings.SaveToFile(AFilename: string = '');
var
  json : string;
begin
  if AFilename = '' then
    AFilename := getDefaultSettingsFilename();

  json := AsJSON(true); // magic method from XSuperObject's helper too
  TFile.WriteAllText(AFilename, json, TEncoding.UTF8);
end;

end.
