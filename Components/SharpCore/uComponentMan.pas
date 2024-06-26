unit uComponentMan;

interface
uses
  Windows,
  SharpAPI,
  Classes,
  SysUtils;

type

  PComponentData = ^TComponentData;
  TComponentData = class(TObject)
  private
    function GetHasConfig: Boolean;
    function GetDisabled: Boolean;
    procedure SetDisabled(const Value: Boolean);
  public
    MetaData: TMetaData;
    ExtraMetaData: TExtraMetaData;
    ID: Integer;
    FileName: string;
    FileHandle: THandle;
    Running: Boolean;
    Stopping: Boolean;

    constructor Create(from: TComponentData); overload;

    property HasConfig: Boolean read GetHasConfig;
    property Disabled: Boolean read GetDisabled write SetDisabled;

    function IsRunning: Boolean;
  end;

  PComponentList = ^TComponentList;
  TComponentList = class(TList) //this is our list of components and services
  public
    destructor Destroy; override;
    function Add(Item: TComponentData): Integer;
    function BuildList(strExtension: string; buildComponents: Boolean = True; getComponentData: Boolean = True): Integer;
    function FindByName(Name: string): Integer;
    function FindByID(ID: Integer): Integer;
  end;

function RemoveSpaces(Input: string): string;
function CustomSort(AItem1, AItem2:Pointer):Integer;

implementation

function CustomSort(AItem1, AItem2:Pointer):Integer;
var
  tmp1,tmp2: TComponentData;
begin
  tmp1 := TComponentData(AItem1);
  tmp2 := TComponentData(AItem2);
  Result := CompareText(tmp1.MetaData.Name,tmp2.MetaData.Name);
end;


function RemoveSpaces(Input: string): string;
const
  Remove = [' ', #13, #10];
var
  i: integer;
begin
  result := '';
  for i := 1 to Length(Input) do begin
    if not (Input[i] in Remove) then
      result := result + Input[i];
  end;
end;

function CheckLocation(Item1, Item2: TComponentData): Integer; //function to sort by priority
begin
  result := 0;
  if Item1.ExtraMetaData.Priority < Item2.ExtraMetaData.Priority then
    result := -1
  else if Item1.ExtraMetaData.Priority = Item2.ExtraMetaData.Priority then
    result := 0
  else if Item1.ExtraMetaData.Priority > Item2.ExtraMetaData.Priority then
    result := 1;
end;

function TComponentList.FindByName(Name: string): Integer;
var
  i: Integer;
begin
  result := -1;
  for i := 0 to Count - 1 do begin
    if LowerCase(TComponentData(Items[i]).MetaData.Name) = LowerCase(Name) then
      result := i;
  end;
  if result = -1 then // if it didn't find it, let's check for it with spaces removed
    for i := 0 to Count - 1 do {// for the sake of backwards compatibility} begin
      if LowerCase(RemoveSpaces(TComponentData(Items[i]).MetaData.Name)) = LowerCase(Name) then
        result := i;
    end;
end;

function TComponentList.FindByID(ID: Integer): Integer;
var
  i: Integer;
begin
  result := -1;
  for i := 0 to Count - 1 do begin
    if TComponentData(Items[i]).ID = ID then
      result := i;
  end;
end;

function TComponentList.Add(Item: TComponentData): Integer;
begin
  result := 0;
  inherited Add(Item); //add item
  inherited Sort(@CheckLocation); //sort the list
end;

function TComponentList.BuildList(strExtension: string; buildComponents: Boolean = True; getComponentData: Boolean = True): Integer;
var
  intFound: Integer;
  srFile: TSearchRec;
  cdComponent: TComponentData;
  sPath: string;
  I : Integer;
  buf : array[0..MAX_PATH] of char;
begin
  GetModuleFileName(0, buf, SizeOf(buf));

  for I := Count - 1 downto 0 do
    TComponentData(Items[I]).Free;

  // Clear items first
  Self.Clear;

  sPath := GetSharpeDirectory + 'Services\';
  intFound := FindFirst(sPath + '*' + strExtension, faAnyFile, srFile); //first we loop through the services
  while intFound = 0 do begin

    if SharpApi.CheckMetaDataVersion(sPath + srFile.Name) then
    begin
      cdComponent := TComponentData.Create;
      cdComponent.FileName := sPath + srFile.Name;
      if getComponentData then
        GetServiceMetaData(sPath + srFile.Name, cdComponent.MetaData, cdComponent.ExtraMetaData);
      cdComponent.ID := Count + 50; //add 50 to ID to make sure it's unique

      Add(cdComponent);
    end else
          SharpApi.SendDebugMessage('ComponentList', 'Not adding Service ' + srFile.Name + ' - Outdated', 0);

    intFound := FindNext(srFile);
  end;
  FindClose(srFile);

  if buildComponents then begin
    sPath := GetSharpeDirectory;
    intFound := FindFirst(sPath + '*.exe', faAnyFile, srFile); //then we loop through components
    while intFound = 0 do begin
      if AnsiCompareStr(buf, SharpApi.GetSharpeDirectory + srFile.Name) <> 0 then
      begin
        if CheckMetaDataVersion(sPath + srFile.Name) then
        begin
          cdComponent := TComponentData.Create;
          cdComponent.FileName := sPath + srFile.Name;
          //wrap in an if statement so we don't get blank entries for non-sharpe executables that might be in the folder
          if GetComponentMetaData(sPath + srFile.Name, cdComponent.MetaData, cdComponent.ExtraMetaData) = 0 then begin
            cdComponent.ID := Count + 50;
            Add(cdComponent);
          end;
        end else
          SharpApi.SendDebugMessage('ComponentList', 'Not adding Component ' + srFile.Name + ' - Outdated', 0);
      end;
      intFound := FindNext(srFile);
    end;
    FindClose(srFile);
  end;

  result := Count;
end;

destructor TComponentList.Destroy;
var
  n : integer;
begin
  for n := Count -1 Downto 0 do
  begin
    TComponentData(Items[n]).Free;
    Delete(n);
  end;

  inherited Destroy;
end;

{ TComponentData }

constructor TComponentData.Create(from: TComponentData);
begin
  inherited Create;

  MetaData := from.MetaData;
  ExtraMetaData := from.ExtraMetaData;
  ID := from.ID;
  FileName := PChar(from.FileName);
  FileHandle := from.FileHandle;
  Running := from.Running;
  Stopping := from.Stopping;
end;

function TComponentData.GetDisabled: Boolean;
var
  sService, sDisabledDir: string;
begin
  sService := RemoveSpaces(MetaData.Name);
  sDisabledDir := GetSharpeUserSettingsPath + 'SharpCore\Disabled\';
  Result := False;

  if (FileExists(sDisabledDir + sService)) then
    Result := True;
end;

function TComponentData.GetHasConfig: Boolean;
var
  sConfigDir: string;

begin
  Result := False;
  sConfigDir := GetCenterDirectory + 'Services\';
  if FileExists(sConfigDir + MetaData.Name + SharpApi.GetCenterConfigExt) then
    Result := True;
end;

function TComponentData.IsRunning: Boolean;
var
  sName: string;
begin
  result := False;
  sName := MetaData.Name;
  if (SharpApi.IsServiceStarted(pchar(sName)) = MR_STARTED) then
    result := True;
end;

procedure TComponentData.SetDisabled(const Value: Boolean);
var
  sService, sDisabledDir: string;
begin
  sService := RemoveSpaces(MetaData.Name);
  sDisabledDir := GetSharpeUserSettingsPath + 'SharpCore\Disabled\';

  if not (DirectoryExists(sDisabledDir)) then
    ForceDirectories(sDisabledDir);

  if Value then begin
    FileClose(FileCreate(sDisabledDir + sService));
  end
  else begin
    DeleteFile(sDisabledDir + sService);
  end;
end;

end.

