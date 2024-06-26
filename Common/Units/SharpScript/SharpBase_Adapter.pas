{
Source Name: SharpBase_Adapter.pas
Description: JvInterpreter Adapater Unit
             Adds Base function support to any script
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

unit SharpBase_Adapter;

interface

uses Windows,
     SysUtils,
     Classes,
     JvInterpreter;


procedure RegisterBaseLog(pLog : TStrings);
procedure UnregisterBaseLog;
procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter);

implementation

uses Variants,
     Types,
     DateUtils;

var
  FLog : TStrings;
  FLogEnabled : boolean;

procedure UnregisterBaseLog;
begin
  FLogEnabled := False;
  FLog := nil;
end;

procedure RegisterBaseLog(pLog : TStrings);
begin
  FLogEnabled := True;
  FLog := pLog;
end;

procedure AddLog(logmsg : String);
begin
  if not FLogEnabled then exit;

  try
    if FLog <> nil then FLog.Add(logmsg);
  except
    FLog := nil;
  end;
end;

procedure Adapter_Sleep(var Value: Variant; Args: TJvInterpreterArgs);
begin
  AddLog('Executing Sleep('+VarToStr(Args.Values[0])+')');
  Sleep(Args.Values[0]);
end;

procedure Adapter_IntToStr(var Value: Variant; Args: TJvInterpreterArgs);
begin
  try
    Value := inttostr(Args.Values[0]);
    AddLog('IntToStr("'+VarToStr(Args.Values[0])+'") -> ' + Value);
  except
    AddLog('Failed to convert "'+VarToStr(Args.Values[0])+'" to String');
    Value := '';
  end;
end;

procedure Adapter_StrToInt(var Value: Variant; Args: TJvInterpreterArgs);
begin
  try
    Value := strtoint(Args.Values[0]);
    AddLog('StrToInt("'+VarToStr(Args.Values[0])+'") -> ' + inttostr(Value));
  except
    AddLog('Failed to convert "'+VarToStr(Args.Values[0])+'" to Integer');
    Value := 0;
  end;
end;


procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter);
begin
  with JvInterpreterAdapter do
  begin
    AddFunction('SharpBase','Sleep',Adapter_Sleep,1,[varInteger],varEmpty);
    AddFunction('SharpBase','IntToStr',Adapter_IntToStr,1,[varInteger],varString);
    AddFunction('SharpBase','StrToInt',Adapter_StrToInt,1,[varString],varInteger);
  end;
end;

end.
