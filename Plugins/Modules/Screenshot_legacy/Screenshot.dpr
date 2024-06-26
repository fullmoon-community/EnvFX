{
Source Name: Screenshot.dpr
Description: SharpBar Module Main Project File
Copyright (C) Ron Nicholson <Sylaei@gmail.com>

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

library Screenshot;



uses
  ShareMem,
  // Default Units
  Windows, Controls, SysUtils, Forms, Classes, Contnrs, StdCtrls,
  // Custom Units
  gr32,
  // SharpE Units
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  SharpESkinManager, SharpEBar, uSharpBarApi, MouseTimer,
  // Project Units
  MainWnd in 'MainWnd.pas' {MainForm},
  SettingsWnd in 'SettingsWnd.pas' {SettingsForm};

type
  TModule = class
            private
              FForm : TForm;
              FID   : integer;
              FPos  : integer;
              FBarWnd  : hWnd;
            public
              constructor Create(pID,pBarID : integer; pParent : hwnd); reintroduce;
              destructor Destroy; override;

              property ID   : integer read FID;
              property Pos  : integer read FPos write FPos;
              property Form : TForm   read FForm;
              property BarWnd : hWnd  read FBarWnd;
            end;

var
  ModuleList : TObjectList;
  MouseTimer : TMouseTimer;

{$R *.res}

function GetControlByHandle(AHandle: THandle): TWinControl;
begin
 Result := Pointer(GetProp( AHandle,
                            PChar( Format( 'Delphi%8.8x',
                                           [GetCurrentProcessID]))));
end;

// Module Storage class for the TObjectList
constructor TModule.Create(pID,pBarID : integer; pParent : hwnd);
begin
  inherited Create;
  FID   := pID;
  FBarWnd := pParent;
  FForm := TMainForm.CreateParented(pParent);
  FForm.BorderStyle := bsNone;
  try
    FForm.Height := GetBarPluginHeight(FBarWnd);
  except
  end;
  FForm.ParentWindow := pParent;
  MouseTimer.AddWinControl(TMainForm(FForm));
  with FForm as TMainForm do
  begin
    ModuleID := pID;
    BarID    := pBarID;
    BarWnd   := FBarWnd;
    LoadSettings;
    RealignComponents(False);
    Show;
    SharpApi.RegisterShellHookReceiver(Handle);
    RegisterActionEx('!PrintScreen', 'SharpCore', FForm.Handle, 0);
    RegisterActionEx('!PrintWindow', 'SharpCore', FForm.Handle, 1);
  end;
end;

destructor TModule.Destroy;
begin
  FForm.Free;
  FForm := nil;
  inherited Destroy;
end;


// New module, wohooo... =)
function CreateModule(ID : integer;
                      BarID : integer;
                      parent : hwnd) : hwnd;
var
  temp : TModule;
begin
  try
    if ModuleList = nil then
       ModuleList := TObjectList.Create;

    if MouseTimer = nil then
       MouseTimer := TMouseTimer.Create;

    temp := TModule.Create(ID,BarID,parent);
    ModuleList.Add(temp);
  except
    result := 0;
    exit;
  end;
  result := temp.Form.Handle;
end;

// SharpBar is closing a module
function CloseModule(ID : integer) : boolean;
var
  n : integer;
begin
  result := False;
  if ModuleList = nil then exit;

  try
    for n := 0 to ModuleList.Count - 1 do
        if TModule(ModuleList.Items[n]).ID = ID then
        begin
          MouseTimer.RemoveWinControl(TModule(ModuleList.Items[n]).Form);
          if MouseTimer.ControlList.Count = 0 then
             FreeAndNil(MouseTimer);
          ModuleList.Delete(n);
          result := True;
          exit;
        end;
  except
    result := False;
  end;
end;

// Module needs to be refreshed...
procedure Refresh(ID : integer);
var
  n : integer;
  temp : TModule;
begin
  for n := 0  to ModuleList.Count - 1 do
      if TModule(ModuleList.Items[n]).ID = ID then
      begin
        temp := TModule(ModuleList.Items[n]);
        TMainForm(temp.Form).ReAlignComponents(True);
      end;
end;

// The Position of a module with given ID has changed!
// Update the Background Bitmap of the module
procedure PosChanged(ID : integer);
var
  n : integer;
  temp : TModule;
begin
  for n := 0  to ModuleList.Count - 1 do
      if TModule(ModuleList.Items[n]).ID = ID then
      begin
        temp := TModule(ModuleList.Items[n]);
        TMainForm(temp.Form).UpdateBackground;
        TMainForm(temp.Form).Repaint;
      end;
end;

// Something changed and the modules have to be updated
procedure UpdateMessage(part : TSU_UPDATE_ENUM; param : integer);
const
  processed : TSU_UPDATES = [suSkinFileChanged,suBackground,suTheme,suSkin,
                             suScheme,suSkinFont];
var
  temp : TModule;
  n,i : integer;
begin
  if not (part in processed) then
    exit;

  if ModuleList = nil then exit;

  for n := 0  to ModuleList.Count - 1 do
  begin
    temp := TModule(ModuleList.Items[n]);

    // Step1: check if height changed
    if [part] <= [suSkinFileChanged,suBackground,suTheme] then
    begin
      i := GetBarPluginHeight(temp.BarWnd);
      if temp.Form.Height <> i then
         temp.Form.Height := i;
    end;

     // Step2: check if skin or scheme changed
    if [part] <= [suScheme,suTheme] then
       TMainForm(temp.Form).SkinManager.UpdateScheme;
    if (part = suSkinFileChanged) then
       TMainForm(temp.Form).SkinManager.UpdateSkin;

    // Step3: update
    if [part] <= [suScheme,suBackground,suSkinFileChanged,suTheme] then
    begin
      TMainForm(temp.Form).UpdateBackground;
      if param <> -2 then
         TMainForm(temp.Form).Repaint;
      if [part] <= [suTheme,suSkinFileChanged] then
         TMainForm(temp.Form).ReAlignComponents(True);
    end;

    // Step4: Update if font changed
    if [part] <= [suSkinFont] then
      TMainForm(temp.Form).SkinManager.RefreshControls;
  end;
end;

// The SharpBar requested to display the Settings Window of the Module with the given ID
procedure ShowSettingsWnd(ID : integer);
var
  n : integer;
  temp : TModule;
begin
  for n := 0 to ModuleList.Count - 1 do
      if TModule(ModuleList.Items[n]).ID = ID then
      begin
        temp := TModule(ModuleList.Items[n]);
        TMainForm(temp.FForm).MenuSettingsItem.OnClick(TMainForm(temp.FForm).MenuSettingsItem);
      end;
end;

// The SharpBar is changing the size a Module!
procedure SetSize(ID : integer; NewWidth : integer);
var
  n : integer;
  temp : TModule;
begin
  for n := 0 to ModuleList.Count - 1 do
      if TModule(ModuleList.Items[n]).ID = ID then
      begin
        temp := TModule(ModuleList.Items[n]);
        TMainForm(temp.FForm).SetWidth(NewWidth);
      end;
end;

function ModuleMessage(ID : integer; msg: string): integer;
var
  n : integer;
  temp : TModule;
begin
  result := 0;
  if ModuleList = nil then exit;
  if CompareText(msg,'MM_SHELLHOOKWINDOWCREATED') <> 0 then exit;

  for n := 0 to ModuleList.Count - 1 do
      if TModule(ModuleList.Items[n]).ID = ID then
      begin
        temp := TModule(ModuleList.Items[n]);
        SharpApi.RegisterShellHookReceiver(temp.Form.Handle);
      end;
end;

function GetMetaData(Preview : TBitmap32) : TMetaData;
begin
  with result do
  begin
    Name := 'Screenshot';
    Author := 'Ron Nicholson <Sylaei@gmail.com>';
    Description := 'Takes screenshots';
    ExtraData := 'preview: false';
    DataType := tteModule;
  end;
end;


Exports
  CreateModule,
  CloseModule,
  Poschanged,
  Refresh,
  UpdateMessage,
  ShowSettingsWnd,
  SetSize,
  ModuleMessage,
  GetMetaData;

begin
end.
