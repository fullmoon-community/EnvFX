{
Source Name: uSharpEMenuLoader.pas
Description: SharpE Menu Loader Functions
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

unit uSharpEMenuLoader;

interface

uses JvSimpleXML,SysUtils,
     uSharpEMenu,
     uSharpEMenuSettings,
     ISharpESkinComponents,
     uSharpEMenuDynamicContentThread;

function LoadMenu(pFileName : String; pManager: ISharpESkinManager; pDesignMode : boolean = false; DynamicContentThread : TSharpEMenuDynamicContentThread = nil) : TSharpEMenu;

implementation

uses uSharpEMenuItem;

function LoadMenuFromXML(pParemtItem : TSharpEMenuItem; pXML : TJvSimpleXMLElems; pManager: ISharpESkinManager; pSettings : TSharpEMenuSettings; DynamicContentThread : TSharpEMenuDynamicContentThread; pDesignMode : boolean) : TSharpEMenu;
var
  n : integer;
  menu : TSharpEMenu;
  menuitem : TSharpEMenuItem;
  typestring : String;
begin
  menu := TSharpEMenu.Create(pParemtItem,pManager,pSettings,DynamicContentThread);
  menu.DesignMode := pDesignMode;
  result := menu;
  // Load the custom settings
  for n := 0 to pXML.Count - 1 do
      with pXML.Item[n].Items do
      begin
        if CompareText(pXML.Item[n].Name,'Settings') = 0 then
        begin
          // custom Settings for this menu exist...
          menu.CustomSettings := True;
          menu.Settings.LoadFromXML(pXML.Item[n].Items);
        end;
      end;

  for n := 0 to pXML.Count - 1 do
      with pXML.Item[n].Items do
      begin
        if CompareText(pXML.Item[n].Name,'Settings') <>0 then
        begin
          typestring := Value('type','none');
          if CompareText(typestring,'link') = 0 then
             menu.AddLinkItem(Value('Caption'),Value('Target'),Value('Icon'),False)
          else
          if CompareText(typestring,'separator') = 0 then
             menu.AddSeparatorItem(False)
          else
          if CompareText(typestring,'dynamicdirectory') = 0 then
             menu.AddDynamicDirectoryItem(Value('Target'),
                                          IntValue('MaxItems',-1),
                                          IntValue('Sort',0),
                                          Value('Filter'),
                                          BoolValue('Recursive',False), False)
          else
          if CompareText(typestring,'drivelist') = 0 then
             menu.AddDriveListItem(BoolValue('ShowDriveNames',True),False)
          else
          if CompareText(typestring,'cpllist') = 0 then
             menu.AddControlPanelItem(False)
          else
          if CompareText(typestring,'label') = 0 then
             menu.AddLabelItem(Value('Caption'),False)
          else
          if CompareText(typestring,'objectlist') = 0 then
            menu.AddObjectListItem(False)
          else
          if CompareText(typestring,'ulist') = 0 then
            menu.AddUListItem(IntValue('itemtype',0),IntValue('count',10),False)
          else
          if CompareText(typestring,'submenu') = 0 then
          begin
            menuitem := TSharpEMenuItem(menu.AddSubMenuItem(Value('Caption'),Value('Icon'),Value('Target',''),False));
            if ItemNamed['items'] <> nil then
              menuitem.SubMenu := LoadMenuFromXML(menuitem,ItemNamed['items'].Items,pManager,menu.settings,DynamicContentThread,menu.DesignMode);
          end;
        end;
      end;
end;

function LoadMenu(pFileName : String; pManager: ISharpESkinManager; pDesignMode : boolean; DynamicContentThread : TSharpEMenuDynamicContentThread) : TSharpEMenu;
var
  XML : TJvSimpleXML;
  RootMenu : TSharpEMenu;
  tempSettings : TSharpEMenuSettings;
begin
  tempSettings := TSharpEMenuSettings.Create;
  try
    tempSettings.LoadFromXML; // Load the default settings;

    RootMenu := nil;
    XML := TJvSimpleXML.Create(nil);
    try
      if FileExists(pFileName) then
      begin
        XML.LoadFromFile(pFileName);
        RootMenu := LoadMenuFromXML(nil,XML.Root.Items,pManager,tempSettings,DynamicContentThread,pDesignMode);
      end;
    finally
      XML.Free;
    end;
  
    if RootMenu = nil then
      RootMenu := TSharpEMenu.Create(nil,pManager,tempSettings,DynamicContentThread);
    result := RootMenu;

  finally
    tempSettings.Free;
  end;
end;

end.
