{
Source Name: SharpBarListEditWnd.pas
Description: SharpBarList Edit Window
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

unit uEditWnd;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Math,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  JvExControls,
  JvComponent,
  ImgList,
  PngImageList,
  JvExStdCtrls,
  JvEdit,
  JvValidateEdit,
  JvValidators,
  JvComponentBase,
  JvErrorIndicator,
  ExtCtrls,
  JvPageList,
  JclSimpleXml,
  SharpApi,
  JclStrings,
  SharpCenterApi,
  SharpThemeApiEx,
  SharpEListBoxEx,
  uListWnd,
  uSharpBar,
  uThemeConsts,

  ISharpCenterHostUnit,
  ISharpCenterPluginUnit, SharpEGaugeBoxEdit, JvXPCore, JvXPCheckCtrls;

type
  TfrmEditwnd = class(TForm)
    errorinc: TJvErrorIndicator;
    pilError: TPngImageList;
    edName: TEdit;
    cobo_monitor: TComboBox;
    cbBasedOn: TComboBox;
    cobo_valign: TComboBox;
    cobo_halign: TComboBox;
    JvLabel2: TLabel;
    JvLabel1: TLabel;
    Label3: TLabel;
    pnlBarSpace: TPanel;
    Label1: TLabel;
    JvLabel4: TLabel;
    cbFixedWidth: TJvXPCheckbox;
    sgbFixedWidth: TSharpeGaugeBox;
    chkAutoHide: TJvXPCheckbox;
    sgbAutoHide: TSharpeGaugeBox;
    Label2: TLabel;
    Panel1: TPanel;
    chkShowThrobber: TJvXPCheckbox;
    chkAlwaysOnTop: TJvXPCheckbox;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Label4: TLabel;
    cobo_design: TComboBox;

    procedure cbBasedOnSelect(Sender: TObject);

    procedure edThemeNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure cbFixedWidthClick(Sender: TObject);
    procedure sgbFixedWidthChangeValue(Sender: TObject; Value: Integer);
    procedure chkAutoHideClick(Sender: TObject);
    procedure chkShowThrobberClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FBars: TBarItems;
    FOrigName: String;

    // Pointer to Bar Item in listwnd
    FBarItem: TBarItem;
    FUpdating: Boolean;
    FPluginHost: ISharpCenterHost;
    { Private declarations }
  public
    { Public declarations }
    procedure BuildMonList;
    procedure ClearMonList;
    function ValidateWindow(AEditMode: TSCE_EDITMODE_ENUM): Boolean;
    procedure ClearValidation;

    property BarItem: TBarItem read FBarItem write FBarItem;

    procedure Init;
    procedure Save;

    procedure ValidateNameEvent(Sender: TObject; Value: Variant; var Valid: Boolean);

    property PluginHost: ISharpCenterHost read FPluginHost write FPluginHost;
  end;

type
  TIntObject = class
    Value: Integer;
    constructor Create(pValue: integer);
  end;

var
  frmEditwnd: TfrmEditwnd;

implementation

uses
  uSharpXMLUtils;

{$R *.dfm}

procedure TfrmEditwnd.Init;
var
  tmpItem: TSharpEListItem;
  tmpBar: TBarItem;
  n: integer;
  SkinFile : String;
  XML : TJclSimpleXML;
  defaultDesign : integer;
begin
  // load list of skin designs
  SharpThemeApiEx.GetCurrentTheme.LoadTheme([tpSkinScheme]);
  SkinFile := SharpThemeApiEx.GetCurrentTheme.Skin.Directory + 'Skin.xml';
  XML := TJclSimpleXML.Create;
  cobo_design.Items.Clear;
  defaultDesign := 0;
  try
    if FileExists(SkinFile) then
    begin
      XML.LoadFromFile(SkinFile);
      for n := 0 to XML.Root.Items.Count - 1 do
        if CompareText(XML.Root.Items.Item[n].Name,'SkinDesign') = 0 then
        with XML.Root.Items.Item[n] do
        begin
          cobo_design.Items.Add(Properties.Value('Name','Default'));
          if Properties.BoolValue('Default', False) then
            defaultDesign := cobo_design.Items.Count - 1;
        end;
    end;
  finally
    XML.Free;
  end;
  if cobo_design.Items.Count = 0 then
  begin
    cobo_design.Items.Add('Default');
    cobo_design.ItemIndex := 0;
  end else
    cobo_design.ItemIndex := defaultDesign;
  cobo_design.Enabled := (cobo_design.Items.Count > 1);

  FBars.Update;

  FUpdating := True;
  try

    case FPluginHost.EditMode of
      sceAdd: begin

          if not (frmListWnd.BarSpaceCheck) then
          begin
            pnlBarSpace.Width := Self.Width;
            pnlBarSpace.Height := Self.Height;
            Label1.Width := Self.Width;
            Label1.Height := Self.Height;
            pnlBarSpace.Show;
            Exit;
          end;

          pnlBarSpace.Hide;
          pnlBarSpace.Width := 0;
          pnlBarSpace.Height := 0;
          edName.Text := '';

          cbBasedOn.Items.Clear;
          cbBasedOn.Items.AddObject('New Bar', nil);

          // Build based on list
          for n := 0 to frmListWnd.lbBarList.Count - 1 do
          begin
            if not Assigned(frmListWnd.lbBarList.Item[n].Data) then
              continue;
              
            tmpBar := TBarItem(frmListWnd.lbBarList.Item[n].Data);
            cbBasedOn.Items.AddObject(tmpBar.Name, tmpBar);
          end;

          cbBasedOn.ItemIndex := 0;
          cbBasedOn.Enabled := True;
          FBarItem := nil;

          BuildMonList;
          cobo_monitor.ItemIndex := 0;
          edName.SetFocus;
        end;
      sceEdit: begin
          if frmListWnd.lbBarList.ItemIndex <> -1 then
          begin
            pnlBarSpace.Hide;
            pnlBarSpace.Width := 0;
            pnlBarSpace.Height := 0;
            tmpItem := frmListWnd.lbBarList.SelectedItem;
            if tmpItem.Data = nil then
              Exit;

            FBarItem := TBarItem(tmpItem.Data);

            edName.Text := FBarItem.Name;
            edName.SetFocus;

            BuildMonList;
            if FBarItem.PMonitor then
              cobo_monitor.ItemIndex := 0
            else
              cobo_monitor.ItemIndex := Min(abs(FBarItem.Monitor), cobo_monitor.Items.Count - 1);
            cobo_valign.ItemIndex := FBarItem.VPos;
            cobo_halign.ItemIndex := FBarItem.HPos;

            sgbFixedWidth.Value := FBarItem.FixedWidth;
            cbFixedWidth.Checked := FBarITem.FixedWidthEnabled;

            chkAutoHide.Checked := FBarItem.AutoHide;
            if FBarITem.AutoHideTime > 0 then
              sgbAutoHide.Value := FBarITem.AutoHideTime div 1000;

            cbBasedOn.Items.Clear;
            cbBasedOn.Items.AddObject('Not Applicable', nil);
            cbBasedOn.ItemIndex := 0;
            cbBasedOn.Enabled := False;

            chkAlwaysOnTop.Checked := FBarItem.AlwaysOnTop;
            chkShowThrobber.Checked := FBarItem.ShowThrobber;

            if cobo_design.Items.IndexOf(FBarItem.SkinDesign) >= 0 then
              cobo_design.ItemIndex := cobo_design.Items.IndexOf(FBarItem.SkinDesign);
          end;
        end;
    end;
  finally
    cbFixedWidthClick(nil);
    FUpdating := False;

    FOrigName := '';
    if Assigned(FBarItem) then
      FOrigName := FBarItem.Name;
  end;
end;

procedure TfrmEditwnd.Save;
var
  dir: string;
  newId: string;
  copyId: integer;
  n: integer;
  wnd: hwnd;
  sr: TSearchRec;
  newItem: TBarItem;
begin
  dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\';

  case FPluginHost.EditMode of
    sceAdd: begin
        // Generate a new unique bar ID and make sure that there is no other
        // bar with the same ID
        repeat
          newId := '';
          for n := 1 to 8 do
            newId := newId + inttostr(random(9) + 1);
        until not DirectoryExists(dir + newId);

        CreateDirectory(PChar(dir + newId), nil);

        if cbBasedOn.ItemIndex > 0 then begin
          copyId := TBarItem(cbBasedOn.Items.Objects[cbBasedOn.ItemIndex]).BarID;

          if FindFirst(dir + inttostr(copyId) + '\*.xml', FAAnyFile, sr) = 0 then
            repeat
              if FileExists(dir + inttostr(copyId) + '\' + sr.Name) then
                CopyFile(PChar(dir + inttostr(copyId) + '\' + sr.Name),
                  PChar(dir + newId + '\' + sr.Name), True);
            until FindNext(sr) <> 0;
          FindClose(sr);
        end;

        newItem := TBarItem.Create(StrToInt(newID));
        try
          newItem.BarID := StrToInt(newID);
          newItem.Name := edName.Text;
          newItem.ShowThrobber := chkShowThrobber.Checked;
          newItem.PMonitor := (cobo_monitor.ItemIndex = 0);
          newItem.Monitor := TIntObject(cobo_monitor.Items.Objects[cobo_monitor.ItemIndex]).Value;
          newItem.HPos := cobo_halign.ItemIndex;
          newItem.VPos := cobo_valign.ItemIndex;
          newItem.FixedWidth := sgbFixedWidth.Value;
          newItem.FixedWidthEnabled := cbFixedWidth.Checked;
          newItem.AutoHide := chkAutoHide.Checked;
          newItem.AutoHideTime := sgbAutoHide.Value * 1000;
          newItem.SkinDesign := cobo_design.Text;

          newItem.Save;
        finally
          newItem.Free;
        end;

        // Send update message
        SharpApi.SharpEBroadCast(WM_BARUPDATED, 0, StrToInt(newId));
      end;
    sceEdit:
      begin
        FBarItem.Name := edName.Text;
        FBarItem.ShowThrobber := chkShowThrobber.Checked;
        FBarItem.PMonitor := (cobo_monitor.ItemIndex = 0);
        FBarItem.Monitor := TIntObject(cobo_monitor.Items.Objects[cobo_monitor.ItemIndex]).Value;
        FBarItem.HPos := cobo_halign.ItemIndex;
        FBarItem.VPos := cobo_valign.ItemIndex;
        FBarItem.FixedWidth := sgbFixedWidth.Value;
        FBarItem.FixedWidthEnabled := cbFixedWidth.Checked;
        FBarItem.AlwaysOnTop := chkAlwaysOnTop.Checked;
        FBarItem.AutoHide := chkAutoHide.Checked;
        FBarItem.AutoHideTime := sgbAutoHide.Value * 1000;
        FBarItem.SkinDesign := cobo_design.Text;

        FBarItem.Save;

        // Send update message
        SharpApi.SharpEBroadCast(WM_BARUPDATED, 0, FBarItem.BarID);
      end;
  end;

  if FPluginHost.EditMode = sceAdd then
    SharpApi.SharpExecute('_nohist,' + SharpApi.GetSharpeDirectory + 'SharpBar.exe' +
      ' -load:' + newId +
      ' -noREB' +
      ' -noLASB')
  else if FPluginHost.EditMode = sceEdit then begin
    wnd := FindWindow(nil, PChar('SharpBar_' + inttostr(FBarItem.BarID)));
    if wnd <> 0 then
      SendMessage(wnd, WM_BARREPOSITION, 0, 0);
  end;

  frmListWnd.tmrUpdate.Enabled := True;
end;

procedure TfrmEditwnd.sgbFixedWidthChangeValue(Sender: TObject; Value: Integer);
begin
  if not (FUpdating) then
    FPluginHost.Editing := true;
end;

procedure TfrmEditwnd.BuildMonList;
var
  n: integer;
  s: string;
  Mon: TMonitor;
begin
  ClearMonList;
  for n := 0 to Screen.MonitorCount - 1 do
  begin
    Mon := Screen.Monitors[n];

    if Mon.Primary then
      s := 'Primary'
    else
      s := inttostr(Mon.MonitorNum);
    s := s + ' (' + inttostr(Mon.Width) + 'x' + inttostr(Mon.Height) + ')';
    cobo_monitor.Items.AddObject(s, TIntObject.Create(Mon.MonitorNum));

    if Mon.Primary then
      cobo_monitor.Items.Move(n, 0);
  end;
end;

procedure TfrmEditwnd.edThemeNameKeyPress(Sender: TObject; var Key: Char);
begin
  if not (FUpdating) then
    FPluginHost.Editing := true;
end;

procedure TfrmEditwnd.FormCreate(Sender: TObject);
begin
  FBars := TBarItems.Create;
end;

procedure TfrmEditwnd.FormDestroy(Sender: TObject);
begin
  ClearMonList;
end;

function TfrmEditwnd.ValidateWindow(AEditMode: TSCE_EDITMODE_ENUM): Boolean;
begin
  Result := True;
  
  errorinc.BeginUpdate;
  try
    errorinc.ClearErrors;
  finally
    errorinc.EndUpdate;
  end;
end;

procedure TfrmEditwnd.cbBasedOnSelect(Sender: TObject);
begin
  if not (FUpdating) then
    FPluginHost.Editing := true;
end;

procedure TfrmEditwnd.cbFixedWidthClick(Sender: TObject);
var
  i : integer;
begin
  sgbFixedWidth.Enabled := cbFixedWidth.Checked;

  i := cobo_halign.ItemIndex;
  if cbFixedWidth.Checked then
  begin
    cobo_halign.Items.Clear;
    cobo_halign.Items.Add('Left');
    cobo_halign.Items.Add('Middle');
    cobo_halign.Items.Add('Right');
    if i = 3 then
      cobo_halign.ItemIndex := 1
    else cobo_halign.ItemIndex := i;
  end
  else begin
    cobo_halign.Items.Clear;
    cobo_halign.Items.Add('Left');
    cobo_halign.Items.Add('Middle');
    cobo_halign.Items.Add('Right');
    cobo_halign.Items.Add('Full Screen');
    cobo_halign.ItemIndex := i;
  end;

  if not (FUpdating) then
    FPluginHost.Editing := true;  
end;

procedure TfrmEditwnd.chkAutoHideClick(Sender: TObject);
begin
  sgbAutoHide.Enabled := chkAutoHide.Checked;

  if not (FUpdating) then
    FPluginHost.Editing := true;
end;

procedure TfrmEditwnd.chkShowThrobberClick(Sender: TObject);
begin
  if not (FUpdating) then
    FPluginHost.Editing := true;
end;

procedure TfrmEditwnd.ClearMonList;
var
  n: integer;
begin
  for n := 0 to cobo_monitor.Items.Count - 1 do
    TIntObject(cobo_monitor.Items.Objects[n]).Free;
  cobo_monitor.Items.Clear;
end;

procedure TfrmEditwnd.ClearValidation;
begin
  errorinc.BeginUpdate;
  try
    errorinc.ClearErrors;
  finally
    errorinc.EndUpdate;
  end;
end;

procedure TfrmEditwnd.ValidateNameEvent(Sender: TObject; Value: Variant; var Valid: Boolean);
var
  name: string;
  i : integer;
begin
  Valid := True;

  // Make sure no other bar exists the same name
  name := Value;

  // Use ErrorMessage as a placeholder for the original name
  if name = FOrigName then
    Exit;

  if Length(Trim(name)) = 0 then
  begin
    MessageBox(frmEditWnd.Handle, 'Please enter a valid name.', 'Change Name', MB_OK);
    Valid := False;
    Exit;
  end;

  for i := 0 to FBars.Count - 1 do
  begin
    if name = FBars.Bars[i].Name then
      Valid := False;
  end;

  if not Valid then
    MessageBox(frmEditWnd.Handle, PChar('A bar with the name ''' + name + ''' already exists.' + sLineBreak + 'Please choose another name.'), 'Change Name', MB_OK);
end;

{ TIntObject }

constructor TIntObject.Create(pValue: integer);
begin
  inherited Create;

  Value := pValue;
end;

end.

