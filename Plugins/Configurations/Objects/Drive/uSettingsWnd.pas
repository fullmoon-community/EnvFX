﻿{
Source Name: uSettingsWnd.pas
Description: Drive Object Settings Window
Copyright (C) Mathias Tillman (mathias@sharpenviro.com)

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

unit uSettingsWnd;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  JclSimpleXML,
  JclFileUtils,
  ImgList,
  PngImageList,
  SharpEListBox,
  SharpEListBoxEx,
  GR32,
  GR32_PNG,
  SharpApi,
  ExtCtrls,
  Menus,
  JclStrings,
  GR32_Image,
  SharpEGaugeBoxEdit,
  SharpEUIC,
  SharpEFontSelectorFontList,
  JvPageList,
  JvExControls,
  SharpEPageControl,
  ComCtrls,
  Mask,
  JvExMask,
  JvToolEdit,
  SharpEColorEditorEx,
  SharpDialogs,
  SharpERoundPanel,
  SharpIconUtils,
  JvExStdCtrls,
  JvCheckBox,
  SharpESwatchManager,
  SharpCenterApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  JvXPCore,
  JvXPCheckCtrls,
  Buttons,
  PngSpeedButton,
  pngimage,
  SharpECenterHeader,
  SharpCenterThemeApi;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

  TSkinItem = class
  private
    FAuthor: string;
    FName: string;
    FWebsite: string;
    FComment: string;
    FSkinName: string;
  public
    property Name: string read FName write FName;
    property Author: string read FAuthor write FAuthor;
    property Website: string read FWebsite write FWebsite;
    property Comment: string read FComment write FComment;
    property SkinName: string read FSkinName write FSkinName;
  end;

type
  TfrmSettings = class(TForm)
    plMain: TJvPageList;
    pagDrive: TJvStandardPage;
    Panel69: TPanel;
    pagIcon: TJvStandardPage;
    Panel1: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    uicIconSize: TSharpEUIC;
    uicIconBlend: TSharpEUIC;
    uicIconShadow: TSharpEUIC;
    uicIconAlpha: TSharpEUIC;
    uicIconBlendAlpha: TSharpEUIC;
    sgbIconBlendAlpha: TSharpeGaugeBox;
    uicIconShadowAlpha: TSharpEUIC;
    sgbIconShadowAlpha: TSharpeGaugeBox;
    uicIconAlphaValue: TSharpEUIC;
    sgbIconAlpha: TSharpeGaugeBox;
    uicIconBlendColor: TSharpEUIC;
    sceIconBlendColor: TSharpEColorEditorEx;
    uicIconShadowColor: TSharpEUIC;
    sceIconShadowColor: TSharpEColorEditorEx;
    pagFont: TJvStandardPage;
    uicFontName: TSharpEUIC;
    cboFontName: TComboBox;
    uicTextSize: TSharpEUIC;
    uicTextAlpha: TSharpEUIC;
    uicTextAlphaValue: TSharpEUIC;
    sgbTextAlphaValue: TSharpeGaugeBox;
    uicTextUnderline: TSharpEUIC;
    uicTextItalic: TSharpEUIC;
    uicTextBold: TSharpEUIC;
    uicTextColor: TSharpEUIC;
    sceTextColor: TSharpEColorEditorEx;
    pagFontShadow: TJvStandardPage;
    pnlTextShadow: TPanel;
    uicTextShadow: TSharpEUIC;
    uicTextShadowType: TSharpEUIC;
    cboTextShadowType: TComboBox;
    uicTextShadowAlpha: TSharpEUIC;
    sgbTextShadowAlpha: TSharpeGaugeBox;
    uicTextShadowColor: TSharpEUIC;
    sceTextShadowColor: TSharpEColorEditorEx;
    SharpESwatchManager1: TSharpESwatchManager;
    imlFontIcons: TPngImageList;
    chkCaption: TJvXPCheckbox;
    chkIconAlpha: TJvXPCheckbox;
    chkIconBlendAlpha: TJvXPCheckbox;
    chkIconShadowAlpha: TJvXPCheckbox;
    chkTextAlpha: TJvXPCheckbox;
    chkTextUnderline: TJvXPCheckbox;
    chkTextItalic: TJvXPCheckbox;
    chkTextBold: TJvXPCheckbox;
    chkTextShadow: TJvXPCheckbox;
    pnlOverride: TPanel;
    Image1: TImage;
    Label6: TLabel;
    btnRevert: TPngSpeedButton;
    SharpECenterHeader1: TSharpECenterHeader;
    SharpECenterHeader5: TSharpECenterHeader;
    SharpERoundPanel1: TSharpERoundPanel;
    icon32: TImage32;
    rdoIcon32: TJvXPCheckbox;
    SharpERoundPanel2: TSharpERoundPanel;
    icon48: TImage32;
    rdoIcon48: TJvXPCheckbox;
    SharpERoundPanel3: TSharpERoundPanel;
    Icon64: TImage32;
    rdoIcon64: TJvXPCheckbox;
    SharpERoundPanel4: TSharpERoundPanel;
    sgbIconSize: TSharpeGaugeBox;
    rdoIconCustom: TJvXPCheckbox;
    SharpECenterHeader7: TSharpECenterHeader;
    SharpECenterHeader8: TSharpECenterHeader;
    SharpECenterHeader3: TSharpECenterHeader;
    pnlIcon: TPanel;
    SharpECenterHeader9: TSharpECenterHeader;
    pnlDrive: TPanel;
    pnlFontShadow: TPanel;
    SharpECenterHeader4: TSharpECenterHeader;
    SharpECenterHeader10: TSharpECenterHeader;
    SharpECenterHeader11: TSharpECenterHeader;
    SharpECenterHeader12: TSharpECenterHeader;
    pnlFont: TPanel;
    SharpECenterHeader13: TSharpECenterHeader;
    SharpECenterHeader14: TSharpECenterHeader;
    SharpECenterHeader15: TSharpECenterHeader;
    SharpECenterHeader16: TSharpECenterHeader;
    SharpECenterHeader17: TSharpECenterHeader;
    SharpECenterHeader2: TSharpECenterHeader;
    Panel3: TPanel;
    btnSelectIcon: TPngSpeedButton;
    edtIcon: TEdit;
    SharpECenterHeader6: TSharpECenterHeader;
    StaticText1: TStaticText;
    Panel2: TPanel;
    cbDriveList: TComboBox;
    sgbTextSize: TSharpeGaugeBox;
    procedure FormCreate(Sender: TObject);
    procedure chkCaptionClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure chkIconBlendAlphaClick(Sender: TObject);
    procedure chkIconShadowAlphaClick(Sender: TObject);
    procedure chkIconAlphaClick(Sender: TObject);
    procedure sgbIconBlendAlphaChangeValue(Sender: TObject; Value: Integer);
    procedure sgbIconShadowAlphaChangeValue(Sender: TObject; Value: Integer);
    procedure sgbIconAlphaChangeValue(Sender: TObject; Value: Integer);
    procedure rdoIcon32Click(Sender: TObject);
    procedure rdoIcon48Click(Sender: TObject);
    procedure rdoIcon64Click(Sender: TObject);
    procedure rdoIconCustomClick(Sender: TObject);
    procedure sgbIconSizeChangeValue(Sender: TObject; Value: Integer);
    procedure uicIconSizeReset(Sender: TObject);
    procedure uicIconBlendReset(Sender: TObject);
    procedure sceIconBlendColorChangeColor(ASender: TObject; AValue: Integer);
    procedure sceIconShadowColorChangeColor(ASender: TObject; AValue: Integer);
    procedure cboFontNameDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cboFontNameChange(Sender: TObject);
    procedure uicFontNameReset(Sender: TObject);
    procedure sgbTextSizeChangeValue(Sender: TObject; Value: Integer);
    procedure chkTextAlphaClick(Sender: TObject);
    procedure uicTextAlphaReset(Sender: TObject);
    procedure sgbTextAlphaValueChangeValue(Sender: TObject; Value: Integer);
    procedure chkTextBoldClick(Sender: TObject);
    procedure chkTextItalicClick(Sender: TObject);
    procedure chkTextUnderlineClick(Sender: TObject);
    procedure uicTextColorClick(Sender: TObject);
    procedure sceTextColorChangeColor(ASender: TObject; AValue: Integer);
    procedure chkTextShadowClick(Sender: TObject);
    procedure uicTextShadowTypeReset(Sender: TObject);
    procedure cboTextShadowTypeChange(Sender: TObject);
    procedure sgbTextShadowAlphaChangeValue(Sender: TObject; Value: Integer);
    procedure sceTextShadowColorChangeColor(ASender: TObject; AValue: Integer);
    procedure uicTextShadowReset(Sender: TObject);
    procedure btnRevertClick(Sender: TObject);
    procedure lbSkinsGetCellText(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
    procedure lbSkinsGetCellImageIndex(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
    procedure lbSkinsGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure lbSkinsClickItem(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem);
    procedure cbDriveListSelect(Sender: TObject);
    procedure sceColorExpandCollapse(ASender: TObject);
    procedure btnSelectIconClick(Sender: TObject);
    procedure edtIconChange(Sender: TObject);
    procedure sceExpandCollapse(ASender: TObject);
  private
    FBlue32, FBlue48, FBlue64: TBitmap32;
    FWhite32, FWhite48, FWhite64: TBitmap32;
    FFontList: TFontList;
    FPluginHost: ISharpCenterHost;
    FDriveLetter: string;
    procedure RefreshFontList;
    procedure UpdateIcon;
    procedure SendUpdate;
    procedure LoadResources;

    procedure SetDriveList;
    procedure ClearList;
  public
    sObjectID: string;
    procedure UpdateIconPage;
    procedure UpdateFontPage;
    procedure UpdateFontShadowPage;
    procedure UpdatePageUI;
    procedure UpdateDrivePage;

    property FontList: TFontList read FFontList;
    property DriveLetter: string read FDriveLetter write FDriveLetter;

    property PluginHost: ISharpCenterHost read FPluginHost
      write FPluginHost;
  end;

var
  frmSettings: TfrmSettings;

const
  cIconSize32 = 32;
  cIconSize48 = 48;
  cIconSize64 = 64;

implementation

{$R *.dfm}

procedure LoadBmpFromRessource(Bmp: TBitmap32; ResName: string);
var
  ResStream: TResourceStream;
  TempBmp: TBitmap32;
  b: boolean;
begin
  if Bmp = nil then exit;

  Bmp.DrawMode := dmBlend;
  Bmp.CombineMode := cmMerge;

  TempBmp := TBitmap32.Create;
  TempBmp.SetSize(22, 22);
  TempBmp.Clear(color32(0, 0, 0, 0));

  TempBmp.DrawMode := dmBlend;
  TempBmp.CombineMode := cmMerge;

  try
    ResStream := TResourceStream.Create(HInstance, ResName, RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp, ResStream, b);
      Bmp.Assign(tempBmp);
    finally
      ResStream.Free;
    end;
  except
  end;

  TempBmp.Free;
end;

procedure TfrmSettings.btnSelectIconClick(Sender: TObject);
var
  s: string;
begin
  s := SharpDialogs.IconDialog(cbDriveList.Text, SMI_ALL_ICONS, Mouse.CursorPos);
  if length(trim(s)) > 0 then
  begin
    edtIcon.Text := s;
    UpdateIcon;
  end;
end;

procedure TfrmSettings.cbDriveListSelect(Sender: TObject);
begin
  FDriveLetter := cbDriveList.Items[cbDriveList.ItemIndex][1];

  SendUpdate;
end;

procedure TfrmSettings.cboFontNameChange(Sender: TObject);
begin
  UICFontName.UpdateStatus;
  SendUpdate;
end;

procedure TfrmSettings.cboFontNameDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  fi: TFontInfo;
  imageindex: integer;
  textheight: integer;
begin
  cboFontName.canvas.fillrect(rect);
  fi := TFontInfo(cboFontName.Items.Objects[Index]);

  imageindex := -1;
  case fi.FontType of
    ftTrueType: imageindex := 0;
  end;

  imlFontIcons.Draw(cboFontName.Canvas, rect.left, rect.top + 1, imageindex);

  cboFontName.Canvas.Font.Name := fi.ShortName;
  textheight := cboFontName.Canvas.TextHeight(fi.FullName);

  if textheight > cboFontName.ItemHeight then
    cboFontName.Canvas.Font.Name := 'Arial';

  cboFontName.canvas.textout(rect.left + imlFontIcons.width + 2, rect.top, fi.FullName);
end;

procedure TfrmSettings.cboTextShadowTypeChange(Sender: TObject);
begin
  uicTextShadowType.UpdateStatus;
  SendUpdate;
end;

procedure TfrmSettings.btnRevertClick(Sender: TObject);
var
  i: Integer;
  n: Integer;
begin
  n := plMain.ActivePageIndex;

  LockWindowUpdate(Self.Handle);
  try
    for i := 0 to Pred(Self.ComponentCount) do begin
      if Self.Components[i].ClassNameIs('TSharpEUIC') then begin
        TSharpEUIC(Self.Components[i]).Reset;
      end;
    end;
    plMain.ActivePageIndex := n;
  finally
    LockWindowUpdate(0);
  end;

  SendUpdate;
  UpdatePageUI;
end;

procedure TfrmSettings.chkCaptionClick(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmSettings.chkTextBoldClick(Sender: TObject);
begin
  uicTextBold.UpdateStatus;
  SendUpdate;
end;

procedure TfrmSettings.chkIconBlendAlphaClick(Sender: TObject);
begin
  UpdateIconPage;
  SendUpdate;
  uicIconBlend.UpdateStatus;
end;

procedure TfrmSettings.chkTextShadowClick(Sender: TObject);
begin
  uicTextShadow.UpdateStatus;
  SendUpdate;
  UpdateFontShadowPage;
end;

procedure TfrmSettings.chkTextAlphaClick(Sender: TObject);
begin
  uicTextAlpha.UpdateStatus;
  SendUpdate;
  UpdateFontPage;
end;

procedure TfrmSettings.chkIconShadowAlphaClick(Sender: TObject);
begin
  UpdateIconPage;
  SendUpdate;
  UICIconShadow.UpdateStatus;
end;

procedure TfrmSettings.chkIconAlphaClick(Sender: TObject);
begin
  UpdateIconPage;
  SendUpdate;
  uicIconAlpha.UpdateStatus;
end;

procedure TfrmSettings.chkTextItalicClick(Sender: TObject);
begin
  uicTextItalic.UpdateStatus;
  SendUpdate;
end;

procedure TfrmSettings.chkTextUnderlineClick(Sender: TObject);
begin
  uicTextUnderline.UpdateStatus;
  SendUpdate;
end;

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;

  FFontList := TFontList.Create;
  FFontList.RefreshFontInfo;

  FBlue32 := TBitmap32.Create;
  FBlue48 := TBitmap32.Create;
  FBlue64 := TBitmap32.Create;
  FWhite32 := TBitmap32.Create;
  FWhite48 := TBitmap32.Create;
  FWhite64 := TBitmap32.Create;
  LoadResources;

  RefreshFontList;
end;

procedure TfrmSettings.FormDestroy(Sender: TObject);
begin
  FBlue32.Free;
  FBlue48.Free;
  FBlue64.Free;
  FWhite32.Free;
  FWhite48.Free;
  FWhite64.Free;
  FFontList.Free;
  ClearList;
end;

procedure TfrmSettings.FormShow(Sender: TObject);
begin
  UpdateIcon;
end;

procedure TfrmSettings.lbSkinsClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  tmp: TSkinItem;
begin
  tmp := TSkinItem(AItem.Data);
  if tmp = nil then
    exit;

  if (ACol = 0) then
  begin
    PluginHost.Refresh;
    PluginHost.Save;
  end else if (ACol = 1) then
  begin
    if (Pos('http', tmp.Website) <> 0) then
      SharpExecute(TSkinItem(AItem.Data).Website)
    else begin
      PluginHost.Refresh(rtPreview);
      PluginHost.Save;
    end;
  end;
end;

procedure TfrmSettings.lbSkinsGetCellCursor(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var ACursor: TCursor);
var
  tmp : TSkinItem;
begin
  tmp := TSkinItem(AItem.Data);
  if tmp = nil then
    exit;

  if (ACol = 0) or (Pos('http', tmp.Website) = 0) then
    ACursor := crDefault
  else if ACol = 1 then
    ACursor := crHandPoint;
end;

procedure TfrmSettings.lbSkinsGetCellImageIndex(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var AImageIndex: Integer;
  const ASelected: Boolean);
var
  tmp : TSkinItem;
begin
  tmp := TSkinItem(AItem.Data);
  if tmp = nil then
    exit;

  if ACol = 0 then
    AImageIndex := 2;

  if ACol = 1 then begin

    if (Pos('http', tmp.Website) = 0) then
      AImageIndex := -1
    else
      AImageIndex := 1;

  end;
end;

procedure TfrmSettings.lbSkinsGetCellText(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmp: TSkinItem;
  s: string;
  colItemTxt, colDescTxt, colBtnTxt: TColor;
begin
  tmp := TSkinItem(AItem.Data);
  if tmp = nil then
    exit;

  // Assign theme colours
  AssignThemeToListBoxItemText(FPluginHost.Theme, AItem, colItemTxt, colDescTxt, colBtnTxt);

  if ACol = 0 then
  begin
    if tmp.Author <> '' then
      s := ' By ' + tmp.Author
    else
      s := '';

    AColText := Format('<font color="%s" />%s<font color="%s" />%s',
      [ColorToString(colItemTxt), tmp.Name, ColorToString(colDescTxt), s]);
  end;
end;

procedure TfrmSettings.SetDriveList;
var
  s : string;
  i : integer;
  DriveStr : array[1..255] of char;
begin
  ClearList;

  GetLogicalDriveStrings(255, @DriveStr);

  i := 1;
  repeat
    s := '';

    while (i <= 255) and (DriveStr[i] <> #00) do
    begin
      s := s + char(drivestr[i]);
      inc(i);
    end;

    inc(i); {step over #00}

    if Length(s) > 0 then
    begin
      cbDriveList.Items.Add(s);
    end;
  until Length(s) = 0;

  for i := 0 to cbDriveList.Items.Count - 1 do
  begin
    if cbDriveList.Items[i][1] = FDriveLetter then
      cbDriveList.ItemIndex := i;
  end;
end;

procedure TfrmSettings.ClearList;
begin
  cbDriveList.Items.Clear;
end;

procedure TfrmSettings.edtIconChange(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmSettings.LoadResources;
begin
  LoadBmpFromRessource(FBlue32, 'Blue32');
  LoadBmpFromRessource(FBlue48, 'Blue48');
  LoadBmpFromRessource(FBlue64, 'Blue64');
  LoadBmpFromRessource(FWhite32, 'White32');
  LoadBmpFromRessource(FWhite48, 'White48');
  LoadBmpFromRessource(FWhite64, 'White64');
end;

procedure TfrmSettings.rdoIcon32Click(Sender: TObject);
begin
  rdoIcon48.Checked := False;
  rdoIcon64.Checked := False;
  rdoIconCustom.Checked := False;

  SendUpdate;
  uicIconSize.UpdateStatusFromValue(cIconSize32);
  UpdateIconPage;
end;

procedure TfrmSettings.rdoIcon48Click(Sender: TObject);
begin
  rdoIcon32.Checked := False;
  rdoIcon64.Checked := False;
  rdoIconCustom.Checked := False;

  SendUpdate;
  uicIconSize.UpdateStatusFromValue(cIconSize48);
  UpdateIconPage;
end;

procedure TfrmSettings.rdoIcon64Click(Sender: TObject);
begin
  rdoIcon32.Checked := False;
  rdoIcon48.Checked := False;
  rdoIconCustom.Checked := False;

  SendUpdate;
  uicIconSize.UpdateStatusFromValue(cIconSize64);
  UpdateIconPage;
end;

procedure TfrmSettings.rdoIconCustomClick(Sender: TObject);
begin
  rdoIcon32.Checked := False;
  rdoIcon48.Checked := False;
  rdoIcon64.Checked := False;

  SendUpdate;
  uicIconSize.UpdateStatusFromValue(sgbIconSize.Value);
  UpdateIconPage;
end;

procedure TfrmSettings.RefreshFontList;
var
  fi: TFontInfo;
  i: integer;
  DuplicateCheck: Integer;
begin
  cboFontName.Items.Clear;
  try
    for i := 0 to pred(FFontList.List.Count) do begin
      fi := TFontInfo(FFontList.List.Objects[i]);
      DuplicateCheck := cboFontName.Items.IndexOf(fi.FullName);

      if DuplicateCheck = -1 then
        cboFontName.Items.AddObject(FFontList.List.Strings[i], fi);
    end;
  finally
    cboFontName.ItemIndex := cboFontName.Items.IndexOf('Arial');
  end;
end;

procedure TfrmSettings.sceIconBlendColorChangeColor(ASender: TObject; AValue: Integer);
begin
  uicIconBlendColor.UpdateStatus;
  SendUpdate;
end;

procedure TfrmSettings.sceExpandCollapse(ASender: TObject);
begin
  UpdatePageUI;
end;

procedure TfrmSettings.sceTextColorChangeColor(ASender: TObject; AValue: Integer);
begin
  uicTextColor.UpdateStatus;
  SendUpdate;
end;

procedure TfrmSettings.sceColorExpandCollapse(ASender: TObject);
begin
  UpdatePageUI;
end;

procedure TfrmSettings.sceIconShadowColorChangeColor(ASender: TObject; AValue: Integer);
begin
  UICIconShadowColor.UpdateStatus;
  SendUpdate;
end;

procedure TfrmSettings.sceTextShadowColorChangeColor(ASender: TObject; AValue: Integer);
begin
  uicTextShadowColor.UpdateStatus;
  SendUpdate;
end;

procedure TfrmSettings.SendUpdate;
begin
  if Visible then
    FPluginHost.SetSettingsChanged;
end;

procedure TfrmSettings.sgbIconBlendAlphaChangeValue(Sender: TObject; Value: Integer);
begin
  uicIconBlendAlpha.UpdateStatus;
  SendUpdate;
end;

procedure TfrmSettings.sgbTextShadowAlphaChangeValue(Sender: TObject;
  Value: Integer);
begin
  uicTextShadowAlpha.UpdateStatus;
  SendUpdate;
end;

procedure TfrmSettings.sgbTextSizeChangeValue(Sender: TObject; Value: Integer);
begin
  uicTextSize.UpdateStatus;
  SendUpdate;
end;

procedure TfrmSettings.sgbTextAlphaValueChangeValue(Sender: TObject; Value: Integer);
begin
  uicTextAlphaValue.UpdateStatus;
  SendUpdate;
end;

procedure TfrmSettings.sgbIconShadowAlphaChangeValue(Sender: TObject; Value: Integer);
begin
  uicIconShadowAlpha.UpdateStatus;
  SendUpdate;
end;

procedure TfrmSettings.sgbIconSizeChangeValue(Sender: TObject; Value: Integer);
begin
  uicIconSize.UpdateStatusFromValue(sgbIconSize.Value);
  SendUpdate;
end;

procedure TfrmSettings.sgbIconAlphaChangeValue(Sender: TObject; Value: Integer);
begin
  uicIconAlphaValue.UpdateStatus;
  SendUpdate;
end;

procedure TfrmSettings.uicIconBlendReset(Sender: TObject);
begin
  SendUpdate;
  UpdateIconPage;
end;

procedure TfrmSettings.uicTextColorClick(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmSettings.uicFontNameReset(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmSettings.uicTextShadowReset(Sender: TObject);
begin
  SendUpdate;
  UpdateFontShadowPage;
end;

procedure TfrmSettings.uicTextShadowTypeReset(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmSettings.uicTextAlphaReset(Sender: TObject);
begin
  SendUpdate;
  UpdateFontPage;
end;

procedure TfrmSettings.uicIconSizeReset(Sender: TObject);
begin
  rdoIcon32.Checked := false;
  rdoIcon48.Checked := false;
  rdoIcon64.Checked := false;
  rdoIconCustom.Checked := false;

  if CompareText(uicIconSize.DefaultValue, IntToStr(cIconSize32)) = 0 then
    rdoIcon32.Checked := True
  else if CompareText(uicIconSize.DefaultValue, IntToStr(cIconSize48)) = 0 then
    rdoIcon48.Checked := True
  else if CompareText(uicIconSize.DefaultValue, IntToStr(cIconSize64)) = 0 then
    rdoIcon64.Checked := True
  else
  begin
    rdoIconCustom.Checked := True;
    sgbIconSize.Value := StrToInt(uicIconSize.DefaultValue);
  end;
  uicIconSize.HasChanged := False;
  SendUpdate;
end;

procedure TfrmSettings.UpdateFontPage;
begin
  if not pagFont.Visible then
    exit;

    // Font Transparency
    uicTextAlphaValue.Visible := chkTextAlpha.Checked;

    // Update Page Height
    Self.Height := pnlFont.Height + 50;
    FPluginHost.Refresh(rtSize);
end;

procedure TfrmSettings.UpdateFontShadowPage;
begin
  if not pagFontShadow.Visible then
    exit;

    // Font Shadow
    pnlTextShadow.Visible := chkTextShadow.Checked;

    // Update Page Height
    Self.Height := pnlFontShadow.Height + 50;

    FPluginHost.Refresh(rtSize);
end;

procedure TfrmSettings.UpdateIcon;
//var
//  Bmp: TBitmap32;
begin
  //  Bmp := TBitmap32.Create;
  //  Bmp.DrawMode := dmBlend;
  //  Bmp.CombineMode := cmMerge;
  //  SharpIconUtils.IconStringToIcon(edtIcon.Text,edtTarget.Text,Bmp,32);
  //  IconPreview.Bitmap.SetSize(32,32);
  //  IconPreview.Bitmap.Clear(color32(IconPreview.Color));
  //  Bmp.DrawTo(IconPreview.Bitmap,Rect(0,0,32,32));
  //  Bmp.Free;
end;

procedure TfrmSettings.UpdateIconPage;
begin
  if not PagIcon.Visible then
    exit;

    // Icon Size
    sgbiconsize.Enabled := rdoIconCustom.checked;
    if rdoIcon32.Checked then
      icon32.Bitmap.Assign(FBlue32)
    else
      icon32.Bitmap.Assign(FWhite32);
    if rdoIcon48.Checked then
      icon48.Bitmap.Assign(FBlue48)
    else
      icon48.Bitmap.Assign(FWhite48);
    if rdoIcon64.Checked then
      icon64.Bitmap.Assign(FBlue64)
    else
      icon64.Bitmap.Assign(FWhite64);

    // IconBlendAlpha
    uicIconBlendAlpha.Visible := chkIconBlendAlpha.checked;

    // IconShadowAlpha
    uicIconShadowAlpha.Visible := chkIconShadowAlpha.checked;

    // IconAlpha
    uicIconAlphaValue.Visible := chkIconAlpha.Checked;

    frmSettings.Height := pnlIcon.Height + 50;

    // Refresh size
    FPluginHost.Refresh(rtSize);
end;

procedure TfrmSettings.UpdateDrivePage;
begin
  if not pagDrive.Visible then
    exit;

  SetDriveList;

  frmSettings.Height := pnlDrive.Height + 50;
  FPluginHost.Refresh(rtSize);
end;

procedure TfrmSettings.UpdatePageUI;
begin
  pnlOverride.Visible := not (pagDrive.Visible);

  if pagIcon.Visible then
    UpdateIconPage else
    if pagFont.Visible then
      UpdateFontPage else
      if pagFontShadow.Visible then
        UpdateFontShadowPage
      else UpdateDrivePage;

end;

end.

