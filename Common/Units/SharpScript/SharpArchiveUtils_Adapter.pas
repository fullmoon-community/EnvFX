{
Source Name: SharpArchiveUtils_Adapter.pas
Description: JvInterpreter Adapater Unit
             Adds Basic Archive function support to any script
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

unit SharpArchiveUtils_Adapter;

interface

uses Windows,
     SysUtils,
     JvInterpreter;


procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter);

implementation

uses Variants,
     Classes,
     Types,
     Dialogs,
     JclStrings,
     SharpApi;

{procedure Adapter_DecompressFile(var Value: Variant; Args: TJvInterpreterArgs);
var
  UnZipper : TAbUnZipper;
  fname : String;
  dir   : String;
  Error : boolean;
  tempdir : String;
begin
  Error := True;
  Value := Error;
  fname := Args.Values[0];
  Dir   := Args.Values[1];
  tempdir := SharpApi.GetSharpeDirectory + 'Temp\';
  if not FileExists(tempdir + fname) then exit;
  Dir := IncludeTrailingBackSlash(Dir);
  UnZipper := TAbUnZipper.Create(nil);
  try
    ForceDirectories(Dir);
    UnZipper.OpenArchive(tempdir + fname);
    UnZipper.ExtractOptions := [eoCreateDirs];
    UnZipper.BaseDirectory := VarToStr(Dir);
    UnZipper.ExtractFiles('*.*');
    UnZipper.CloseArchive;
    Error := False;
  except
  end;
  UnZipper.Free;
  Value := Error;
end;              }


procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter);
begin
  with JvInterpreterAdapter do
  begin
    //AddFunction('SharpArchiveUtils','DecompressFile',Adapter_DecompressFile,2,[varString,varString],varBoolean);
  end;
end;

end.
