{
Source Name: SharpDialogs.dpr
Description: dll exporting commonly used menus and dialogs
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

library SharpDialogs;

{$R 'res\icons.res'}
{$R 'VersionInfo.res'}
{$R *.res}

uses
  ShareMem,
  Windows,
  Messages,
  Graphics,
  Dialogs,
  SysUtils,
  CommCtrl,
  Classes,
  Forms,
  Types,
  Menus,
  Controls,
  PngImageList,
  ActiveX,
  ShellApi,
  ShlObj,
  SharpApi,
  SharpApiEx,
  uThemeConsts,
  uISharpETheme,
  ExPopupList,
  SharpThemeApiEx,
  {$IFDEF DEBUG}DebugDialog in '..\..\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  SharpIconUtils in '..\..\Units\SharpIconUtils\SharpIconUtils.pas',
  GR32_PNG in '..\..\3rd party\GR32 Addons\GR32_PNG.pas',
  uVistaFuncs in '..\..\Units\VistaFuncs\uVistaFuncs.pas',
  SharpFileUtils in '..\..\Units\SharpFileUtils\SharpFileUtils.pas';

type
  TTargetDialogSelectItem = (stiFile,stiRecentFiles,stiMostUsedFiles,stiDrive,
                             stiDirectory,stiShellFolders,stiScript,stiAction,
                             stiSharpEFolders);
  TTargetDialogSelectItems = Set of TTargetDialogSelectItem;
  TTargetDialogClickHandler = class
                                procedure OnFileOpenClick(Sender : TObject);
                                procedure OnMRClick(Sender : TObject);
                                procedure OnDriveClick(Sender : TObject);
                                procedure OnShellFolderClick(Sender : TObject);
                                procedure OnSharpEFolderClick(Sender : TObject);
                                procedure OnDirOpenClick(Sender : TObject);
                                procedure OnScriptClick(Sender : TObject);
                                procedure OnActionClick(Sender : TObject);
                              end;

  TIconMenuSelectItem = (smiShellIcon,smiCustomIcon,smiSharpEIcon,smiGenericIcon);
  TIconMenuSelectItems = Set of TIconMenuSelectItem;
  TIconMenuClickHandler = class
                            procedure OnShellIconClick(Sender : TObject);
                            procedure OnCustomIconClick(Sender : TObject);
                            procedure OnSharpEIconClick(Sender : TObject);
                          end;
  {TTargetDialogSkinClickHandler =
  class
    procedure OnFileOpenClick(pItem : TSharpEMenuItem; var CanClose : boolean);
    procedure OnDirOpenClick(pItem : TSharpEMenuItem; var CanClose : boolean);
    procedure OnShellFolderClick(pItem : TSharpEMenuItem; var CanClose : boolean);
    procedure OnMRClick(pItem : TSharpEMenuItem; var CanClose : boolean);    
  end;}


const
  SMI_ALL_ICONS = [smiShellIcon,smiCustomIcon,smiSharpEIcon]; // do not add smiGenericIcon
  STI_ALL_TARGETS = [stiFile,stiRecentFiles,stiMostUsedFiles,stiDrive,
                     stiDirectory,stiShellFolders,stiScript,stiAction,
                     stiSharpEFolders];

var
  targetmenuresult : String;
  iconmenuresult : String;
  targetmenu  : TPopupMenu;
  iconmenu : TPopupMenu;

procedure BuildShellFolderList(Slist : TStringList);
begin
 SList.Clear;

 if (IsWindowsVista or IsWindows7) then
 begin
   SList.Add('shell:AddNewProgramsFolder=Add New Programs');
   SList.Add('shell:Administrative Tools=Administrative Tools');
   SList.Add('shell:AppData=Application Data');
   SList.Add('shell:AppUpdatesFolder=Application Updates');
   SList.Add('shell:Cache=Cache');
   SList.Add('shell:CD Burning=CD Burning');
   SList.Add('shell:ChangeRemoveProgramsFolder=Change/Remove Programs');
   SList.Add('shell:Common Administrative Tools=Common Administrative Tools');
   SList.Add('shell:Common AppData=Common Application Data');
   SList.Add('shell:Common Desktop=Common Desktop');
   SList.Add('shell:Common Documents=Common Documents');
   SList.Add('shell:CommonDownloads=Common Downloads');
   SList.Add('shell:CommonMusic=Common Music');
   SList.Add('shell:CommonPictures=Common Pictures');   
   SList.Add('shell:Common Programs=Common Programs');
   if IsWindows7 then SList.Add('shell:CommonRingtones=Common Ringtones');
   SList.Add('shell:Common Start Menu=Common Start Menu');
   SList.Add('shell:Common Startup=Common Startup');
   SList.Add('shell:Common Templates=Common Templates');
   if IsWindows7 then SList.Add('shell:UserProgramFilesCommon=Common User Program Files');
   SList.Add('shell:CommonVideo=Common Video');
   SList.Add('shell:ConflictFolder=Conflicts');
   SList.Add('shell:ConnectionsFolder=Connections');
   SList.Add('shell:Contacts=Contacts');
   SList.Add('shell:ControlPanel=Control Panel');
   SList.Add('shell:ControlPanelFolder=Control Panel Folder');
   SList.Add('shell:Cookies=Cookies');
   SList.Add('shell:CredentialManager=Credential Manager');
   SList.Add('shell:CryptoKeys=Crypto Keys');
   SList.Add('shell:CSCFolder=CSC Folder');
   SList.Add('shell:Default Gadgets=Default Gadgets');
   SList.Add('shell:Desktop=Desktop');
   if IsWindows7 then SList.Add('shell:Device Metadata Store=Device Metadata Store');
   if IsWindows7 then SList.Add('shell:DocumentsLibrary=Documents Library');
   SList.Add('shell:Downloads=Downloads');
   SList.Add('shell:DpapiKeys=Dpapi Keys');
   SList.Add('shell:Favorites=Favorites');
   SList.Add('shell:Fonts=Fonts');
   SList.Add('shell:Gadgets=Gadgets');
   SList.Add('shell:Games=Games');
   SList.Add('shell:GameTasks=Game Tasks');
   SList.Add('shell:History=History');
   if IsWindows7 then SList.Add('shell:ImplicitAppShortcuts=Implicit App Shortcuts');
   SList.Add('shell:InternetFolder=Internet');
   if IsWindows7 then SList.Add('shell:Libraries=Libraries');
   SList.Add('shell:Links=Links');
   SList.Add('shell:Local AppData=Local Application Data');
   SList.Add('shell:LocalAppDataLow=Local Application Data Low');
   SList.Add('shell:LocalizedResourcesDir=Localized Resources Directory');
   SList.Add('shell:MAPIFolder=MAPI Folder');
   if IsWindows7 then SList.Add('shell:MusicLibrary=Music Library');   
   SList.Add('shell:My Music=My Music');
   SList.Add('shell:My Pictures=My Pictures');
   SList.Add('shell:My Video=My Video');
   SList.Add('shell:MyComputerFolder=My Computer');
   SList.Add('shell:NetHood=Network Shortcuts');
   SList.Add('shell:NetworkPlacesFolder=Network');
   SList.Add('shell:OEM Links=OEM Links');
   if IsWindows7 then SList.Add('shell:OtherUsersFolder=Other Users Folder');
   SList.Add('shell:Original Images=Original Images');
   SList.Add('shell:Personal=Personal');
   SList.Add('shell:PhotoAlbums=Photo Albums');
   if IsWindows7 then SList.Add('shell:PicturesLibrary=Pictures Library');
   if IsWindows7 then SList.Add('shell:User Pinned=Pinned Taskbar Items');
   SList.Add('shell:Playlists=Playlists');
   if IsWindows7 then SList.Add('shell:PublicSuggestedLocations=Public Suggested Locations');   
   SList.Add('shell:PrintersFolder=Printers');
   SList.Add('shell:PrintHood=PrintHood');
   SList.Add('shell:Profile=Profile');
   SList.Add('shell:ProgramFiles=Program Files');
   SList.Add('shell:ProgramFilesCommon=Program Files Common');
   SList.Add('shell:ProgramFilesCommonX86=Program Files Common X86');
   SList.Add('shell:ProgramFilesX86=Program Files X86');
   SList.Add('shell:Programs=Programs');
   SList.Add('shell:Public=Public');
   SList.Add('shell:PublicGameTasks=Public Game Tasks');
   SList.Add('shell:Quick Launch=Quick Launch');
   SList.Add('shell:Recent=Recent');
   SList.Add('shell:RecycleBinFolder=Recycle Bin');
   if IsWindows7 then SList.Add('shell:RecordedTVLibrary=Recorded TV Library');
   SList.Add('shell:ResourceDir=Resource Dir');
   if IsWindows7 then SList.Add('shell:Ringtones=Ringtones');   
   SList.Add('shell:SampleMusic=Sample Music');
   SList.Add('shell:SamplePictures=Sample Pictures');
   SList.Add('shell:SamplePlaylists=Sample Playlists');
   SList.Add('shell:SampleVideos=Sample Videos');
   SList.Add('shell:SavedGames=Saved Games');
   SList.Add('shell:Searches=Searches');
   SList.Add('shell:SendTo=Send To');
   if IsWindows7 then SList.Add('shell:SuggestedLocations=Suggested Locations');
   SList.Add('shell:Start Menu=Start Menu');
   SList.Add('shell:Startup=Startup');
   SList.Add('shell:SyncCenterFolder=SyncCenter');
   SList.Add('shell:SyncResultsFolder=SyncResults');
   SList.Add('shell:SyncSetupFolder=SyncSetup');
   SList.Add('shell:System=System');
   SList.Add('shell:SystemCertificates=SystemCertificates');
   SList.Add('shell:SystemX86=System X86');
   SList.Add('shell:Templates=Templates');
   SList.Add('shell:TreePropertiesFolder=Tree Properties');
   SList.Add('shell:UsersFilesFolder=Users Files');
   SList.Add('shell:UserProfiles=User Profiles');
   if IsWindows7 then SList.Add('shell:UserProgramFiles=User Program Files');
   if IsWindows7 then SList.Add('shell:UsersLibrariesFolder=Users Libraries Folder');
   if IsWindows7 then SList.Add('shell:VideosLibrary=Videos Library');     
   SList.Add('shell:Windows=Windows');
 end
 else
 begin
   SList.Add('shell:Administrative Tools=Administrative Tools');
   SList.Add('shell:AppData=Application Data');
   SList.Add('shell:Common Administrative Tools=All Users Administrative Tools');
   SList.Add('shell:Common AppData=All Users Application Data');
   SList.Add('shell:Common Desktop=All Users Desktop');
   SList.Add('shell:Common Documents=All Users Documents');
   SList.Add('shell:Common Favorites=All Users Favorites');
   SList.Add('shell:Common Menu=All Users Start Menu');
   SList.Add('shell:Common Startup=All Users Startup');
   SList.Add('shell:Common Templates=All Users Templates');
   SList.Add('shell:Common Programs=Common Programs');
   SList.Add('shell:CommonProgramFiles=Common Program Files');
   SList.Add('shell:ControlPanelFolder=Control Panel');
   SList.Add('shell:Cookies=Cookies');
   SList.Add('shell:Desktop=Desktop');
   SList.Add('shell:Favorites=Favorites');
   SList.Add('shell:Fonts=Fonts');
   SList.Add('shell:History=History');
   SList.Add('shell:InternetFolder=Internet Folder');
   SList.Add('shell:Local AppData=Local Application Data');
   //SList.Add('shell:Menu=Menu');
   SList.Add('shell:DriveFolder=My Computer');
   SList.Add('shell:Personal=My Documents');
   SList.Add('shell:My Music=My Music');
   SList.Add('shell:My Pictures=My Pictures');
   SList.Add('shell:NetHood=NetHood');
   SList.Add('shell:ConnectionsFolder=Network Connections');
   SList.Add('shell:NetworkFolder=Network Folder');
   SList.Add('shell:PrintersFolder=Printers Folder');
   SList.Add('shell:PrintHood=PrintHood');
   SList.Add('shell:ProgramFiles=Program Files');
   SList.Add('shell:Programs=Programs');
   SList.Add('shell:Recent=Recent Documents');
   SList.Add('shell:RecycleBinFolder=Recycle Bin');
   SList.Add('shell:SendTo=Send To');
   SList.Add('shell:SystemX86=System32 (X86)');
   SList.Add('shell:System=System32');
   SList.Add('shell:Templates=Templates');
   SList.Add('shell:Profile=User Profile');
   SList.Add('shell:Windows=Windows Directory');
 end;
end;

function DriveExists(DriveByte: Byte): Boolean;
begin
  Result := GetLogicalDrives and (1 shl DriveByte) <> 0;
end;

function DriveType(DriveByte: Byte): String;
begin
  case GetDriveType(PChar(Chr(DriveByte + Ord('A')) + ':\')) of
    DRIVE_UNKNOWN: Result := 'Unknown';
    DRIVE_NO_ROOT_DIR: Result := 'NO ROOT DIR';
    DRIVE_REMOVABLE: Result := 'Removeable Drive'; 
    DRIVE_FIXED: Result := 'Hard Drive'; 
    DRIVE_REMOTE: Result := 'Network Drive';
    DRIVE_CDROM: Result := 'CD-ROM/DVD'; 
    DRIVE_RAMDISK: Result := 'RAM Disk'; 
  else 
    Result := 'other drive type';
  end; 
end;

function GetDriveName(DriveByte : Byte) : string;
var
  NotUsed, VolFlags: DWORD;
  Buf: array[0..MAX_PATH] of Char;
begin
  try
    GetVolumeInformation(PChar(Chr(DriveByte + Ord('A')) + ':\'), Buf, SizeOf(Buf), nil, NotUsed, VolFlags, nil, 0);
    Result := Buf;
  except
  end;
end;

procedure TIconMenuClickHandler.OnShellIconClick(Sender : TObject);
begin
  try
    iconmenuresult := 'shell:icon';
  finally
    nrevent := False;
  end;
end;

procedure TIconMenuClickHandler.OnCustomIconClick(Sender : TObject);
var
  ofdialog : TOpenDialog;
begin
  iconmenuresult := '';
  ofdialog := TOpenDialog.Create(nil);
  try
    ofdialog.Filter := 'Images (*.jpg,*.png,*.ico)|*.jpg;*.jpeg;*.ico;*.png';
    ofdialog.Options := ofdialog.Options + [ofNoDereferenceLinks];
    if ofdialog.Execute then iconmenuresult := ofdialog.FileName;
  finally
    ofdialog.Free;
    nrevent := False;
  end;
end;

procedure TIconMenuClickHandler.OnSharpEIconClick(Sender : TObject);
begin
  try
    iconmenuresult := TMenuItem(Sender).Hint;
  finally
    nrevent := False;
  end;
end;

procedure TTargetDialogClickHandler.OnActionClick(Sender : TObject);
begin
  try
    targetmenuresult := TMenuItem(Sender).Hint;
  finally
    nrevent := False;
  end;
end;

procedure TTargetDialogClickHandler.OnScriptClick(Sender : TObject);
begin
  try
    targetmenuresult := TMenuItem(Sender).Hint;
  finally
    nrevent := False;
  end;
end;

procedure TTargetDialogClickHandler.OnDirOpenClick(Sender : TObject);
var
  pidl, pidlSelected: PItemIDList;
  bi: TBrowseInfo;
  szDirName: array [0..260] of AnsiChar;
begin
  {Get the root PIDL of the network neighborhood tree}
  if SHGetSpecialFolderLocation(Application.Handle, CSIDL_DESKTOP, pidl) = NOERROR then
  begin
    {Populate a BROWSEINFO structure}
    bi.hwndOwner := Application.Handle;
    bi.pidlRoot := pidl;
    bi.pszDisplayName := szDirName;
    bi.lpszTitle := 'Select Directory';
    bi.ulFlags := BIF_RETURNONLYFSDIRS;
    bi.lpfn := nil;
    bi.lParam := 0;
    bi.iImage := - 1;
    {Display the "Browse For Folder" dialog box}
    pidlSelected := SHBrowseForFolder(bi);
    {NULL indicates that Cancel was selected from the dialog box}
    if pidlSelected <> nil then
    begin
      SHGetPathFromIDList(pidlSelected, szDirName);
      targetmenuresult := szDirName;
      {Release the PIDL of the computer name}
      CoTaskMemFree(pidlSelected);
    end;
    {Release the PIDL of the network neighborhood tree}
    CoTaskMemFree(pidl);
  end;
  nrevent := False;
end;

procedure TTargetDialogClickHandler.OnSharpEFolderClick(Sender : TObject);
begin
  try
    targetmenuresult := TMenuItem(Sender).Hint;
  finally
    nrevent := False;
  end;
end;

procedure TTargetDialogClickHandler.OnShellFolderClick(Sender : TObject);
begin
  try
    targetmenuresult := TMenuItem(Sender).Hint;
  finally
    nrevent := False;
  end;
end;

procedure TTargetDialogClickHandler.OnDriveClick(Sender : TObject);
begin
  try
    targetmenuresult := TMenuItem(Sender).Hint;
  finally
    nrevent := False;
  end;
end;

procedure TTargetDialogClickHandler.OnMRClick(Sender : TObject);
begin
  try
    targetmenuresult := TMenuItem(Sender).Hint;
  finally
    nrevent := False;
  end;
end;

procedure TTargetDialogClickHandler.OnFileOpenClick(Sender : TObject);
var
  ofdialog : TOpenDialog;
begin
  targetmenuresult := '';
  ofdialog := TOpenDialog.Create(nil);
  try
    ofdialog.Filter := 'All Files (*.*)|*.*';
    ofdialog.Options := ofdialog.Options + [ofNoDereferenceLinks];
    if ofdialog.Execute then targetmenuresult := ofdialog.FileName;
  finally
    ofdialog.Free;
    nrevent := False;
  end;
end;

{function AddItemToMenu(Menu : TSharpEMenu; Caption : String; IconResName : String; pType :TSharpEMenuItemType = mtCustom) : TSharpEMenuItem;
var
  ResStream : TResourceStream;
  b : boolean;
  Icon : TBitmap32;
begin
  Icon := TBitmap32.Create;
  try
    ResStream := TResourceStream.Create(HInstance, IconResName, RT_RCDATA);
    try
      LoadBitmap32FromPng(Icon,ResStream,b);
    finally
      ResStream.Free;
    end;
  except
    Icon.SetSize(22,22);
    Icon.Clear(color32(0,0,0,0));
  end;
  result := TSharpEMenuItem(Menu.AddCustomItem(Caption,IconResName,Icon,pType));
  Icon.Free;
end;

procedure TTargetDialogSkinClickHandler.OnDirOpenClick(pItem : TSharpEMenuItem; var CanClose : boolean);
var
  tdc : TTargetDialogClickHandler;
begin
  tdc := TTargetDialogClickHandler.Create;
  tdc.OnDirOpenClick(pItem);
  tdc.Free;
  CanClose := True;
end;

procedure TTargetDialogSkinClickHandler.OnFileOpenClick(pItem: TSharpEMenuItem;
  var CanClose: boolean);
var
  tdc : TTargetDialogClickHandler;
begin
  tdc := TTargetDialogClickHandler.Create;
  tdc.OnFileOpenClick(pItem);
  tdc.Free;
  CanClose := True;
end;

procedure TTargetDialogSkinClickHandler.OnMRClick(pItem: TSharpEMenuItem;
  var CanClose: boolean);
begin
  try
    targetmenuresult := pItem.PropList.GetString('Action');
  finally
    nrevent := False;
  end;
  CanClose := True;
end;

procedure TTargetDialogSkinClickHandler.OnShellFolderClick(
  pItem: TSharpEMenuItem; var CanClose: boolean);
begin
  try
    targetmenuresult := pItem.Caption;
  finally
    nrevent := False;
  end;
  CanClose := True;
end;

function GetWndClass(wnd : hwnd) : String;
var
  buf: array [0..254] of Char;
begin
  GetClassName(wnd, buf, SizeOf(buf));
  result := buf;
end;

function TargetDialogSkin(TargetItems : TTargetDialogSelectItems; PopupPoint : TPoint) : PChar;
var
  SM : TSharpESkinManager;
  ms : TSharpEMenuSettings;
  mn : TSharpEMenu;
  mwnd : TSharpEMenuWnd;
  click : TTargetDialogSkinClickHandler;
  SList : TStringList;
  n : integer;
  s : String;
  mIcon : TBitmap32;
  ResStream : TResourceStream;
  b : boolean;
  Dir : String;
  Info: TSHFileInfo;
  P: PChar;
  SC : String;
  sn : String;
  ic : String;
  Tmp: array [0..104] of Char;  
  sr : TSearchRec;
  sub : TSharpEMenu;
begin
  targetmenuresult := '';

  click := TTargetDialogSkinClickHandler.Create;
  SList := TStringList.Create;
  SList.Clear;

  SM := TSharpESkinManager.Create(nil,[scBar,scMenu,scMenuItem]);
  SM.SkinSource := ssSystem;
  SM.SchemeSource := ssSystem;
  SM.Skin.UpdateDynamicProperties(SM.Scheme);

  ms := TSharpEMenuSettings.Create;
  ms.CacheIcons := False;
  ms.LoadFromXML;

  mn := TSharpEMenu.Create(SM,ms);
  ms.Free;

  mIcon := TBitmap32.Create;
  try
    ResStream := TResourceStream.Create(HInstance, 'specialfile22', RT_RCDATA);
    try
      LoadBitmap32FromPng(mIcon,ResStream,b);
    finally
      ResStream.Free;
    end;
  except
    mIcon.SetSize(22,22);
    mIcon.Clear(color32(0,0,0,0));
  end;

  if stiFile in TargetItems then
  with AddItemToMenu(mn,'File','file22',mtSubMenu) do
  begin
    SubMenu := TSharpEMenu.Create(SM,mn.Settings);
    AddItemToMenu(TSharpEMenu(SubMenu),'Open...','open22').OnClick := click.OnFileOpenClick;

    if (stiRecentFiles in TargetItems) or (stiMostUsedFiles in TargetItems) then
    begin
      TSharpEMenu(SubMenu).AddSeparatorItem(False);

      if stiRecentFiles in TargetItems then
      with AddItemToMenu(TSharpEMenu(SubMenu),'Recent','recentfile22',mtSubMenu) do
      begin
        SubMenu := TSharpEMenu.Create(SM,mn.Settings);
        SList.CommaText := SharpApiEx.GetRecentItems(10);

        for n := 0 to SList.Count -1 do
        begin
          s := ExtractFileName(SList[n]);
          if length(trim(s)) = 0 then
            s := SList[n];
          if FileExists(SList[n]) then
            TSharpEMenuItem(TSharpEMenu(SubMenu).AddLinkItem(s,SList[n],'shell:icon',False)).OnClick := Click.OnMRClick
          else TSharpEMenuItem(TSharpEMenu(SubMenu).AddLinkItem(s,SList[n],'specialfile',mIcon,False)).OnClick := Click.OnMRClick;
        end;
      end;

      if stiMostUsedFiles in TargetItems then
      with AddItemToMenu(TSharpEMenu(SubMenu),'Most Used','recentfile22',mtSubMenu) do
      begin
        SubMenu := TSharpEMenu.Create(SM,mn.Settings);
        SList.CommaText := SharpApiEx.GetMostUsedItems(10);

        for n := 0 to SList.Count -1 do
        begin
          s := ExtractFileName(SList[n]);
          if length(trim(s)) = 0 then
            s := SList[n];
          if FileExists(SList[n]) then
            TSharpEMenuItem(TSharpEMenu(SubMenu).AddLinkItem(s,SList[n],'shell:icon',False)).OnClick := Click.OnMRClick
          else TSharpEMenuItem(TSharpEMenu(SubMenu).AddLinkItem(s,SList[n],'specialfile',mIcon,False)).OnClick := Click.OnMRClick;
        end;
      end;
    end;
  end;

  if stiDrive in TargetItems then
  with AddItemToMenu(mn,'Drive','driveharddisk22',mtSubMenu) do
  begin
    SubMenu := TSharpEMenu.Create(SM,mn.Settings);
    try
      FillChar(Tmp[0], SizeOf(Tmp), #0);
      GetLogicalDriveStrings(SizeOf(Tmp), Tmp);
      P := Tmp;
      while P^ <> #0 do
      begin
        SC := P;
        Inc(P, 4);
        SHGetFileInfo(PChar(SC), 0, Info, SizeOf(TSHFileInfo), SHGFI_DISPLAYNAME or SHGFI_TYPENAME);
        sn := '';
        sn := Trim(Info.szDisplayName);// + '[' + Trim(Info.szTypeName) + ']';
        s := '['+ SC[1] + ':] - ' + sn;
        case GetDriveType(PChar(SC[1] + ':\')) of
          DRIVE_UNKNOWN: ic := 'driveremovable22';
          DRIVE_NO_ROOT_DIR: ic := 'driveremovable22';
          DRIVE_REMOVABLE: ic := 'driveremovable22';
          DRIVE_FIXED: ic := 'driveharddisk22';
          DRIVE_REMOTE: ic := 'driveremovable22';
          DRIVE_CDROM: ic := 'drivecdrom22';
          DRIVE_RAMDISK: ic := 'driveharddisk22';
          else ic := 'driveremovable22';
        end;
        with AddItemToMenu(TSharpEMenu(SubMenu),sn,ic) do
        begin
          PropList.Add('Action',SC[1] + ':\');
          OnClick := click.OnMRClick;
        end;
      end;
    except
    end;
  end;

  if stiDirectory in TargetItems then
  with AddItemToMenu(mn,'Directory','folder22',mtSubMenu) do
  begin
    SubMenu := TSharpEMenu.Create(SM,mn.Settings);
    AddItemToMenu(TSharpEMenu(SubMenu),'Open...','open22').OnClick := click.OnDirOpenClick;

    if stiShellFolders in TargetItems then
    begin
      TSharpEMenu(SubMenu).AddSeparatorItem(False);
      with AddItemToMenu(TSharpEMenu(SubMenu),'Shell Folder','specialfolder22',mtSubMenu) do
      begin
        SubMenu := TSharpEMenu.Create(SM,mn.Settings);
        TSharpEMenu(SubMenu).Settings.WrapMenu := True;
        TSharpEMenu(SubMenu).Settings.WrapCount := 20;
        BuildShellFolderList(Slist);
        for n := 0 to SList.Count -1 do
          with AddItemToMenu(TSharpEMenu(SubMenu),SList.ValueFromIndex[n],'folder22') do
          begin
            PropList.Add('Action',SList.Names[n]);
            OnClick := click.OnMRClick;
          end;
      end;
    end;
  end;

  if stiScript in TargetItems then
  with AddItemToMenu(mn,'Script','scriptfile22',mtSubMenu) do
  begin
    SubMenu := TSharpEMenu.Create(SM,mn.Settings);
    Dir := SharpApi.GetSharpeUserSettingsPath + 'Scripts\';
    if FindFirst(Dir + '*.sescript',FAAnyFile,sr) = 0 then
    repeat
      s := sr.Name;
      setlength(s,length(s) - length('.sescript'));
      with AddItemToMenu(TSharpEMenu(SubMenu),s,'specialfile') do
      begin
        PropList.Add('Action',Dir + sr.Name);
        OnClick := click.OnMRClick;
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;

  if stiAction in TargetItems then
  with AddItemToMenu(mn,'Action','actions22',mtSubMenu) do
  begin
    SubMenu := TSharpEMenu.Create(SM,mn.Settings);

    SList.Clear;
    SList.DelimitedText := SharpApiEx.GetDelimitedActionList;
    SList.Sort;
    s := '';
    sub := TSharpEMenu(SubMenu);
    for n := 0 to SList.Count - 1 do
    begin
      if CompareText(s,SList.Names[n]) <> 0 then
      begin
        s := SList.Names[n];
        sub := TSharpEMenu.Create(SM,TSharpEMenu(SubMenu).Settings);
        AddItemToMenu(TSharpEMenu(SubMenu),s,'actionscategory22',mtSubMenu).SubMenu := sub;
      end;
      AddItemToMenu(sub,SList.ValueFromIndex[n],'action22').OnClick := click.OnShellFolderClick;
    end;
  end;

  nrevent := True;

  mwnd := TSharpEMenuWnd.Create(nil,mn);
  mwnd.FreeMenu := False;
  mwnd.Left := PopupPoint.X;
  mwnd.Top := PopupPoint.Y;
  mwnd.Show;

  while nrevent and (mwnd.Visible) do
  begin
    Application.ProcessMessages;
    if GetWndClass(GetForeGroundWindow) <> 'TSharpEMenuWnd' then
      nrevent := False;
    sleep(10);
  end;
  mwnd.Free;
  mn.Free;
  mIcon.Free;
  SList.Free;
  SM.Free;
  click.Free;

  if SharpEMenuPopups <> nil then
     FreeAndNil(SharpEMenuPopups);
  if SharpEMenuIcons <> nil then
     FreeAndNil(SharpEMenuIcons);
       
  result := PChar(targetmenuresult);
end;   }

function TargetDialog(TargetItems : TTargetDialogSelectItems; PopupPoint : TPoint) : PChar;
var
  menuItem : TMenuItem;
  SList : TStringList;
  n : integer;
  mindex : integer;
  sr : TSearchRec;
  s,dir : String;
  targetmenuclick : TTargetDialogClickHandler;
  iml : TPngImageList;
  bmp : TBitmap;
  sn : String;
  Tmp: array [0..104] of Char;
  Info: TSHFileInfo;
  P: PChar;
  SC : String;
  iScriptFiles : integer;
begin
  targetmenuresult := '';
  targetmenu := TPopupMenu.Create(nil);
  targetmenuclick := TTargetDialogClickHandler.Create;
  iml := TPngImageList.Create(nil);
  iml.Width := 16;
  iml.Height := 16;
  targetmenu.Images := iml;

  SList := TStringList.Create;
  try
    // Build Image List
    Bmp := TBitmap.Create;
    try
      Bmp.Width := 16;
      Bmp.Height := 16;
      Bmp.Canvas.Brush.Color := clRed;
      Bmp.canvas.FillRect(bmp.canvas.ClipRect);

      iml.Add(bmp,bmp);

      iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'recentfile16');
      iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'open16');
      iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'drivecdrom16');
      iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'driveharddisk16');
      iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'driveremovable16');
      iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'folder16');
      iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'specialfolder16');
      iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'file16');
      iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'specialfile16');
      iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'scriptfile16');
      iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'actions16');
      iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'actionscategory16');
      iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'action16');

      iml.Add(bmp,bmp);
    finally
      Bmp.Free;
    end;

    targetmenu.Items.Clear;
    mindex := -1;

    // two Dummy items! do not remove!
    menuItem := TMenuItem.Create(targetmenu);
    targetmenu.Items.Add(menuItem);
    menuItem.Visible := False;
    mindex := mindex + 1;

    menuItem := TMenuItem.Create(targetmenu);
    menuItem.Visible := False;
    targetmenu.Items.Add(menuItem);
    mindex := mindex + 1;

    if stiFile in TargetItems then
    begin
      // Files Menu
      menuItem := TMenuItem.Create(targetmenu);
      menuItem.Caption := 'File';
      menuItem.ImageIndex := 8;
      targetmenu.Items.Add(menuItem);
      mindex := mindex + 1;

      menuItem := TMenuItem.Create(targetmenu);
      menuItem.Caption := 'Open...';
      menuItem.OnClick := targetmenuclick.OnFileOpenClick;
      menuItem.ImageIndex := 2;
      targetmenu.Items.Items[mindex].Add(menuItem);

      if (stiRecentFiles in TargetItems) or (stiMostUsedFiles in TargetItems) then
      begin
        menuItem := TMenuItem.Create(targetmenu);
        menuItem.Caption := '-';
        targetmenu.Items.Items[mindex].Add(menuItem);
      end;

      if stiRecentFiles in TargetItems then
      begin
        menuItem := TMenuItem.Create(targetmenu);
        menuItem.Caption := 'Recent';
        menuItem.ImageIndex := 1;
        targetmenu.Items.Items[mindex].Add(menuItem);

        SList.CommaText := SharpApiEx.GetRecentItems(10);
        for n := 0 to SList.Count -1 do
        begin
          menuItem := TMenuItem.Create(targetmenu);
          menuItem.Caption := ExtractFileName(SList[n]);
          if length(trim(menuItem.Caption)) = 0 then menuItem.Caption := SList[n];
          menuItem.Hint := SList[n];
          menuItem.OnClick := targetmenuclick.OnMRClick;
          menuItem.ImageIndex := 9;
          targetmenu.Items.Items[mindex].Items[targetmenu.Items.Items[mindex].Count-1].Add(menuItem);
        end;
      end;

      if stiMostUsedFiles in TargetItems then
      begin
        menuItem := TMenuItem.Create(targetmenu);
        menuItem.Caption := 'Most Used';
        menuItem.ImageIndex := 1;
        targetmenu.Items.Items[mindex].Add(menuItem);
        //mindex := mindex + 1;

        SList.CommaText := SharpApiEx.GetMostUsedItems(10);
        for n := 0 to SList.Count -1 do
        begin
          menuItem := TMenuItem.Create(targetmenu);
          menuItem.Caption := ExtractFileName(SList[n]);
          if length(trim(menuItem.Caption)) = 0 then menuItem.Caption := SList[n];
          menuItem.Hint := SList[n];
          menuItem.OnClick := targetmenuclick.OnMRClick;
          menuItem.ImageIndex := 9;
          targetmenu.Items.Items[mindex].Items[targetmenu.Items.Items[mindex].Count-1].Add(menuItem);
        end;
      end;
    end;


    if stiDrive in TargetItems then
    begin
      // Drive Menu
      menuItem := TMenuItem.Create(targetmenu);
      menuItem.Caption := 'Drive';
      menuItem.ImageIndex := 4;
      targetmenu.Items.Add(menuItem);
      mindex := mindex + 1;

      try
        FillChar(Tmp[0], SizeOf(Tmp), #0);
        GetLogicalDriveStrings(SizeOf(Tmp), Tmp);
        P := Tmp;
        while P^ <> #0 do
        begin
          SC := P;
          Inc(P, 4);
          SHGetFileInfo(PChar(SC), 0, Info, SizeOf(TSHFileInfo), SHGFI_DISPLAYNAME or SHGFI_TYPENAME);
          sn := '';
          sn := Trim(Info.szDisplayName);// + '[' + Trim(Info.szTypeName) + ']';
          s := '['+ SC[1] + ':] - ' + sn;
          menuItem := TMenuItem.Create(targetmenu);
          menuItem.Caption := sn;
          case GetDriveType(PChar(SC[1] + ':\')) of
            DRIVE_UNKNOWN: menuItem.ImageIndex := 5;
            DRIVE_NO_ROOT_DIR: menuItem.ImageIndex := 5;
            DRIVE_REMOVABLE: menuItem.ImageIndex := 5;
            DRIVE_FIXED: menuItem.ImageIndex := 4;
            DRIVE_REMOTE: menuItem.ImageIndex := 5;
            DRIVE_CDROM: menuItem.ImageIndex := 3;
            DRIVE_RAMDISK: menuItem.ImageIndex := 4;
            else menuItem.ImageIndex := 5;
          end;
          menuItem.Hint := SC[1] + ':\';
          menuItem.OnClick := targetmenuclick.OnDriveClick;
          targetmenu.Items.Items[mindex].Add(menuItem);
        end;
      except
      end;
      {for i := 0 to 25 do
          if DriveExists(i) then
          begin
            menuItem := TMenuItem.Create(targetmenu);
            // menuItem.Caption := '[' + inttostr(i) + ':\] ' + GetDriveName(i) +' (' + DriveType(i) +')';
            case GetDriveType(PChar(Chr(i + Ord('A')) + ':\')) of
              DRIVE_UNKNOWN: menuItem.ImageIndex := 5;
              DRIVE_NO_ROOT_DIR: menuItem.ImageIndex := 5;
              DRIVE_REMOVABLE: menuItem.ImageIndex := 5;
              DRIVE_FIXED: menuItem.ImageIndex := 4;
              DRIVE_REMOTE: menuItem.ImageIndex := 5;
              DRIVE_CDROM: menuItem.ImageIndex := 3;
              DRIVE_RAMDISK: menuItem.ImageIndex := 4;
              else menuItem.ImageIndex := 5;
            end;
            menuItem.Caption := '[' + Chr(i + Ord('A')) + ':\] ' + DriveType(i);
            menuItem.Hint := Chr(i + Ord('A')) + ':\';
            menuItem.OnClick := targetmenuclick.OnDriveClick;

            targetmenu.Items.Items[mindex].Add(menuItem);
          end;  }
    end;

    if stiDirectory in TargetItems then
    begin
      // Directory  Menu
      menuItem := TMenuItem.Create(targetmenu);
      menuItem.Caption := 'Directory';
      targetmenu.Items.Add(menuItem);
      menuItem.ImageIndex := 6;
      mindex := mindex + 1;

      menuItem := TMenuItem.Create(targetmenu);
      menuItem.Caption := 'Open...';
      menuItem.ImageIndex := 2;
      menuItem.OnClick := targetmenuclick.OnDirOpenClick;//.OnFileOpenClick;//.;
      targetmenu.Items.Items[mindex].Add(menuItem);

      if stiShellFolders in TargetItems then
      begin
        menuItem := TMenuItem.Create(targetmenu);
        menuItem.Caption := '-';
        targetmenu.Items.Items[mindex].Add(menuItem);

        menuItem := TMenuItem.Create(targetmenu);
        menuItem.Caption := 'Shell Folder';
        menuItem.ImageIndex := 7;
        targetmenu.Items.Items[mindex].Add(menuItem);

        BuildShellFolderList(Slist);
        for n := 0 to SList.Count -1 do
        begin
          menuItem := TMenuItem.Create(targetmenu);
          menuItem.Caption := SList.ValueFromIndex[n];
          menuItem.Hint := SList.Names[n];
          menuItem.ImageIndex := 6;
          menuItem.OnClick := targetmenuclick.OnShellFolderClick;
          if (n mod 20  = 0) and (n > 0) then menuItem.Break := mbBarBreak;
          targetmenu.Items.Items[mindex].Items[targetmenu.Items.Items[mindex].Count-1].Add(menuItem);
        end;
      end;
      if stiSharpEFolders in TargetItems then
      begin
        SList.Clear;
        SList.Add('sharpe:globalsettings=Global Settings');
        SList.Add('sharpe:directory=SharpE Directory');
        SList.Add('sharpe:usersettings=User Settings');
        if not (stiShellFolders in TargetItems) then
        begin
          menuItem := TMenuItem.Create(targetmenu);
          menuItem.Caption := '-';
          targetmenu.Items.Items[mindex].Add(menuItem);
        end;
        menuItem := TMenuItem.Create(targetmenu);
        menuItem.Caption := 'SharpE Folder';
        menuItem.ImageIndex := 7;
        targetmenu.Items.Items[mindex].Add(menuItem);

        for n := 0 to SList.Count -1 do
        begin
          menuItem := TMenuItem.Create(targetmenu);
          menuItem.Caption := SList.ValueFromIndex[n];
          menuItem.Hint := SList.Names[n];
          menuItem.ImageIndex := 6;
          menuItem.OnClick := targetmenuclick.OnSharpEFolderClick;
          targetmenu.Items.Items[mindex].Items[targetmenu.Items.Items[mindex].Count-1].Add(menuItem);
        end;        
      end;
    end;

    if stiScript in TargetItems then
    begin
      // Scripts Menu
      menuItem := TMenuItem.Create(targetmenu);
      menuItem.Caption := 'Script';
      menuItem.ImageIndex := 10;
      targetmenu.Items.Add(menuItem);
      mindex := mindex + 1;

      Dir := SharpApi.GetSharpeUserSettingsPath + 'Scripts\';
      iScriptFiles := 0;
      if FindFirst(Dir + '*.sescript',FAAnyFile,sr) = 0 then
      repeat
        menuItem := TMenuItem.Create(targetmenu);
        s := sr.Name;
        setlength(s,length(s) - length('.sescript'));
        menuItem.Caption := s;
        menuItem.ImageIndex := 9;
        menuItem.Hint := Dir + sr.Name;
        menuItem.OnClick := targetmenuclick.OnScriptClick;
        targetmenu.Items.Items[mindex].Add(menuItem);
        iScriptFiles := iScriptFiles + 1;
      until FindNext(sr) <> 0;
      FindClose(sr);

      if iScriptFiles = 0 then // Remove Scripts menu if there are no items
        targetmenu.Items.Items[mindex].Visible := False;
    end;

    if stiAction in TargetItems then
    begin
      // Actions Menu
      menuItem := TMenuItem.Create(targetmenu);
      menuItem.Caption := 'Actions';
      menuItem.ImageIndex := 11;
      targetmenu.Items.Add(menuItem);
      mindex := mindex + 1;

      SList.Clear;
      SList.DelimitedText := SharpApiEx.GetDelimitedActionList;
      SList.Sort;
      s := '';
      for n := 0 to SList.Count - 1 do
      begin
        if CompareText(s,SList.Names[n]) <> 0 then
        begin
          s := SList.Names[n];
          menuItem := TMenuItem.Create(targetmenu);
          menuItem.Caption := s;
          menuItem.ImageIndex := 12;
          targetmenu.Items.Items[mindex].Add(menuitem);
        end;
        menuItem := TMenuItem.Create(targetmenu);
        menuItem.Caption := SList.ValueFromIndex[n];
        menuItem.Hint    := SList.ValueFromIndex[n];
        menuItem.OnClick := targetmenuclick.OnActionClick;
        menuItem.ImageIndex := 13;
        targetmenu.Items.Items[mindex].Items[targetmenu.Items.Items[mindex].Count -1 ].Add(menuItem);
      end;
    end;

    targetmenu.Popup(PopupPoint.X,PopupPoint.Y);

    // freeze until OnClick event is done;
    while nrevent do
    begin
      Application.ProcessMessages;
    end;

  finally
    FreeAndNil(SList);
    FreeAndNil(TargetMenu);
    FreeAndNil(targetmenuclick);
    FreeAndNil(iml);
  end;
  result := PChar(targetmenuresult);
end;

function IconDialog(pTarget : String; IconItems : TIconMenuSelectItems; PopupPoint : TPoint) : PChar;
var
  menuItem : TMenuItem;
  n : integer;
  mindex : integer;
  dir : String;
  iconmenuclick : TIconMenuClickHandler;
  iml : TPngImageList;
  subiml : TPngImageList;
  subgenericiml : TPngImageList;
  bmp : TBitmap;
  FileInfo : SHFILEINFO;
  ImageListHandle : THandle;
  WIcon : TIcon;
  s : string;
  Theme : ISharpETheme;
  sr : TSearchRec;
  filename,filetag : String;
  count,cstart : integer;
begin
  Iconmenuresult := '';
  Iconmenu := TPopupMenu.Create(nil);
  Iconmenuclick := TIconMenuClickHandler.Create;
  iml := TPngImageList.Create(nil);
  iml.Width := 16;
  iml.Height := 16;
  subiml := TPngImageList.Create(nil);
  subiml.Width := 16;
  subiml.Height := 16;
  subgenericiml := TPngImageList.Create(nil);
  subgenericiml.Width := 16;
  subgenericiml.Height := 16;
  Iconmenu.Images := iml;

  try

  // Build Image Lists
  Bmp := TBitmap.Create;
  try
  Bmp.Width := 16;
  Bmp.Height := 16;

  iml.Add(bmp,bmp);

  iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'cube16');
  iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'open16');
  iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'graph16');
  iml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'action16');

  iml.Add(bmp,bmp);

  Bmp.Width := 16;
  Bmp.Height := 16;
  subiml.Add(bmp,bmp);

  Bmp.Width := 16;
  Bmp.Height := 16;
  subgenericiml.Add(bmp,bmp);

  if smiShellIcon in IconItems then
  begin
    wIcon := TIcon.Create;
    ImageListHandle := 0;
    try
      ImageListHandle := SHGetFileInfo(pChar(pTarget), 0, FileInfo, sizeof( SHFILEINFO ),
                                      SHGFI_ICON or SHGFI_SMALLICON);
      if FileInfo.hicon <> 0 then
      begin
        wIcon.Handle := FileInfo.hicon;
        subiml.AddIcon(wIcon);
        wIcon.ReleaseHandle;
        DestroyIcon(FileInfo.hIcon);
      end else subiml.Add(bmp,bmp);
    except
      try
        subiml.PngImages.Add(False).PngImage.LoadFromResourceName(hinstance,'error22');
      finally
        ImageList_Destroy(ImageListHandle);
      end;
    end;
    wIcon.Free;
  end;

  Iconmenu.Items.Clear;
  mindex := -1;

  // two Dummy items! do not remove!
  menuItem := TMenuItem.Create(Iconmenu);
  Iconmenu.Items.Add(menuItem);
  menuItem.Visible := False;
  mindex := mindex + 1;

  menuItem := TMenuItem.Create(Iconmenu);
  menuItem.Visible := False;
  Iconmenu.Items.Add(menuItem);
  mindex := mindex + 1;

  if smiShellIcon in IconItems then
  begin
    // Files Menu
    menuItem := TMenuItem.Create(Iconmenu);
    menuItem.Caption := 'Shell Icon';
    menuItem.ImageIndex := 3;
    menuItem.SubMenuImages := subiml;
    Iconmenu.Items.Add(menuItem);
    mindex := mindex + 1;

    menuItem := TMenuItem.Create(Iconmenu);
    menuItem.Caption := 'Shell Icon';
    menuItem.OnClick := iconmenuclick.OnShellIconClick;
    menuItem.ImageIndex := 1;
    Iconmenu.Items.Items[mindex].Add(menuItem);
  end;

  if smiSharpEIcon in IconItems then
  begin
    menuItem := TMenuItem.Create(Iconmenu);
    menuItem.Caption := 'SharpE Icon';
    menuItem.ImageIndex := 1;
    menuItem.SubMenuImages := subiml;
    Iconmenu.Items.Add(menuItem);
    mindex := mindex + 1;

    Theme := GetCurrentTheme;
    Theme.LoadTheme([tpIconSet]);

    subiml.BeginUpdate;
    count := 0;
    cstart := subiml.count;
    for n := 0 to Theme.Icons.GetIconCount - 1 do
    begin
      s := Theme.Icons.GetIconFileSizesByIndex(n,16);

      if FileExists(s) then
      begin
        subiml.PngImages.Add(False).PngImage.LoadFromFile(s);

        s := ExtractFileName(s);
        filename := s;
        setlength(s,length(s) - length(ExtractFileExt(filename)));
        menuItem := TMenuItem.Create(Iconmenu);
        menuItem.Caption := s;
        menuItem.Hint := s;
        menuItem.OnClick := iconmenuclick.OnSharpEIconClick;
        menuItem.ImageIndex := count + cstart;
        count := count + 1;
        if (n mod 20  = 0) and (n > 0) then menuItem.Break := mbBarBreak;
        Iconmenu.Items.Items[mindex].Add(menuItem);
      end;
    end;
    subiml.EndUpdate(True);
  end;


  if smiGenericIcon in IconItems then
  begin
    menuItem := TMenuItem.Create(Iconmenu);
    menuItem.Caption := 'Generic Icon';
    menuItem.ImageIndex := 4;
    menuItem.SubMenuImages := subgenericiml;
    Iconmenu.Items.Add(menuItem);
    mindex := mindex + 1;

    n := 0;
    Dir := SharpApi.GetSharpeDirectory + 'Icons\Menu\';
    count := 0;
    cstart := subgenericiml.count;
    subgenericiml.BeginUpdate;
    if FindFirst(Dir + '*.png',faAnyFile,sr) = 0 then
    repeat
      filename := Dir + sr.Name;
      if FileExists(filename) then
      begin
          filetag := sr.Name;
          setlength(filetag,length(filetag) - length(ExtractFileExt(filetag)));
          filetag := 'generic.' + filetag;
          subgenericiml.PngImages.Add(False).PngImage.LoadFromFile(filename);
          menuItem := TMenuItem.Create(Iconmenu);
          menuItem.Caption := filetag;
          menuItem.Hint := filetag;
          menuItem.OnClick := iconmenuclick.OnSharpEIconClick;
          menuItem.ImageIndex := count + cstart;
          count := count + 1;
          if (n mod 20  = 0) and (n > 0) then menuItem.Break := mbBarBreak;
          Iconmenu.Items.Items[mindex].Add(menuItem);
          n := n + 1;
        end;
      until (FindNext(sr) <> 0);
      FindClose(sr);
    end;
    subgenericiml.EndUpdate(True);

    if smiCustomIcon in IconItems then
    begin
      menuItem := TMenuItem.Create(Iconmenu);
      menuItem.Caption := 'Custom Icon...';
      menuItem.ImageIndex := 2;
      menuItem.OnClick := iconmenuclick.OnCustomIconClick;
      menuItem.SubMenuImages := subiml;
      Iconmenu.Items.Add(menuItem);
      //mindex := mindex + 1;
    end;

    Bmp.Width := 16;
    Bmp.Height := 16;
    subiml.Add(bmp,bmp);

    Bmp.Width := 16;
    Bmp.Height := 16;
    subgenericiml.Add(bmp,bmp);
  finally
    Bmp.Free;
  end;

  Iconmenu.Popup(PopupPoint.X,PopupPoint.Y);

  // freeze until OnClick event is done;
  while nrevent do
  begin
    Application.ProcessMessages;
  end;

  finally
    FreeAndNil(IconMenu);
    FreeAndNil(subiml);
    FreeAndNil(subgenericiml);
    FreeAndNil(iml);
    FreeAndNil(Iconmenuclick);
  end;

  result := PChar(Iconmenuresult);
end;


Exports
  TargetDialog,
  //TargetDialogSkin,
  IconDialog;



procedure EntryPointProc(Reason: Integer);
begin
    case reason of
        DLL_PROCESS_ATTACH:
            begin
            end;

        DLL_PROCESS_DETACH:
            begin
            end;
    end;
end;

// we have to tell the DLL where our entry point proc is and call it as an attach
begin 
    DllProc := @EntryPointProc; 
    EntryPointProc(DLL_PROCESS_ATTACH); 
end.
