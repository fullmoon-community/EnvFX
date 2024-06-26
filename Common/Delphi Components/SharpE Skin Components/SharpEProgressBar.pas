{
Source Name: SharpEProgressBar
Description: Skinned ProgressBar component for SharpE
Copyright (C) Malx (Malx@techie.com)
              Martin Kr�mer (MartinKraemer@gmx.net)

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
unit SharpEProgressBar;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Controls,
  Forms,
  Types,
  StdCtrls,
  gr32,
  Graphics,
  ISharpESkinComponents,
  SharpEBaseControls,
  SharpEDefault,
  SharpTypes,
  math;

type
  TSharpEProgressBar = class(TCustomSharpEGraphicControl)
  private
    FMin: Integer;
    FMax: Integer;
    FValue: Integer;
    FAutoPos: TSharpEBarAutoPos;

    procedure SetMin(Value: integer);
    procedure SetMax(Value: integer);
    procedure SetValue(Value: integer);
    procedure SetAutoPos(Value: TSharpEBarAutoPos);
  protected
    procedure DrawDefaultSkin(bmp: TBitmap32; Scheme: ISharpEScheme); override;
    procedure DrawManagedSkin(bmp: TBitmap32; Scheme: ISharpEScheme); override;
  public
    constructor Create(AOwner: TComponent); override;

  published
    //property Align;
    property Anchors;
    property Min: integer read FMin write SetMin;
    property Max: integer read FMax write SetMax;
    property Value: integer read FValue write SetValue;
    property AutoPos: TSharpEBarAutoPos read FAutoPos write SetAutoPos;

    property Constraints;
    property Enabled;
    property ParentShowHint;
    property ShowHint;
    property SkinManager;
    property AutoSize;
    property Visible;

    property OnDblClick;
     { Published declarations }
  end;

implementation

constructor TSharpEProgressBar.Create;
begin
  inherited Create(AOwner);
  Min := 0;
  Max := 100;
  Value := 0;
  Width := 75;
  Height := 25;
  FAutoPos := apCenter;
end;

procedure TSharpEProgressBar.SetMin(Value: integer);
begin
  if Value <> FMin then
  begin
    FMin := Value;
    Invalidate;
  end;
end;

procedure TSharpEProgressBar.SetAutoPos(Value: TSharpEBarAutoPos);
begin
  if Value <> FAutoPos then
  begin
    FAutoPos := Value;
    Invalidate;
  end;
end;

procedure TSharpEProgressBar.SetMax(Value: integer);
begin
  if Value <> FMax then
  begin
    FMax := Value;
    Invalidate;
  end;
end;

procedure TSharpEProgressBar.SetValue(Value: integer);
begin
  if Value <> FValue then
  begin
    FValue := Value;
    Invalidate;
  end;
end;

procedure TSharpEProgressBar.DrawDefaultSkin(bmp: TBitmap32; Scheme: ISharpEScheme);
var
  r: TRect;
begin
  with bmp do
  begin
    Clear(color32(0, 0, 0, 0));
    DrawMode := dmBlend;
    r := Rect(0, 0, Width, Height);
    if true then
    begin
      FrameRectS(0, 0, Width, Height, color32(clblack));
      Inc(r.Left); Inc(r.Top); Dec(r.Bottom); Dec(r.Right);
    end;
    FrameRectS(r.Left, r.Top, r.Right, r.Bottom, color32(Scheme.GetColorByName('WorkArealight')));
    FrameRectS(r.Left, r.Top, r.Right - 1, r.Bottom - 1, color32(Scheme.GetColorByName('WorkAreadark')));
    FillRectS(r.Left + 1, r.Top + 1, r.Right - 1, r.Bottom - 1, color32(Scheme.GetColorByName('WorkAreaBack')));
    FillRectS(r.Left + 1, r.Top + 1, r.left + round((r.Right - r.Left - 2) *
              FValue / (FMax - FMin)), r.Bottom - 1, color32(Scheme.GetColorByName('ThrobberBack')));
  end;
end;

procedure TSharpEProgressBar.DrawManagedSkin(bmp: TBitmap32; Scheme: ISharpEScheme);
var
  r, CompRect: TRect;
  temp: TBitmap32;
  Mon : TMonitor;
  isBarBottom : boolean;
  p : TPoint;
begin
  if (Width = 0) or (Height = 0)  then
    exit;
    
  if (not assigned(FManager)) then
  begin
    DrawDefaultSkin(bmp, DefaultSharpEScheme);
    exit;
  end;

  temp := TBitmap32.create;
  try
    CompRect := Rect(0, 0, width, height);
    if FManager.Skin.ProgressBar.Valid then
    begin
      if FAutoSize or (FAutoPos <> apNone) then
      begin
        // check if the bar is aligned at the bottom, if so user alternative location
        Mon := nil;
        isBarBottom := False;        
        if (parent <> nil) then
          Mon := TForm(parent).Monitor;
        if Mon <> nil then
        begin
          p := ClientToScreen(Point(0,0));
          if p.y > Mon.Top + Mon.Height div 2 then
            isBarBottom := True;
        end;

        r := FManager.Skin.ProgressBar.GetAutoDim(CompRect,FAutoPos,isBarBottom);
        if (r.Right <> width) or (r.Bottom - r.Top <> height) or (r.Top <> top) then
        begin
          top := r.Top;
          width := r.Right;
          height := r.Bottom - r.Top;
          Exit;
        end;
      end;
      bmp.Clear(Color32(0, 0, 0, 0));
      if not (FManager.Skin.ProgressBar.BackGround.Empty) then
      begin
        if (not FManager.Skin.ProgressBar.BackgroundSmall.Empty) and
          (Bmp.Height <= FManager.Skin.ProgressBar.SmallModeOffset.Y) then
          FManager.Skin.ProgressBar.BackgroundSmall.DrawTo(bmp, Scheme)
        else
          FManager.Skin.ProgressBar.BackGround.DrawTo(bmp, Scheme);
      end;
      if not (FManager.Skin.ProgressBar.Progress.Empty) then
      begin
        if (not FManager.Skin.ProgressBar.ProgressSmall.Empty) and
           (Bmp.Height <= FManager.Skin.ProgressBar.SmallModeOffset.Y) then
           r := FManager.Skin.ProgressBar.ProgressSmall.GetDimRect(rect(0, 0, bmp.Width, bmp.Height))
        else r := FManager.Skin.ProgressBar.Progress.GetDimRect(rect(0, 0, bmp.width, bmp.height));
        if r.Right = 0 then
           r.right := bmp.Width - r.Left;
        if r.Bottom = 0 then
           r.Bottom := bmp.Height - r.Top;
        temp.Height := r.Bottom - r.Top;
        temp.Width := round((r.Right - r.Left) * FValue / (FMax - FMin)) + 1;
        if temp.Width <= 0 then
          temp.Width := 1;
        temp.Clear(Color32(0, 0, 0, 0));
        temp.DrawMode := dmBlend;
        temp.CombineMode := cmMerge;
        if (not FManager.Skin.ProgressBar.ProgressSmall.Empty) and
           (Bmp.Height <= FManager.Skin.ProgressBar.SmallModeOffset.Y) then
           FManager.Skin.ProgressBar.ProgressSmall.DrawTo(temp, Scheme)
        else FManager.Skin.ProgressBar.Progress.DrawTo(temp, Scheme);
        bmp.Draw(r.Left, r.Top, rect(0, 0, temp.Width, temp.Height), temp);
      end;
    end
    else
      DrawDefaultSkin(bmp, DefaultSharpEScheme);
  finally
    temp.free;
  end;
end;

end.
