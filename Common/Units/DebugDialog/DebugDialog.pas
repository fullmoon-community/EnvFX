{****************************************************************************}
{                                                                            }
{ Project JEDI Code Library (JCL)                                            }
{                                                                            }
{ The contents of this file are subject to the Mozilla Public License        }
{ Version 1.1 (the "License"); you may not use this file except in           }
{ compliance with the License. You may obtain a copy of the License at       }
{ http://www.mozilla.org/MPL/                                                }
{                                                                            }
{ Software distributed under the License is distributed on an "AS IS" basis, }
{ WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   }
{ for the specific language governing rights and limitations under the       }
{ License.                                                                   }
{                                                                            }
{ The Original Code is ExceptDlg.pas.                                        }
{                                                                            }
{ The Initial Developer of the Original Code is Petr Vones.                  }
{ Portions created by Petr Vones are Copyright (C) of Petr Vones.            }
{                                                                            }
{****************************************************************************}
{                                                                            }
{ Last modified: $Date: 2006-05-18 18:04:47 +0200 (jeu., 18 mai 2006) $      }
{                                                                            }
{****************************************************************************}

unit DebugDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, AppEvnts,
  JclSysUtils, JclMapi, JclDebug;

const
  UM_CREATEDETAILS = WM_USER + $100;

type
  TDebugDialog = class(TForm)
    SendBtn: TButton;
    TextLabel: TMemo;
    OkBtn: TButton;
    DetailsBtn: TButton;
    BevelDetails: TBevel;
    DetailsMemo: TMemo;
    procedure SendBtnClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DetailsBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    private
    FDetailsVisible: Boolean;
    FThreadID: DWORD;
    FLastActiveControl: TWinControl;
    FNonDetailsHeight: Integer;
    FFullHeight: Integer;

    function GetReportAsText: string;
    procedure SetDetailsVisible(const Value: Boolean);
    procedure UMCreateDetails(var Message: TMessage); message UM_CREATEDETAILS;
  protected
    procedure AfterCreateDetails; dynamic;
    procedure BeforeCreateDetails; dynamic;
    procedure CreateDetails; dynamic;
    procedure CreateReport;
    function ReportMaxColumns: Integer; virtual;
    function ReportNewBlockDelimiterChar: Char; virtual;
    procedure NextDetailBlock;
    procedure UpdateTextLabelScrollbars;
  public
    procedure CopyReportToClipboard;
    class procedure ExceptionHandler(Sender: TObject; E: Exception);
    class procedure ExceptionThreadHandler(Thread: TJclDebugThread);
    class procedure ShowException(E: TObject; Thread: TJclDebugThread);
    property DetailsVisible: Boolean read FDetailsVisible
      write SetDetailsVisible;
    property ReportAsText: string read GetReportAsText;

  end;

  TDebugDialogClass = class of TDebugDialog;

var
  DebugDialogClass: TDebugDialogClass = TDebugDialog;

implementation

{$R *.dfm}

uses
  ClipBrd, Math,
  JclBase, JclFileUtils, JclHookExcept, JclPeImage, JclStrings, JclSysInfo,
  JclWin32, JclAnsiStrings;

resourcestring
  RsAppError = '%s - application error';
  RsExceptionClass = 'Exception class: %s';
  RsExceptionMessage = 'Exception message: %s';
  RsExceptionAddr = 'Exception address: %p';
  RsStackList = 'Stack list, generated %s';
  RsModulesList = 'List of loaded modules:';
  RsOSVersion = 'System   : %s %s, Version: %d.%d, Build: %x, "%s"';
  RsProcessor = 'Processor: %s, %s, %d MHz';
  RsMemory = 'Memory: %d; free %d';
  RsScreenRes = 'Display  : %dx%d pixels, %d bpp';
  RsActiveControl = 'Active Controls hierarchy:';
  RsThread = 'Thread: %s';
  RsMissingVersionInfo = '(no version info)';
  RsMainThreadCallStack = 'Call stack for main thread';
  RsThreadCallStack = 'Call stack for thread %s';

var
  DebugDlg: TDebugDialog;

//============================================================================
// Helper routines
//============================================================================

// SortModulesListByAddressCompare
// sorts module by address
function SortModulesListByAddressCompare(List: TStringList;
  Index1, Index2: Integer): Integer;
var
  Addr1, Addr2: Cardinal;
begin
  Addr1 := Cardinal(List.Objects[Index1]);
  Addr2 := Cardinal(List.Objects[Index2]);
  if Addr1 > Addr2 then
    Result := 1
  else if Addr1 < Addr2 then
    Result := -1
  else
    Result := 0;
end;

//============================================================================
// TApplication.HandleException method code hooking for exceptions from DLLs
//============================================================================

// We need to catch the last line of TApplication.HandleException method:
// [...]
//   end else
//    SysUtils.ShowException(ExceptObject, ExceptAddr);
// end;

procedure HookShowException(ExceptObject: TObject; ExceptAddr: Pointer);
begin
  if JclValidateModuleAddress(ExceptAddr)
    and (ExceptObject.InstanceSize >= Exception.InstanceSize) then
    TDebugDialog.ExceptionHandler(nil, Exception(ExceptObject))
  else
    SysUtils.ShowException(ExceptObject, ExceptAddr);
end;

//----------------------------------------------------------------------------

function HookTApplicationHandleException: Boolean;
const
  CallOffset      = $86;
  CallOffsetDebug = $94;
type
  PCALLInstruction = ^TCALLInstruction;
  TCALLInstruction = packed record
    Call: Byte;
    Address: Integer;
  end;
var
  TApplicationHandleExceptionAddr, SysUtilsShowExceptionAddr: Pointer;
  CALLInstruction: TCALLInstruction;
  CallAddress: Pointer;
  WrittenBytes: Cardinal;

  function CheckAddressForOffset(Offset: Cardinal): Boolean;
  begin
    try
      CallAddress := Pointer(Cardinal(TApplicationHandleExceptionAddr) + Offset);
      CALLInstruction.Call := $E8;
      Result := PCALLInstruction(CallAddress)^.Call = CALLInstruction.Call;
      if Result then
      begin
        if IsCompiledWithPackages then
          Result := PeMapImgResolvePackageThunk(Pointer(Integer(CallAddress) + Integer(PCALLInstruction(CallAddress)^.Address) + SizeOf(CALLInstruction))) = SysUtilsShowExceptionAddr
        else
          Result := PCALLInstruction(CallAddress)^.Address = Integer(SysUtilsShowExceptionAddr) - Integer(CallAddress) - SizeOf(CALLInstruction);
      end;
    except
      Result := False;
    end;
  end;

begin
  TApplicationHandleExceptionAddr := PeMapImgResolvePackageThunk(@TApplication.HandleException);
  SysUtilsShowExceptionAddr := PeMapImgResolvePackageThunk(@SysUtils.ShowException);
  if Assigned(TApplicationHandleExceptionAddr) and Assigned(SysUtilsShowExceptionAddr) then
  begin
    Result := CheckAddressForOffset(CallOffset) or CheckAddressForOffset(CallOffsetDebug);
    if Result then
    begin
      CALLInstruction.Address := Integer(@HookShowException) - Integer(CallAddress) - SizeOf(CALLInstruction);
      Result := WriteProtectedMemory(CallAddress, @CallInstruction, SizeOf(CallInstruction), WrittenBytes);
    end;
  end
  else
    Result := False;
end;

//============================================================================
// Exception dialog with Send
//============================================================================

var
  ExceptionShowing: Boolean;

//=== { TDebugDialog } ===============================================

procedure TDebugDialog.AfterCreateDetails;
begin
  SendBtn.Enabled := True;
  CopyReportToClipboard;
end;

//----------------------------------------------------------------------------

procedure TDebugDialog.BeforeCreateDetails;
begin
  SendBtn.Enabled := False;
end;

//----------------------------------------------------------------------------

function TDebugDialog.ReportMaxColumns: Integer;
begin
  Result := 78;
end;

//----------------------------------------------------------------------------

procedure TDebugDialog.SendBtnClick(Sender: TObject);
begin
  with TJclEmail.Create do
  try
    ParentWnd := Application.Handle;
    Recipients.Add('staff@sharpenviro.com');
    Subject := 'Bug Report';
    Body := ReportAsText;
    SaveTaskWindows;
    try
      Send(True);
    finally
      RestoreTaskWindows;
    end;
  finally
    Free;
  end;
end;

//----------------------------------------------------------------------------

procedure TDebugDialog.CopyReportToClipboard;
begin
  ClipBoard.AsText := ReportAsText;
end;

//----------------------------------------------------------------------------

procedure TDebugDialog.CreateDetails;
begin
  Screen.Cursor := crHourGlass;
  DetailsMemo.Lines.BeginUpdate;
  try
    CreateReport;

    DetailsMemo.SelStart := 0;
    SendMessage(DetailsMemo.Handle, EM_SCROLLCARET, 0, 0);
    AfterCreateDetails;
  finally
    DetailsMemo.Lines.EndUpdate;
    OkBtn.Enabled := True;
    DetailsBtn.Enabled := True;
    OkBtn.SetFocus;
    Screen.Cursor := crDefault;
  end;
end;

//----------------------------------------------------------------------------

procedure TDebugDialog.CreateReport;
var
  SL: TStringList;
  I: Integer;
  ModuleName: TFileName;
  NtHeaders32: PImageNtHeaders32;
  NtHeaders64: PImageNtHeaders64;
  ModuleBase: Cardinal;
  ImageBaseStr: string;
  C: TWinControl;
  CpuInfo: TCpuInfo;
  ProcessorDetails: string;
  StackList: TJclStackInfoList;
  ThreadList: TJclDebugThreadList;
  AThreadID: DWORD; 
  PETarget: TJclPeTarget;
begin
  SL := TStringList.Create;
  try
    // Stack list
    StackList := JclGetExceptStackList(FThreadID);
    if Assigned(StackList) then
    begin
      DetailsMemo.Lines.Add(Format(RsStackList, [DateTimeToStr(StackList.TimeStamp)]));
      StackList.AddToStrings(DetailsMemo.Lines, True, False, True, False);
      NextDetailBlock;
    end;
    // Main thread
    if FThreadID <> MainThreadID then
    begin
      StackList := JclCreateThreadStackTraceFromID(False, MainThreadID);
      if Assigned(StackList) then
      begin
        DetailsMemo.Lines.Add(RsMainThreadCallStack);
        DetailsMemo.Lines.Add(Format(RsStackList, [DateTimeToStr(StackList.TimeStamp)]));
        StackList.AddToStrings(DetailsMemo.Lines, True, False, True, False);
        NextDetailBlock;
      end;
    end;
    // All threads
    ThreadList := JclDebugThreadList;
    ThreadList.Lock.Enter; // avoid modifications
    try
      for I := 0 to ThreadList.ThreadIDCount - 1 do
      begin
        AThreadID := ThreadList.ThreadIDs[I];
        if (AThreadID <> FThreadID) then
        begin
          StackList := JclCreateThreadStackTrace(False, ThreadList.ThreadHandles[I]);
          if Assigned(StackList) then
          begin
            DetailsMemo.Lines.Add(Format(RsThreadCallStack, [ThreadList.ThreadInfos[AThreadID]]));
            DetailsMemo.Lines.Add(Format(RsStackList, [DateTimeToStr(StackList.TimeStamp)]));
            StackList.AddToStrings(DetailsMemo.Lines, True, False, True, False);
            NextDetailBlock;
          end;
        end;
      end;
    finally
      ThreadList.Lock.Leave;
    end;



    // System and OS information
    DetailsMemo.Lines.Add(Format(RsOSVersion, [GetWindowsVersionString, NtProductTypeString,
      Win32MajorVersion, Win32MinorVersion, Win32BuildNumber, Win32CSDVersion]));
    GetCpuInfo(CpuInfo);
    with CpuInfo do
    begin
      ProcessorDetails := Format(RsProcessor, [Manufacturer, CpuName,
        RoundFrequency(FrequencyInfo.NormFreq)]);
      if not IsFDIVOK then
        ProcessorDetails := ProcessorDetails + ' [FDIV Bug]';
      if ExMMX then
        ProcessorDetails := ProcessorDetails + ' MMXex'
      else if MMX then
        ProcessorDetails := ProcessorDetails + ' MMX';
//      if SSE > 0 then
  //      ProcessorDetails := Format('%s SSE%d', [ProcessorDetails, SSE]);
      if Ex3DNow then
        ProcessorDetails := ProcessorDetails + ' 3DNow!ex'
      else if _3DNow then
        ProcessorDetails := ProcessorDetails + ' 3DNow!';
      if Is64Bits then
        ProcessorDetails := ProcessorDetails + ' 64 bits';
      if DEPCapable then
        ProcessorDetails := ProcessorDetails + ' DEP';
    end;
    DetailsMemo.Lines.Add(ProcessorDetails);
    DetailsMemo.Lines.Add(Format(RsMemory, [GetTotalPhysicalMemory div 1024 div 1024,
      GetFreePhysicalMemory div 1024 div 1024]));
    DetailsMemo.Lines.Add(Format(RsScreenRes, [Screen.Width, Screen.Height, GetBPP]));
    NextDetailBlock;


    // Modules list
    if LoadedModulesList(SL, GetCurrentProcessId) then
    begin
      DetailsMemo.Lines.Add(RsModulesList);
      SL.CustomSort(SortModulesListByAddressCompare);
      for I := 0 to SL.Count - 1 do
      begin
        ModuleName := SL[I];
        ModuleBase := Cardinal(SL.Objects[I]);
        DetailsMemo.Lines.Add(Format('[%.8x] %s', [ModuleBase, ModuleName]));
        PETarget := PeMapImgTarget(Pointer(ModuleBase));
        NtHeaders32 := nil;
        NtHeaders64 := nil;
        if PETarget = taWin32 then
          NtHeaders32 := PeMapImgNtHeaders32(Pointer(ModuleBase))
        else
        if PETarget = taWin64 then
          NtHeaders64 := PeMapImgNtHeaders64(Pointer(ModuleBase));
        if (NtHeaders32 <> nil) and (NtHeaders32^.OptionalHeader.ImageBase <> ModuleBase) then
          ImageBaseStr := Format('<%.8x> ', [NtHeaders32^.OptionalHeader.ImageBase])
        else
        if (NtHeaders64 <> nil) and (NtHeaders64^.OptionalHeader.ImageBase <> ModuleBase) then
          ImageBaseStr := Format('<%.8x> ', [NtHeaders64^.OptionalHeader.ImageBase])
        else
          ImageBaseStr := StrRepeat(' ', 11);
        if VersionResourceAvailable(ModuleName) then
          with TJclFileVersionInfo.Create(ModuleName) do
          try
            DetailsMemo.Lines.Add(ImageBaseStr + BinFileVersion + ' - ' + FileVersion);
            if FileDescription <> '' then
              DetailsMemo.Lines.Add(StrRepeat(' ', 11) + FileDescription);
          finally
            Free;
          end
        else
          DetailsMemo.Lines.Add(ImageBaseStr + RsMissingVersionInfo);
      end;
      NextDetailBlock;
    end;


    // Active controls
    if (FLastActiveControl <> nil) then
    begin
      DetailsMemo.Lines.Add(RsActiveControl);
      C := FLastActiveControl;
      while C <> nil do
      begin
        DetailsMemo.Lines.Add(Format('%s "%s"', [C.ClassName, C.Name]));
        C := C.Parent;
      end;
      NextDetailBlock;
    end;

  finally
    SL.Free;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TDebugDialog.DetailsBtnClick(Sender: TObject);
begin
  DetailsVisible := not DetailsVisible;
end;

//--------------------------------------------------------------------------------------------------

class procedure TDebugDialog.ExceptionHandler(Sender: TObject; E: Exception);
begin
  if ExceptionShowing then
    Application.ShowException(Exception(E))
  else if Assigned(E) and not IsIgnoredException(E.ClassType) then
  begin
    ExceptionShowing := True;
    try
      ShowException(E, nil);
    finally
      ExceptionShowing := False;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

class procedure TDebugDialog.ExceptionThreadHandler(Thread: TJclDebugThread);
begin
  if ExceptionShowing then
  begin
    if Thread.SyncException is EXception then
      Application.ShowException(Exception(Thread.SyncException));
  end
  else
  begin
    ExceptionShowing := True;
    try
      ShowException(Thread.SyncException, Thread);
    finally
      ExceptionShowing := False;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TDebugDialog.FormCreate(Sender: TObject);
begin

  FFullHeight := ClientHeight;
  DetailsVisible := False;
  Caption := Format(RsAppError, [Application.Title]);
end;

//--------------------------------------------------------------------------------------------------

procedure TDebugDialog.FormDestroy(Sender: TObject);
begin

end;

//--------------------------------------------------------------------------------------------------

procedure TDebugDialog.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = Ord('C')) and (ssCtrl in Shift) then
  begin
    CopyReportToClipboard;
    MessageBeep(MB_OK);
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TDebugDialog.FormPaint(Sender: TObject);
begin
  DrawIcon(Canvas.Handle, TextLabel.Left - GetSystemMetrics(SM_CXICON) - 15,
    TextLabel.Top, LoadIcon(0, IDI_ERROR));
end;

//--------------------------------------------------------------------------------------------------

procedure TDebugDialog.FormResize(Sender: TObject);
begin
  UpdateTextLabelScrollbars;
end;

//--------------------------------------------------------------------------------------------------

procedure TDebugDialog.FormShow(Sender: TObject);
begin
  BeforeCreateDetails;
  MessageBeep(MB_ICONERROR);
  if (GetCurrentThreadId = MainThreadID) and (GetWindowThreadProcessId(Handle, nil) = MainThreadID) then
    PostMessage(Handle, UM_CREATEDETAILS, 0, 0)
  else
    CreateReport;
end;

//--------------------------------------------------------------------------------------------------

function TDebugDialog.GetReportAsText: string;
begin
  Result := StrEnsureSuffix(AnsiCrLf, TextLabel.Text) + AnsiCrLf + DetailsMemo.Text;
end;

//--------------------------------------------------------------------------------------------------

procedure TDebugDialog.NextDetailBlock;
begin
  DetailsMemo.Lines.Add(StrRepeat(ReportNewBlockDelimiterChar, ReportMaxColumns));
end;

//--------------------------------------------------------------------------------------------------

function TDebugDialog.ReportNewBlockDelimiterChar: Char;
begin
  Result := '-';
end;


//--------------------------------------------------------------------------------------------------

procedure TDebugDialog.SetDetailsVisible(const Value: Boolean);
var
  DetailsCaption: string;
begin
  FDetailsVisible := Value;
  DetailsCaption := Trim(StrRemoveChars(DetailsBtn.Caption, ['<', '>']));
  if Value then
  begin
    Constraints.MinHeight := FNonDetailsHeight + 100;
    Constraints.MaxHeight := Screen.Height;
    DetailsCaption := '<< ' + DetailsCaption;
    ClientHeight := FFullHeight;
    DetailsMemo.Height := FFullHeight - DetailsMemo.Top - 3;
  end
  else
  begin
    FFullHeight := ClientHeight;
    DetailsCaption := DetailsCaption + ' >>';
    if FNonDetailsHeight = 0 then
    begin
      ClientHeight := BevelDetails.Top;
      FNonDetailsHeight := Height;
    end
    else
      Height := FNonDetailsHeight;
    Constraints.MinHeight := FNonDetailsHeight;
    Constraints.MaxHeight := FNonDetailsHeight
  end;
  DetailsBtn.Caption := DetailsCaption;
  DetailsMemo.Enabled := Value;
end;

//--------------------------------------------------------------------------------------------------

class procedure TDebugDialog.ShowException(E: TObject; Thread: TJclDebugThread);
begin
  if DebugDlg = nil then
    DebugDlg := TDebugDialogClass.Create(Application);
  try
    with DebugDlg do
    begin
      if Assigned(Thread) then
        FThreadID := Thread.ThreadID
      else
        FThreadID := MainThreadID;
      FLastActiveControl := Screen.ActiveControl;
      if E is Exception then
        TextLabel.Text := AdjustLineBreaks(StrEnsureSuffix('.', Exception(E).Message))
      else
        TextLabel.Text := AdjustLineBreaks(StrEnsureSuffix('.', E.ClassName));
      UpdateTextLabelScrollbars;
      DetailsMemo.Lines.Add(Format(RsExceptionClass, [E.ClassName]));
      if E is Exception then
        DetailsMemo.Lines.Add(Format(RsExceptionMessage, [StrEnsureSuffix('.', Exception(E).Message)]));
      if Thread = nil then
        DetailsMemo.Lines.Add(Format(RsExceptionAddr, [ExceptAddr]))
      else
        DetailsMemo.Lines.Add(Format(RsThread, [Thread.ThreadInfo]));
      NextDetailBlock;
      ShowModal;
    end;
  finally
    FreeAndNil(DebugDlg);
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TDebugDialog.UMCreateDetails(var Message: TMessage);
begin
  Update;
  CreateDetails;
end;

//--------------------------------------------------------------------------------------------------

procedure TDebugDialog.UpdateTextLabelScrollbars;
begin
  Canvas.Font := TextLabel.Font;
  if TextLabel.Lines.Count * Canvas.TextHeight('Wg') > TextLabel.ClientHeight then
    TextLabel.ScrollBars := ssVertical
  else
    TextLabel.ScrollBars := ssNone;   
end;

//==================================================================================================
// Exception handler initialization code
//==================================================================================================

var
  AppEvents: TApplicationEvents = nil;

procedure InitializeHandler;
begin
  if AppEvents = nil then
  begin
    AppEvents := TApplicationEvents.Create(nil);
    AppEvents.OnException := TDebugDialog.ExceptionHandler;


    JclStackTrackingOptions := JclStackTrackingOptions + [stTraceAllExceptions];

    JclStackTrackingOptions := JclStackTrackingOptions + [stStaticModuleList];
    JclStackTrackingOptions := JclStackTrackingOptions + [stDelayedTrace];
    JclDebugThreadList.OnSyncException := TDebugDialog.ExceptionThreadHandler;
    JclStartExceptionTracking;
    if HookTApplicationHandleException then
      JclTrackExceptionsFromLibraries;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure UnInitializeHandler;
begin
  if AppEvents <> nil then
  begin
    FreeAndNil(AppEvents);
    JclDebugThreadList.OnSyncException := nil;
    JclUnhookExceptions;
    JclStopExceptionTracking;
  end;
end;

//--------------------------------------------------------------------------------------------------

initialization
  InitializeHandler;

finalization
  UnInitializeHandler;

end.
