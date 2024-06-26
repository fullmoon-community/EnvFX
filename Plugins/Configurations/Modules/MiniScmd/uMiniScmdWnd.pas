﻿{
Source Name: uMiniScmdWnd.pas
Description: MiniScmd Module Settings Window
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

unit uMiniScmdWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SharpApi, ExtCtrls, Menus, JclStrings, SharpEGaugeBoxEdit,
  JvPageList, JvExControls, ComCtrls, ISharpCenterHostUnit,
  SharpECenterHeader, JvXPCore, JvXPCheckCtrls;

type
  TfrmMiniScmd = class(TForm)
    plMain: TJvPageList;
    pagMiniScmd: TJvStandardPage;
    pnlSize: TPanel;
    sgb_width: TSharpeGaugeBox;
    scmQuickSelect: TSharpECenterHeader;
    scmSize: TSharpECenterHeader;
    cbQuickSelect: TJvXPCheckbox;
    pnButtonPos: TPanel;
    lbButtonPos: TLabel;
    cboButtonPos: TComboBox;
    SharpECenterHeader1: TSharpECenterHeader;
    cbEnableAutoCom: TJvXPCheckbox;
    btnACClearList: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cbQuickSelectClick(Sender: TObject);
    procedure sgb_widthChangeValue(Sender: TObject; Value: Integer);
    procedure cboButtonPosChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbEnableAutoComClick(Sender: TObject);
    procedure btnACClearListClick(Sender: TObject);
  private
    FPluginHost: ISharpCenterHost;
    procedure UpdateSettings;
  public
    moduleID : integer;

    procedure UpdateGUI;  
    property PluginHost: ISharpCenterHost read FPluginHost write FPluginHost;
  end;

var
  frmMiniScmd: TfrmMiniScmd;

implementation

{$R *.dfm}

procedure TfrmMiniScmd.cboButtonPosChange(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmMiniScmd.cbQuickSelectClick(Sender: TObject);
begin
  UpdateSettings;
  UpdateGUI;
end;

procedure TfrmMiniScmd.btnACClearListClick(Sender: TObject);
begin
  if FileExists(SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Module Settings\MiniScmd\AutoComplete.xml') then
  begin
    if DeleteFile(SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Module Settings\MiniScmd\AutoComplete.xml') then
    begin
      MessageBox(frmMiniScmd.Handle, 'The Auto-Complete list was removed', 'Information', MB_OK);
      SharpEBroadCast(WM_SHARPEUPDATESETTINGS, Integer(suModule), moduleID);
    end;
  end;
end;

procedure TfrmMiniScmd.cbEnableAutoComClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmMiniScmd.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
end;

procedure TfrmMiniScmd.FormShow(Sender: TObject);
begin
  UpdateGUI;
end;


procedure TfrmMiniScmd.sgb_widthChangeValue(Sender: TObject; Value: Integer);
begin
  UpdateSettings
end;

procedure TfrmMiniScmd.UpdateGUI;
begin
  lbButtonPos.Enabled := cbQuickSelect.Checked;
  cboButtonPos.Enabled := cbQuickSelect.Checked;
end;

procedure TfrmMiniScmd.UpdateSettings;
begin
  if Visible then
    PluginHost.SetSettingsChanged;
end;

end.

