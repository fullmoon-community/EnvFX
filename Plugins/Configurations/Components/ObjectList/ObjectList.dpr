﻿{
Source Name: ModuleManager
Description: SharpDesk Manager Config Dll
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

library ObjectList;
uses
  ShareMem,
  Controls,
  Classes,
  Contnrs,
  Windows,
  Forms,
  Dialogs,
  graphics,
  JvSimpleXml,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  SharpCenterApi,
  SharpApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',
  uListWnd in 'uListWnd.pas' {frmListWnd},
  uEditWnd in 'uEditWnd.pas' {frmEditWnd},
  uSharpDeskTDeskSettings in '..\..\..\..\Components\SharpDesk\Units\uSharpDeskTDeskSettings.pas';

{$E .dll}

{$R 'VersionInfo.res'}
{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin, ISharpCenterPluginEdit )
  private
  public
    constructor Create( APluginHost: ISharpCenterHost );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure CloseEdit(AApply: Boolean); stdcall;
    function OpenEdit: Cardinal; stdcall;

    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdcall;

  end;


{ TSharpCenterPlugin }

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmListWnd);
  FreeAndNil(frmEditWnd);
end;

procedure TSharpCenterPlugin.CloseEdit(AApply: Boolean);
begin
  if AApply then
    frmEditWnd.Save;

  FreeAndNil(frmEditWnd);

  frmListWnd.BuildObjectList;
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmListWnd = nil then frmListWnd := TfrmListWnd.Create(nil);
  
  uVistaFuncs.SetVistaFonts(frmListWnd);
  frmListWnd.PluginHost := PluginHost;

  result := PluginHost.Open(frmListWnd);
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
  AssignThemeToForms(frmListWnd,frmEditWnd,AEditing,Theme);
  PluginHost.SetEditTabVisibility(scbEditTab,false);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Desktop Objects';
    Description := 'SharpDesk Object Manager Configuration';
    Author := 'Martin Krämer (martin@sharpenviro.com)';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suSharpBar)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
var
  tmp: TObjectList;
begin
  with result do
  begin
    Name := 'Objects';

    Description := 'Desktop Object Configuration';
	  Status := '';

    tmp := TObjectList.Create;
    try
      AddItemsToList(pluginID,tmp);
      Status := IntToStr(tmp.Count);
    finally
      tmp.Free;
    end;
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
