{
Source Name: BatteryMonitor.dpr
Description: SharpBar Module Main Project File
Copyright (C) Martin Kr�mer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.sharpenviro.com

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
}

library Weather;

uses
  ShareMem,
  Windows,
  Controls,
  SysUtils,
  Forms,
  Classes,
  Graphics,
  Contnrs,
  StdCtrls,
  SharpApi,
  gr32,
  uISharpBarModule,
  uISharpESkin,
  uISharpBar,
  uInterfacedSharpBarModuleBase,
  DebugDialog in '..\..\..\Common\Units\DebugDialog\DebugDialog.pas',
  MainWnd in 'MainWnd.pas' {MainForm},
  uWeatherParser in '..\..\Objects\Weather\uWeatherParser.pas',
  SharpNotify in '..\..\..\Common\Units\SharpNotify\SharpNotify.pas',
  uWeatherOptions in '..\..\Services\Weather\uWeatherOptions.pas';

type
  TInterfacedSharpBarModule = class(TInterfacedSharpBarModuleBase)
    private
    public
      constructor Create(pID,pBarID : integer; pBarWnd : hwnd); override;

      function CloseModule : HRESULT; override;
      function SetTopHeight(Top,Height : integer) : HRESULT; override;
      function UpdateMessage(part : TSU_UPDATE_ENUM; param : integer) : HRESULT; override;
      function InitModule : HRESULT; override;
      function ModuleMessage(msg: string) : HRESULT; override;      

      procedure SetSkinInterface(Value : ISharpESkinInterface); override;
  end;

{$R 'VersionInfo.res'}
{$R *.res}

{ TInterfacedSharpBarModule }

function TInterfacedSharpBarModule.CloseModule: HRESULT;
begin
  try
    Form.Free;
    Form := nil;
    result := S_OK;
  except
    on E:Exception do
    begin
      result := E_FAIL;
      SharpApi.SendDebugMessageEx(PChar(ModuleName),PChar('Error in CloseModule('
        + inttostr(ID) + '):' + E.Message),clred,DMT_ERROR);
    end;
  end;
end;

constructor TInterfacedSharpBarModule.Create(pID, pBarID: integer;
  pBarWnd: hwnd);
begin
  inherited Create(pID, pBarID, pBarWnd);
  ModuleName := 'Weather Module';

  try
    Form := TMainForm.CreateParented(BarWnd);
    Form.BorderStyle := bsNone;
    TMainForm(Form).mInterface := self;
    Form.ParentWindow := BarWnd;
  except
    on E:Exception do
    begin
      SharpApi.SendDebugMessageEx(PChar(ModuleName),PChar('Error in CreateModule('
        + inttostr(ID) + '):' + E.Message),clred,DMT_ERROR);
      exit;
    end;
  end;
end;

function TInterfacedSharpBarModule.InitModule: HRESULT;
begin
  result := inherited InitModule;

  if Form <> nil then
  begin
    TMainForm(Form).LoadSettings;
    TMainForm(Form).RealignComponents;
  end;
end;

function TInterfacedSharpBarModule.ModuleMessage(msg: string): HRESULT;
begin
  result := inherited ModuleMessage(msg);

  if not (Initialized) then
    exit;

  if (TMainForm(Form).WeatherLocation = '0') then
    TMainForm(Form).LoadSettings;
  
  TMainForm(Form).WeatherParser.Update(TMainForm(Form).WeatherLocation);
  TMainForm(Form).ReAlignComponents;
end;

procedure TInterfacedSharpBarModule.SetSkinInterface(Value: ISharpESkinInterface);
begin
  inherited SetSkinInterface(Value);

  if Form <> nil then
    TMainForm(Form).UpdateComponentSkins;
end;

function TInterfacedSharpBarModule.SetTopHeight(Top, Height: integer): HRESULT;
begin
  result := inherited SetTopHeight(Top, Height);

  if (Form <> nil) and (Initialized) then
    TMainForm(Form).RealignComponents(False);
end;

function TInterfacedSharpBarModule.UpdateMessage(part: TSU_UPDATE_ENUM;
  param: integer): HRESULT;
const
  processed : TSU_UPDATES = [suSkinFileChanged,suBackground,suTheme,suSkin,
                             suScheme,suIconSet,suSkinFont,suModule,suWeather];
begin
  result := inherited UpdateMessage(part,param);

  if not (Initialized) then
    exit;

  if not (part in processed) then
    exit;  

  if ((part = suModule) and (ID  = param)) or (part = suWeather) then
  begin
    TMainForm(Form).LoadSettings;
    TMainForm(Form).ReAlignComponents;
  end;

  if [part] <= [suTheme,suSkinFileChanged] then
    TMainForm(Form).ReAlignComponents;
end;

function GetMetaData(Preview : TBitmap32) : TMetaData;
begin
  with result do
  begin
    Name := 'Weather';
    Author := 'Martin Kr�mer <Martin@SharpEnviro.com>';
    Description := 'Displays current weather information';
    ExtraData := 'preview: false';
    DataType := tteModule;
  end;
end;

function CreateModule(ID,BarID : integer; BarWnd : hwnd) : IInterface;
begin
  result := TInterfacedSharpBarModule.Create(ID,BarID,BarWnd);
end;

Exports
  CreateModule,
  GetMetaData;

begin
end.
