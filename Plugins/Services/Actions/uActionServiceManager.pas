{
Source Name: ActionMgr
Description: Action Management
Copyright (C) Pixol (Lee Green)

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

unit uActionServiceManager;

interface
uses
  // Standard
  Classes,
  ContNrs,
  SysUtils,
  dialogs,
  Forms,
  Windows,
  Messages,

  // JVCL
  JvSimpleXml,

  // JCL
  JclStrings,
  jclIniFiles,

  // Common
  SharpApi,

  // Project
  uActionServiceList;

type
  TActionMgr = class
  private
    ActionList: TActionStore;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddAction(ParamsText: string);
    procedure DelAction(ParamsText: string);
    procedure BuildList(ParamText: string);
    procedure ExecAction(ParamText: string);
    function ActionExists(ParamText: string): Integer;
  end;

procedure Debug(DebugText: string; DebugType: Integer);

var
  ActionMgr: TActionMgr;

implementation

{ TActionMgr }


Procedure Debug(DebugText:String; DebugType:Integer);
Begin
  SendDebugMessageEx(AC_SERVICE_NAME,Pchar(DebugText),0,DebugType);
End;

function TActionMgr.ActionExists(ParamText: string): Integer;
var
  strlParams: TStringList;
  prmActionName: string;
  i: integer;
begin
  // Init
  Result := 0;
  strlParams := TStringList.Create;
  try

    // Extract Action Name from Paramtext
    StrTokenToStrings(ParamText, ',', strlParams);
    prmActionName := strlParams.Strings[0];

    // Check Actionlist for Action Name
    for i := 0 to ActionList.Count - 1 do begin
      if CompareText(prmActionName,ActionList.Info[i].ActionName) = 0 then begin

        // Action does exist, return 1 (True)
        Result := 1;
        break;
      end;
    end;
  finally
    StrlParams.Free;
  end;
end;

procedure TActionMgr.AddAction(ParamsText: string);
var
  strlParams: TStringList;
  prmWindowHandle, prmLParam: Integer;
  prmActionName, prmGroupName: string;
  NewItem: Integer;
  i: integer;
begin
  // Init
  strlParams := TStringList.Create;

  try
    // Extract Parameters from Paramtext
    StrTokenToStrings(ParamsText, ',', strlParams);

    // Assign to the local vars
    prmActionName := strlParams.Strings[0];
    prmGroupName := strlParams.Strings[1];
    prmWindowHandle := StrToInt(strlParams.Strings[2]);
    prmLParam := StrToInt(strlParams.Strings[3]);

    // Check whether the Action already exists
    NewItem := -1;
    for i := 0 to ActionList.Count - 1 do begin
      if CompareText(prmActionName,ActionList.Info[i].ActionName) = 0 then begin
        NewItem := i;
        break;
      end;
    end;

    if NewItem < 0 then begin
      // If the action did not exist, then add it to the Action list
      ActionList.Add(prmActionName, prmGroupName, prmWindowHandle, prmLParam);
      Debug(Format('%s %s (%s)', [AC_REGISTER_ACTION, prmActionName, prmGroupName]), DMT_STATUS);
    end
    else begin
      // Action exists, change the existing properties
      ActionList.Info[NewItem].GroupName := prmGroupName;
      ActionList.Info[NewItem].WindowHandle := prmWindowHandle;
      ActionList.Info[NewItem].LParamID := prmLParam;
      Debug(Format('%s %s (%s)', [AC_UPDATE_ACTION, prmActionName, prmGroupName]), DMT_STATUS);
    end;
  finally
    strlParams.Free;
  end;
end;

procedure TActionMgr.BuildList(ParamText: string);
var
  i: integer;
  strlTmp, strlParams: TStringList;
  fn: string;
begin
  // Init
  strlTmp := TStringList.Create;
  strlParams := TStringList.Create;

  // Extract filename from paramtext
  StrTokenToStrings(ParamText, ',', strlParams);
  fn := strlParams.Strings[0];
  Debug(Format('BuildActionList %s', [fn]), DMT_STATUS);

  try
    // Build a string list of all Actions, (ActionGroup=ActionName)
    for i := 0 to ActionList.Count - 1 do
      strlTmp.Add(format('%s=%s', [ActionList.Info[i].GroupName, ActionList.Info[i].ActionName]));

    // Save the stringlist to a file
    strlTmp.SaveToFile(fn);

  finally
    StrlTmp.Free;
    strlParams.Free;
  end;
end;

constructor TActionMgr.Create;
begin
  inherited;
  ActionList := TActionStore.Create;
end;

procedure TActionMgr.DelAction(ParamsText: string);
var
  strlParams: TStringList;
  prmActionName: string;
  NewItem: Integer;
  i: integer;
begin
  // Init
  strlParams := TStringList.Create;

  try

    // Extract Action Name from Paramtext
    StrTokenToStrings(ParamsText, ',', strlParams);
    prmActionName := strlParams.Strings[0];

    // Check if the Action Exists
    NewItem := -1;
    for i := ActionList.Count - 1 downto 0 do begin
      if CompareText(prmActionName,ActionList.Info[i].ActionName) = 0 then
        NewItem := i;
    end;

    // If it exists, then delete it
    if NewItem < 0 then
      Debug(Format('Action %s does not exist', [prmActionName]), DMT_INFO)
    else begin
      ActionList.Delete(NewItem);
      Debug(Format('Action %s unregistered', [prmActionName]), DMT_STATUS);
    end;
  finally
    strlParams.Free;
  end;
end;

destructor TActionMgr.Destroy;
begin
  ActionList.Free;

  inherited Destroy;
end;

procedure TActionMgr.ExecAction(ParamText: string);
var
  strlParams: TStringList;
  prmActionName: string;
  i: integer;
  b: boolean;
begin
  // Get Parameters
  strlParams := TStringList.Create;

  try
    // Extract Action name from Paramtext
    StrTokenToStrings(ParamText, ',', strlParams);
    prmActionName := strlParams.Strings[0];

    // Search the Action list for the Action name
    // If successfull post the message to the window handle
    // LParamID contains the id of the Action
    for i := 0 to ActionList.Count - 1 do
      if CompareText(prmActionName,ActionList.Info[i].ActionName) = 0 then begin
        with ActionList.Info[i] do
          b := PostMessage(WindowHandle, WM_SHARPEACTIONMESSAGE, 0, LParamID);

        Debug(Format('%s %s %s', [AC_EXECUTE_ACTION, prmActionName, booltostr(b)]), DMT_STATUS);
      end;
  finally
    StrlParams.Free;
  end;
end;

end.

