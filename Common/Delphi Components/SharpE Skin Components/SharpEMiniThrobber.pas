{
Source Name: SharpEMiniThrobber
Description: SharpE component for SharpE
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

unit SharpEMiniThrobber;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  gr32,
  ISharpEskinComponents,
  SharpEBase,
  SharpEBaseControls,
  SharpEDefault,
  math;

type
  TSharpEMiniThrobber = class(TCustomSharpEGraphicControl)
  private
    FCancel: Boolean;
    FAutoPosition: Boolean;
    FBottom : Boolean;
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure SetAutoPosition(const Value: boolean);
    procedure SetBottom(const Value: boolean);
  protected
    procedure DrawDefaultSkin(bmp: TBitmap32; Scheme: ISharpEScheme); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure SMouseEnter; override;
    procedure SMouseLeave; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DrawManagedSkin(bmp: TBitmap32; Scheme: ISharpEScheme); override;
  published
    property Anchors;
    property Cancel: Boolean read FCancel write FCancel default False;
    property Constraints;
    property ParentShowHint;
    property ShowHint;
    property SkinManager;
    property AutoSize;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseEnter;
    property OnMouseLeave;
    property Bottom : Boolean read FBottom write SetBottom;
    property AutoPosition: Boolean read FAutoPosition write SetAutoPosition;
  end;

implementation

constructor TSharpEMiniThrobber.Create;
begin
  inherited Create(AOwner);
  Width := 7;
  Height := 9;
  FAutoPosition := True;
  FAutoSize := True;
end;

procedure TSharpEMiniThrobber.CNCommand(var Message: TWMCommand);
begin
  if Message.NotifyCode = BN_CLICKED then
    Click;
end;

procedure TSharpEMiniThrobber.CMDialogKey(var Message: TCMDialogKey);
begin
  inherited;
end;

procedure TSharpEMiniThrobber.CMDialogChar(var Message: TCMDialogChar);
begin
  inherited;
end;

procedure TSharpEMiniThrobber.CMFocusChanged(var Message: TCMFocusChanged);
begin
  inherited;
end;

procedure TSharpEMiniThrobber.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  UpdateSkin;
end;

procedure TSharpEMiniThrobber.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  UpdateSkin;
end;

procedure TSharpEMiniThrobber.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  inherited;
end;

procedure TSharpEMiniThrobber.SMouseEnter;
begin
  UpdateSkin;
end;

procedure TSharpEMiniThrobber.SMouseLeave;
begin
  UpdateSkin;
end;

procedure TSharpEMiniThrobber.SetBottom(const Value: boolean);
begin
  if FBottom <> Value then
  begin
    FBottom := Value;
    UpdateSkin;
  end;
end;

procedure TSharpEMiniThrobber.SetAutoPosition(const Value: boolean);
begin
  if FAutoPosition <> Value then
  begin
    FAutoPosition := Value;
    UpdateSkin;
  end;
end;

procedure TSharpEMiniThrobber.DrawDefaultSkin(bmp: TBitmap32; Scheme: ISharpEScheme);
var
  r: TRect;
begin
  if FAutoSize then
  begin
    if (Width<>7) or (height<>9) then
    begin
      width := 7;
      height := 9;
      exit;
    end;
  end;
  if FAutoPosition then
     if Top <> 3 then
        Top := 3;
  with bmp do
  begin
    Clear(color32(0, 0, 0, 0));
    AssignDefaultFontTo(Font);
    DrawMode := dmBlend;
    r := Rect(0, 0, Width, Height);
    if true then
    begin
      FrameRectS(0, 0, Width, Height, color32(clblack));
      Inc(r.Left); Inc(r.Top); Dec(r.Bottom); Dec(r.Right);
    end;
    if FButtonDown then
    begin
      FrameRectS(r.Left, r.Top, r.Right, r.Bottom,
        setalpha(color32(Scheme.GetColorByName('ThrobberLight')), 255));
      FrameRectS(r.Left, r.Top, r.Right - 1, r.Bottom - 1,
        setalpha(color32(Scheme.GetColorByName('ThrobberDark')), 255));
    end
    else
    begin
      FrameRectS(r.Left, r.Top, r.Right, r.Bottom,
        setalpha(color32(Scheme.GetColorByName('Throbberdark')), 255));
      FrameRectS(r.Left, r.Top, r.Right - 1, r.Bottom - 1,
        setalpha(color32(Scheme.GetColorByName('ThrobberLight')), 255));
    end;
    FillRect(r.Left + 1, r.Top + 1, r.Right - 1, r.Bottom - 1,
      setalpha(color32(Scheme.GetColorByName('ThrobberBack')), 255));
  end;
end;

procedure TSharpEMiniThrobber.DrawManagedSkin(bmp: TBitmap32; Scheme: ISharpEScheme);
var
  r, CompRect: TRect;
begin
  if not assigned(FManager) then
  begin
    DrawDefaultSkin(bmp,Scheme);
    exit;
  end;

  CompRect := Rect(0, 0, width, height);
  if FAutoSize then
  begin
    r := FManager.Skin.MiniThrobber.GetAutoDim(CompRect);
    if (r.Right <> width) or (r.Bottom <> height) then
    begin
      width := r.Right;
      height := r.Bottom;
      Exit;
    end;
  end;

  if FAutoPosition then
  begin
    if FBottom then
    begin
      if top <> FManager.Skin.MiniThrobber.BottomLocation.Y then
        top := FManager.Skin.MiniThrobber.BottomLocation.Y
    end else begin
       if top <> FManager.Skin.MiniThrobber.Location.Y then
         top := FManager.Skin.MiniThrobber.Location.Y;
    end;
  end;

  if FManager.Skin.MiniThrobber.Valid then
  begin
    FSkin.Clear(Color32(0, 0, 0, 0));
    if FButtonDown and not (FManager.Skin.MiniThrobber.Down.Empty) then
    begin
      FManager.Skin.MiniThrobber.Down.DrawTo(bmp, Scheme);
    end
    else
      if FButtonOver and not (FManager.Skin.MiniThrobber.Hover.Empty) then
      begin
        FManager.Skin.MiniThrobber.Hover.DrawTo(bmp, Scheme);
      end
      else
      begin
        FManager.Skin.MiniThrobber.Normal.DrawTo(bmp, Scheme);
      end;
  end
  else
    DrawDefaultSkin(bmp, DefaultSharpEScheme);
end;

end.
