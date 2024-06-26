﻿{
Source Name: uSharpDeskSettingsWnd.pas
Description: SharpDesk Settings Window
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

unit settingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, Menus, ComCtrls, SharpApi, SharpCenterApi,
  JvExComCtrls, JvComCtrls, ExtCtrls, JvPageList, JvExControls, JvComponent,
  SharpEGaugeBoxEdit, SharpECenterHeader, JvXPCore, JvXPCheckCtrls,
  ISharpCenterHostUnit, ISharpCenterPluginUnit;

type
  TfrmSettings = class(TForm)
    pnlWrapping: TPanel;
    Label1: TLabel;
    sgbWrapCount: TSharpeGaugeBox;
    cboWrapPos: TComboBox;
    SharpECenterHeader1: TSharpECenterHeader;
    SharpECenterHeader3: TSharpECenterHeader;
    SharpECenterHeader4: TSharpECenterHeader;
    chkUseIcons: TJvXPCheckbox;
    chkMenuWrapping: TJvXPCheckbox;
    pnlGenericIcons: TPanel;
    schGenericIcons: TSharpECenterHeader;
    chkUseGenericIcons: TJvXPCheckbox;
    chkHideTimeout: TJvXPCheckbox;
    Label2: TLabel;
    edtHideTimeout: TEdit;
    Label3: TLabel;
    pnlAutoHide: TPanel;
    pnlIcons: TPanel;
    chkCacheIcons: TJvXPCheckbox;
    procedure cboWrapPosChange(Sender: TObject);
    procedure sgbWrapCountChangeValue(Sender: TObject; Value: Integer);
    procedure chkUseIconsClick(Sender: TObject);
    procedure chkMenuWrappingClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chkHideTimeoutClick(Sender: TObject);
    procedure edtHideTimeoutKeyPress(Sender: TObject; var Key: Char);
    procedure edtHideTimeoutKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure chkCacheIconsClick(Sender: TObject);
  private
    FIsUpdating: Boolean;
    FPluginHost: ISharpCenterHost;
    FPlugin: TInterfacedSharpCenterPlugin;
    procedure SendUpdate;
  public
    property IsUpdating: Boolean read FIsUpdating write FIsUpdating;
    property PluginHost: ISharpCenterHost read FPluginHost write FPluginHost;
    property Plugin: TInterfacedSharpCenterPlugin read FPlugin write FPlugin;

    procedure UpdateUi;
  end;

var
  frmSettings: TfrmSettings;

implementation

{$R *.dfm}

{ TfrmConfigListWnd }

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  Self.DoubleBuffered := true;
  pnlWrapping.DoubleBuffered := true;
end;

procedure TfrmSettings.FormShow(Sender: TObject);
begin
  chkUseIconsClick(self);
end;

procedure TfrmSettings.chkCacheIconsClick(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmSettings.chkHideTimeoutClick(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmSettings.chkMenuWrappingClick(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmSettings.SendUpdate;
begin
  if Not(FIsUpdating) then
    FPlugin.Save;
end;

procedure TfrmSettings.chkUseIconsClick(Sender: TObject);
begin
  SendUpdate;
  UpdateUi;
end;

procedure TfrmSettings.edtHideTimeoutKeyPress(Sender: TObject; var Key: Char);
begin
  // #8 is Backspace
  if not (Key in [#8, '0'..'9', '.']) then
    Key := #0;
end;

procedure TfrmSettings.edtHideTimeoutKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  SendUpdate;
end;

procedure TfrmSettings.sgbWrapCountChangeValue(Sender: TObject;
  Value: Integer);
begin
  SendUpdate;
end;

procedure TfrmSettings.UpdateUi;
begin
  pnlGenericIcons.Visible := chkUseIcons.Checked;
  chkCacheIcons.Enabled := chkUseIcons.Checked;
end;

procedure TfrmSettings.cboWrapPosChange(Sender: TObject);
begin
  SendUpdate;
end;

end.

