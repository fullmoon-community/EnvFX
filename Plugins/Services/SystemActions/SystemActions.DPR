{
Source Name: SystemActions.dpr
Description: System Actions Service library file
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

library SystemActions;

uses
  ShareMem,
  windows,
  Forms,
  SysUtils,
  Messages,
  Classes,
  SharpApi,
  SharpTypes,
  uSystemFuncs,
  dialogs,
  JCLLocales,
  VWMFunctions,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uShutdown in '..\..\..\Common\Units\Shutdown\uShutdown.pas',
  uSharpBar in '..\..\..\Components\SharpBar\uSharpBar.pas';

type
  TActionEvent = class(Tobject)
    procedure MessageHandler(var msg: TMessage);
  end;

type
  PParam = ^TParam;
  TParam = record
    wndlist: array of hwnd;
  end;

  TWndItem = record
    wnd : THandle;
    wasMinimized : boolean;
  end;
  TWndItems = array of TWndItem;

  TRunFileDlgA = procedure(hWndOwner : HWND; Icon : HICON; Directory,Title,Description : PChar; Flags : UInt); stdcall;
  TRunFileDlgW = procedure(hWndOwner : HWND; Icon : HICON; Directory,Title,Description : PWideChar; Flags : UInt); stdcall;

var
  OwnerWnd : HWND;
  AE: TActionEvent;
  h: THandle;
  LocalsList: TJclKeyboardLayoutList;
  WindowToggle: Boolean = false;
  Param: TParam;

  hRunFileDll : THandle;
  RunFileDlgA : TRunFileDlgA;
  RunFileDlgW : TRunFileDlgW;

  ActionBarList: TBarItems;

const
  cRestartIdx = 0;
  cShutdownIdx = 1;
  cLogoutIdx = 2;
  cHibernateIdx = 3;
  cSwitchUserLockIdx = 4;
  cSleepIdx = 5;
  cRestartShellIdx = 6;
  cShutdownShellIdx = 7;

  cRestart_QuietIdx = 10;
  cShutdown_QuietIdx = 11;
  cLogout_QuietIdx = 12;
  cHibernate_QuietIdx = 13;
  cSwitchUserLock_QuietIdx = 14;
  cSleep_QuietIdx = 15;
  cRestartShell_QuietIdx = 16;
  cShutdownShell_QuietIdx = 17;

  cShutdownStart = 0;
  cShutdownEnd = 17;
  cShutdownNonVerbose = 10;

  cMinimizeAllIdx = 20;
  cRestoreAllIdx = 21;
  cToggleAllBarsIdx = 22;
  cToggleAllIdx = 23;

  cRunDlgIdx = 24;

  cMinimizeAllMonitorsIdx = 25;
  cRestoreAllMonitorsIdx = 30;
  cToggleAllMonitorsIdx = 26;

  cConfigThemeIdx = 27;
  cConfigWallpaperIdx = 28;

  cSearchIdx = 29;

  // Last = 30

  cKeyboardLayoutIdx = 99;

  cStartBarIdx = 200;
  cStopBarIdx = 300;

  RFF_NOBROWSE = 1; //Removes the browse button.
  RFF_NODEFAULT = 2; // No default item selected.
  RFF_CALCDIRECTORY = 4; // Calculates the working directory from the file name.
  RFF_NOLABEL = 8; // Removes the edit box label.
  RFF_NOSEPARATEMEM = 14; // Removes the Separate Memory Space check box (Windows NT only)

{$R 'VersionInfo.res'}
{$R *.RES}

function SwitchToThisWindow(Wnd: hwnd; fAltTab: boolean): boolean; stdcall; external 'user32.dll';

procedure RegisterKeyBoardLocals;
var
  n: integer;
begin
  if LocalsList.Count <= 1 then
    exit;

  RegisterActionEx(PChar('!KLCycle'), 'Keyboard Layouts', h, 99);
  for n := 0 to LocalsList.Count - 1 do
    RegisterActionEx(PChar('!KL' + LocalsList[n].DisplayName), 'Keyboard Layouts', h, 100 + n);
end;

procedure UnRegisterKeyBoardLocals;
var
  n: integer;
begin
  if LocalsList.Count <= 1 then
    exit;

  UnRegisterAction(PChar('!KLCycle'));
  for n := 0 to LocalsList.Count - 1 do
    UnRegisterAction(PChar('!KL' + LocalsList[n].DisplayName));
end;

procedure RegisterBarActions;
var
  i : integer;
begin
  for i := 0 to Pred(ActionBarList.Count) do
  begin
    RegisterActionEx('!StartBar: ' + ActionBarList.Bars[i].Name, 'SharpBar', h, cStartBarIdx + i);
    RegisterActionEx('!StopBar: ' + ActionBarList.Bars[i].Name, 'SharpBar', h, cStopBarIdx + i);
  end;
end;

procedure UnregisterBarActions;
var
  i : integer;
begin
  for i := 0 to Pred(ActionBarList.Count) do
  begin
    UnregisterAction('!StartBar: ' + ActionBarList.Bars[i].Name);
    UnregisterAction('!StopBar: ' + ActionBarList.Bars[i].Name);
  end;
end;

procedure RegisterActions;
begin
  RegisterActionEx('!Restart', 'Shutdown', h, cRestartIdx);
  RegisterActionEx('!Shutdown', 'Shutdown', h, cShutdownIdx);
  RegisterActionEx('!Logout', 'Shutdown', h, cLogoutIdx);
  RegisterActionEx('!Hibernate', 'Shutdown', h, cHibernateIdx);
  RegisterActionEx('!SwitchUser/LockStation', 'Shutdown', h, cSwitchUserLockIdx);
  RegisterActionEx('!Sleep', 'Shutdown', h, cSleepIdx);
  RegisterActionEx('!ShellShutdown', 'Shutdown', h, cShutdownShellIdx);
  RegisterActionEx('!ShellRestart', 'Shutdown', h, cRestartShellIdx);

  RegisterActionEx('!Restart_Quiet', 'Shutdown', h, cRestart_QuietIdx);
  RegisterActionEx('!Shutdown_Quiet', 'Shutdown', h, cShutdown_QuietIdx);
  RegisterActionEx('!Logout_Quiet', 'Shutdown', h, cLogout_QuietIdx);
  RegisterActionEx('!Hibernate_Quiet', 'Shutdown', h, cHibernate_QuietIdx);
  RegisterActionEx('!SwitchUser/LockStation_Quiet', 'Shutdown', h, cSwitchUserLock_QuietIdx);
  RegisterActionEx('!Sleep_Quiet', 'Shutdown', h, cSleep_QuietIdx);
  RegisterActionEx('!ShellShutdown_Quiet', 'Shutdown', h, cShutdownShell_QuietIdx);
  RegisterActionEx('!ShellRestart_Quiet', 'Shutdown', h, cRestartShell_QuietIdx);

  RegisterActionEx('!MinimizeAll', 'Window Management', h, cMinimizeAllIdx);
  RegisterActionEx('!RestoreAll', 'Window Management', h, cRestoreAllIdx);
  RegisterActionEx('!ToggleAll', 'Window Management', h, cToggleAllIdx);

  RegisterActionEx('!MinimizeAllMonitors', 'Window Management', h, cMinimizeAllMonitorsIdx);
  RegisterActionEx('!RestoreAllMonitors', 'Window Management', h, cRestoreAllMonitorsIdx);
  RegisterActionEx('!ToggleAllMonitors', 'Window Management', h, cToggleAllMonitorsIdx);

  RegisterActionEx('!ToggleAllBars', 'SharpBar', h, cToggleAllBarsIdx);

  RegisterBarActions;

  RegisterActionEx('!RunDlg', 'Misc', h, cRunDlgIdx);
  RegisterActionEx('!Search', 'Misc', h, cSearchIdx);
  
  RegisterActionEx('!ConfigureTheme', 'Themes', h, cConfigThemeIdx);
  RegisterActionEx('!ConfigureWallpaper', 'Themes', h, cConfigWallpaperIdx);

  RegisterKeyBoardLocals;
end;

// Service is started

function Start(owner: hwnd): hwnd;
begin
  Result := owner;
  OwnerWnd := Result;

  ae := TActionEvent.Create;
  h := allocatehwnd(Ae.MessageHandler);

  LocalsList := TJclKeyboardLayoutList.Create;
  LocalsList.Refresh;

  ActionBarList := TBarItems.Create;

  RegisterActions;

  hRunFileDll := LoadLibrary('shell32.dll');
  @RunFileDlgA := GetProcAddress(hRunFileDll, PAnsiChar(MAKELPARAM(61, 0)));
  @RunFileDlgW := GetProcAddress(hRunFileDll, PAnsiChar(MAKELPARAM(61, 0)));

  ServiceDone('System Actions');
end;

// Service is stopped

procedure Stop;
begin
  DeallocateHWnd(h);
  AE.Free;

  FreeLibrary(hRunFileDll);

  UnRegisterKeyBoardLocals;
  UnRegisterAction('!Restart');
  UnRegisterAction('!Shutdown');
  UnRegisterAction('!Logout');
  UnRegisterAction('!Hibernate');
  UnRegisterAction('!SwitchUser/LockStation');
  UnRegisterAction('!Sleep');
  UnRegisterAction('!ShellShutdown');
  UnRegisterAction('!ShellReboot');

  UnRegisterAction('!Restart_Quiet');
  UnRegisterAction('!Shutdown_Quiet');
  UnRegisterAction('!Logout_Quiet');
  UnRegisterAction('!Hibernate_Quiet');
  UnRegisterAction('!SwitchUser/LockStation_Quiet');
  UnRegisterAction('!Sleep_Quiet');
  UnRegisterAction('!ShellShutdown_Quiet');
  UnRegisterAction('!ShellReboot_Quiet');  

  UnRegisterAction('!MinimizeAll');
  UnRegisterAction('!RestoreAll');
  UnRegisterAction('!ToggleAll');

  UnRegisterAction('!MinimizeAllMonitors');
  UnregisterAction('!RestoreAllMonitors');
  UnRegisterAction('!ToggleAllMonitors');

  UnRegisterAction('!ToggleAllBars');

  UnregisterBarActions;

  UnRegisterAction('!RunDlg');

  UnRegisterAction('!ConfigureTheme');
  UnRegisterAction('!ConfigureWallpaper');

  LocalsList.Free;
end;

procedure RunFileDlg(hOwner : HWND; Directory,Title,Description : PChar; Flags : UInt);
var
  DirectoryW,TitleW,DescriptionW: PWideChar;
begin
  if Assigned(RunFileDlgW) then
  begin
    DirectoryW := nil;
    TitleW := nil;
    DescriptionW := nil;

    try
      if Directory <> nil then
      begin
        GetMem(DirectoryW, sizeof(WideChar) * Succ(Length(Directory)));
        StringToWideChar(Directory, DirectoryW, Succ(Length(Directory)));
      end;
      if Title <> nil then
      begin
        GetMem(TitleW, sizeof(WideChar) * Succ(Length(Title)));
        StringToWideChar(Title, TitleW, Succ(Length(Title)));
      end;
      if Description <> nil then
      begin
        GetMem(DescriptionW, sizeof(WideChar) * Succ(Length(Description)));
        StringToWideChar(Description, DescriptionW, Succ(Length(Description)));
      end;

      RunFileDlgW(hOwner, 0, DirectoryW, TitleW, DescriptionW, Flags);
    finally
      if DirectoryW <> nil then
        FreeMem(DirectoryW);
      if TitleW <> nil then
        FreeMem(TitleW);
      if DescriptionW <> nil then
        FreeMem(DescriptionW);
    end;
  end else if Assigned(RunFileDlgA) then
    RunFileDlgA(hOwner, 0, Directory, Title, Description, Flags);
end;

{ TActionEvent }

procedure TActionEvent.MessageHandler(var msg: TMessage);

var
  ShutDown: TSEShutdown;
  n, k, j, lParam: integer;
  BarList: THandleArray;
  BarHidden: boolean;
  AL: TJclKeyboardLayout;

  wnd : HWND;
  i: integer;
begin
  if msg.Msg = WM_INPUTLANGCHANGE then
  begin
    UnRegisterKeyBoardLocals;
    LocalsList.Refresh;
    RegisterKeyBoardLocals;
  end
  else if (msg.Msg = WM_SHARPEUPDATEACTIONS) then
  begin
    RegisterActions;
  end
  else if (msg.Msg = WM_BARUPDATED) then
  begin
    // Unregister old actions first
    UnregisterBarActions;

    // Update and register new actions
    ActionBarList.Update;
    RegisterBarActions;
  end
  else if msg.Msg = WM_SHARPEACTIONMESSAGE then
  begin
    lParam := Msg.LParam;

    // Start/Stop bars
    if (msg.LParam >= cStartBarIdx) and (msg.LParam < cStopBarIdx) then
    begin
      for i := 0 to Pred(ActionBarList.Count) do
      begin
        if msg.LParam = cStartBarIdx + i then
        begin
          SharpApi.SharpExecute('_nohist,' + SharpApi.GetSharpeDirectory + 'SharpBar.exe' +
                                ' -load:' + IntToStr(ActionBarList.Bars[i].BarID) +
                                ' -noREB' +
                                ' -noLASB');
        end;
      end;
    end else if (msg.LParam >= cStopBarIdx) and (msg.LParam < cStopBarIdx + 100) then
    begin
      for i := 0 to Pred(ActionBarList.Count) do
      begin
        if msg.LParam = cStopBarIdx + i then
        begin
          wnd := FindWindow(nil, PChar('SharpBar_' + IntToStr(ActionBarList.Bars[i].BarID)));
          if wnd <> 0 then
            SendMessage(wnd, WM_SHARPTERMINATE, 0, 0);
        end;
      end;
    end;

    // Keyboard layout
    if (Msg.LParam = cKeyboardLayoutIdx) then
    begin
      k := 0;
      AL := LocalsList.ActiveLayout;
      for n := 0 to LocalsList.Count - 1 do
        if AL = LocalsList.Items[n] then
        begin
          j := n + 1;
          if j > LocalsList.Count - 1 then
            j := 0;
          SystemParametersInfo(SPI_SETDEFAULTINPUTLANG, k, @LocalsList.Items[j].Layout, SPIF_SENDCHANGE or SPIF_UPDATEINIFILE);
          PostMessage(HWND_BROADCAST, WM_INPUTLANGCHANGEREQUEST, 0, LocalsList.Items[j].Layout);
          break;
        end;
      exit;
    end else
      if (Msg.LParam > cKeyboardLayoutIdx + 1) then
      begin
        n := Msg.LParam - cKeyboardLayoutIdx + 1;
        k := 0;
        if n <= LocalsList.Count - 1 then
        begin
          SystemParametersInfo(SPI_SETDEFAULTINPUTLANG, k, @LocalsList.Items[n].Layout, SPIF_SENDCHANGE or SPIF_UPDATEINIFILE);
          PostMessage(HWND_BROADCAST, WM_INPUTLANGCHANGEREQUEST, 0, LocalsList.Items[n].Layout);
        end;
        exit;
      end;

    // The others
    case lParam of
      cShutdownStart..cShutdownEnd: begin

          case lParam of
            cShutdownShellIdx: begin
              if TSEShutDown.ShowConfirmationDialog('Shutdown', 'icon.shutdown.shutdown', 'the shell', 'Shell') then
                PostMessage(FindWindow('TSharpCoreMainWnd',nil),WM_COMMAND,makewparam(2,0),0); // 2 = ID_SHUTDOWN
              exit;
            end;
            cRestartShellIdx: begin
              if TSEShutDown.ShowConfirmationDialog('Restart', 'icon.shutdown.reboot', 'the shell', 'Shell') then
                PostMessage(FindWindow('TSharpCoreMainWnd',nil),WM_COMMAND,makewparam(3,0),0); // 3 = ID_RESTART
              exit;
            end;
            cShutdownShell_QuietIdx: begin
              PostMessage(FindWindow('TSharpCoreMainWnd',nil),WM_COMMAND,makewparam(2,0),0); // 2 = ID_SHUTDOWN
              exit;
            end;
            cRestartShell_QuietIdx: begin
              PostMessage(FindWindow('TSharpCoreMainWnd',nil),WM_COMMAND,makewparam(3,0),0); // 3 = ID_RESTART
              exit;
            end;

          end;


          ShutDown := TSEShutDown.Create(FindWindow('TSharpCoreMainWnd', nil));
          try
            case lParam of
              cRestartIdx, cRestart_QuietIdx: begin
                  ShutDown.ActionType := sdReboot;
                end;
              cShutdownIdx, cShutdown_QuietIdx: begin
                  ShutDown.ActionType := sdPowerOff;
                end;
              cLogoutIdx, cLogout_QuietIdx: begin
                  ShutDown.ActionType := sdLogOff;
                end;
              cHibernateIdx, cHibernate_QuietIdx: begin
                  ShutDown.ActionType := sdHibernate;
                end;
              cSwitchUserLockIdx, cSwitchUserLock_QuietIdx: begin
                  ShutDown.ActionType := sdLock;
                end;
              cSleepIdx, cSleep_QuietIdx: begin
                ShutDown.ActionType := sdSleep;
              end;
            end;
            ShutDown.Force := True;

            // Set verbosity
            if (lParam >= cShutdownNonVerbose) then
              ShutDown.Verbose := false else
              ShutDown.Verbose := true;

            ShutDown.Execute;
          finally
            ShutDown.Free;
          end;
        end;
      cMinimizeAllIdx, cRestoreAllIdx, cMinimizeAllMonitorsIdx, cRestoreAllMonitorsIdx: begin
          if (lParam = cMinimizeAllIdx) or (lParam = cMinimizeAllMonitorsIdx) then
          begin
            PostMessage(FindWindow('Shell_TrayWnd', nil), WM_MINIMIZEALLWINDOWS, Screen.MonitorFromWindow(GetForegroundWindow).MonitorNum, Integer(lParam = cMinimizeAllMonitorsIdx));
          end else
            PostMessage(FindWindow('Shell_TrayWnd', nil), WM_RESTOREALLWINDOWS, Screen.MonitorFromWindow(GetForegroundWindow).MonitorNum, Integer(lParam = cRestoreAllMonitorsIdx));
        end;
      cToggleAllIdx, cToggleAllMonitorsIdx: begin
          if WindowToggle then
          begin
            PostMessage(FindWindow('Shell_TrayWnd', nil), WM_MINIMIZEALLWINDOWS, Screen.MonitorFromWindow(GetForegroundWindow).MonitorNum, Integer(lParam = cToggleAllMonitorsIdx));
          end else
            PostMessage(FindWindow('Shell_TrayWnd', nil), WM_RESTOREALLWINDOWS, Screen.MonitorFromWindow(GetForegroundWindow).MonitorNum, Integer(lParam = cToggleAllMonitorsIdx));

          // Toggle (Show/Hide) all windows
          WindowToggle := not (WindowToggle);
        end;
      cToggleAllBarsIdx: begin
          // Toggle (Show/Hide) all bars
          BarList := FindAllWindows('TSharpBarMainForm');
          BarHidden := False;
          for n := 0 to High(BarList) do
            if not IsWindowVisible(BarList[n]) then
            begin
              BarHidden := True;
              break;
            end;
          SetLength(BarList, 0);
          if BarHidden then
            SharpApi.SharpEBroadCast(WM_SHOWBAR, 0, 0)
          else SharpApi.SharpEBroadCast(WM_HIDEBAR, 0, 0);
          SharpApi.ServiceMsg('DeskArea', 'Update');
        end;
      cRunDlgIdx:
        RunFileDlg(0, nil, nil, nil, 0);
      cSearchIdx:
         PostMessage(FindWindow('TSharpExplorerForm', nil), WM_SHARPSEARCH, 0, 0);
      cConfigThemeIdx:
        SharpApi.SharpExecute(SharpApi.GetSharpeDirectory + 'SharpCenter.exe -api "0|Themes|Theme|{CurrentTheme}"');
      cConfigWallpaperIdx:
        SharpApi.SharpExecute(SharpApi.GetSharpeDirectory + 'SharpCenter.exe -api "3|Themes|Wallpaper|{CurrentTheme}"');
    end;

  end
  else msg.Result := DefWindowProc(h, msg.Msg, Msg.WParam, msg.LParam);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'System Actions';
    Description := 'Adds a set of actions for system use (shutdown, reboot, etc.)';
    Author := 'Martin Kr�mer (MartinKraemer@gmx.net)';
    DataType := tteService;
    ExtraData := 'priority: 40| delay: 0';
  end;
end;

//Ordinary Dll code, tells delphi what functions to export.
exports
  Start,
  Stop,
  GetMetaData;

begin
end.

