{
Source Name: uThemeWallpaper.pas
Description: TThemeWallpaper class implementing IThemeWallpaper Interface
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
unit uThemeWallpaper;

interface

uses
  Classes, Masks, uThemeInfo, uThemeConsts, uIThemeWallpaper, uIThemeScheme;

type
  TThemeWallpaper = class(TInterfacedObject, IThemeWallpaper)
  private
    FThemeInfo   : TThemeInfo;
    FWallpapers  : TThemeWallpaperItems;
    FMonitors    : TMonitorWallpapers;
    FAutoCurIndex : integer;
    FIsLoaded : boolean;

    procedure SetDefaults;
    procedure SetWallpaperDefaults(wallpaperItemIndex : Smallint);

  public
    LastUpdate : Int64;
    constructor Create(pThemeInfo : TThemeInfo); reintroduce;
    destructor Destroy; override;
    procedure ParseColors(pScheme : IThemeScheme);

    // IThemeWallpaperInterface
    function GetWallpapers : TThemeWallpaperItems; stdcall;
    property Wallpapers : TThemeWallpaperItems read GetWallpapers;

    function GetMonitors : TMonitorWallpapers; stdcall;
    property Monitors : TMonitorWallpapers read GetMonitors;

    function GetMonitorWallpaper(MonitorID: integer): TThemeWallpaperItem; stdcall;
    function GetMonitor(MonitorID : integer): TWallpaperMonitor; stdcall;
    procedure UpdateMonitor(pMonitor : TWallpaperMonitor); stdcall;
    procedure UpdateWallpaper(pWallpaper : TThemeWallpaperItem); stdcall;

    function UpdateAutomaticWallpaper(MonID : integer) : boolean; stdcall;

    procedure SaveToFile; stdcall;
    procedure LoadFromFile; stdcall;

    function GetIsLoaded: boolean; stdcall;
    property IsLoaded: boolean read GetIsLoaded;    
  end;

implementation

uses
  SysUtils, DateUtils, IXmlBaseUnit;

constructor TThemeWallpaper.Create(pThemeInfo : TThemeInfo);
begin
  Inherited Create;

  setlength(FMonitors, 0);
  setlength(FWallpapers, 0);

  FAutoCurIndex := 0;
  FIsLoaded := False;
  
  FThemeInfo := pThemeInfo;

  LoadFromFile;
end;

destructor TThemeWallpaper.Destroy;
begin
  setlength(FMonitors,0);
  setlength(FWallpapers,0);

  inherited;
end;

function TThemeWallpaper.GetMonitor(MonitorID: integer): TWallpaperMonitor;
var
  n : integer;
begin
  for n := 0 to High(FMonitors) do
    if FMonitors[n].ID = MonitorID then
    begin
      result := FMonitors[n];
      exit;
    end;

  // return the default/primary monitor if not found
  result := FMonitors[0];
end;

function TThemeWallpaper.GetMonitors : TMonitorWallpapers;
begin
  result := FMonitors;
end;

function TThemeWallpaper.GetMonitorWallpaper(MonitorID: integer): TThemeWallpaperItem;
var
  n, i: integer;
  found : boolean;
  newName : String;
begin
  for n := 0 to High(FMonitors) do
    if FMonitors[n].ID = MonitorID then
      for i := 0 to High(FWallpapers) do
        if CompareText(FWallpapers[i].Name, FMonitors[n].Name) = 0 then
        begin
          result := FWallpapers[i];
          exit;
        end;

  i := 0;
  repeat
    found := False;
    i := i + 1;
    // Always start with the Default wallpaper name and increment from there.
    NewName := FWallpapers[0].Name + IntToStr(i);
    for n := 0 to High(FWallpapers) do
      if CompareText(FWallpapers[n].Name,NewName) = 0 then
    begin
      found := True;
      break;
    end;
  until not found;
  result := FWallpapers[0];
  result.Name := NewName;
  for n := 0 to High(FMonitors) do
    if FMonitors[n].ID = MonitorID then
    begin
      FMonitors[n].Name := NewName;
      break;
    end;
end;

function TThemeWallpaper.GetWallpapers : TThemeWallpaperItems;
begin
  result := FWallpapers;
end;

function TThemeWallpaper.GetIsLoaded: boolean;
var
  i : integer;
begin
  Result := True;

  for i := Length(FWallpapers) - 1 downto 0 do
  begin
    if (not FIsLoaded) and (FWallpapers[i].Switch) and (Result = True) then
      Result := False;
  end;
end;

procedure FindFiles(FilesList: TStringList; StartDir: String; FileMask: TStringList; bRecursive : boolean = false);
var
  SR: TSearchRec;
  DirList: TStringList;
  i: integer;
begin
  {$WARNINGS OFF} StartDir := IncludeTrailingBackslash(StartDir); {$WARNINGS ON}

  if FindFirst(StartDir + '*.*', faAnyFile - faDirectory, SR) = 0 then
  begin
    repeat
      for i := 0 to FileMask.Count - 1 do
      begin
        if MatchesMask(SR.Name, FileMask[i]) then
        begin
          FilesList.Add(StartDir + SR.Name);
          break;
        end;
      end;

    until FindNext(SR) <> 0;
    FindClose(SR);
  end;

  // Build a list of subdirectories
  if bRecursive then
  begin
    DirList := TStringList.Create;
    try
      if FindFirst(StartDir + '*.*', faAnyFile, SR) = 0 then
      begin
        repeat
          if ((SR.Attr and faDirectory) <> 0) and (SR.Name[1] <> '.') then
            DirList.Add(StartDir + SR.Name);
        until FindNext(SR) <> 0;
        FindClose(SR);
      end;

      // Scan the list of subdirectories
      for i := 0 to DirList.Count - 1 do
        FindFiles(FilesList, DirList[i], FileMask);
    finally
      DirList.Free;
    end;
  end;
end;

function TThemeWallpaper.UpdateAutomaticWallpaper(MonID : integer) : boolean;
var
  i : integer;
  wallID : integer;

  WallPics : TStringList;
  RandPic : integer;
  Mask : TStringList;
begin
  wallID := 0;
  for i := 0 to High(FMonitors) do
  begin
    if FMonitors[i].ID = MonID then
    begin
      WallID := i;
      break;
    end;
  end;

  // The monitor does not have automatic wallpaper changing enabled so exit.
  if (FWallpapers[wallID].SwitchTimer <= 0) or (not FWallpapers[wallID].Switch) then
  begin
    result := False;
    Exit;
  end;
    
  WallPics := TStringList.Create;
  try
    WallPics.Clear;

    Mask := TStringList.Create;
    try
      Mask.Add('*.bmp');
      Mask.Add('*.jpg');
      Mask.Add('*.jpeg');
      Mask.Add('*.png');

      FindFiles(WallPics, FWallpapers[wallID].SwitchPath, Mask, FWallpapers[wallID].SwitchRecursive);
    finally
      Mask.Free;
    end;
  finally
    // Get a random Wallpaper index
	  if WallPics.Count > 0 then
	  begin
	    if FWallpapers[wallID].SwitchRandomize then
        // Random returns a max of ARange - 1 so we use WallPics.Count.
	      RandPic := Random(WallPics.Count)
	    else
	      RandPic := FAutoCurIndex;

      FWallpapers[wallID].Image := WallPics[RandPic];

      if not FWallpapers[wallID].SwitchRandomize then
      begin
        Inc(FAutoCurIndex);
        if FAutoCurIndex > WallPics.Count - 1 then
          FAutoCurIndex := 0;
      end;
	  end else
	    FWallpapers[wallID].Image := '';

    WallPics.Free;
  end;

  FIsLoaded := True;

  result := True;
end;

procedure TThemeWallpaper.LoadFromFile;
var
  XML : IXmlBase;
  fileloaded : boolean;
  n : integer;
begin
  SetDefaults;

  XML := TInterfacedXMLBase.Create(True);
  XML.XmlFilename := FThemeInfo.Directory + '\' + THEME_WALLPAPER_FILE;
  if XML.Load then
  begin
    fileloaded := True;
    // Load Wallpaper list
    if XML.XmlRoot.Items.ItemNamed['Wallpapers'] <> nil then
      for n := 0 to XML.XmlRoot.Items.ItemNamed['Wallpapers'].Items.Count - 1 do
        with XML.XmlRoot.Items.ItemNamed['Wallpapers'].Items.Item[n].Items do
        begin
          if n <> 0 then // (There always is a default wallpaper at [0], overwrite this)
            setlength(FWallpapers, length(FWallpapers) + 1);
          with FWallpapers[High(FWallpapers)] do
          begin
            SetWallpaperDefaults(High(FWallpapers));

            Name  := Value('Name', Name);
            SwitchPath := Value('SwitchPath', '');
            Switch := BoolValue('Switch', Switch);
            if (Switch) and (DirectoryExists(SwitchPath)) then
            begin
              SwitchRecursive := BoolValue('SwitchRecursive', SwitchRecursive);
              SwitchRandomize := BoolValue('SwitchRandomize', SwitchRandomize);
              SwitchTimer := IntValue('SwitchTimer', SwitchTimer);
            end else
            begin
              Image := Value('Image', '');
              Switch := False;
            end;

            ColorStr        := Value('Color', ColorStr);
            Alpha           := IntValue('Alpha', Alpha);
            Size            := TThemeWallpaperSize(IntValue('Size', 0));
            ColorChange     := BoolValue('ColorChange', ColorChange);
            Hue             := IntValue('Hue', Hue);
            Saturation      := IntValue('Saturation', Saturation);
            Lightness       := IntValue('Lightness', Lightness);
            Gradient        := BoolValue('Gradient', Gradient);
            GradientType    := TThemeWallpaperGradientType(IntValue('GradientType', 0));
            GDStartColorStr := Value('GDStartColor', GDStartColorStr);
            GDStartAlpha    := IntValue('GDStartAlpha', GDStartAlpha);
            GDEndColorStr   := Value('GDEndColor', GDEndColorStr);
            GDEndAlpha      := IntValue('GDEndAlpha', GDEndAlpha);
            MirrorHoriz     := BoolValue('MirrorHoriz', MirrorHoriz);
            MirrorVert      := BoolValue('MirrorVert', MirrorVert);
          end;
        end;

    if XML.XmlRoot.Items.ItemNamed['Monitors'] <> nil then
      for n := 0 to XML.XmlRoot.Items.ItemNamed['Monitors'].Items.Count - 1 do
        with XML.XmlRoot.Items.ItemNamed['Monitors'].Items.Item[n].Items do
        begin
          if n <> 0 then  // (There always is a default monitor at [0], overwrite this)
            setlength(FMonitors, length(FMonitors) + 1);
          FMonitors[High(FMonitors)].Name := Value('Name', 'Default');
          FMonitors[High(FMonitors)].ID := IntValue('ID', -100);
        end;
  end else fileloaded := False;
  XML := nil;

  if not fileloaded then
    SaveToFile;

  LastUpdate := DateTimeToUnix(Now());
end;

procedure TThemeWallpaper.ParseColors(pScheme: IThemeScheme);
var
  n : integer;
begin
  for n := 0 to High(FWallpapers) do
    with FWallpapers[n] do
    begin
      Color        := pScheme.ParseColor(ColorStr);
      GDStartColor := pScheme.ParseColor(GDStartColorStr);
      GDEndColor   := pScheme.ParseColor(GDEndColorStr);
    end;
end;

procedure TThemeWallpaper.SaveToFile;
var
  XML : IXmlBase;
  n : integer;
begin
  XML := TInterfacedXMLBase.Create(True);
  XML.XmlFilename := FThemeInfo.Directory + '\' + THEME_WALLPAPER_FILE;

  XML.XmlRoot.Name := 'SharpEThemeWallpapers';
  with XML.XmlRoot do
  begin
    with Items.Add('Wallpapers') do
    begin
      for n := 0 to High(FWallpapers) do
        with Items.Add('item').Items, FWallpapers[n] do
        begin
          Add('Name', Name);
          Add('Image', Image);

          Add('Switch', Switch);
          Add('SwitchPath', SwitchPath);
          Add('SwitchRecursive', SwitchRecursive);
          Add('SwitchRandomize', SwitchRandomize);
          Add('SwitchTimer', SwitchTimer);

          Add('Color', ColorStr);
          Add('Alpha', Alpha);
          Add('Size', Integer(Size));
          Add('ColorChange', ColorChange);
          Add('Hue', Hue);
          Add('Saturation', Saturation);
          Add('Lightness', Lightness);
          Add('Gradient', Gradient);
          Add('GradientType', Integer(GradientType));
          Add('GDStartColor', GDStartColorStr);
          Add('GDStartAlpha', GDStartAlpha);
          Add('GDEndColor', GDEndColorStr);
          Add('GDEndAlpha', GDEndAlpha);
          Add('MirrorHoriz', MirrorHoriz);
          Add('MirrorVert', MirrorVert);
        end;
    end;

    with Items.Add('Monitors') do
    begin
      for n := 0 to High(FMonitors) do
        with Items.Add('item').Items, FMonitors[n] do
        begin
          Add('Name', Name);
          Add('ID', ID);
        end;
    end;
  end;
  XML.Save;

  XML := nil;
end;

procedure TThemeWallpaper.SetDefaults;
begin
  setlength(FWallpapers, 1);
  setlength(FMonitors, 1);
  FMonitors[0].Name := 'Default';
  FMonitors[0].ID := -100;
  SetWallpaperDefaults(0);
end;

procedure TThemeWallpaper.SetWallpaperDefaults(wallpaperItemIndex: Smallint);
begin
  with FWallpapers[wallpaperItemIndex] do
  begin
    Name            := 'Default';
    Image           := '';
    Color           := 0;
    ColorStr        := '0';
    Alpha           := 255;
    Size            := twsScale;
    ColorChange     := False;
    Hue             := 0;
    Saturation      := 0;
    Lightness       := 0;
    Gradient        := False;
    GradientType    := twgtHoriz;
    GDStartColor    := 0;
    GDStartColorStr := '0';
    GDStartAlpha    := 0;
    GDEndColor      := 0;
    GDEndColorStr   := '0';
    GDEndAlpha      := 0;
    MirrorHoriz     := False;
    MirrorVert      := False;
    SwitchPath      := '';
    SwitchRecursive := False;
    SwitchRandomize := True;
    SwitchTimer     := 5000 * 60;
    Switch          := False;
  end;
end;

procedure TThemeWallpaper.UpdateMonitor(pMonitor : TWallpaperMonitor);
var
  n : integer;
begin
  for n := 0 to High(FMonitors) do
    if FMonitors[n].ID = pMonitor.ID then
    begin
      FMonitors[n].Name := pMonitor.Name;
      exit;
    end;

  SetLength(FMonitors,length(FMonitors)+1);
  FMonitors[High(FMonitors)] := pMonitor;
end;

procedure TThemeWallpaper.UpdateWallpaper(pWallpaper : TThemeWallpaperItem);
var
  n : integer;
begin
  for n := 0 to High(FWallpapers) do
    if CompareText(FWallpapers[n].Name,pWallpaper.Name) = 0 then
    begin
      FWallpapers[n] := pWallpaper;
      exit;
    end;

  SetLength(FWallpapers,length(FWallpapers)+1);
  FWallpapers[High(FWallpapers)] := pWallpaper;
end;

end.
