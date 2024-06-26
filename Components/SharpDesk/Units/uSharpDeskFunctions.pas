{
Source Name: uSharpDeskFunctions.pas
Description: usefull functions
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

unit uSharpDeskFunctions;

interface

uses Windows,
     Menus,
     SysUtils,
     Dialogs,
     Controls,
     Forms,
     GR32,
     types,
     Classes,
     jvSimpleXML,
     SharpApi;



function IsAdmin: Boolean;
procedure RGBValueToRGB(out R,G,B : byte; RGB : integer);
procedure CopyXML(Source,Target : TJvSimpleXMLElems);
function GetCurrentMonitor : integer;
function HasVisiblePixel(Bitmap: TBitmap32): Boolean;     
function PointInRect(P : TPoint; Rect : TRect) : boolean;
function GetBitmapSize(pBitmap : TBitmap32; pSList : TStringList) : TPoint;
function ForceForegroundWindow(hwnd: THandle): Boolean;
procedure CopyMenuItems(const Item1,Item2 : TMenuItem; ImageIndexMod : integer; UseParent : boolean);


implementation


procedure CopyMenuItems(const Item1,Item2 : TMenuItem; ImageIndexMod : integer; UseParent : boolean);
var
   n : integer;
   MenuItem : TMenuItem;
begin
  for n := 0 to Item1.Count - 1 do
  begin
    MenuItem                    := TMenuItem.Create(Item2);
    MenuItem.OnClick            := Item1.Items[n].OnClick;
    MenuItem.OnDrawItem         := Item1.Items[n].OnDrawItem;
    MenuItem.OnAdvancedDrawItem := Item1.Items[n].OnAdvancedDrawItem;
    MenuItem.OnMeasureItem      := Item1.Items[n].OnMeasureItem;
    MenuItem.Caption            := Item1.Items[n].Caption;
    MenuItem.ImageIndex         := ImageIndexMod + Item1.Items[n].ImageIndex;
    MenuItem.Tag                := Item1.Items[n].Tag;
    MenuItem.Visible            := Item1.Items[n].Visible;
    if UseParent then Item2.Parent.Insert(Item2.Parent.IndexOf(Item2),MenuItem)
       else Item2.Add(MenuItem);
    if Item1.Items[n].Count>0 then CopyMenuItems(item1.Items[n],MenuItem,ImageIndexMod,False);
  end;
end;

function IsAdmin: Boolean;
const
  SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority =
  (Value: (0, 0, 0, 0, 0, 5));
  SECURITY_BUILTIN_DOMAIN_RID = $00000020;
  DOMAIN_ALIAS_RID_ADMINS     = $00000220;

var
  hAccessToken: THandle;
  ptgGroups: PTokenGroups;
  dwInfoBufferSize: DWORD;
  psidAdministrators: PSID;
  x: Integer;
  bSuccess: BOOL;
begin
  Result := False;
  bSuccess:=False;
  ptgGroups:=nil;
  psidAdministrators:=nil;
  try
    bSuccess := OpenThreadToken(GetCurrentThread, TOKEN_QUERY, True,
      hAccessToken);
    if not bSuccess then
    begin
      if GetLastError = ERROR_NO_TOKEN then
      bSuccess := OpenProcessToken(GetCurrentProcess, TOKEN_QUERY,
        hAccessToken);
    end;
    if bSuccess then
    begin
      GetMem(ptgGroups, 1024);
      bSuccess := GetTokenInformation(hAccessToken, TokenGroups,
        ptgGroups, 1024, dwInfoBufferSize);
      if bSuccess then
      begin
        AllocateAndInitializeSid(SECURITY_NT_AUTHORITY, 2,
          SECURITY_BUILTIN_DOMAIN_RID, DOMAIN_ALIAS_RID_ADMINS,
          0, 0, 0, 0, 0, 0, psidAdministrators);
        
{$R-}
        for x := 0 to ptgGroups.GroupCount - 1 do
          if EqualSid(psidAdministrators, ptgGroups.Groups[x].Sid) then
          begin
            Result := True;
            Break;
          end;
        
{$R+}
      end;
    end;
  finally
    if bSuccess then
      CloseHandle(hAccessToken);
    if Assigned(ptgGroups) then
      FreeMem(ptgGroups);
    if Assigned(psidAdministrators) then
      FreeSid(psidAdministrators);
  end;
end;

function GetCurrentMonitor : integer;
var
  n : integer;
  CPos : TPoint;
begin
  // something went wrong and the cursor isn't in any monitor
  result := 0;

  if not GetCursorPosSecure(CPos) then
    exit;

  for n := 0 to Screen.MonitorCount - 1 do
      if PointInRect(CPos,Screen.Monitors[n].BoundsRect) then
      begin
        result := n;
        exit;
      end;
end;

// function written by Andre Beckedorf (graphics32 dev team)
function HasVisiblePixel(Bitmap: TBitmap32): Boolean;
var
  I: Integer;
  S: PColor32;
begin
  Result := False;
  if (Bitmap.DrawMode = dmBlend) and (Bitmap.MasterAlpha = 0) then Exit;

  S := @Bitmap.Bits[0];
//  showmessage(inttostr(I));
  for I := 0 to Bitmap.Width * Bitmap.Height - 1 do
  begin
    if S^ shr 24 > 0 then
    begin
      Result := True;
      Exit;
    end;
    Inc(S);
  end;
end;


function ForceForegroundWindow(hwnd: THandle): Boolean;
const  
  SPI_GETFOREGROUNDLOCKTIMEOUT = $2000;  
  SPI_SETFOREGROUNDLOCKTIMEOUT = $2001;  
var  
  ForegroundThreadID: DWORD;  
  ThisThreadID: DWORD;  
  timeout: DWORD;  
begin  
  if IsIconic(hwnd) then ShowWindow(hwnd, SW_RESTORE);  

 
  if GetForegroundWindow = hwnd then Result := True  
  else  
  begin  
    // Windows 98/2000 doesn't want to foreground a window when some other  
    // window has keyboard focus  
 
    if ((Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion > 4)) or  
      ((Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and  
      ((Win32MajorVersion > 4) or ((Win32MajorVersion = 4) and  
      (Win32MinorVersion > 0)))) then  
    begin  
      // Code from Karl E. Peterson, www.mvps.org/vb/sample.htm  
      // Converted to Delphi by Ray Lischner  
      // Published in The Delphi Magazine 55, page 16  
 
      Result := False;  
      ForegroundThreadID := GetWindowThreadProcessID(GetForegroundWindow, nil);  
      ThisThreadID := GetWindowThreadPRocessId(hwnd, nil);  
      if AttachThreadInput(ThisThreadID, ForegroundThreadID, True) then  
      begin  
        BringWindowToTop(hwnd); // IE 5.5 related hack  
        SetForegroundWindow(hwnd);  
        AttachThreadInput(ThisThreadID, ForegroundThreadID, False);  
        Result := (GetForegroundWindow = hwnd);  
      end;  
      if not Result then  
      begin  
        // Code by Daniel P. Stasinski  
        SystemParametersInfo(SPI_GETFOREGROUNDLOCKTIMEOUT, 0, @timeout, 0);  
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(0),  
          SPIF_SENDCHANGE);  
        BringWindowToTop(hwnd); // IE 5.5 related hack  
        SetForegroundWindow(hWnd);  
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(timeout), SPIF_SENDCHANGE);  
      end;  
    end  
    else  
    begin  
      BringWindowToTop(hwnd); // IE 5.5 related hack  
      SetForegroundWindow(hwnd);  
    end;  

 
    Result := (GetForegroundWindow = hwnd);  
  end;  
end; { ForceForegroundWindow }

function GetBitmapSize(pBitmap : TBitmap32; pSList : TStringList) : TPoint;
var
  n : integer;
  w,h : integer;
  nw,nh : integer;
begin
  w := 0;
  h := 0;
  for n := 0 to pSList.Count - 1 do
  begin
    nw := pBitmap.TextWidth(pSList[n]);
    nh := pBitmap.TextHeight(pSList[n]);
    if nw > w then w := nw;
    h := h + nh;
  end;
  result := Point(w,h);
end;


procedure CopyXML(Source,Target : TJvSimpleXMLElems);
var
   n,i : integer;
begin
     if Source.Count = 0 then exit;
     for n:=0 to Source.Count-1 do
         if Source.Item[n].Items.Count>0 then
            CopyXML(Source.Item[n].Items,Target.Add(Source.Item[n].Name).Items)
            else with Target.Add(Source.Item[n].Name,Source.Item[n].Value) do
                 if Source.Item[n].Properties.Count>0 then
                    for i:=0 to Source.Item[n].Properties.Count-1 do
                        Properties.Add(Source.Item[n].Properties.Item[i].Name,Source.Item[n].Properties.Item[i].Value); 
end;


function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;


procedure RGBValueToRGB(out R,G,B : byte; RGB : integer);
begin
     R:=Trunc(Frac(RGB / 65536 *256)*256);
     G:=Trunc(Frac(RGB / 65536)*256);
     B:=Trunc(RGB / 65536);
end;


end.
 