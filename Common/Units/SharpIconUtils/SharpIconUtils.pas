{
Source Name: SharpIconUtils.pas
Description: Icon related help Functions
Copyright (C) Malx <>
              Martin Kr�mer <MartinKraemer@gmx.net>

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

unit SharpIconUtils;

interface

uses Windows,
     Graphics,
     Controls,
     JclFileUtils,
     SysUtils,
     Classes,
     ShellApi,
     SharpAPI,
     SharpThemeApiEx,
     uThemeConsts,
     uISharpETheme,
     CommCtrl,
     Math,
     GR32,
     GR32_PNG,
     GR32_Filters,
     GR32_Resamplers,
     SharpFileUtils;

procedure IconToImage(Bmp : TBitmap32; const icon : hicon);
function extrShellIcon(Bmp : TBitmap32; FileName : String; Size : Integer = -1) : THandle;
function extrShellIconLarge(Bmp : TBitmap32; FileName : String; Size : Integer) : THandle;
function GetShellIconHandle(FileName : String) : THandle;
function LoadIco(Bmp : TBitmap32; IconFile : string; Size : integer) : boolean;
function LoadPng(Bmp : TBitmap32; PngFile:string) : boolean;
function IconStringToIcon(Icon,Target : String; Bmp : TBitmap32) : boolean; overload;
function IconStringToIcon(Icon,Target : String; Bmp : TBitmap32; Size : integer) : boolean; overload;
function GetNearestIconSize(Height : integer) : integer;
function CreateIconFromBitmap(Bitmap: TBitmap32; TransparentColor: TColor): TIcon;
function LoadIconFromPNG(outBitmap: TBitmap32; Dir, pngFile: String; Size: Integer): Boolean;

implementation

var
  ShellIconAccess : TRTLCriticalSection;


type
  TColorRec = packed record
                b,g,r,a: Byte;
              end;
  TColorArray = array[0..MaxInt div SizeOf(TColorRec)-1] of TColorRec;
  PColorArray = ^TColorArray;

procedure IconToImage(Bmp : TBitmap32; const icon : hicon);
var
   w,h,i    : Integer;
   p        : PColorArray;
   p2       : pColor32;
   bmi      : BITMAPINFO;
   AlphaBmp : Tbitmap32;
   tempbmp  : Tbitmap;
   info     : Ticoninfo;
   alphaUsed : boolean;
   b : boolean;
begin
     Alphabmp := nil;
     tempbmp := Tbitmap.Create;
//     dc := createcompatibledc(0);
     try
        //get info about icon
        b := GetIconInfo(icon,info);
        tempbmp.handle := info.hbmColor;
        ///////////////////////////////////////////////////////
        // Here comes a ugly step were it tries to paint it as
        // a 32 bit icon and check if it is successful.
        // If failed it will paint it as an icon with fewer colors.
        // No way of deciding bitcount in the beginning has been
        // found reliable , try if you want too.   /Malx
        ///////////////////////////////////////////////////////
        AlphaUsed := false;
        if true then
        begin //32-bit icon with alpha
              w := tempbmp.Width;
              h := tempbmp.Height;
              Bmp.setsize(w,h);
              with bmi.bmiHeader do
              begin
                   biSize := SizeOf(bmi.bmiHeader);
                   biWidth := w;
                   biHeight := -h;
                   biPlanes := 1;
                   biBitCount := 32;
                   biCompression := BI_RGB;
                   biSizeImage := 0;
                   biXPelsPerMeter := 1; //dont care
                   biYPelsPerMeter := 1; //dont care
                   biClrUsed := 0;
                   biClrImportant := 0;
              end;
              GetMem(p,w*h*SizeOf(TColorRec));
              GetDIBits(tempbmp.Canvas.Handle,tempbmp.Handle,0,h,p,bmi,DIB_RGB_COLORS);
              P2 := Bmp.PixelPtr[0, 0];
              for i := 0 to w*h-1 do
              begin
                   if (p[i].a > 0) then alphaused := true;
                   P2^ := color32(p[i].r,p[i].g,p[i].b,p[i].a);
                   Inc(P2);// proceed to the next pixel
              end;
              FreeMem(p);
        end;
        if not(alphaused) then
        begin // 24,16,8,4,2 bit icons
              Bmp.Assign(tempbmp);
              AlphaBmp := Tbitmap32.Create;
              tempbmp.handle := info.hbmMask;
              AlphaBmp.Assign(tempbmp);
              Invert(AlphaBmp,AlphaBmp);
              Intensitytoalpha(Bmp,AlphaBmp);
        end;
     finally
//            DeleteDC(dc);
            AlphaBmp.free;
            DeleteObject(info.hbmMask);
            DeleteObject(info.hbmColor);             
            tempbmp.free;
     end;
end;

function GetShellIconHandle(FileName : String) : THandle;
var
  FileInfo : SHFILEINFO;
  ImageListHandle : THandle;
begin
  ImageListHandle := SHGetFileInfo( pChar(FileName), 0, FileInfo, sizeof( SHFILEINFO ),
                                    SHGFI_ICON or SHGFI_SHELLICONSIZE);
  if FileInfo.hicon <> 0 then
     result := FileInfo.hicon
  else result := 0;
  DestroyIcon(FileInfo.hIcon);
  ImageList_Destroy(ImageListHandle);
end;

function ImageListExtraLarge: HIMAGELIST;
type
  TSHGetImageList = function (iImageList: integer; const riid: TGUID; var ppv: Pointer): hResult; stdcall;
var
  hInstShell32: THandle;
  SHGetImageList: TSHGetImageList;
const
  //SHIL_LARGE= 0;//32X32
  //SHIL_SMALL= 1;//16X16
  SHIL_EXTRALARGE= 2;
  IID_IImageList: TGUID= '{46EB5926-582E-4017-9FDF-E8998DAA0950}';
begin
  Result:= 0;
  hInstShell32:= LoadLibrary('Shell32.dll');
  if hInstShell32<> 0 then
  try
    SHGetImageList:= GetProcAddress(hInstShell32, PChar(727));
    if Assigned(SHGetImageList) and (Win32Platform = VER_PLATFORM_WIN32_NT) then
      SHGetImageList(SHIL_EXTRALARGE, IID_IImageList, pointer(Result));
  finally
    FreeLibrary(hInstShell32);
  end;
end;

{function ExpandEnvVars(const Str: string): string;
var
  BufSize: Integer; // size of expanded string
begin
  // Get required buffer size
  BufSize := ExpandEnvironmentStrings(PChar(Str), nil, 0);
  // Read expanded string into result string
  SetLength(Result, BufSize);
  ExpandEnvironmentStrings(PChar(Str), PChar(Result), BufSize);
end;       }

function ExpandEnvVars(const szInput: string): string;
const
  MAXSIZE = 32768;
begin
  SetLength(Result,MAXSIZE);
  SetLength(Result,ExpandEnvironmentStrings(pchar(szInput),@Result[1],length(Result)));
end;

function extrShellIconLarge(Bmp : TBitmap32; FileName : String; Size : Integer) : THandle;
var
  Icon : HIcon;
  hImgList: HIMAGELIST;
  FileInfo : SHFILEINFO;
begin
  if not FileExists(FileName) then
    FileName := ExpandEnvVars(FileName);

  hImgList:= ImageListExtraLarge;
  if hImgList <> 0 then
  begin
    SHGetFileInfo( pChar(FileName),0,FileInfo, sizeof( SHFILEINFO ),SHGFI_SYSICONINDEX);
    Icon := commctrl.ImageList_GetIcon(hImgList, FileInfo.iIcon, 0);
    result := Icon;
    try
      IconToImage(Bmp,Icon);
    finally
      DestroyIcon(Icon);
    end;
    ImageList_Destroy(hImgList);
  end else result := extrShellIcon(Bmp, FileName, 32);
end;

function extrShellIcon(Bmp : TBitmap32; FileName : String; Size : Integer = -1) : THandle;
var
  FileInfo : SHFILEINFO;
  ImageListHandle : THandle;
  Flag : DWord;
  Attr : integer;
  LinkPath : String;
begin
  if not FileExists(FileName) then
    FileName := ExpandEnvVars(FileName);
  FileName := Trim(FileName);

  if CompareText(ExtractFileExt(FileName),'.lnk') = 0 then
  begin
    // Resolve the shell link and get the path
    if GetFilePathFromLink(FileName,LinkPath) then
    begin
      // Expand all environmental vars (following checks will be performed on the full path)
      LinkPath := Trim(ExpandEnvVars(LinkPath));
      // Try to see if the path is valid for any x64 directory
      LinkPath := GetX64ValidPath(LinkPath);
      if FileExists(LinkPath) then
        FileName := LinkPath;
    end;
  end;

  if Size <= 16 then
    Flag := SHGFI_ICON or SHGFI_SMALLICON
  else if Size <= 32 then
    Flag := SHGFI_ICON or SHGFI_LARGEICON
  else
  begin
    result := extrShellIconLarge(Bmp,FileName,Size);
    exit;
  end;
  Flag := Flag or SHGFI_USEFILEATTRIBUTES;

  if isDirectory(FileName) then
    Attr := FILE_ATTRIBUTE_DIRECTORY
  else
    Attr := FILE_ATTRIBUTE_NORMAL;

  ImageListHandle := SHGetFileInfo(pChar(FileName),
                                   Attr,
                                   FileInfo, sizeof( SHFILEINFO ),
                                   Flag);
  if FileInfo.hicon <> 0 then
  begin
    try
      IconToImage(Bmp,FileInfo.hicon);
      result := FileInfo.hicon;
    finally
      DestroyIcon(FileInfo.hIcon);
      ImageList_Destroy(ImageListHandle);
    end;
  end else
  begin
    result := 0;
    Bmp.SetSize(16,16);
    Bmp.Clear(color32(64,64,64,64));
  end;
end;

function LoadIco(Bmp : TBitmap32; IconFile : string; Size : integer) : boolean;
var
  icon : Hicon;
begin
  icon := 0;
  if FileExists(IconFile) then
    icon := loadimage(0,pchar(IconFile),IMAGE_ICON,Size,Size,LR_DEFAULTSIZE or LR_LOADFROMFILE);
  if icon <> 0 then
  begin
    IconToImage(Bmp, icon);
    destroyicon(icon);
    result := True;
  end else
  begin
    result := False;
    Bmp.SetSize(Max(Size,1),Max(1,Size));
    Bmp.Clear(color32(clWindow));
  end;
end;

function LoadPng(Bmp : TBitmap32; PngFile:string) : boolean;
var
  b : boolean;
begin
  if not FileExists(PngFile) then
  begin
    result := False;
    Bmp.SetSize(100,100);
    Bmp.Clear(color32(64,64,64,64));
    exit;
  end;

  GR32_PNG.LoadBitmap32FromPNG(Bmp,PngFile,b);
  result := true;
end;

function IconStringToIcon(Icon,Target : String; Bmp : TBitmap32) : boolean;
begin
  result := IconStringToIcon(Icon,Target,Bmp,32);
end;

function IconStringToIcon(Icon,Target : String; Bmp : TBitmap32; Size : integer) : boolean;
var
  Theme : ISharpETheme;
  Ext : String;
begin
  Target := GetFileNameWithoutParams(Target);
  if CompareText(Icon,'shell:icon') = 0 then
  begin
    EnterCriticalSection(ShellIconAccess);
    result := (extrShellIcon(Bmp,Target,Size) <> 0);
    LeaveCriticalSection(ShellIconAccess);
  end else
  begin
    Theme := GetCurrentTheme;
    if Theme.Icons.IsIconInIconSet(Icon) then
    begin
      result := LoadPng(Bmp,Theme.Icons.GetIconFileSizedByTag(Icon,Size));
    end else
    begin
      if FileExists(Icon) then
      begin
        Ext := ExtractFileExt(Icon);
        if CompareText(Ext,'.png') = 0 then
           result := LoadPng(Bmp,Icon)
        else if CompareText(Ext,'.ico') = 0 then
           result := LoadIco(Bmp,Icon,GetNearestIconSize(Size))
        else result := False;
      end else result := False;
    end;
  end;
end;

function GetNearestIconSize(Height : integer) : integer;
begin
  if Height <= 16 then
    result := 16
//  else if Height <= 22 then
//    result := 22
  else if Height <= 32 then
    result := 32
//  else if Height <= 48 then
//    result := 48
//  else if Height <= 64 then
//    result := 64
  else if Height <= 128 then
    result := 128
//  else result := 256;
	else result := 128;
end;

function CreateIconFromBitmap(Bitmap: TBitmap32; TransparentColor: TColor): TIcon;
var
  bmp : TBitmap;
begin
  bmp := TBitmap.Create;

  try
    try
      bmp.Assign(Bitmap);
    
      with TImageList.CreateSize(bmp.Width, bmp.Height) do
      begin
        try
          AllocBy := 1;
          AddMasked(bmp, TransparentColor);
          Result := TIcon.Create;
          try
            GetIcon(0, Result);
          except
            Result.Free;
            Result := nil;
            raise;
          end;
        finally
          Free;
        end;
      end;  
    except
      Result := nil;
    end;
  finally
    bmp.Free;
  end;
end;

function LoadIconFromPNG(outBitmap: TBitmap32; Dir, pngFile: String; Size: Integer): Boolean;
var
  iconFile: String;
  TempBitmap: TBitmap32;
  a: Boolean;
begin
  Result := False;

  iconFile := SharpAPI.GetSharpeDirectory + 'Icons\' + Dir + '\' + IntToStr(GetNearestIconSize(Size)) + '\' + pngFile;
  if FileExists(iconFile) then
  begin
    TempBitmap := TBitmap32.Create;
    TLinearResampler.Create(TempBitmap);
    try
      LoadBitmap32FromPNG(TempBitmap, iconFile, a);

      outBitmap.SetSize(Size, Size);
      outBitmap.Clear(color32(0,0,0,0));
      TempBitmap.DrawTo(outBitmap, Rect(0, 0, Size, Size));

      Result := True;
    finally
      TempBitmap.Free;
    end;
  end;
end;

initialization
  InitializeCriticalSection(ShellIconAccess);

finalization
  DeleteCriticalSection(ShellIconAccess);

end.
