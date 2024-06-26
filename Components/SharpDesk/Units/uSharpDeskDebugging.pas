{
Source Name: uSharpDeskDebugging.pas
Description: Debugging Unit
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

unit uSharpDeskDebugging;

interface

uses Forms,
     Graphics,
     SysUtils,
     SharpApi;

procedure DebugFree(pObject : TObject);

implementation

procedure DebugFree(pObject : TObject);
var
  className : String;
begin
  if pObject = nil then exit;
  try
    className := pObject.ClassName;
    FreeAndNil(pObject);
  except
    on E: Exception do 
    begin
      SharpApi.SendDebugMessageEx('ClassManager',PChar('Failed to free [' + className + '] in [' + Application.ExeName+']'),clred,DMT_ERROR);
      SharpApi.SendDebugMessageEx('ClassManager',PChar('Error message : ' + E.message),clred,DMT_ERROR);      
    end;
  end;
end;

end.
