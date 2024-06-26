{
Source Name: Shell.dpr
Description: SystemTray and TaskManager service library file
Copyright (C) Martin Kr�mer (MartinKraemer@gmx.net)

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

library Shell;

uses
  ShareMem,
  MultiMon,
  uxtheme,
  math,
  windows,
  Psapi,
  classes,
  sysutils,
  shellapi,
  registry,
  messages,
  Contnrs,
  ActiveX,
  JclSysInfo,
  JclSimpleXML,
  Jclstrings,
  MonitorList,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uTypes in 'uTypes.pas',
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  uTaskManager in 'uTaskManager.pas',
  uTaskItem in 'uTaskItem.pas',
  VWMFunctions in '..\..\..\Common\Units\VWM\VWMFunctions.pas',
  uSystemFuncs in '..\..\..\Common\Units\SystemFuncs\uSystemFuncs.pas',
  uExplorer in 'uExplorer.pas',
  uWindows in 'uWindows.pas',
  uDeskArea in 'uDeskArea.pas',
  uTray in 'uTray.pas',
  uFullscreen in 'uFullscreen.pas';

{$R 'VersionInfo.res'}
{$R *.RES}

{$WARN SYMBOL_PLATFORM OFF}

var
  ExplorerThread : TExplorerThread;

function GetWndCaption(pHandle: hwnd): string;
var
  buf: array[0..254] of Char;
begin
  GetWindowText(pHandle, buf, SizeOf(buf));
  result := buf;
end;

function GetWndClass(pHandle: hwnd): string;
var
  buf: array[0..254] of Char;
begin
  GetClassName(pHandle, buf, SizeOf(buf));
  result := buf;
end;

function GetPidFromProcessNameCase(const ProcessName: string): DWORD;
var
  List: TStringList;
  I: Integer;
  HasFullPath: Boolean;
begin
  Result := INVALID_HANDLE_VALUE;
  List := TStringList.Create;
  try
    HasFullPath := ExtractFilePath(ProcessName) <> '';
    if RunningProcessesList(List, HasFullPath) then
    begin
      for I := 0 to List.Count - 1 do
      begin
        if AnsiCompareStr(List[I], Processname) = 0 then
          Result := DWORD(List.Objects[I]);
      end;
    end;
  finally
    List.Free;
  end;
end;

function Start(owner: hwnd): hwnd;
begin
  InitThemeLibrary;

  ExplorerThread := TExplorerThread.Create(False);
  ExplorerThread.Resume;
  if not ExplorerThread.WaitStarted then
    FreeAndNil(ExplorerThread);

  TaskMsgManager := nil;
  TrayManager := nil;
  DeskAreaManager := nil;
  
  WindowsClass := TWindowStructureClass.Create;
  FullscreenChecker := TFullscreenChecker.Create;

  TaskMsgManager     := TTaskMsgManager.Create;
  TrayManager     := TTrayManager.Create;
  DeskAreaManager := TDeskAreaManager.Create;
  DeskAreaManager.LoadSettings;
  TaskManager := TTaskManager.Create;
  TaskManager.ListMode := True;
  TaskManager.Enabled := True;
  TaskManager.MultiThreading := False;
  TaskManager.InitList;

  SharpApi.SharpEBroadCast(WM_SHELLHOOKWINDOWCREATED,WindowsClass.MsTaskSwWClass,0);
  TaskMsgManager.RegisterHook;

  ServiceDone('Shell');
  Result := owner;

  SendNotifyMessage(HWND_BROADCAST, RegisterWindowMessage('TaskbarCreated'), 0, 0);
end;

procedure Stop;
begin
  if ExplorerThread <> nil then
  begin
    ExplorerThread.Terminate;
    ExplorerThread.Resume;
    ExplorerThread.WaitFor;
  end;
  FreeAndNil(ExplorerThread);

  FreeAndNil(FullscreenChecker);

  FreeAndNil(DeskAreaManager);
  FreeAndNil(TrayManager);
  FreeAndNil(TaskMsgManager);
  FreeAndNil(TaskManager);

  WindowsClass.Free;
end;

function SCMsg(msg: string): integer;
var
  CmdList: TStringList;
  Cmd, Val: string;
begin
  CmdList := TStringList.Create;
  StrTokenToStrings(msg, ',', CmdList);

  // Get Command and value
  Cmd := CmdList.Strings[0];
  Val := Copy(msg, length(cmd) + 2, length(msg));
  CmdList.Free;

  if Cmd = 'DeskAreaUpdate' then
    DeskAreaManager.SetDeskArea
  else if Cmd = 'StartExplorer' then
  begin
    DeskAreaManager.SetDeskArea;

    // Start Explorer Desktop
    if (FindWindow('TSharpExplorerForm', nil) <> 0) then
	  begin
      PostMessage(FindWindow('TSharpExplorerForm', nil), WM_SHARPSHELLREADY, 0, 0);
	  end;
  end else if Cmd = 'ShuttingDown' then
    TrayManager.ShuttingDown := True;

  Result := 1;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Shell';
    Description := 'Provides the core shell functionality (Taskbar,Tray,DeskArea)';
    Author := 'Martin Kr�mer (MartinKraemer@gmx.net)';
    DataType := tteService;
    ExtraData := 'priority: 20| delay: 0';
  end;
end;

//Ordinary Dll code, tells delphi what functions to export.
exports
  Start,
  Stop,
  SCMsg,
  GetMetaData;

begin

end.


