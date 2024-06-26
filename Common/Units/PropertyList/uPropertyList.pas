{
Source Name: uPropertyList.pas
Description: TPropertyList class
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

unit uPropertyList;

interface

uses
  SysUtils,
  Classes,
  Contnrs;

type
  TPropertyData = class
                  public
                    Name : String;
                    constructor Create(pName : String); reintroduce;
                  end;
                  
  TIntData = class(TPropertyData)
             public
               Value : Int64;
               constructor Create(pName : String; pValue : Int64); reintroduce;
             end;

  TStringData = class(TPropertyData)
                public
                  Value : String;
                  constructor Create(pName : String; pValue : String); reintroduce;
                end;

  TBoolData = class(TPropertyData)
              public
                Value : Boolean;
                constructor Create(pName : String; pValue : boolean); reintroduce;
              end;

  TObjectData = class(TPropertyData)
                public
                  Value : TObject;            
                  constructor Create(pName : String; pValue : TObject); reintroduce;
                end;

  TPropertyList = class
  private
    FList : TObjectList;
    function FindByName(pName : String) : TObject;
  public
    procedure Add(pName : String; pValue : String); overload;
    procedure Add(pName : String; pValue : Int64); overload;
    procedure Add(pName : String; pValue : boolean); overload;
    procedure Add(pName : String; pValue : TObject); overload;
    function GetString(pName : String) : String;
    function GetInt(pName : String) : Int64;
    function GetBool(pName : String) : boolean;
    function GetObject(pName : String) : TObject;
    function Remove(pName : String) : boolean;
    procedure Clear;
    function HasProperty(pName : String) : boolean;
    procedure Assign(from : TPropertyList);

    constructor Create; reintroduce;
    destructor Destroy; override;

  end;

implementation

constructor TPropertyData.Create(pName : String);
begin
  inherited Create;
  Name := pName;
end;

constructor TObjectData.Create(pName: String; pValue: TObject);
begin
  inherited Create(pName);
  Value := pValue;
end;

constructor TIntData.Create(pName : String; pValue : Int64);
begin
  inherited Create(pName);
  Value := pValue;
end;

constructor TStringData.Create(pName : String; pValue : String);
begin
  inherited Create(pName);
  Value := pValue;
end;

constructor TBoolData.Create(pName : String; pValue : boolean);
begin
  inherited Create(pName);
  Value := pValue;
end;

constructor TPropertyList.Create;
begin
  inherited Create;

  FList := TObjectList.Create(True);
  FList.Clear;
end;

destructor TPropertyList.Destroy;
begin
  FList.Clear;
  FreeAndNil(FList)
end;

procedure TPropertyList.Assign(from : TPropertyList);
var
  n : integer;
begin
  clear;
  for n := 0 to from.FList.Count - 1 do
  begin
    if from.FList.Items[n] is TIntData then
       Add(TIntData(from.FList.Items[n]).Name,TIntData(from.FList.Items[n]).Value)
    else if from.FList.Items[n] is TStringData then
            Add(TStringData(from.FList.Items[n]).Name,TStringData(from.FList.Items[n]).Value)
    else if from.FList.Items[n] is TBoolData then
            Add(TBoolData(from.FList.Items[n]).Name,TBoolData(from.FList.Items[n]).Value);
  end;
end;

procedure TPropertyList.Add(pName : String; pValue : String);
begin
  Remove(pName);
  FList.Add(TStringData.Create(pName,pValue));
end;

procedure TPropertyList.Add(pName : String; pValue : Int64);
begin
  Remove(pName);
  FList.Add(TIntData.Create(pName,pValue));
end;

procedure TPropertyList.Add(pName : String; pValue : boolean);
begin
  Remove(pName);
  FList.Add(TBoolData.Create(pName,pValue));
end;

procedure TPropertyList.Add(pName: String; pValue: TObject);
begin
  Remove(pName);
  FList.Add(TObjectData.Create(pName,pValue));
end;

function TPropertyList.GetString(pName : String) : String;
var
  item : TObject;
begin
  item := FindByName(pName);
  result := '';
  if item <> nil then
     if item is TStringData then
        result := TStringData(item).Value;
end;

function TPropertyList.GetInt(pName : String) : Int64;
var
  item : TObject;
begin
  item := FindByName(pName);
  result := 0;
  if item <> nil then
     if item is TIntData then
        result := TIntData(item).Value;
end;

function TPropertyList.GetObject(pName: String): TObject;
var
  item : TObject;
begin
  item := FindByName(pName);
  result := nil;
  if item <> nil then
     if item is TObjectData then
        result := TObjectData(item).Value;
end;

function TPropertyList.GetBool(pName : String) : boolean;
var
  item : TObject;
begin
  item := FindByName(pName);
  result := False;
  if item <> nil then
     if item is TBoolData then
        result := TBoolData(item).Value;
end;

function TPropertyList.FindByName(pName : String) : TObject;
var
  n : integer;
begin
  for n := 0 to FList.Count - 1 do
      if CompareText(TPropertyData(FList.Items[n]).Name,pName) = 0 then
      begin
        result := FList.Items[n];
        exit;
      end;
  result := nil;
end;

function TPropertyList.Remove(pName : String) : boolean;
var
  item : TObject;
begin
  item := FindByName(pName);
  if item <> nil then
  begin
    FList.Remove(item);
    result := True;
    exit;
  end;
  result := False;
end;

procedure TPropertyList.Clear;
begin
  FList.Clear;
end;

function TPropertyList.HasProperty(pName : String) : boolean;
begin
  result := (FindByName(pName) <> nil);
end;


end.
