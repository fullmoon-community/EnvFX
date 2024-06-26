﻿{
Source Name: KeyboardLayout.dpr
Description: Keyboard Layout Module Config Dll
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

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

library KeyboardLayout;
uses
  ShareMem,
  Controls,
  Classes,
  Windows,
  Forms,
  Math,
  uVistaFuncs,
  SysUtils,
  Graphics,
  SharpAPI,
  SharpCenterAPI,
  SharpThemeApiEx,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uKLayoutWnd in 'uKLayoutWnd.pas' {frmKLayout};

{$E .dll}
                        
{$R 'VersionInfo.res'}
{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin )
  private
    barID : string;
    moduleID : string;
    procedure Load;
  public
    constructor Create( APluginHost: ISharpCenterHost );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdcall;
    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdCall;
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;
  PluginHost.GetBarModuleIdFromPluginId(barID, moduleID);
end;

procedure TSharpCenterPlugin.Save;
begin
  PluginHost.Xml.XmlRoot.Name := 'KeyboardLayoutModuleSettings';

  with PluginHost.Xml.XmlRoot.Items, frmKLayout do
  begin
    // Clear the list so we don't get duplicates.
    Clear;

    Add('ShowIcon', chkIcon.Checked);
    Add('ThreeLetterCode', chkTLC.Checked);
  end;

  PluginHost.Xml.Save;
end;

procedure TSharpCenterPlugin.Load;
begin
  PluginHost.Xml.XmlFilename := GetSharpeUserSettingsPath + 'SharpBar\Bars\' + barID + '\' + moduleID + '.xml';
  if PluginHost.Xml.Load then
  begin
    with PluginHost.Xml.XmlRoot.Items, frmKLayout do
    begin
      chkIcon.Checked := BoolValue('ShowIcon', chkIcon.Checked);
      chkTLC.Checked  := BoolValue('ThreeLetterCode', chkTLC.Checked);
    end;
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmKLayout = nil then frmKLayout := TfrmKLayout.Create(nil);
  frmKLayout.PluginHost := PluginHost;
  uVistaFuncs.SetVistaFonts(frmKLayout);

  Load;
  result := PluginHost.Open(frmKLayout);
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmKLayout);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Keyboard Layout';
    Description := 'Keyboard Layout Module Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suModule)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
begin
  with Result do
  begin
	Name := 'Keyboard Layout';
    Description := 'Configure the Keyboard Layout module';
	Status := '';
  end;
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmKLayout,AEditing,Theme);
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

