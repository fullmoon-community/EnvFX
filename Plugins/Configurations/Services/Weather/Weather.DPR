library Weather;

uses
  ShareMem,
  windows,
  registry,
  Classes,
  Messages,
  graphics,
  sysutils,
  forms,
  SharpApi,
  SharpCenterApi,
  uVistaFuncs,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uListWnd in 'uListWnd.pas' {frmItemswnd},
  uEditWnd in 'uEditWnd.pas' {frmEditWnd},
  uWeatherList in '..\..\..\Services\Weather\uWeatherList.pas',
  uWeatherMgr in '..\..\..\Services\Weather\uWeatherMgr.pas',
  VKToString in '..\..\..\..\Common\Units\SCHotkeyManager\VKToString.pas',
  uScHotkeyMgr in '..\..\..\..\Common\Units\SCHotkeyManager\uScHotkeyMgr.pas',
  uWeatherOptions in '..\..\..\Services\Weather\uWeatherOptions.pas',
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  uSharpHTTP in '..\..\..\..\Common\Units\SharpHTTP\uSharpHTTP.pas';

{$E dll}

{$R 'VersionInfo.res'}
{$R *.RES}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin, ISharpCenterPluginEdit,
    ISharpCenterPluginValidation )
  private
    procedure Load;

  public
    constructor Create( APluginHost: ISharpCenterHost );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure CloseEdit(AApply: Boolean); stdcall;
    function OpenEdit: Cardinal; stdcall;
    procedure Save; override; stdCall;

    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdcall;
    procedure SetupValidators; stdcall;
  end;

{ TSharpCenterPlugin }

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmItemsWnd);
  FreeAndNil(frmEditWnd);
end;

procedure TSharpCenterPlugin.CloseEdit(AApply: Boolean);
begin
  if AApply then
    frmEditWnd.Save;

  FreeAndNil(frmEditWnd);
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;
end;

procedure TSharpCenterPlugin.Load;
begin
  frmItemswnd.WeatherList.FileName := GetSharpeUserSettingsPath + 'SharpCore\Services\Weather\WeatherList.xml';
  frmItemswnd.WeatherList.LoadSettings;

  frmItemswnd.WeatherOptions.FileName := GetSharpeUserSettingsPath + 'SharpCore\Services\Weather\WeatherOptions.xml';
  frmItemswnd.WeatherOptions.LoadSettings;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmItemsWnd = nil then frmItemsWnd := TfrmItemsWnd.Create(nil);
  uVistaFuncs.SetVistaFonts(frmItemsWnd);

  frmItemsWnd.PluginHost := PluginHost;

  Load;
  result := PluginHost.Open(frmItemsWnd);
end;

function TSharpCenterPlugin.OpenEdit: Cardinal;
begin
  if frmEditWnd = nil then frmEditWnd := TfrmEditWnd.Create(nil);
  frmEditWnd.PluginHost := Self.PluginHost;
  uVistaFuncs.SetVistaFonts(frmEditWnd);

  result := PluginHost.OpenEdit(frmEditWnd);
  frmEditWnd.Init;
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToForms(frmItemsWnd, frmEditWnd, AEditing, Theme);
end;

procedure TSharpCenterPlugin.Save;
begin
  inherited;
  frmItemswnd.WeatherList.SaveSettings;
  frmItemswnd.WeatherOptions.SaveSettings;
end;

procedure TSharpCenterPlugin.SetupValidators;
begin
  // Can not leave fields blank
  PluginHost.AddRequiredFieldValidator( frmEditWnd.edWeatherID,'Please enter a valid location Id','Text');
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Weather';
    Description := 'Weather Service Configuration';
    Author := 'Martin Kr�mer (MartinKraemer@gmx.net)';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suService)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
begin
  with result do
  begin
    Name := 'Weather';
    Description := 'Configure your weather locations. SOAP Services provided by Weather.com.';
    Status := '';
  end;
end;

function InitPluginInterface( APluginHost: ISharpCenterHost ) : ISharpCenterPlugin;
begin
  result := TSharpCenterPlugin.Create(APluginHost);
end;

exports
  InitPluginInterface,
  GetPluginData,
  GetMetaData;

begin
end.


