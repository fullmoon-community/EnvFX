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
}

unit BarForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SharpEBaseControls, SharpEBar;

type
  TBarWnd = class(TForm)
    procedure FormDeactivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    SharpEBar1: TSharpEBar;
  end;

var
  BarWnd: TBarWnd;

implementation

uses MainForm;

{$R *.dfm}

procedure TBarWnd.FormCreate(Sender: TObject);
begin
  SharpEBar1 := TSharpEBar.CreateRuntime(self,MainForm.SkinManager);
end;

procedure TBarWnd.FormDeactivate(Sender: TObject);
begin
  SharpEBar1.Free;
end;

end.
