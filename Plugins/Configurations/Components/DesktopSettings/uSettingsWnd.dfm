object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmSettings'
  ClientHeight = 399
  ClientWidth = 428
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pcOptions: TPageControl
    Left = 0
    Top = 0
    Width = 428
    Height = 391
    ActivePage = tabDesktop
    Align = alTop
    Style = tsFlatButtons
    TabOrder = 0
    object tabDesktop: TTabSheet
      Caption = 'tabDesktop'
      ImageIndex = 1
      TabVisible = False
      object SharpECenterHeader1: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 82
        Width = 410
        Height = 35
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 10
        Title = 'Desktop resolution adjustment'
        Description = 
          'Define whether the desktop resizes when the resolution is change' +
          'd'
        TitleColor = clWindowText
        DescriptionColor = clGrayText
        Align = alTop
        ExplicitTop = 84
      end
      object SharpECenterHeader2: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 154
        Width = 410
        Height = 35
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 10
        Title = 'Wallpaper rotation'
        Description = 'Define whether the desktop rotates when the screen is rotated'
        TitleColor = clWindowText
        DescriptionColor = clGrayText
        Align = alTop
        ExplicitTop = 156
      end
      object SharpECenterHeader3: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 226
        Width = 410
        Height = 35
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 10
        Title = 'Memory management'
        Description = 
          'Define whether to allow swap file usage within SharpDesk. Reduce' +
          's memory usage at a cost of performance.'
        TitleColor = clWindowText
        DescriptionColor = clGrayText
        Align = alTop
        ExplicitTop = 228
      end
      object SharpECenterHeader4: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 298
        Width = 410
        Height = 35
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 10
        Title = 'Wallpaper monitoring'
        Description = 
          'Define whether to allow external applications to change the desk' +
          'top wallapaper automatically'
        TitleColor = clWindowText
        DescriptionColor = clGrayText
        Align = alTop
        ExplicitTop = 300
      end
      object cb_adjustsize: TJvXPCheckbox
        AlignWithMargins = True
        Left = 3
        Top = 127
        Width = 412
        Height = 17
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Caption = 'Enable desktop sizing to resolution changes'
        TabOrder = 1
        Checked = True
        State = cbChecked
        Align = alTop
        OnClick = cb_ammClick
        ExplicitTop = 129
      end
      object cb_useexplorer: TJvXPCheckbox
        AlignWithMargins = True
        Left = 3
        Top = 55
        Width = 412
        Height = 17
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Caption = 'Enable Explorer desktop'
        TabOrder = 0
        Align = alTop
        OnClick = cb_useexplorerClick
        ExplicitTop = 57
      end
      object cb_amm: TJvXPCheckbox
        AlignWithMargins = True
        Left = 3
        Top = 271
        Width = 412
        Height = 17
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Caption = 'Enable memory management (Advanced)'
        TabOrder = 3
        Align = alTop
        OnClick = cb_ammClick
        ExplicitTop = 273
      end
      object cb_wpwatch: TJvXPCheckbox
        AlignWithMargins = True
        Left = 3
        Top = 343
        Width = 412
        Height = 17
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Caption = 'Enable wallpaper monitoring (Advanced)'
        TabOrder = 4
        Align = alTop
        OnClick = cb_ammClick
        ExplicitTop = 345
      end
      object SharpECenterHeader9: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 10
        Width = 410
        Height = 35
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 10
        Title = 'Explorer Desktop'
        Description = 'Define whether to use Explorer'#39's Desktop'
        TitleColor = clWindowText
        DescriptionColor = clGrayText
        Align = alTop
      end
      object cb_autorotate: TJvXPCheckbox
        AlignWithMargins = True
        Left = 3
        Top = 199
        Width = 412
        Height = 17
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Caption = 'Enable wallpaper rotation (Advanced)'
        TabOrder = 2
        Checked = True
        State = cbChecked
        Align = alTop
        OnClick = cb_ammClick
      end
    end
    object tabObjects: TTabSheet
      Caption = 'tabObjects'
      TabVisible = False
      object cb_dd: TJvXPCheckbox
        AlignWithMargins = True
        Left = 3
        Top = 148
        Width = 412
        Height = 17
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Caption = 'Enable drag && drop'
        TabOrder = 2
        Checked = True
        State = cbChecked
        Align = alTop
        OnClick = cb_ddClick
        ExplicitTop = 152
      end
      object cb_singleclick: TJvXPCheckbox
        AlignWithMargins = True
        Left = 3
        Top = 220
        Width = 412
        Height = 17
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Caption = 'Single click action'
        TabOrder = 3
        Align = alTop
        OnClick = cb_singleclickClick
        ExplicitTop = 226
      end
      object SharpECenterHeader5: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 0
        Width = 410
        Height = 35
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 10
        Title = 'Object grid alignment'
        Description = 'Define whether to allow snap to grid functionality for objects'
        TitleColor = clWindowText
        DescriptionColor = clGrayText
        Align = alTop
      end
      object SharpECenterHeader6: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 103
        Width = 410
        Height = 35
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 10
        Title = 'Drag and drop'
        Description = 
          'Define whether to allow drag and drop functionality for the desk' +
          'top'
        TitleColor = clWindowText
        DescriptionColor = clGrayText
        Align = alTop
      end
      object SharpECenterHeader7: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 175
        Width = 410
        Height = 35
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 10
        Title = 'Single click action'
        Description = 
          'Define whether to enable hyper link functionality for all object' +
          's'
        TitleColor = clWindowText
        DescriptionColor = clGrayText
        Align = alTop
      end
      object pnlGrid: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 72
        Width = 405
        Height = 21
        Margins.Left = 5
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object sgb_gridy: TSharpeGaugeBox
          Left = 0
          Top = 0
          Width = 120
          Height = 21
          ParentBackground = False
          TabOrder = 0
          Min = 2
          Max = 128
          Value = 32
          Prefix = 'Height: '
          Suffix = 'px'
          Description = 'Grid Height'
          PopPosition = ppBottom
          PercentDisplay = False
          Formatting = '%d'
          OnChangeValue = sgb_gridyChangeValue
          BackgroundColor = clWindow
        end
        object sgb_gridx: TSharpeGaugeBox
          Left = 126
          Top = 0
          Width = 120
          Height = 21
          ParentBackground = False
          TabOrder = 1
          Min = 2
          Max = 128
          Value = 32
          Prefix = 'Width: '
          Suffix = 'px'
          Description = 'Grid Width'
          PopPosition = ppBottom
          PercentDisplay = False
          Formatting = '%d'
          OnChangeValue = sgb_gridyChangeValue
          BackgroundColor = clWindow
        end
      end
      object cb_grid: TJvXPCheckbox
        AlignWithMargins = True
        Left = 3
        Top = 45
        Width = 412
        Height = 17
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Caption = 'Align objects to grid'
        TabOrder = 0
        Checked = True
        State = cbChecked
        Align = alTop
        OnClick = cb_gridClick
      end
    end
    object tabMenu: TTabSheet
      Caption = 'tbMenu'
      ImageIndex = 2
      TabVisible = False
      object SharpECenterHeader8: TSharpECenterHeader
        AlignWithMargins = True
        Left = 5
        Top = 0
        Width = 410
        Height = 35
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 10
        Title = 'Desktop menu'
        Description = 'Define which menu to display on mouse click'
        TitleColor = clWindowText
        DescriptionColor = clGrayText
        Align = alTop
      end
      object Panel1: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 45
        Width = 405
        Height = 25
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 1
        DesignSize = (
          405
          25)
        object Label1: TLabel
          Left = 0
          Top = 7
          Width = 49
          Height = 13
          Caption = 'Right Click'
        end
        object cbMenuList: TComboBox
          AlignWithMargins = True
          Left = 114
          Top = 4
          Width = 283
          Height = 21
          Margins.Left = 26
          Margins.Top = 4
          Margins.Right = 8
          Margins.Bottom = 0
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          TabOrder = 0
          OnChange = cbMenuListChange
        end
      end
      object Panel3: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 75
        Width = 405
        Height = 34
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alTop
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 2
        DesignSize = (
          405
          34)
        object Label2: TLabel
          Left = 0
          Top = 7
          Width = 85
          Height = 13
          Caption = 'Shift + Right Click'
        end
        object cbMenuShift: TComboBox
          AlignWithMargins = True
          Left = 114
          Top = 4
          Width = 283
          Height = 21
          Margins.Left = 26
          Margins.Top = 4
          Margins.Right = 8
          Margins.Bottom = 0
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          TabOrder = 0
          OnChange = cbMenuListChange
        end
      end
    end
  end
end
