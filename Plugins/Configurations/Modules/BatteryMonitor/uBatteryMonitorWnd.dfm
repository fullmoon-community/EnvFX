object frmBMon: TfrmBMon
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmBMon'
  ClientHeight = 348
  ClientWidth = 660
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWhite
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object plMain: TJvPageList
    Left = 0
    Top = 0
    Width = 660
    Height = 348
    ActivePage = pagNotes
    PropagateEnable = False
    Align = alClient
    object pagNotes: TJvStandardPage
      Left = 0
      Top = 0
      Width = 660
      Height = 348
      object SharpECenterHeader1: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 0
        Width = 650
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 10
        Title = 'Icon Visibility'
        Description = 'Would you like to display the power status Icon?'
        TitleColor = clWindowText
        DescriptionColor = clGrayText
        Align = alTop
        Color = clWindow
      end
      object cb_icon: TJvXPCheckbox
        AlignWithMargins = True
        Left = 5
        Top = 47
        Width = 650
        Height = 17
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 10
        Caption = 'Display the icon'
        TabOrder = 1
        Checked = True
        State = cbChecked
        Align = alTop
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        OnClick = cb_iconClick
      end
      object schNotifications: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 74
        Width = 650
        Height = 37
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 10
        Title = 'Notifications'
        Description = 
          'Would you like to be notified when the power status goes below 5' +
          '0, 20 and 10 percent?'
        TitleColor = clWindowText
        DescriptionColor = clGrayText
        Align = alTop
        Color = clWindow
        ExplicitTop = 111
      end
      object cbNotifications: TJvXPCheckbox
        AlignWithMargins = True
        Left = 5
        Top = 121
        Width = 650
        Height = 17
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 10
        Caption = 'Display notifications'
        TabOrder = 3
        Checked = True
        State = cbChecked
        Align = alTop
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        OnClick = cbNotificationsClick
        ExplicitTop = 148
      end
    end
  end
end
