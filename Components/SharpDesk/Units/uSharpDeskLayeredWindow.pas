{
Source Name: uSharpDeskLayeredWindow.pas
Description: layered window class
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

unit uSharpDeskLayeredWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  Types,
  GR32,GR32_Backends,
  SharpApi,
  SharpDeskApi;

type
  TSharpDeskLayeredWindow = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDblClick(Sender: TObject);
  private
    //FTerminate : boolean;
    DC: HDC;
    Blend: TBlendFunction;
    FPicture : TBitmap32;
    FDesktopObject : TObject;
    procedure UpdateWndLayer;
  protected
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure WMNCHitTest(var Message: TWMNCHitTest);
    procedure WMMouseMove(var Msg: TMessage); message WM_MOUSEMOVE;
    procedure WMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
  public
    procedure DrawWindow;
  published
    property Picture : TBitmap32 read FPicture write FPicture;
    property DesktopObject : TObject read FDesktopObject write FDesktopObject;
  end;

var
  SharpDeskLayeredWindow: TSharpDeskLayeredWindow;
  dbclick : boolean = False;
  ignorenext : boolean = False;

implementation

uses
  uSharpDeskDesktopObject,
  uSharpDeskMainForm,
  uSharpDeskFunctions;

{$R *.dfm}

procedure TSharpDeskLayeredWindow.WMMouseMove(var Msg: TMessage);
var
  pDesktopObject : TDesktopObject;
  CPos : TPoint;
  tme: TTRACKMOUSEEVENT;  
  TrackMouseEvent_: function(var EventTrack: TTrackMouseEvent): BOOL; stdcall; 
begin
  tme.cbSize := sizeof(TTRACKMOUSEEVENT);
  tme.dwFlags := TME_HOVER or TME_LEAVE;
  tme.dwHoverTime := 10;
  tme.hwndTrack := self.Handle;
  @TrackMouseEvent_:= @TrackMouseEvent; // nur eine Pointerzuweisung!!!
  TrackMouseEvent_(tme);

  pDesktopObject := TDesktopObject(FDesktopObject);
  pDesktopObject.DeskManager.LastLayer := Tag;
  if not pDesktopObject.Selected then
  begin
    SharpDesk.UnselectAll;
    pDesktopObject.Selected := True;
    pDesktopObject.Owner.DllSharpDeskMessage(pDesktopObject.Settings.ObjectID,
                                             pDesktopObject.Layer,
                                             SDM_MOUSE_ENTER,0,0,0);
   // self.DrawWindow;
  end;

  if not GetCursorPosSecure(CPos) then
    exit;
  
  CPos := SharpDesk.Image.ScreenToClient(CPos);
  pDesktopObject.Owner.DllSharpDeskMessage(pDesktopObject.Settings.ObjectID,
                                          pDesktopObject.Layer,
                                          SDM_MOUSE_MOVE,CPos.X,CPos.Y,0);
end;

procedure TSharpDeskLayeredWindow.WMMouseLeave(var Msg: TMessage);
var
  pDesktopObject : TDesktopObject;
begin
  if ignorenext then
  begin
    ignorenext := False;
    exit;
  end;

  pDesktopObject := TDesktopObject(FDesktopObject);
  if pDesktopObject = nil then exit;
  try
  //  if PointInRect(Mouse.CursorPos,self.BoundsRect) then exit;
    pDesktopObject.Owner.DllSharpDeskMessage(pDesktopObject.Settings.ObjectID,
                                             pDesktopObject.Layer,
                                             SDM_MOUSE_LEAVE,0,0,0);
  except
    on E: Exception do
    begin
      SharpApi.SendDebugMessageEx('SharpDesk',PChar('Error while sending SDM_MOUSE_LEAVE to ' + inttostr(pDesktopObject.Settings.ObjectID) + '('+pDesktopObject.Owner.FileName+')'), clred, DMT_ERROR);
      SharpApi.SendDebugMessageEx('SharpDesk',PChar(E.Message),clred, DMT_ERROR);
    end;
  end;

  pDesktopObject.Selected := False;
  SharpDesk.SelectionCount := 0;
end;

procedure TSharpDeskLayeredWindow.WMPaint(var Msg: TWMPaint);
begin
  inherited;
  Application.ProcessMessages;
end;

procedure TSharpDeskLayeredWindow.WMNCHitTest(var Message: TWMNCHitTest);
begin
  if PtInRect(ClientRect, ScreenToClient(Point(Message.XPos, Message.YPos))) then
     Message.Result := HTClient;
end;

procedure TSharpDeskLayeredWindow.DrawWindow;
begin
  UpdateWndLayer;
end;

procedure TSharpDeskLayeredWindow.FormCreate(Sender: TObject);
begin
  DC := 0;

  with Blend do
  begin
    BlendOp := AC_SRC_OVER;
    BlendFlags := 0;
    SourceConstantAlpha := 255;
    AlphaFormat := AC_SRC_ALPHA;
  end;

  SetWindowLong(Handle,GWL_EXSTYLE,WS_EX_TOOLWINDOW or WS_EX_TOPMOST);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
  SetWindowPos(Handle, HWND_TOPMOST, 0,0, 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
  SetWindowLong(Handle, GWL_HWNDPARENT, 0);
end;

procedure TSharpDeskLayeredWindow.UpdateWndLayer;
var
  TopLeft, BmpTopLeft: TPoint;
  BmpSize: TSize;
  Bmp : TBitmap32;
begin
  if (Width=0) or (Height=0) then exit;
  BmpSize.cx := Width;
  BmpSize.cy := Height;
  BmpTopLeft := Point(0, 0);
  TopLeft := BoundsRect.TopLeft;

  DC := GetDC(Handle);
  try
    {$WARNINGS OFF}
    if not Win32Check(LongBool(DC)) then
      RaiseLastWin32Error;

    Bmp := TBitmap32.Create;
    //bmp.SetSize(FPicture.Width,FPicture.Height);
    Bmp.SetSize(Width,Height);
    Bmp.Clear(color32(1,1,1,1));
    FPicture.DrawMode := dmBlend;    
    //Bmp.Draw(0,0,FPicture);
    FPicture.DrawTo(Bmp,Rect(0,0,self.Width,self.Height));
    if not Win32Check(UpdateLayeredWindow(Handle, DC, @TopLeft, @BmpSize,
      Bmp.Handle, @BmpTopLeft, clNone, @Blend, ULW_ALPHA)) then
      RaiseLastWin32Error;
    Bmp.Free;
  finally
    ReleaseDC(Handle, DC);
  end;
  {$WARNINGS ON}
end;

procedure TSharpDeskLayeredWindow.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  p : TPoint;
  pDesktopObject : TDesktopObject;
  CPos : TPoint;
begin
  if (not TDesktopObject(FDesktopObject).Settings.Locked) and (Button = mbLeft) and (not dbclick) then
  begin
    ReleaseCapture;
    Perform(WM_NCLBUTTONDOWN,HTCAPTION,0);
    pDesktopObject := TDesktopObject(FDesktopObject);
    pDesktopObject.DeskManager.LastLayer := Tag;
    if not GetCursorPosSecure(CPos) then
      exit;
    p := pDesktopObject.DeskManager.Image.ScreenToClient(CPos);
    pDesktopObject.DeskManager.MoveLayerTo(pDesktopObject,
                                           p.X-x - pDesktopObject.Layer.Bitmap.Width div 2,
                                           p.Y-y - pDesktopObject.Layer.Bitmap.Height div 2);
    pDesktopObject.Settings.Pos := Point(Left + round(Width / 2),Top + round(Height / 2));
  end else dbclick := False;
end;

procedure TSharpDeskLayeredWindow.FormMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  pDesktopObject : TDesktopObject;
  b : integer;
  cursorPos : TPoint;
begin
  if not GetCursorPosSecure(cursorPos) then
    exit;
  cursorPos := SharpDesk.Image.ScreenToClient(cursorPos);

  pDesktopObject := TDesktopObject(FDesktopObject);
  pDesktopObject.DeskManager.LastLayer := Tag;
  pDesktopObject.Selected := True;

  case Button of
   mbLeft   : B:=0;
   mbRight  : B:=1;
   mbMiddle : B:=2;
   else B:=0;
  end;
  try
    pDesktopObject.Owner.DllSharpDeskMessage(pDesktopObject.Settings.ObjectID,
                                             pDesktopObject.Layer,
                                             SDM_MOUSE_UP,cursorPos.X,cursorPos.Y,B);
  except
    on E: Exception do
    begin
      SharpApi.SendDebugMessageEx('SharpDesk',PChar('Error while sending SDM_MOUSE_UP to ' + inttostr(pDesktopObject.Settings.ObjectID) + '('+pDesktopObject.Owner.FileName+')'), clred, DMT_ERROR);
      SharpApi.SendDebugMessageEx('SharpDesk',PChar(E.Message),clred, DMT_ERROR);
    end;
  end;

  if Button = mbRight then
  with SharpDeskMainForm do
  begin
    ENDOFCUSTOMMENU.Visible := True;
    STARTOFBOTTOMMENU.Visible := True;

    while ObjectPopUp.Items[0].Name <> 'ENDOFCUSTOMMENU' do ObjectPopUp.Items.Delete(0);
    while ObjectPopUp.Items[ObjectPopUp.Items.Count-1].Name <> 'STARTOFBOTTOMMENU' do ObjectPopUp.Items.Delete(ObjectPopUp.Items.Count-1);
    while ObjectPopUp.Images.Count > ObjectPopUpImageCount do ObjectPopUp.Images.Delete(ObjectPopUpImageCount);
    try
      pDesktopObject.Owner.DllSharpDeskMessage(pDesktopObject.Settings.ObjectID,
                                               pDesktopObject.Layer,
                                               SDM_MENU_POPUP,cursorPos.X,cursorPos.Y,0);
      except
        on E: Exception do
        begin
         SharpApi.SendDebugMessageEx('SharpDesk',PChar('Error while sending SDM_MENU_POPUP to ' + inttostr(pDesktopObject.Settings.ObjectID) + '('+pDesktopObject.Owner.FileName+')'), clred, DMT_ERROR);
         SharpApi.SendDebugMessageEx('SharpDesk',PChar(E.Message),clred, DMT_ERROR);
        end;
      end;

      if ObjectPopUp.Items[0].Name = 'ENDOFCUSTOMMENU' then ObjectPopUp.Items[0].Visible := False
         else ObjectPopUp.Items[0].Visible := True;

      if ObjectPopUp.Items[ObjectPopUp.Items.Count-1].Name = 'STARTOFBOTTOMMENU' then ObjectPopUp.Items[ObjectPopUp.Items.Count-1].Visible := False
         else ObjectPopUp.Items[ObjectPopUp.Items.Count-1].Visible := True;

    if pDesktopObject.Settings.Locked then LockObjec1.ImageIndex:=4
       else LockObjec1.ImageIndex:=29;
    if pDesktopObject.Settings.isWindow then MakeWindow1.ImageIndex:=4
       else MakeWindow1.ImageIndex:=29;
    ignorenext := True;
    self.PopupMenu.Popup(cursorPos.X,cursorPos.y);
  end;
end;

procedure TSharpDeskLayeredWindow.FormDblClick(Sender: TObject);
var
  pDesktopObject : TDesktopObject;
  Cpos : TPoint;
begin
  dbclick := True;
  if not GetCursorPosSecure(CPos) then
    exit;
  CPos := SharpDesk.Image.ScreenToClient(CPos);
  pDesktopObject := TDesktopObject(FDesktopObject);
  pDesktopObject.Owner.DllSharpDeskMessage(pDesktopObject.Settings.ObjectID,
                                           pDesktopObject.Layer,
                                           SDM_DOUBLE_CLICK,
                                           CPos.X,CPos.Y,0);
end;

end.
