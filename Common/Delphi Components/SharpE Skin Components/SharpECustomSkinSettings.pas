{
Source Name: SharpECustomSkinSettings
Description: custom skin settings usage unit
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

unit SharpECustomSkinSettings;

interface

uses JclSimpleXML, SysUtils, SharpApi, SharpThemeApiEx, uSharpXMLUtils;

type
   TSharpECustomSkinSettings = class
  private
    FXML : TJclSimpleXML;
    FPath : String;
    function GetXMLElem : TJclSimpleXMLElem;
  public
    procedure LoadFromXML(ppath: string);
    procedure Clear;
    constructor Create; reintroduce;
    destructor Destroy; override;

    property xml : TJclSimpleXMLElem read GetXMLElem;
    property Path : String read FPath;
  end;

implementation

function TSharpECustomSkinSettings.GetXMLElem : TJclSimpleXMLElem;
begin
  result :=  FXML.Root;
end;

procedure TSharpECustomSkinSettings.LoadFromXML(ppath: string);
var
  dir : String;
  fn : String;
begin
  Clear;
  dir := ppath;
  if FileExists(dir + 'custom.xml') then fn := dir + 'custom.xml'
     else
     begin
       {$WARNINGS OFF}
       dir := GetCurrentTheme.Skin.Directory;
       {$WARNINGS ON}
       if FileExists(dir + 'custom.xml') then fn := dir + 'custom.xml'
          else exit;
     end;

  if LoadXMLFromSharedFile(FXML,fn,True) then
    FPath := dir
  else Clear;
end;

procedure TSharpECustomSkinSettings.Clear;
begin
  FXML.Root.Items.Clear;
  FPath := '';
end;

constructor TSharpECustomSkinSettings.Create;
begin
  inherited Create;
  FXML := TJclSimpleXML.Create;
  Clear;
end;

destructor TSharpECustomSkinSettings.Destroy;
begin
  FXML.Free;
  Inherited Destroy;
end;

end.
