{
Source Name: uEditWnd.pas
Description: <Type> Items Edit window
Copyright (C) <Author> (<Email>)

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

unit uEditWnd;

interface

uses
  // Standard
  Windows,
  Messages,
  SysUtils,
  Forms,
  Variants,
  Classes,
  ImgList,
  Controls,
  Graphics,

  // SharpE
  SharpApi,
  SharpFileUtils,
  SharpCenterApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,

  // Jedi
  JvExControls,
  JvComponentBase,

  // PngImage
  PngImageList, Buttons, PngSpeedButton, StdCtrls, ExtCtrls, SharpEListBoxEx, uButtonBarList, SharpDialogs;

type
  TfrmEdit = class(TForm)
    edName: TLabeledEdit;
    edCommand: TLabeledEdit;
    btnCommandBrowse: TPngSpeedButton;
    edIcon: TLabeledEdit;
    btnIconBrowse: TPngSpeedButton;

    procedure UpdateEditState(Sender: TObject);
    procedure btnCommandBrowseClick(Sender: TObject);
    procedure btnIconBrowseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
    FUpdating: Boolean;
    FItemEdit: TButtonBarItem;
    FPluginHost: ISharpCenterHost;
  public
    { Public declarations }
    
    property PluginHost: ISharpCenterHost read FPluginHost write
      FPluginHost;
    property ItemEdit: TButtonBarItem read FItemEdit write FItemEdit;
    procedure Init;
    procedure Save;
  end;

var
  frmEdit: TfrmEdit;

implementation

uses
  uListWnd;

{$R *.dfm}

procedure TfrmEdit.Init;
var
  tmpItem: TSharpEListItem;
  tmp: TButtonBarItem;
begin
  FUpdating := True;
  try

    case FPluginHost.EditMode of
      sceAdd: begin
          edName.Text := '';
          edCommand.Text := '';
          edIcon.Text := 'shell:icon';
        end;
      sceEdit: begin
          if frmList.lbItems.SelectedItem = nil then
            exit;

          tmpItem := frmList.lbItems.SelectedItem;
          tmp := TButtonBarItem(tmpItem.Data);
          FItemEdit := tmp;

          edName.Text := tmp.Name;
          edCommand.Text := tmp.Command;
          edIcon.Text := tmp.Icon;
          edName.SetFocus;
        end;
    end;

  finally
    FUpdating := False;
  end;
end;

procedure TfrmEdit.btnCommandBrowseClick(Sender: TObject);
var
  s: string;
begin
  s := SharpDialogs.TargetDialog(STI_ALL_TARGETS,
    ClientToScreen(point(btnCommandBrowse.Left, btnCommandBrowse.Top)));
  if length(trim(s)) > 0 then
  begin
    edCommand.Text := s;
    if edName.Text = '' then
      edName.Text := GetFileDescription(s);
  end;
end;

procedure TfrmEdit.btnIconBrowseClick(Sender: TObject);
var
  s: string;
begin
  s := SharpDialogs.IconDialog(edCommand.Text,
    SMI_ALL_ICONS,
    ClientToScreen(point(btnIconBrowse.Left, btnIconBrowse.Top)));
  if length(trim(s)) > 0 then
  begin
    edIcon.Text := s;
  end;
end;

procedure TfrmEdit.FormCreate(Sender: TObject);
begin
  FItemEdit := TButtonBarItem.Create('','','');
end;

procedure TfrmEdit.FormShow(Sender: TObject);
begin
  Self.DoubleBuffered := True;
end;

procedure TfrmEdit.Save;
var
  tmpItem: TSharpEListItem;
  tmp: TButtonBarItem;
begin

  case PluginHost.EditMode of
    sceAdd: begin
        frmList.Items.AddButtonItem(edName.Text, edCommand.Text, edIcon.Text);
        FPluginHost.Save;
      end;
    sceEdit: begin
        tmpItem := frmList.lbItems.SelectedItem;
        tmp := TButtonBarItem(tmpItem.Data);
        tmp.Name := edName.Text;
        tmp.Command := edCommand.Text;
        tmp.Icon := edIcon.Text;
        FPluginHost.Save;
      end;
  end;

  LockWindowUpdate(frmList.Handle);
  try
    frmList.RenderItems;
  finally
    LockWindowUpdate(0);
  end;

  FPluginHost.Refresh;
end;

procedure TfrmEdit.UpdateEditState(Sender: TObject);
begin
  if not (FUpdating) then
    FPluginHost.Editing := true;
end;

end.

