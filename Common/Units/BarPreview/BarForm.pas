{
Source Name: BarForm.pas
Description: SharpSkin Bar Form
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
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit BarForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SharpEBaseControls, SharpEBar, SharpESkinManager, SharpEScheme,
  SharpTypes, SharpESkin, SharpEButton, GR32, SharpGraphicsUtils, ISharpESkinComponents;

type
  TBarWnd = class(TForm)
    Button: TSharpEButton;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure OnBackgroundPaint(Sender : TObject; Target : TBitmap32; x : integer);
  public
    Bar: TSharpEBar;
//    SkinManagerClass : TSharpESkinManager;
    SkinManager : ISharpESkinManager;
    SkinComp : TSharpESkin;
    Scheme : TSharpEScheme;
    Background : TBitmap32;
    procedure ApplyGlassEffect(GEBlurRadius,GEBlurIterations : integer; GEBlend : boolean;
                               GEBlendColor,GEBlendAlpha : integer; GELighten : boolean;
                               GELightenAmount : integer);
  end;

var
  BarWndUseMenu : boolean;

implementation

{$R *.dfm}

procedure TBarWnd.FormCreate(Sender: TObject);
begin
  Background := TBitmap32.Create;
  Background.SetSize(1,1);
  Background.Clear(color32(0,0,0,0));

  if BarWndUseMenu then
     SkinComp := TSharpESkin.Create([scBar,scButton,scMenu,scMenuItem])
     else SkinComp := TSharpESkin.Create([scBar,scButton]);

  Scheme := TSharpEScheme.Create;

  SkinManager := TSharpESkinManager.CreateRuntime(self,SkinComp,Scheme,True,[scBar,scButton]);

  Bar := TSharpEBar.CreateRuntime(self,SkinManager);
  Button.SkinManager := SkinManager;
  Bar.OnBackgroundPaint := OnBackgroundPaint;
end;

procedure TBarWnd.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Bar);
  SkinManager := nil;
  FreeAndNil(Background);
end;

procedure TBarWnd.OnBackgroundPaint(Sender : TObject; Target : TBitmap32; x : integer);
begin
  if Background <> nil then
     Background.DrawTo(Target);
end;

procedure TBarWnd.ApplyGlassEffect(GEBlurRadius,GEBlurIterations : integer; GEBlend : boolean;
                                   GEBlendColor,GEBlendAlpha : integer; GELighten : boolean;
                                   GELightenAmount : integer);
begin
  if SkinManager.Skin.Bar.GlassEffect then
  begin
    if GEBlend then
       BlendImageC(Background,GEBlendColor,GEBlendAlpha);
    fastblur(Background,GEBlurRadius,GEBlurIterations);
    if GELighten then
       lightenBitmap(Background,GELightenAmount);
  end;
end;

end.
