{
Source Name: uSharpESkinInterface
Description: Implementar Class for the ISharpESkin interface
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

unit uSharpESkinInterface;

interface

uses
  GR32,
  uISharpESkin,
  SharpESkin,
  SharpTypes,
  Classes,
  SharpESkinManager,
  ISharpESkinComponents;

type
  TSharpESkinInterface = class(TInterfacedObject, ISharpESkinInterface)
    private
      FSkinManager : TSharpESkinManager;
      FSkinManagerInterface : ISharpESkinManager;
      FBackground : TBitmap32;
    public
      constructor Create(AOwner: TComponent; Skins : TSharpESkinItems = ALL_SHARPE_SKINS); reintroduce;
      destructor Destroy; override;

      function GetSkinManager : ISharpESkinManager; stdcall;
      property SkinManager : ISharpESkinManager read GetSkinManager;

      function GetBackground : TBitmap32; stdcall;
      property Background : TBitmap32 read GetBackground;
      procedure SetBackground(Value : TBitmap32);
  end;

implementation

{ TSharpESkinInterface }

constructor TSharpESkinInterface.Create(AOwner: TComponent; Skins : TSharpESkinItems = ALL_SHARPE_SKINS);
begin
  FSkinManager := TSharpESkinManager.Create(AOwner, Skins);
  FSkinManager.HandleUpdates := False;
  if (FSkinManager.Skin <> nil) then
    FSkinManager.Skin.UpdateDynamicProperties(FSkinManager.Scheme);
  FSkinManagerInterface := FSkinManager;
end;

destructor TSharpESkinInterface.Destroy;
begin
  FSkinManagerInterface := nil; 
  
  inherited;
end;

function TSharpESkinInterface.GetBackground: TBitmap32;
begin
  result := FBackground;
end;

function TSharpESkinInterface.GetSkinManager: ISharpESkinManager;
begin
  result := FSkinManagerInterface;
end;

procedure TSharpESkinInterface.SetBackground(Value: TBitmap32);
begin
  FBackground := Value;
end;

end.
