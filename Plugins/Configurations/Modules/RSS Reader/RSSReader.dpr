﻿{
Source Name: RSSReader
Description: RSS Reader Module Config Dll
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

library RSSReader;
uses
  ShareMem,
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  uVistaFuncs,
  SysUtils,
  Graphics,
  SharpAPI,
  SharpCenterAPI,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uRSSReaderWnd in 'uRSSReaderWnd.pas' {frmRSSReader};

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
  with PluginHost.Xml.XmlRoot do
  begin
    Name := 'RssReaderModuleSettings';

    // Clear the list so we don't get duplicates.
    Items.Clear;

    Items.Add('showicon', frmRSSReader.cbIcon.Checked);
    Items.Add('Website', frmRSSReader.edtURL.Text);
    Items.Add('shownotification', frmRSSReader.cbNotify.Checked);
    Items.Add('switchtime', frmRssReader.sgbSwitchInterval.Value);
    Items.Add('feedupdate', frmRssReader.sgbUpdateInterval.Value);
    Items.Add('showbuttons', frmRssReader.cbButtons.Checked);
    Items.Add('customicon', frmRssReader.cbCustomIcon.Checked);

    PluginHost.Xml.Save;
  end;
end;

procedure TSharpCenterPlugin.Load;
begin
  PluginHost.Xml.XmlFilename := GetSharpeUserSettingsPath + 'SharpBar\Bars\' + barID + '\' + moduleID + '.xml';
  if PluginHost.Xml.Load then
  begin
    with PluginHost.Xml.XmlRoot do
    begin
      frmRSSReader.cbIcon.Checked := Items.BoolValue('showicon',True);
      frmRSSReader.edtURL.Text := Items.Value('Website',frmRSSReader.edtURL.Text);
      frmRSSReader.cbNotify.Checked := Items.BoolValue('shownotification',True);
      frmRssReader.sgbSwitchInterval.Value := Items.IntValue('switchtime',20); // seconds
      frmRssReader.sgbUpdateInterval.Value := Items.IntValue('feedupdate',15); // minutes
      frmRssReader.cbButtons.Checked := Items.BoolValue('showbuttons', False);
      frmRssReader.cbCustomIcon.Checked := Items.BoolValue('customicon', False);
    end;
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmRSSReader = nil then frmRSSReader := TfrmRSSReader.Create(nil);
  frmRSSReader.PluginHost := PluginHost;
  uVistaFuncs.SetVistaFonts(frmRSSReader);

  Load;
  result := PluginHost.Open(frmRSSReader);
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmRSSReader);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'RSS Reader';
    Description := 'RSS Reader Module Configuration';
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
	Name := 'RSS Reader';
    Description := 'Configure formatting options for the RSS Reader module';
	Status := '';
  end;
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmRSSReader,AEditing,Theme);
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

