{
Source Name: uSharpEMenuPopups.pas
Description: SharpE Menu Popup Handler class
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

unit uSharpEMenuPopups;

interface

uses
  Forms, Types, Dialogs, Menus, Controls, SysUtils, ImgList, PngImageList;


type
  TSharpEMenuPopups = class
  private
    FImageList : TPngImageList;
    FDynamicDirPopup : TPopupMenu;
    FDynamicLinkPopup : TPopupMenu;
    FPopupVisible : boolean;
    FLastMenu : TObject;
    procedure BuildDynamicDirPopup;
    procedure BuildDynamicLinkPopup;
    procedure DynamicDirPopupOnClick(Sender : TObject);
    procedure DynamicLinkPopupOnClick(Sender : TObject);
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    property DynamicDirPopup : TPopupMenu read FDynamicDirPopup;
    property DynamicLinkPopup : TPopupMenu read FDynamicLinkPopup;
    property PopupVisible : boolean read FPopupVisible write FPopupVisible;
    property LastMenu : TObject read FLastMenu write FLastMenu;
  end;

implementation

uses SharpApi,
     uSharpEMenu,
     uSharpEMenuWnd,
     uSharpEMenuItem,
     JclShell,
     JclFileUtils;

constructor TSharpEMenuPopups.Create;
begin
  inherited Create;

  // Load image List;
  FImageList := TPngImageList.Create(Application.MainForm);
  try
    FImageList.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'delete');
    FImageList.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'properties');
    FImageList.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'application');
    FImageList.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'folder');
    FImageList.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'openas');
    FImageList.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'properties'); // last one is a dummy image...
  except
  end;

  // Create Popups
  FDynamicDirPopup := TPopUpMenu.Create(Application.MainForm);
  FDynamicDirPopup.Images := FImageList;
  BuildDynamicDirPopup;

  FDynamicLinkPopup := TPopUpMenu.Create(Application.MainForm);
  FDynamicLinkPopup.Images := FImageList;
  BuildDynamicLinkPopup;
end;

destructor TSharpEMenuPopups.Destroy;
begin
  FDynamicDirPopup.Free;
  FDynamicLinkPopup.Free;
  FImageList.Free;

  inherited Destroy; 
end;

procedure TSharpEMenuPopups.DynamicDirPopupOnClick(Sender : TObject);
var
  item : TSharpEMenuItem;
  menu : TSharpEMenu;
  menuwnd : TSharpEMenuWnd;
begin
  PopupVisible := False;
  if FLastMenu = nil then exit;

  menuwnd := TSharpEMenuWnd(FLastMenu);
  menu := menuwnd.SharpEMenu;

  if (menu.ItemIndex > -1) and (menu.ItemIndex < menu.Items.Count) then
  begin
    item := TSharpEMenuItem(menu.Items[menu.ItemIndex]);
    case TMenuItem(Sender).Tag of
      1: begin
           DeleteDirectory(item.PropList.GetString('Target'),True);
           if DirectoryExists(item.PropList.GetString('Target')) then
              RemoveDir(item.PropList.GetString('Target'));
           menu.Items.Remove(item);
           menuwnd.Visible := False;
           menu.RenderBackground(menuwnd.Left,menuwnd.Top);
           menu.RenderNormalMenu;
           menu.RenderTo(menuwnd.Picture);
           menuwnd.PreMul(menuwnd.Picture);
           menuwnd.DrawWindow;
           menuwnd.Visible := True;
         end;
      2: SharpApi.SharpExecute('_properties,' + item.PropList.GetString('Target'));
      3: SharpApi.SharpExecute(item.PropList.GetString('Target'));
    end;
  end;
end;

procedure TSharpEMenuPopups.DynamicLinkPopupOnClick(Sender : TObject);
var
  item : TSharpEMenuItem;
  menu : TSharpEMenu;
  menuwnd : TSharpEMenuWnd;
begin
  PopupVisible := False;
  if FLastMenu = nil then exit;

  menuwnd := TSharpEMenuWnd(FLastMenu);
  menu := menuwnd.SharpEMenu;

  if (menu.ItemIndex > -1) and (menu.ItemIndex < menu.Items.Count) then
  begin
    item := TSharpEMenuItem(menu.Items[menu.ItemIndex]);
    case TMenuItem(Sender).Tag of
      1: begin
           JclFileUtils.FileDelete(item.PropList.GetString('Action'));
           menu.Items.Remove(item);
           menuwnd.Visible := False;           
           menu.RenderBackground(menuwnd.Left,menuwnd.Top);
           menu.RenderNormalMenu;
           menu.RenderTo(menuwnd.Picture);
           menuwnd.PreMul(menuwnd.Picture);
           menuwnd.DrawWindow;
           menuwnd.Visible := True;           
         end;
      2: SharpApi.SharpExecute('_properties,' + item.PropList.GetString('Action'));
      3: SharpApi.SharpExecute(item.PropList.GetString('Action'));
      4: begin
           SharpApi.SharpExecute('_elevate,'+item.PropList.GetString('Action'));
           menuwnd.CloseAll;
         end;
    end;
  end;
end;

procedure TSharpEMenuPopups.BuildDynamicDirPopup;
var
  item : TMenuItem;
begin
  FDynamicDirPopup.Items.Clear;

  // Seperator
  item := TMenuItem.Create(FDynamicDirPopup);
  item.Caption := 'Open';
  item.ImageIndex := 3;
  item.Tag := 3;
  item.OnClick := DynamicDirPopupOnClick;
  FDynamicDirPopup.Items.Add(item);

  // Seperator
  item := TMenuItem.Create(FDynamicDirPopup);
  item.Caption := '-';
  FDynamicDirPopup.Items.Add(item);

  // Delete
  item := TMenuItem.Create(FDynamicDirPopup);
  item.Caption := 'Delete Directory';
  item.ImageIndex := 0;
  item.Tag := 1;
  item.OnClick := DynamicDirPopupOnClick;
  FDynamicDirPopup.Items.Add(item);

  // Seperator
  item := TMenuItem.Create(FDynamicDirPopup);
  item.Caption := '-';
  item.Visible := False;
  FDynamicDirPopup.Items.Add(item);

  // Properties
  item := TMenuItem.Create(FDynamicDirPopup);
  item.Caption := 'Properties';
  item.Tag := 2;
  item.ImageIndex := 1;
  item.OnClick := DynamicDirPopupOnClick;
  item.Visible := False;
  FDynamicDirPopup.Items.Add(item);
end;

procedure TSharpEMenuPopups.BuildDynamicLinkPopup;
var
  item : TMenuItem;
begin
  FDynamicLinkPopup.Items.Clear;

  // Seperator
  item := TMenuItem.Create(FDynamicLinkPopup);
  item.Caption := 'Open';
  item.ImageIndex := 3;
  item.Tag := 3;
  item.OnClick := DynamicLinkPopupOnClick;
  FDynamicLinkPopup.Items.Add(item);

  // Seperator
  item := TMenuItem.Create(FDynamicLinkPopup);
  item.Caption := 'Open Elevated...';
  item.ImageIndex := 4;
  item.Tag := 4;
  item.OnClick := DynamicLinkPopupOnClick;
  FDynamicLinkPopup.Items.Add(item);

  // Seperator
  item := TMenuItem.Create(FDynamicLinkPopup);
  item.Caption := '-';
  FDynamicLinkPopup.Items.Add(item);

  // Delete
  item := TMenuItem.Create(FDynamicLinkPopup);
  item.Caption := 'Delete';
  item.ImageIndex := 0;
  item.Tag := 1;
  item.OnClick := DynamicLinkPopupOnClick;
  FDynamicLinkPopup.Items.Add(item);

  // Seperator
  item := TMenuItem.Create(FDynamicLinkPopup);
  item.Caption := '-';
  item.Visible := True;
  FDynamicLinkPopup.Items.Add(item);

  // Properties
  item := TMenuItem.Create(FDynamicLinkPopup);
  item.Caption := 'Properties';
  item.Tag := 2;
  item.ImageIndex := 1;
  item.Visible := True;
  item.OnClick := DynamicLinkPopupOnClick;
  FDynamicLinkPopup.Items.Add(item);
end;

end.
