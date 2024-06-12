object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'ApplicationBar'
  ClientHeight = 159
  ClientWidth = 344
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sb_config: TSharpEButton
    Left = 2
    Top = 0
    Width = 127
    Height = 25
    AutoSize = True
    OnClick = sb_configClick
    Glyph32.DrawMode = dmBlend
    Glyph32.CombineMode = cmMerge
    Glyph32.ResamplerClassName = 'TNearestResampler'
    Layout = blGlyphLeft
    Caption = 'Click to Add Buttons'
    AutoPosition = True
    ForceDown = False
    ForceHover = False
  end
  object ButtonPopup: TPopupMenu
    Images = PngImageList1
    OnPopup = ButtonPopupPopup
    Left = 208
    Top = 8
    object Delete1: TMenuItem
      Caption = 'Remove from Application Bar'
      ImageIndex = 1
      OnClick = Delete1Click
    end
    object mnPopupSep1: TMenuItem
      Caption = '-'
    end
    object mnPopupCloseAll: TMenuItem
      Caption = 'Close all windows'
      ImageIndex = 0
      OnClick = mnPopupCloseAllClick
    end
    object LaunchElevated1: TMenuItem
      Caption = 'Launch Elevated'
      ImageIndex = 3
      OnClick = mnuPopupLaunchElevClick
    end
    object Launch1: TMenuItem
      Caption = 'Launch'
      ImageIndex = 2
      OnClick = mnuPopupLaunchClick
    end
  end
  object PngImageList1: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000774494D45000000000000000973942E000000097048597300001EC1
          00001EC101C3695453000001D04944415478DA9D925F2864511CC7BF07973163
          87642CB53CA94D9EF65D4AE14129A2A9B5D12C45A23CE045ED9384B6FC4F1935
          CA3C91C4D63E189B19CDEC16F2E4C10B61289E103377EECCBDF71CE76ECD98B9
          3C98F9D5B99D73EEEF7CCEF99CDF210EE7DA62C9A7E2EF198220509541A12A44
          51C2DDC31302C110644541381C414892E4CBF333BBD33ED587B8203B6E2F2D9A
          1E23B9ED47B0A57FC67C8513FA2004C833E76078647273796EB429E19FDBBBCF
          CA0F3D30D4F8309BF6052D599D282F2B4D009C9CFA51906FC6E08F89AD9585F1
          C60480CBF397592C85B8F25F21DB2080AB201915B2BDEB6575D595F8E3F181AB
          205915F2DBB5C7EA6BABE0F11D201515B2FECBC59A1B6AB1B3F70F49AA80AB1C
          9385E555D663B3C2E5F62105951BF273DEC1FA3ABF62D77B8014546EC9F8CC12
          3319B351FCB110F12AF1A11D5B14C308476428AA0A45514129C5FAC6D62D8926
          E955DE136DDD438F31805E450C49B144A679C7F5B58FC968C0B7AE8117805E25
          C8018C2732C612B7E5636DC69C6384B5A39F11FDB1A22A0151FABFD55B106D9C
          FBC184A6D6AED780A8CAFD63102ABFB097D291D8628D67E155B0DA7A5F03A22A
          92A420A2CA5015CAFB12C460805721C21F97CC1B4556A6800BFF357D06DBC24E
          12F520560C0000000049454E44AE426082}
        Name = 'PngImage1'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000774494D45000000000000000973942E000000097048597300001EC1
          00001EC101C3695453000002424944415478DAA5536B489351187ECE2E6C637D
          6E544A83740845883FA2FB9F288C4C0B168D628992289344A124AC9020888222
          7F445414DA8D3088C5186DA0C359BAD8BE1FB546973FFE718A33A34C2A267397
          EF723A9FA39560DAE53D3C3CCFB9BCEF79CFCB7B08FED3C8BD9EC75DC5AB2D8D
          1AAD564B65409425085911A22822AB80E9AC20209311729C65CC904AA785F1B1
          583719180AC9ABAE5E22A6FA281AD4EB70A3BC67E95B09602E58863317AE3C21
          43A117B42C12847E7718D7541B7048E744D99A9245030C8FC4B17279014E9EBD
          EC2581204F0B0B8B163C288AEC39027B8EC4986965AE6885655986DBE3F592FE
          C110DD53B1FD9F0A78A4F9144F7A03CFE9BECA1DAC2899BF7236E875A83BDACE
          139F7F90DAAA2B584A74DE014A690E6C287B8A9658DA8CE6346734A0A6E9044F
          DCBE003D68ABCC0758CAF1074C9C118EC6E33C79E4E9A335F6BD90247951C7A9
          BE6E862ECC4E8C405D6481757F2B4EFBE33C79E0F2D17A878D5559FCED8D53FE
          DB48BD7263ED4E3B74A5E548BD0B60987F86FE09FD28B9F3D0439D7576A433D9
          055355EC4DCB7A6CAD6D8521160426C380C98C698D15A1A7D134B979DF455B1A
          1C48A6D2F39C7FB5C801337675BA4036DAF36BDFCE59100D4D83745EBF9B38D6
          54CB7D4D24E79A231700F9200AC7DAB7605B55158CF15E64521F31CBD667126A
          BC1ED567485BC7F9368E333901159795C49FDDC76A22B2CF234A02362522E6CD
          DA7153C90A816854EF31F359C4D8270D7D2B95BE247FDA38E1C3C51DC92F1F9A
          D512B14A6A3AC9F2BB553D205DFC0E99467FF805A63BEE0000000049454E44AE
          426082}
        Name = 'PngImage2'
        Background = clMenu
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000001CE4944415478DAA5534B28FC51143EC74CC4F4B3B12065
          A1445136928DA2949212919190B09147C2E419112684C66B41F24C9E919252F6
          928DFAFF1BC20A2B65C762C6BDC7B9F737BFD4ECC6DC3A9D73EEE3BBDF3DF73B
          484410CEC0D28EBD96DCFCECC98F2F72682C2981D88414EC0924712E047BD25E
          F05A6CA4EFD3EB7DEB3999732EE1D8E1B3300C4744A8373F7BEFA5A723CF86FD
          BB4F7F7AC3FBEB0BACB8F211FBB61F69A22625648046F715ACF51520F66E3D90
          BB36157CDFFC665E50EF16924BC199D431D7E39B4CE37AF80441728201F5E397
          B03150C8009BF7E4AE4B033F6F0455284611CA9B29C7A00B2AA4392719283E2E
          1AEA462E606BB808D1B5FE9FA6EAD3F54D9A813252D507CD40816893A041148B
          38230A6A86CE6167B418B17BED1F4D376498B7B2610044068088299831685095
          183176A81E3C83DDB112C4CED53B9A69CAD400D6B0C4650121B3538703320147
          941DAAFA4F616FA214B17DF9963CCD5920D4C6A0C3C12AB55846DBED50E13A82
          A3E90AC4B6851B9A6FCDFE3D6452806071488B1D5388B4D9A0BCEB008E672A11
          5B3CD7B4D89E13B20ECA3AF7E164D689AA17F6E393122BA5D23B0B4028AFFEDE
          EFD75EF780EA0B11E80B3567D239E05E7062D8DD182EC00FFD5A32F08EC9B5CE
          0000000049454E44AE426082}
        Name = 'PngImage2'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000003104944415478DA65926B48545110C7FF771FEE5EDF9524
          AEA9BB596CF9D84C48C9B2A0E84310454561E007EB4351B4B516A64129E80741
          A12808B2B0B214835E1044445490A190A64B90EF5573F1B9A6B9E95EDBFB388D
          7B2D563A309C73EE9DF99D99FF0CC71843F06A6868085714A54896E5AD642BC9
          40364DD6224952B5C3E1980BF6E78201F5F5F51914FCDC643259A2A2A2A0D168
          40770882008FC783415A043A545C5CECFC0F40C1E1F4B3233939799DDFEF87DB
          EDC6FCFCFCE2EBD0E974888D8D0DF8757676F6D3375B595999B00C5057575714
          171757A5D7EBD1D3D33340E9EE22C7D145009D4DB4375B2C1693CFE75BCCE452
          454545F532406D6DED73ABD57AD0E572C1EBF5A6D8EDF6AEE05ACBCBCB371A0C
          864EB3D90CA7D3F9A2B2B2F2D032404D4D4D537A7AFAF6F6F67688A2C8171616
          2E04034A4B4B8DE42BD86C36B4B6B67EAAAAAACAFD07186E3ACE9A5D564CCCF2
          819A0FA4B641CB4430590293541345190F9C990151638D33D817DF06EBA90E4E
          057C2C60F19967C041034ECBD3AE05140ED019E90DCA5016214BBFA048D44145
          0C64D4DF780E1BEDDF54C0F70FF96CCD163BE4A9A7D01962A0E1C2C9510FF0D1
          14AF00BE59F8BD7DF00B2304F181B79C45DFA3D348B9D8AF0286DEE6B1846C07
          644F23E606C6A8FF61884ECD81FBFD1D8A5F8DC49D7B30F9F90D016610615E01
          7EFD79F4DD3F89D492611530F8FA304BCCB90869A21E7A7E25342131A40E8FA1
          5735F83AB516FBF3B2E09F1EC2C2DC28E94119581DE8BD7B026957C755C0C0CB
          FD2C714711E4B187981B1C83D61089E84DDB30F0E42EBE781270A4201B932DEF
          B040A54426452374C305F4DC2E407AF9940A703DDBCB927695401AB907BD3102
          DAD0558091EAD79388A2047827F0FBC72084594F2083B0946274DFCA87AD7256
          05F43FDECDCC7BAEC0EFBE0361689C0011042021752124E622E02784190FC4F9
          5F88488C4468DA6574DF38864DD53E15D0F7289799F7965113018D560B2EC440
          C13C5DA8138A0C520FB2E0A56EFE2651E5401BBBAE1D45C675BF0AE8ADCD624C
          A2C111C5A5C11197ECEF998268C00283252F9D09B4F9A6C2FD015353C6F09982
          3FD90000000049454E44AE426082}
        Name = 'PngImage3'
        Background = clWindow
      end>
    Left = 240
    Top = 8
    Bitmap = {}
  end
  object CheckTimer: TTimer
    OnTimer = CheckTimerTimer
    Left = 176
    Top = 8
  end
  object PreviewCheckTimer: TTimer
    Enabled = False
    Interval = 300
    OnTimer = PreviewCheckTimerTimer
    Left = 272
    Top = 8
  end
  object DropTarget: TJvDropTarget
    OnDragOver = DropTargetDragOver
    Left = 152
    Top = 96
  end
  object DDHandler: TJvDragDrop
    DropTarget = Owner
    Left = 184
    Top = 96
  end
  object PreviewViewTimer: TTimer
    Enabled = False
    Interval = 400
    OnTimer = PreviewViewTimerTimer
    Left = 304
    Top = 8
  end
  object PreviewViewClickBlockTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = PreviewViewClickBlockTimerTimer
    Left = 304
    Top = 40
  end
end