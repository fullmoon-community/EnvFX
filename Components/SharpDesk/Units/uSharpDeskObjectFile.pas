{
Source Name: uSharpDeskObjectFile
Description: TObjectFile class
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

unit uSharpDeskObjectFile;

interface

uses Windows,
     Contnrs,
     SysUtils,
     Graphics,
     gr32,
     gr32_layers,
     gr32_image,
     SharpApi,
     SharpDeskApi,
     uSharpDeskObjectSetItem;

type

    TObjectFile = class(TObjectList)
    private
      FFileName        : String;
      FPath            : String;
      FDllHandle       : THandle;
      FLoaded          : boolean;
      FOwner           : TObject;
    public
      DllCreateLayer      : function (Image: TImage32; ObjectID : integer) : TBitmapLayer;
      DllSharpDeskMessage : procedure(ObjectID : integer; Layer : TBitmapLayer; DeskMessage,P1,P2,P3 : integer);
      DllInitSettings     : procedure();
      procedure Unload;
      procedure UnloadObjects;
      procedure Load;
      function AddDesktopObject(pSettings : TObjectSetItem) : TObject;
      function GetByObjectID(ID : integer) : TObject;
      constructor Create(pOwner : TObject; pFileName : String);
      destructor Destroy; override;

      property DllHandle       : THandle read FDLLHandle;
      property FileName        : String  read FFileName;
      property Path            : String  read FPath;
      property Loaded          : boolean read FLoaded;
      property Owner           : TObject read FOwner;
    end;



implementation


uses uSharpDeskDesktopObject,
     uSharpDeskManager,
     uSharpDeskObjectFileList;


constructor TObjectFile.Create(pOwner : TObject; pFileName : String);
begin
  Inherited Create;
  FOwner           := pOwner;
  FPath            := pFileName;
  FFileName        := ExtractFileName(pFileName);
  FLoaded          := False;
  //Load;
end;



destructor TObjectFile.Destroy;
begin
  Unload;
  Inherited Destroy;
end;


function TObjectFile.GetByObjectID(ID : integer) : TObject;
var
   n : integer;
begin
  for n := 0 to Count - 1 do
      if TDesktopObject(Items[n]).Settings.ObjectID = ID then
      begin
        result := TDesktopObject(Items[n]);
        exit;
      end;
  result := nil;
end;


function TObjectFile.AddDesktopObject(pSettings : TObjectSetItem) : TObject;
var
   tempObject : TDesktopObject;
begin
  if not FLoaded then Load;
  tempObject := TDesktopObject.Create(self,pSettings);
  self.Add(tempObject);
  DllSharpDeskMessage(tempObject.Settings.ObjectID,tempObject.Layer,SDM_INIT_DONE,0,0,0);
  result := tempObject;
end;

procedure TObjectFile.Unload;
begin
  if not FLoaded then exit;

  UnloadObjects;
  DllSharpDeskMessage(0,nil,SDM_SHUTDOWN,0,0,0);

  try
    FreeLibrary(FDllHandle);
  finally
    FLoaded    := False;
    FDllHandle := 0;
    DllCreateLayer      := nil;
    DllSharpDeskMessage := nil;
    DllInitSettings     := nil;
  end;
end;



procedure TObjectFile.Load;
begin
  Unload;
  if not FileExists(FPath) then exit;

  try
    FDllhandle := LoadLibrary(PChar(FPath));

    if FDllhandle <> 0 then
    begin
      @DllCreateLayer      := GetProcAddress(dllhandle, 'CreateLayer');
      @DllSharpDeskMessage := GetProcAddress(dllhandle, 'SharpDeskMessage');
      @DllInitSettings     := GetProcAddress(dllhandle, 'InitSettings');
    end;

    if (@DllCreateLayer = nil) or
       (@DllSharpDeskMessage = nil) then
    begin
      FreeLibrary(FDllhandle);
      FDllhandle := 0;
      SharpApi.SendDebugMessageEx('SharpDesk',PChar(FPath + ' is not a valid SharpDesk object'),clmaroon,DMT_ERROR);
      exit;
    end;

    FLoaded := True;
    if (@DLLInitSettings <> nil) then
       DLLInitSettings;
    SharpApi.SendDebugMessageEx('SharpDesk',PChar('Initializing ' + FPath),clblack,DMT_STATUS);
  except
    try
      FreeLibrary(FDllhandle);
    finally
      FDllhandle := 0;
    end;
    SharpApi.SendDebugMessageEx('SharpDesk',PChar('Failed to initialize ' + FPath),clmaroon,DMT_ERROR);
  end;
end;



procedure TObjectFile.UnloadObjects;
begin
  Clear;
 { for n:= 0 to Count - 1 do
      if Items[n] <> nil then
      begin
        Items[n].Free;
        Items[n] := nil;
      end;
  Pack;    }
end;


end.
