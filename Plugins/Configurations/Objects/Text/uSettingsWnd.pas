﻿{
Source Name: uLinkWnd.pas
Description: Link Object Settings Window
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

unit uSettingsWnd;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  JvSimpleXml,
  JclFileUtils,
  ImgList,
  PngImageList,
  SharpEListBox,
  SharpEListBoxEx,
  GR32,
  GR32_PNG,
  SharpApi,
  ExtCtrls,
  Menus,
  JclStrings,
  GR32_Image,
  SharpEGaugeBoxEdit,
  SharpEUIC,
  SharpEFontSelectorFontList,
  JvPageList,
  JvExControls,
  SharpEPageControl,
  ComCtrls,
  Mask,
  JvExMask,
  JvToolEdit,
  SharpEColorEditorEx,
  SharpDialogs,
  SharpERoundPanel,
  SharpIconUtils,
  JvExStdCtrls,
  JvCheckBox,
  SharpESwatchManager,
  SharpCenterApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  JvXPCore,
  JvXPCheckCtrls,
  Buttons,
  PngSpeedButton,
  pngimage,
  SharpECenterHeader;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TfrmSettings = class(TForm)
    plMain: TJvPageList;
    pagText: TJvStandardPage;
    pnlText: TPanel;
    SharpECenterHeader13: TSharpECenterHeader;
    edText: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edTextChange(Sender: TObject);
  private
    FPluginHost: ISharpCenterHost;

    procedure SendUpdate;
  public
    sObjectID: string;

    property PluginHost: ISharpCenterHost read FPluginHost write FPluginHost;
  end;

var
  frmSettings: TfrmSettings;

implementation

{$R *.dfm}

procedure TfrmSettings.edTextChange(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmSettings.SendUpdate;
begin
  if Visible then
    FPluginHost.SetSettingsChanged;
end;

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
end;

procedure TfrmSettings.FormDestroy(Sender: TObject);
begin
  //
end;

procedure TfrmSettings.FormShow(Sender: TObject);
begin
  //
end;

end.
