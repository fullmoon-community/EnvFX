{
Source Name: MainWnd.pas
Description: SharpE VWM Module - Main Window
Copyright (C) Author Martin Kr�mer <MartinKraemer@gmx.net>

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

unit MainWnd;

interface

uses
  // Default Units
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, Math,
  // Custom Units
  GR32, VWMFunctions, MonitorList,
  // SharpE API Units
  SharpApi, SharpThemeApiEx,
  // Interface Units
  uISharpBarModule, uISharpETheme;

type
  TMainForm = class(TForm)
    UpdateTimer: TTimer;
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure UpdateTimerTimer(Sender: TObject);
    procedure FormClick(Sender: TObject);
  protected
  private
    sVWMSpacing : integer;
    sBackgroundColor : integer;
    sBackgroundColorSetting : String;
    sBackgroundAlpha : byte;
    sBorderColor : integer;
    sBorderColorSetting : String;
    sBorderAlpha : byte;
    sForegroundColor : integer;
    sForegroundColorSetting : String;
    sForegroundAlpha : byte;
    sHighlightColor : integer;
    sHighlightColorSetting : String;
    sHighlightAlpha : byte;
    sTextColor : integer;
    sTextColorSetting : String;
    sTextAlpha : byte;
    sDisplayVWMNumbers : boolean;
    procedure WMShellMessage(var msg : TMessage); message WM_SHARPSHELLMESSAGE;
  public
    // vars and functions
    VWM : TBitmap32;
    VWMWidth,VWMHeight : integer;
    VWMCount : integer;
    VWMIndex : integer;
    mInterface : ISharpBarModule;
    procedure LoadSettings;
    procedure ReAlignComponents(BroadCast : boolean = True);
    procedure UpdateSize;
    procedure DrawVWMToForm;
    procedure DrawVWM;
    procedure UpdateVWMSettings;
    procedure UpdateColors;
  end;

implementation

uses JclSimpleXML,
     SharpGraphicsUtils,
     uSharpXMLUtils;

{$R *.dfm}

procedure TMainForm.LoadSettings;
var
  XML : TJclSimpleXML;
begin
  sBackgroundColor := clWhite;
  sBackgroundColorSetting := 'clWhite';
  sBackgroundAlpha := 128;
  sBorderColor := clBlack;
  sBorderColorSetting := 'clBlack';
  sBorderAlpha := 128;
  sForegroundColor := clBlack;
  sForegroundColorSetting := 'clBlack';
  sForegroundAlpha := 64;
  sVWMSpacing := 1;
  sHighlightColor := sBackgroundColor;
  sHighlightColorSetting  := 'clBlack';
  sHighlightAlpha := 192;
  sTextColor := clBlack;
  sTextColorSetting := 'clBlack';
  sTextAlpha := 255;
  sDisplayVWMNumbers := True;

  XML := TJclSimpleXML.Create;
  if LoadXMLFromSharedFile(XML,mInterface.BarInterface.GetModuleXMLFile(mInterface.ID),True) then
    with XML.Root.Items do
    begin
      sDisplayVWMNumbers := BoolValue('Numbers',sDisplayVWMNumbers);
      sBackgroundColorSetting   := Value('Background',IntToStr(sBackgroundColor));
      sBorderColorSetting       := Value('Border',IntToStr(sBorderColor));
      sForegroundColorSetting   := Value('Foreground',IntToStr(sForegroundColor));
      sHighlightColorSetting    := Value('Highlight',IntToStr(sHighlightColor));
      sTextColorSetting         := Value('Text',IntToStr(sTextColor));
      sBackgroundAlpha := IntValue('BackgroundAlpha',sBackgroundAlpha);
      sBorderAlpha     := IntValue('BorderAlpha',sBorderAlpha);
      sForegroundAlpha := IntValue('ForegroundAlpha',sForegroundAlpha);
      sHighlightAlpha  := IntValue('HighlightAlpha',sHighlightAlpha);
      sTextAlpha       := IntValue('TextAlpha',sTextAlpha);
    end;
    
  UpdateColors;
  XML.Free;
end;

procedure TMainForm.UpdateColors;
var
  Theme : ISharpETheme;
begin
  Theme := GetCurrentTheme;
  with Theme.Scheme do
  begin
    sBackgroundColor := ParseColor(sBackgroundColorSetting);
    sBorderColor     := ParseColor(sBorderColorSetting);
    sForegroundColor := ParseColor(sForegroundColorSetting);
    sHighlightColor  := ParseColor(sHighlightColorSetting);
    sTextColor       := ParseColor(sTextColorSetting);
  end;
end;

procedure TMainForm.UpdateVWMSettings;
begin
  VWMFunctions.VWMMoveToolWindows := GetVWMMoveToolWindows;
  VWMCount := GetVWMCount;
  VWMIndex := GetCurrentVWM;
  VWMHeight := Height - 2 - mInterface.SkinInterface.SkinManager.Skin.Bar.NCYOffset.X
               - mInterface.SkinInterface.SkinManager.Skin.Bar.NCYOffset.Y;
//  VWMWidth := round(VWMHeight / MonList.PrimaryMonitor.Height * MonList.PrimaryMonitor.Width);
  VWMWidth := round(VWMHeight / MonList.DesktopHeight * MonList.DesktopWidth);
end;

procedure TMainForm.WMShellMessage(var msg: TMessage);
begin
  msg.Result := 0;

  if VWMCount = 0 then
    exit;

  if msg.LParam = Integer(self.Handle) then exit;
  case msg.WParam of
   HSHELL_WINDOWCREATED,HSHELL_WINDOWDESTROYED,HSHELL_GETMINRECT,
   HSHELL_REDRAW,HSHELL_REDRAW + 32768,HSHELL_WINDOWACTIVATED,
   HSHELL_WINDOWACTIVATED + 32768:
   begin
     DrawVWM;
     DrawVWMToForm;
   end;
  end;
end;

procedure TMainForm.UpdateSize;
begin
  UpdateVWMSettings;
  DrawVWM;
  DrawVWMToForm;
end;

procedure TMainForm.UpdateTimerTimer(Sender: TObject);
begin
  DrawVWM;
  DrawVWMToForm;
end;

procedure TMainForm.ReAlignComponents(BroadCast : boolean);
var
  newWidth : integer;
begin
  // The caption of the module is the description in the module manager!
  UpdateVWMSettings;
  self.Caption := 'VWM' ;

  newWidth := (VWMWidth + 2) * VWMCount + Max(0,(VWMCount - 1)) * sVWMSpacing;
  DrawVWM;

  mInterface.MinSize := NewWidth;
  mInterface.MaxSize := NewWidth;
  if newWidth <> Width then
    mInterface.BarInterface.UpdateModuleSize;
end;

procedure TMainForm.DrawVWM;
var
  n,i,k : integer;
  VWMArea : TRect;
  wndlist,dlist : TWndArray;
  wndrect : TRect;
  scale : double;
  wndbmp : TBitmap32;
  index : integer;
  DstRect,SrcRect : TRect;
  c : TColor32;
  smod : integer;
  w,h : integer;
  tw,th : integer;
  found : boolean;
begin
  if VWMCount = 0 then
  begin
    VWM.SetSize(0,0);
    exit;
  end;

  VWM.SetSize((VWMWidth + 2) * VWMCount + Max(0,(VWMCount - 1)) * sVWMSpacing, VWMHeight + 2);
  VWM.Clear(color32(0,0,0,0));

  scale := VWMHeight / MonList.DesktopHeight;             

  wndbmp := TBitmap32.Create;
  wndbmp.DrawMode := dmBlend;
  wndbmp.CombineMode := cmMerge;
  wndbmp.SetSize((VWMCount + 1) * VWMWidth + VWMSpacing * Max(0,VWMCount - 1),VWMHeight);
  wndbmp.Clear(color32(0,0,0,0));

  setlength(dlist,0);
  for n := - 1 to VWMCount - 1 do
  begin
    if n = - 1 then
      index := VWMIndex - 1
    else index := n;
    VWMArea := VWMGetDeskArea(VWMIndex,index);
    wndlist := VWMGetWindowList(VWMArea);

    smod := index + 1;
    for i := High(wndlist) downto 0 do
    begin
      found := False;
      for k := 0 to High(dlist) do
        if dlist[k] = wndlist[i] then
        begin
          found := True;
          break;
        end;
      if not found then
      begin
        GetWindowRect(wndlist[i],wndrect);
        w := wndRect.Right - wndRect.Left;
        h := wndRect.Bottom - wndRect.Top;
        if (w < 50) or (h < 50) then
          continue;

        setlength(dlist,length(dlist) + 1);
        dlist[High(dlist)] := wndlist[i];

        if index + 1 = VWMIndex then
          wndrect.Left := (index + 1)*VWMWidth + round((wndRect.Left - MonList.DesktopLeft) * scale)
        else
        wndrect.Left := smod*VWMWidth + round((wndRect.Left - MonList.DesktopLeft - (smod) * (MonList.DesktopWidth + VWMWidth)) * scale);
        wndrect.Top := Max(0,round((wndrect.Top + MonList.DesktopTop) * scale));
        wndrect.Right := wndrect.Left + Min(VWMWidth,round(w * scale));
        wndrect.Bottom := Min(wndbmp.Height,round((wndrect.Bottom + MonList.DesktopTop) * scale));
        c := ColorToColor32Alpha(sBackgroundColor,sForegroundAlpha);
        if n + 1 = VWMIndex then
          c := LightenColor32(c,64);

        // a bug in the asm code of gr32 makes this try/except block necessary
        // otherwise rare and random Access Violation on 64 bit systems
        try
          wndbmp.FillRect(wndrect.Left,wndrect.Top,wndrect.Right,wndrect.Bottom,c);
        except
        end;
        
        c := ColorToColor32Alpha(sForegroundColor,sForegroundAlpha);
        if n + 1 = VWMIndex then
          c := LightenColor32(c,64);

        // a bug in the asm code of gr32 makes this try/except block necessary
        // otherwise rare and random Access Violation on 64 bit systems
        try
          wndbmp.FillRect(wndrect.Left + 1 ,wndrect.Top + 1,wndrect.Right - 1,wndrect.Bottom - 1,c);
        except        
        end;
      end;
    end;
  end;

  for n := 0 to VWMCount - 1 do
  begin
    c := ColorToColor32Alpha(sBorderColor,sBorderAlpha);
    if n + 1 = VWMIndex then
      c := LightenColor32(c,32);

    // a bug in the asm code of gr32 makes this try/except block necessary
    // otherwise rare and random Access Violation on 64 bit systems  
    try      
      VWM.FrameRectTS(n * (VWMWidth + 2) + n * sVWMSpacing,
                     0,
                     (n+1)*(VWMWidth + 2) + n * sVWMSpacing,
                     VWMHeight + 2,
                     c);
    except
    end;

    DstRect.Left := n * (VWMWidth  + 2 ) + 1 + n * sVWMSpacing;
    DstRect.Top := 1;
    DstRect.Right := (n+1) * (VWMWidth + 2) - 1 + n * sVWMSpacing;
    DstRect.Bottom := VWMHeight + 2 - 1;

    c := ColorToColor32Alpha(sBackgroundColor,sBackgroundAlpha);
    if n + 1 = VWMIndex then
      c := ColorToColor32Alpha(sHighlightColor,sHighlightAlpha);

    // a bug in the asm code of gr32 makes this try/except block necessary
    // otherwise rare and random Access Violation on 64 bit systems      
    try
      VWM.FillRectTS(DstRect.Left,DstRect.Top,DstRect.Right,DstRect.Bottom,c);
    except
    end;
    
    index := n + 1;
    index := index + 1;
    SrcRect.Left := VWMWidth * (index - 1) ;//round((MonList.DesktopWidth * (index - 1) + Max(0,index - 2) * VWMSpacing) * scale);
    SrcRect.Right := VWMWidth * (index) ;//;round((MonList.DesktopWidth * (index)) * scale);
    SrcRect.Top := 0;
    SrcRect.Bottom := wndbmp.Height;
    wndbmp.DrawTo(VWM,DstRect.Left,DstRect.Top,SrcRect);

    if sDisplayVWMNumbers then
    begin
      tw := VWM.TextWidth(inttostr(n+1));
      th := VWM.TextHeight('1');      
      c := ColorToColor32Alpha(sTextColor,sTextAlpha);
      if n + 1 = VWMIndex then
        c := LightenColor32(c,64);
      VWM.RenderText(DstRect.Right - tw - 2,DstRect.Bottom - th - 1,inttostr(n+1),0,c);
    end;
  end;
  wndbmp.Free;
end;

procedure TMainForm.DrawVWMToForm;
var
  tmp : TBitmap32;
begin
  tmp := TBitmap32.Create;
  tmp.assign(mInterface.Background);
  VWM.DrawTo(tmp,0,mInterface.SkinInterface.SkinManager.Skin.Bar.NCYOffset.X);
  tmp.DrawTo(Canvas.Handle,0,0);
  tmp.Free;
end;

procedure TMainForm.FormClick(Sender: TObject);
var
  NewDesk : integer;
  p : TPoint;
  n : integer;
begin
  if VWMCount = 0 then
    exit;

  NewDesk := 0;
  p := ScreenToClient(Mouse.CursorPos);
  for n := 0 to VWMCount do
    if p.x < (n * (VWMWidth + 2) + n * sVWMSpacing) then
    begin
      NewDesk := n;
      break;
    end;

  NewDesk := Min(NewDesk,VWMCount);

  if NewDesk = VWMIndex then
    exit;

  if SharpApi.SwitchToVWM(NewDesk) then
  begin
    UpdateVWMSettings;
    DrawVWM;
    DrawVWMToForm;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;

  VWM := TBitmap32.Create;
  VWM.SetSize(0,0);
  VWM.DrawMode := dmBlend;
  VWM.CombineMode := cmMerge;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  VWM.Free;

  SharpApi.UnRegisterShellHookReceiver(Handle);
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  DrawVWMToForm;
end;

begin
end.
