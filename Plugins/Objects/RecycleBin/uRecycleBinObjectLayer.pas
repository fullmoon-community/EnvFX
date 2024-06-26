{
Source Name: uRecycleBinObjectLayer.pas
Description: RecycleBin object layer class
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

unit uRecycleBinObjectLayer;

interface
uses
  Windows, StdCtrls, Forms,Classes, Controls, ExtCtrls, Dialogs,Math,
  Messages, SharpApi, SysUtils,ShellApi, Graphics,
  gr32,GR32_Image, GR32_Layers, GR32_BLEND,GR32_Transforms, GR32_Filters,
  JvSimpleXML, SharpDeskApi, JclShell, Types,
  RecycleBinObjectXMLSettings,
  uSharpDeskDebugging,
  uSharpDeskFunctions,
  uSharpDeskObjectSettings,
  SharpGraphicsUtils,
  SharpThemeApiEx,
  uISharpETheme,
  uThemeConsts,
  SharpIconUtils,
  GR32_Resamplers;

type
   TColorRec = packed record
                 b,g,r,a: Byte;
               end;
  TColorArray = array[0..MaxInt div SizeOf(TColorRec)-1] of TColorRec;
  PColorArray = ^TColorArray;

  PSHQueryRBInfo = ^TSHQueryRBInfo;
  TSHQUERYRBINFO = packed record
     cbSize : DWord;
     i64Size : Int64;
     i64NumItems : Int64;
  end;

  TRecycleBinLayer = class(TBitmapLayer)
  private
    FIconEmpty       : TBitmap32;
    FIconFull        : TBitmap32;
    FPicture         : TBitmap32;
    FBinSize         : extended;
    FBinShowSize     : extended;
    FBinExt          : string;
    FBinItems        : integer;
    FBinTimer        : TTimer;
    FFontSettings    : TDeskFont;
    FIconSettings    : TDeskIcon;
    FCaptionSettings : TDeskCaption;
    FSettings        : TRecycleXMLSettings;
    FHLTimer         : TTimer;
    FHLTimerI        : integer;
    FAnimSteps       : integer;
    FObjectID        : integer;
    FScale           : integer;
    FLocked          : Boolean;

    FDllHandle       : THandle;
    SHEmptyRecycleBin : function (hWnd: HWND; pszRootPath: PChar; dwFlags: DWORD): HResult; stdcall;
    SHQueryRecycleBin : function (pszRootPath: PChar; var pSHQueryRBInfo: TSHQueryRBInfo): HResult; stdcall;

  protected
  public
     FParentImage : Timage32;
     procedure DoubleClick;
     procedure StartHL;
     procedure EndHL;
     procedure DrawBitmap;
     procedure LoadSettings;
     procedure GetRecycleBinStatus;
     procedure OnTimer(Sender: TObject);
     procedure OnBinTimer(Sender: TObject);
     procedure OnPropertiesClick(Sender : TObject);
     procedure OnOpenClick(Sender : TObject);
     procedure OnEmptyBinClick(Sender : TObject);
     constructor Create( ParentImage:Timage32; Id : integer); reintroduce;
     destructor Destroy; override;
     property ObjectId  : Integer read FObjectId  write FObjectId;
     property Locked    : boolean read FLocked    write FLocked;
     property Settings  : TRecycleXMLSettings read FSettings;
     property BinItems  : integer read FBinItems;
  private
  end;

implementation

procedure TRecycleBinLayer.OnEmptyBinClick(Sender : TObject);
begin
  try
    if @SHEmptyRecycleBin = nil then exit;
    SHEmptyRecycleBin(Application.Handle, nil, 0);
    GetRecycleBinStatus;
    DrawBitmap;
  except
    on E: Exception do
    begin
      SharpApi.SendDebugMessageEx('RecycleBin.Object',PChar('Error in OnEmptyBinClick'),0,DMT_Error);
      SharpApi.SendDebugMessageEx('RecycleBin.Object',PChar(E.Message),clred, DMT_ERROR);
    end;
  end;
end;

procedure TRecycleBinLayer.OnOpenClick(Sender : TObject);
begin
  DoubleClick;
end;

procedure TRecycleBinLayer.DoubleClick;
begin
  SharpExecute(FSettings.Target);
end;

procedure TRecycleBinLayer.OnPropertiesClick(Sender : TObject);
begin
  DisplayPropDialog(Application.Handle,FSettings.Target);
end;

procedure TRecycleBinLayer.OnBinTimer(Sender: TObject);
var
 oldSize  : extended;
 oldItems : integer;
begin
  oldSize := FBinSize;
  oldItems := FBinItems;
  GetRecycleBinStatus;
  if (oldSize <> FBinSize) or (oldItems <> FBinItems) then
     DrawBitmap;
end;

procedure TRecycleBinLayer.GetRecycleBinStatus;
var
  rbinfo : TSHQUERYRBINFO;
begin
  if @SHQueryRecycleBin = nil then exit;
  rbinfo.cbSize := sizeof(TSHQUERYRBINFO);
  rbinfo.i64Size := 0;
  rbinfo.i64NumItems := 0;
  if SHQueryRecycleBin(nil,rbinfo) = S_OK then
  begin
    FBinSize := rbinfo.i64Size;

    if FBinSize < 1024 then
    begin
      FBinShowSize := FBinSize;
      if FBinSize = 1 then
        FBinExt := 'Byte'
      else
        FBinExt := 'Bytes';
    end else if FBinSize < 1024 * 1024 then
    begin
      FBinShowSize := FBinSize / 1024;
      FBinExt := 'KB';
    end else if FBinSize < 1024 * 1024 * 1024 then
    begin
      FBinShowSize := FBinSize / 1024 / 1024;
      FBinExt := 'MB';
    end else
    begin
      FBinShowSize := FBinSize / 1024 / 1024 / 1024;
      FBinExt := 'GB';
    end;

    FBinItems := Rbinfo.i64NumItems;
    if FBinItems = 0 then
    begin
      FPicture := FIconEmpty;
    end else
    begin
      FPicture := FIconFull;
    end;
  end;
end;

procedure TRecycleBinLayer.StartHL;
begin
  if GetCurrentTheme.Desktop.Animation.UseAnimations then
  begin
    FHLTimerI := 1;
    FHLTimer.Enabled := True;
  end else
  begin
    DrawBitmap;
    LightenBitmap(Bitmap,50);
  end;
end;

procedure TRecycleBinLayer.EndHL;
begin
  if GetCurrentTheme.Desktop.Animation.UseAnimations then
  begin
    FHLTimerI := -1;
    FHLTimer.Enabled := True;
  end else
  begin
    DrawBitmap;
  end;
end;

procedure TRecycleBinLayer.OnTimer(Sender: TObject);
var
  i : integer;
  Theme : ISharpETheme;
begin
  FParentImage.BeginUpdate;
  BeginUpdate;
  FHLTimer.Tag := FHLTimer.Tag + FHLTimerI;
  if FHLTimer.Tag <= 0 then
  begin
    FHLTimer.Enabled := False;
    FHLTimer.Tag := 0;
    FScale := 100;

    i := 255;
    Bitmap.MasterAlpha := i;
    
    DrawBitmap;
    FParentImage.EndUpdate;
    EndUpdate;
    Changed;
    exit;
  end;

  Theme := GetCurrentTheme;
  if Theme.Desktop.Animation.Scale then
    FScale := round(100 + ((Theme.Desktop.Animation.ScaleValue)/FAnimSteps)*FHLTimer.Tag);
  if Theme.Desktop.Animation.Alpha then
  begin
    FScale := 100;

    i := 255;
    i := i + round(((Theme.Desktop.Animation.AlphaValue/FAnimSteps)*FHLTimer.Tag));
    if i > 255 then
      i := 255
    else if i < 32 then
      i := 32;
      
    Bitmap.MasterAlpha := i;
  end;
  if FHLTimer.Tag >= FAnimSteps then
  begin
    FHLTimer.Enabled := False;
    FHLTimer.Tag := FAnimSteps;
  end;
  DrawBitmap;
  if Theme.Desktop.Animation.Brightness then
     LightenBitmap(Bitmap,round(FHLTimer.Tag*(Theme.Desktop.Animation.BrightnessValue/FAnimSteps)));
  if Theme.Desktop.Animation.Blend then
     BlendImageA(Bitmap,
                 Theme.Desktop.Animation.BlendColor,
                 round(FHLTimer.Tag*(Theme.Desktop.Animation.BlendValue/FAnimSteps)));
  FParentImage.EndUpdate;
  EndUpdate;
  Changed;
end;

procedure TRecycleBinLayer.DrawBitmap;
var
   R : TFloatrect;
   w,h : integer;
   TempBitmap : TBitmap32;
begin
  FParentImage.BeginUpdate;
  BeginUpdate;

  if FSettings.ShowData then
  begin
    FCaptionSettings.Caption.Delete(FCaptionSettings.Caption.Count-1);
    FCaptionSettings.Caption.Delete(FCaptionSettings.Caption.Count-1);
    FCaptionSettings.Caption.Add('Size : '+FloatToStrF(FBinShowSize,ffFixed,6,2)+' '+FBinExt);
    FCaptionSettings.Caption.Add('Items : '+inttostr(FBinItems));
  end;

  FIconSettings.Icon := FPicture;

  TempBitmap := TBitmap32.Create;
  TempBitmap.DrawMode := dmBlend;
  TempBitmap.CombineMode := cmMerge;
  SharpDeskApi.RenderObject(TempBitmap,
                            FIconSettings,
                            FFontSettings,
                            FCaptionSettings,
                            Point(0,0),
                            Point(0,0));

  Bitmap.SetSize(TempBitmap.Width,TempBitmap.Height);
  Bitmap.Clear(color32(0,0,0,0));
  Bitmap.Draw(0,0,TempBitmap);

  TempBitmap.Free;

  if FLocked then
  begin
    w := (Bitmap.Width*FScale) div 100;
    h := (Bitmap.Height*FScale) div 100;
    TDraftResampler.Create(Bitmap);
  end else
  begin
    w := Bitmap.Width;
    h := Bitmap.Height;
  end;
  R := getadjustedlocation;
  if (w <> (R.Right-R.left)) then   //dont move image if resize
    R.Left := R.left + round(((R.Right-R.left)- w)/2);
  if (h <> (R.Bottom-R.Top)) then   //dont move image if resize
    R.Top := R.Top + round(((R.Bottom-R.Top)-h)/2);
  R.Right := r.Left + w;
  R.Bottom := r.Top + h;
  location := R;

  Bitmap.DrawMode := dmBlend;

  FParentImage.EndUpdate;
  EndUpdate;
  changed;
end;

procedure TRecycleBinLayer.LoadSettings;
var
  bmp : TBitmap32;
  ITheme : ISharpETheme;
begin
  if ObjectID=0 then exit;

  FSettings.LoadSettings;

  ITheme := GetCurrentTheme;
  with FSettings do
  begin
    FFontSettings.Name      := Theme[DS_FONTNAME].Value;
    FFontSettings.Size      := Theme[DS_TEXTSIZE].IntValue;
    FFontSettings.Color     := ITheme.Scheme.SchemeCodeToColor(Theme[DS_TEXTCOLOR].IntValue);
    FFontSettings.Bold      := Theme[DS_TEXTBOLD].BoolValue;
    FFontSettings.Italic    := Theme[DS_TEXTITALIC].BoolValue;
    FFontSettings.Underline := Theme[DS_TEXTUNDERLINE].BoolValue;
    FFontSettings.ClearType   := Theme[DS_TEXTCLEARTYPE].BoolValue;
    FFontSettings.ShadowColor      := ITheme.Scheme.SchemeCodeToColor(Theme[DS_TEXTSHADOWCOLOR].IntValue);
    FFontSettings.ShadowAlphaValue := Theme[DS_TEXTSHADOWALPHA].IntValue;
    FFontSettings.Shadow           := Theme[DS_TEXTSHADOW].BoolValue;
    FFontSettings.TextAlpha        := Theme[DS_TEXTALPHA].BoolValue;
    FFontSettings.Alpha            := Theme[DS_TEXTALPHAVALUE].IntValue;
    FFontSettings.ShadowType       := Theme[DS_TEXTSHADOWTYPE].IntValue;
    FFontSettings.ShadowSize       := Theme[DS_TEXTSHADOWSIZE].IntValue;

    FCaptionSettings.Caption.Clear;
    FCaptionSettings.Caption.Delimiter := ' ';
    
    if FSettings.MLineCaption then
      FCaptionSettings.Caption.DelimitedText := FSettings.Caption
    else if Length(Trim(FSettings.Caption)) > 0 then
      FCaptionSettings.Caption.Add(FSettings.Caption);

    if FSettings.ShowData then
    begin
      FCaptionSettings.Caption.Add('-');
      FCaptionSettings.Caption.Add('-');
    end;
    FCaptionSettings.Align := IntToTextAlign(FSettings.CaptionAlign);
    FCaptionSettings.Xoffset := 0;
    FCaptionSettings.Yoffset := 0;
    FCaptionSettings.Draw := ShowCaption;
    FCaptionSettings.LineSpace := 0;

    FIconSettings.Size  := 100;
    FIconSettings.Alpha := 255;
    if Theme[DS_ICONALPHABLEND].BoolValue then
      FIconSettings.Alpha := Theme[DS_ICONALPHA].IntValue;
    FIconSettings.XOffset     := 0;
    FIconSettings.YOffset     := 0;

    FIconSettings.Blend       := Theme[DS_ICONBLENDING].BoolValue;
    FIconSettings.BlendColor  := ITheme.Scheme.SchemeCodeToColor(Theme[DS_ICONBLENDCOLOR].IntValue);
    FIconSettings.BlendValue  := Theme[DS_ICONBLENDALPHA].IntValue;
    FIconSettings.Shadow      := Theme[DS_ICONSHADOW].BoolValue;
    FIconSettings.ShadowColor := ITheme.Scheme.SchemeCodeToColor(Theme[DS_ICONSHADOWCOLOR].IntValue);
    FIconSettings.ShadowAlpha := 255-Theme[DS_ICONSHADOWALPHA].IntValue;

    if Theme[DS_ICONSIZE].IntValue <= 8 then
       Theme[DS_ICONSIZE].IntValue:= 48;

    bmp := TBitmap32.Create;
    bmp.DrawMode := dmBlend;
    bmp.CombineMode := cmMerge;
    TLinearResampler.Create(bmp);

    IconStringToIcon(FSettings.Icon,FSettings.Target,Bmp,GetNearestIconSize(FSettings.Theme[DS_ICONSIZE].IntValue));
    FIconEmpty.SetSize(FSettings.Theme[DS_ICONSIZE].IntValue,FSettings.Theme[DS_ICONSIZE].IntValue);
    FIconEmpty.Clear(color32(0,0,0,0));
    bmp.DrawTo(FIconEmpty,Rect(0,0,FIconEmpty.Width,FIconEmpty.Height));

    IconStringToIcon(FSettings.Icon2,FSettings.Target,Bmp,GetNearestIconSize(FSettings.Theme[DS_ICONSIZE].IntValue));
    FIconFull.SetSize(FSettings.Theme[DS_ICONSIZE].IntValue,FSettings.Theme[DS_ICONSIZE].IntValue);
    FIconFull.Clear(color32(0,0,0,0));
    bmp.DrawTo(FIconFull,Rect(0,0,FIconFull.Width,FIconFull.Height));

    bmp.Free;

    Bitmap.MasterAlpha := 255;
  end;

  GetRecycleBinStatus;
  if FHLTimer.Tag >= FAnimSteps then
     FHLTimer.OnTimer(FHLTimer);
  DrawBitmap;
end;


constructor TRecycleBinLayer.Create( ParentImage:Timage32; Id : integer);

begin
  Inherited Create(ParentImage.Layers);

  try
    SharpApi.SendDebugMessage('RecycleBin.object','Loading shell32.dll',clblack);
    FDllhandle := LoadLibrary('shell32.dll');

    if FDllhandle <> 0 then
    begin
      SharpApi.SendDebugMessage('RecycleBin.object','SHEmptyRecycleBin := GetProcAddress(dllhandle, "SHEmptyRecycleBinA");',clblack);
      @SHEmptyRecycleBin := GetProcAddress(FDllhandle, 'SHEmptyRecycleBinA');
      SharpApi.SendDebugMessage('RecycleBin.object','SHQueryRecycleBin := GetProcAddress(dllhandle, "SHQueryRecycleBinA");',clblack);
      @SHQueryRecycleBin := GetProcAddress(FDllhandle, 'SHQueryRecycleBinA');
    end;

    if @SHEmptyRecycleBin = nil then
       SharpApi.SendDebugMessageEx('RecycleBin.object','Failed to get SHEmptyRecycleBin',clRed,DMT_ERROR);
    if @SHQueryRecycleBin = nil then
       SharpApi.SendDebugMessageEx('RecycleBin.object','Failed to get SHQueryRecycleBin',clRed,DMT_ERROR);
  except
    SharpApi.SendDebugMessageEx('RecycleBin.object','Failed to load shell32.dll',clRed,DMT_ERROR);
    try
      FreeLibrary(FDllhandle);
    finally
      FDllhandle := 0;
    end;
  end;

  FParentImage := ParentImage;
  Alphahit := False;
  FObjectId := id;
  scaled := false;
  FSettings := TRecycleXMLSettings.Create(FObjectId,nil,'RecycleBin');
  FHLTimer := TTimer.Create(nil);
  FHLTimer.Interval := 20;
  FHLTimer.Tag      := 0;
  FHLTimer.Enabled := False;
  FHLTimer.OnTimer := OnTimer;
  FAnimSteps       := 5;
  FScale           := 100;
  FCaptionSettings.Caption := TStringList.Create;
  FCaptionSettings.Caption.Clear;
  FIconEmpty := TBitmap32.Create;
  FIconFull := TBitmap32.Create;
  FBinTimer := TTimer.Create(nil);
  FBinTimer.Interval := 5000;
  FBinTimer.Enabled := True;
  FBinTimer.OnTimer := OnBinTimer;
  FPicture := FIconEmpty;
  FBinSize := -1;
  FBinItems := -1;
  FBinExt := '';
  LoadSettings;
end;

destructor TRecycleBinLayer.Destroy;
begin
  DebugFree(FIconEmpty);
  DebugFree(FIconFull);
  DebugFree(FBinTimer);
  DebugFree(FCaptionSettings.Caption);
  DebugFree(FSettings);
  FHLTimer.Enabled := False;
  DebugFree(FHLTimer);

  try
    FreeLibrary(FDllhandle);
  finally
    FDllhandle := 0;
  end;

  inherited Destroy;
end;

end.
