object frmListWnd: TfrmListWnd
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmListWnd'
  ClientHeight = 290
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Shape1: TShape
    Left = 0
    Top = 30
    Width = 434
    Height = 1
    Align = alTop
    ExplicitLeft = 8
    ExplicitTop = 26
  end
  object Shape2: TShape
    Left = 0
    Top = 103
    Width = 434
    Height = 1
    Align = alTop
    ExplicitTop = 107
  end
  object lbModulesLeft: TSharpEListBoxEx
    AlignWithMargins = True
    Left = 0
    Top = 36
    Width = 434
    Height = 32
    Margins.Left = 0
    Margins.Top = 5
    Margins.Right = 0
    Margins.Bottom = 5
    Columns = <
      item
        Width = 200
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calLeft
        StretchColumn = True
        ColumnType = ctDefault
        VisibleOnSelectOnly = False
        Images = StatusImages
      end
      item
        Width = 30
        HAlign = taCenter
        VAlign = taVerticalCenter
        ColumnAlign = calRight
        StretchColumn = False
        ColumnType = ctDefault
        VisibleOnSelectOnly = True
        Images = StatusImages
      end
      item
        Width = 25
        HAlign = taCenter
        VAlign = taVerticalCenter
        ColumnAlign = calRight
        StretchColumn = False
        ColumnType = ctDefault
        VisibleOnSelectOnly = True
        Images = StatusImages
      end
      item
        Width = 25
        HAlign = taCenter
        VAlign = taVerticalCenter
        ColumnAlign = calRight
        StretchColumn = False
        ColumnType = ctDefault
        VisibleOnSelectOnly = True
        Images = StatusImages
      end
      item
        Width = 35
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calRight
        StretchColumn = False
        ColumnType = ctDefault
        VisibleOnSelectOnly = True
        Images = StatusImages
      end>
    Colors.BorderColor = clBtnFace
    Colors.BorderColorSelected = clBtnShadow
    Colors.ItemColor = 16640983
    Colors.ItemColorSelected = 16571834
    Colors.CheckColorSelected = clBtnFace
    Colors.CheckColor = 15528425
    Colors.DisabledColor = clBlack
    DefaultColumn = 0
    ItemHeight = 30
    OnClickItem = lbModulesClickItem
    OnDblClickItem = lbModulesLeftDblClickItem
    OnGetCellCursor = lbModulesGetCellCursor
    OnGetCellText = lbModulesGetCellText
    OnGetCellImageIndex = lbModulesGetCellImageIndex
    AutosizeGrid = True
    Borderstyle = bsNone
    Ctl3d = False
    Align = alTop
  end
  object lbModulesRight: TSharpEListBoxEx
    AlignWithMargins = True
    Left = 0
    Top = 109
    Width = 434
    Height = 32
    Margins.Left = 0
    Margins.Top = 5
    Margins.Right = 0
    Margins.Bottom = 5
    Columns = <
      item
        Width = 200
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calLeft
        StretchColumn = True
        ColumnType = ctDefault
        VisibleOnSelectOnly = False
        Images = StatusImages
      end
      item
        Width = 30
        HAlign = taCenter
        VAlign = taVerticalCenter
        ColumnAlign = calRight
        StretchColumn = False
        ColumnType = ctDefault
        VisibleOnSelectOnly = True
        Images = StatusImages
      end
      item
        Width = 25
        HAlign = taCenter
        VAlign = taVerticalCenter
        ColumnAlign = calRight
        StretchColumn = False
        ColumnType = ctDefault
        VisibleOnSelectOnly = True
        Images = StatusImages
      end
      item
        Width = 25
        HAlign = taCenter
        VAlign = taVerticalCenter
        ColumnAlign = calRight
        StretchColumn = False
        ColumnType = ctDefault
        VisibleOnSelectOnly = True
        Images = StatusImages
      end
      item
        Width = 35
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calRight
        StretchColumn = False
        ColumnType = ctDefault
        VisibleOnSelectOnly = True
        Images = StatusImages
      end>
    Colors.BorderColor = clBtnFace
    Colors.BorderColorSelected = clBtnShadow
    Colors.ItemColor = 14286304
    Colors.ItemColorSelected = 11205562
    Colors.CheckColorSelected = clBtnFace
    Colors.CheckColor = 15528425
    Colors.DisabledColor = clBlack
    DefaultColumn = 0
    ItemHeight = 30
    OnClickItem = lbModulesClickItem
    OnDblClickItem = lbModulesLeftDblClickItem
    OnGetCellCursor = lbModulesGetCellCursor
    OnGetCellText = lbModulesGetCellText
    OnGetCellImageIndex = lbModulesGetCellImageIndex
    AutosizeGrid = True
    Borderstyle = bsNone
    Ctl3d = False
    Align = alTop
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 4
    Top = 0
    Width = 425
    Height = 25
    Margins.Left = 4
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 2
    object Image1: TImage
      Left = 0
      Top = 0
      Width = 20
      Height = 25
      Align = alLeft
      Center = True
      Picture.Data = {
        0A54504E474F626A65637489504E470D0A1A0A0000000D494844520000001000
        00001008060000001FF3FF610000000774494D45000000000000000973942E00
        0000097048597300001EC100001EC101C36954530000000467414D410000B18F
        0BFC6105000001444944415478DA6364A01030D2C480FFFFFF6388F52F79DECE
        C4C4985B102DC943B2012DB31EB77371B29433333332020D6024C98082AEDB7D
        9A4A02852A0A3C0CE7AEBC67284B9426DE80B0E2CBF30C340412F5350518D8D9
        98198E9C7BC3D098294F9C0136B1279798E98B445BEA8B30FCF8F597819F9795
        E1E0A9570C7DA52A840D50F7DAFFC8585744D6DE549CE1FBCFBF0CFFFEFD6790
        11E762D879F439C3DC464DC206C83A6CDD6CA82BE5E36421C1F0EDFB1F867F7F
        FF33484B72316C3BF08C61759F1E610304F4FB5938796457E8EB2806BB5A4B32
        7CFEF69B4154889D61DDCE470C7BE79A111F881256CB56EAEAA885B95A4A3030
        313331ACD9FE90E1E40A2BD2A251D474D6221D5DC35817A077166FBCCB70739B
        2369068080A0C184053A7A96F10F1FBF65787CC09B7403C0E1A2D3359B834732
        E5E5C938C206900228360000F5E1781139194ED70000000049454E44AE426082}
      ExplicitHeight = 41
    end
    object lblLeft: TLabel
      AlignWithMargins = True
      Left = 22
      Top = 5
      Width = 101
      Height = 15
      Margins.Left = 2
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'Left Aligned Modules'
      Layout = tlCenter
      ExplicitHeight = 13
    end
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 4
    Top = 73
    Width = 425
    Height = 25
    Margins.Left = 4
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 3
    object Image2: TImage
      Left = 0
      Top = 0
      Width = 20
      Height = 25
      Align = alLeft
      Center = True
      Picture.Data = {
        0A54504E474F626A65637489504E470D0A1A0A0000000D494844520000001000
        00001008060000001FF3FF610000000467414D410000AFC837058AE900000019
        74455874536F6674776172650041646F626520496D616765526561647971C965
        3C000001524944415478DA63FCFFFF3F03258091EA0634AC7EF9E5DF3F86C94D
        E1E295641AF0FAFF9F7FFFFEFFF8F9ABB3274E96A0211806542E7FFEDF448993
        E1D6F39F0C379F7EED5F90AD54449201790B1EFFB7D2E061F8FDEB3FC3A547DF
        182E3DF83C7F678D6612D106244D7FF4DF5E8B9BE1E3B73F0CEC2C8C0C27EE7C
        61387DFBC3D22B7D4631441910DC77E7BF9B2E3FC3F3F73F191819191838D918
        190E5EFFC470FED6FBC7CFE659C91134C0B9E5FA7F5F43418627EF7E3230030D
        E06267623874E523C3B55B9FB63C5F6EE54BD000D3F2CBFF832C84185E7FFACD
        C0C5C1C470F8E27B869B37DFAFFDFBE97BC4EBDD9E7F081AA09C77EE7FB49508
        C3EF7FFF198E5CFCC070EBE69B552F373887131D885249A7FE473B8A311C0769
        BEF676F1AB6DCE712445A344E491FFCA12C07470E5CDC2D7BBDD131808000C03
        C4FC0EFCFFFFF9FB9CD7FB3D530969C66A00A980620300318BC0E171DEB98A00
        00000049454E44AE426082}
      ExplicitHeight = 41
    end
    object lblRight: TLabel
      AlignWithMargins = True
      Left = 22
      Top = 5
      Width = 107
      Height = 15
      Margins.Left = 2
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'Right Aligned Modules'
      Layout = tlCenter
      ExplicitHeight = 13
    end
  end
  object StatusImages: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000010000000100804000000B5FA37
          EA0000000467414D410000AFC837058AE90000001974455874536F6674776172
          650041646F626520496D616765526561647971C9653C0000017A4944415478DA
          6D914D48025110C7FFCFCC22A1D508A90E259429D42D3C7A8BA82E1D02C14B75
          B6A05B84F7820E752F90A228C9D24BC76E752BA363501928BA6484EEE247DAEE
          FA9A5DB32F9A81C77B33BFF9CFBCF71847D32ED7E5B9421F6017857D5FA81965
          4D20EE5033FED6C63EAA68CE80F8055065A0D00F930017DCE0B8C31364A06E4F
          0B115F888068D5DFA6B329240801EEE1C54043A9E66F67F15D2CB8E1A1E315F2
          E44017B9D7507A4421C24E955173190C2D78C0ECE73C315252508686A4CA4EA4
          49A182122119F46090D249E4D04D27D07A2DB3A83425D4892D428419160A2BC8
          A203FA853A75E0589A1634A8A8E31D155A5FF146EDCCA4A8C18A1B991DD5662C
          9AD14F214CC10B4CC61C0A2156246AECF0BC77DC456215725DE999EA416A362A
          1291BF6007163ECF579C436E4A1451A5FEA0A44A43E652D8E461E3A9F71C7C99
          073DB661D2C890B4887489EFF0ADA5EC8FBF088FF0100F8C318990528CAF2DDE
          FEF92CDDB627F82AB7F08DE0D977EC17F09F7D006A1A99FC2862604500000000
          49454E44AE426082}
        Name = 'PngImage2'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000097048597300001EC100001EC101C369545300000A4D694343505068
          6F746F73686F70204943432070726F66696C65000078DA9D53775893F7163EDF
          F7650F5642D8F0B1976C81002223AC08C81059A21092006184101240C585880A
          561415119C4855C482D50A489D88E2A028B867418A885A8B555C38EE1FDCA7B5
          7D7AEFEDEDFBD7FBBCE79CE7FCCE79CF0F8011122691E6A26A003952853C3AD8
          1F8F4F48C4C9BD80021548E0042010E6CBC26705C50000F00379787E74B03FFC
          01AF6F00020070D52E2412C7E1FF83BA50265700209100E02212E70B01905200
          C82E54C81400C81800B053B3640A009400006C797C422200AA0D00ECF4493E05
          00D8A993DC1700D8A21CA908008D0100992847240240BB00605581522C02C0C2
          00A0AC40222E04C0AE018059B632470280BD0500768E58900F4060008099422C
          CC0020380200431E13CD03204C03A030D2BFE0A95F7085B8480100C0CB95CD97
          4BD23314B895D01A77F2F0E0E221E2C26CB142611729106609E4229C979B2313
          48E7034CCE0C00001AF9D1C1FE383F90E7E6E4E1E666E76CEFF4C5A2FE6BF06F
          223E21F1DFFEBC8C020400104ECFEFDA5FE5E5D60370C701B075BF6BA95B00DA
          560068DFF95D33DB09A05A0AD07AF98B7938FC401E9EA150C83C1D1C0A0B0BED
          2562A1BD30E38B3EFF33E16FE08B7EF6FC401EFEDB7AF000719A4099ADC0A383
          FD71616E76AE528EE7CB0442316EF7E723FEC7857FFD8E29D1E234B15C2C158A
          F15889B850224DC779B952914421C995E212E97F32F11F96FD0993770D00AC86
          4FC04EB607B5CB6CC07EEE01028B0E58D27600407EF32D8C1A0B910010673432
          79F7000093BFF98F402B0100CD97A4E30000BCE8185CA894174CC608000044A0
          812AB041070CC114ACC00E9CC11DBCC01702610644400C24C03C104206E4801C
          0AA11896411954C03AD804B5B0031AA0119AE110B4C131380DE7E0125C81EB70
          170660189EC218BC86090441C8081361213A8811628ED822CE0817998E042261
          48349280A420E988145122C5C872A402A9426A915D4823F22D7214398D5C40FA
          90DBC820328AFC8ABC47319481B25103D4027540B9A81F1A8AC6A073D174340F
          5D8096A26BD11AB41E3D80B6A2A7D14BE87574007D8A8E6380D1310E668CD961
          5C8C87456089581A26C71663E55835568F35631D583776151BC09E61EF082402
          8B8013EC085E8410C26C82909047584C5843A825EC23B412BA085709838431C2
          272293A84FB4257A12F9C478623AB1905846AC26EE211E219E255E270E135F93
          48240EC992E44E0A21259032490B496B48DB482DA453A43ED210699C4C26EB90
          6DC9DEE408B280AC209791B7900F904F92FBC9C3E4B7143AC588E24C09A22452
          A494124A35653FE504A59F324299A0AA51CDA99ED408AA883A9F5A496DA07650
          2F5387A91334759A25CD9B1643CBA42DA3D5D09A696769F7682FE974BA09DD83
          1E4597D097D26BE807E9E7E983F4770C0D860D83C7486228196B197B19A718B7
          192F994CA605D39799C85430D7321B9967980F986F55582AF62A7C1591CA1295
          3A9556957E95E7AA545573553FD579AA0B54AB550FAB5E567DA64655B350E3A9
          09D416ABD5A91D55BBA936AECE5277528F50CF515FA3BE5FFD82FA630DB28685
          46A08648A35463B7C6198D2116C63265F15842D6725603EB2C6B984D625BB2F9
          EC4C7605FB1B762F7B4C534373AA66AC6691669DE671CD010EC6B1E0F039D99C
          4ACE21CE0DCE7B2D032D3F2DB1D66AAD66AD7EAD37DA7ADABEDA62ED72ED16ED
          EBDAEF75709D409D2C9DF53A6D3AF77509BA36BA51BA85BADB75CFEA3ED363EB
          79E909F5CAF50EE9DDD147F56DF4A3F517EAEFD6EFD11F373034083690196C31
          3863F0CC9063E86B9869B8D1F084E1A811CB68BA91C468A3D149A327B826EE87
          67E33578173E66AC6F1C62AC34DE65DC6B3C61626932DBA4C4A4C5E4BE29CD94
          6B9A66BAD1B4D374CCCCC82CDCACD8ACC9EC8E39D59C6B9E61BED9BCDBFC8D85
          A5459CC54A8B368BC796DA967CCB05964D96F7AC98563E567956F556D7AC49D6
          5CEB2CEB6DD6576C501B579B0C9B3A9BCBB6A8AD9BADC4769B6DDF14E2148F29
          D229F5536EDA31ECFCEC0AEC9AEC06ED39F661F625F66DF6CF1DCC1C121DD63B
          743B7C727475CC766C70BCEBA4E134C3A9C4A9C3E957671B67A1739DF33517A6
          4B90CB1297769717536DA78AA76E9F7ACB95E51AEEBAD2B5D3F5A39BBB9BDCAD
          D96DD4DDCC3DC57DABFB4D2E9B1BC95DC33DEF41F4F0F758E271CCE39DA79BA7
          C2F390E72F5E765E595EFBBD1E4FB39C269ED6306DC8DBC45BE0BDCB7B603A3E
          3D65FACEE9033EC63E029F7A9F87BEA6BE22DF3DBE237ED67E997E07FC9EFB3B
          FACBFD8FF8BFE179F216F14E056001C101E501BD811A81B3036B031F049904A5
          0735058D05BB062F0C3E15420C090D591F72936FC017F21BF96333DC672C9AD1
          15CA089D155A1BFA30CC264C1ED6118E86CF08DF107E6FA6F94CE9CCB60888E0
          476C88B81F69199917F97D14292A32AA2EEA51B453747174F72CD6ACE459FB67
          BD8EF18FA98CB93BDB6AB6727667AC6A6C526C63EC9BB880B8AAB8817887F845
          F1971274132409ED89E4C4D8C43D89E37302E76C9A339CE49A54967463AEE5DC
          A2B917E6E9CECB9E773C593559907C3885981297B23FE5832042502F184FE5A7
          6E4D1D13F2849B854F45BEA28DA251B1B7B84A3C92E69D5695F638DD3B7D43FA
          68864F4675C633094F522B79911992B923F34D5644D6DEACCFD971D92D39949C
          949CA3520D6996B42BD730B728B74F662B2B930DE479E66DCA1B9387CAF7E423
          F973F3DB156C854CD1A3B452AE500E164C2FA82B785B185B78B848BD485AD433
          DF66FEEAF9230B82167CBD90B050B8B0B3D8B87859F1E022BF45BB16238B5317
          772E315D52BA647869F0D27DCB68CBB296FD50E2585255F26A79DCF28E5283D2
          A5A5432B82573495A994C9CB6EAEF45AB9631561956455EF6A97D55B567F2A17
          955FAC70ACA8AEF8B046B8E6E2574E5FD57CF5796DDADADE4AB7CAEDEB48EBA4
          EB6EACF759BFAF4ABD6A41D5D086F00DAD1BF18DE51B5F6D4ADE74A17A6AF58E
          CDB4CDCACD03356135ED5BCCB6ACDBF2A136A3F67A9D7F5DCB56FDADABB7BED9
          26DAD6BFDD777BF30E831D153BDEEF94ECBCB52B78576BBD457DF56ED2EE82DD
          8F1A621BBABFE67EDDB847774FC59E8F7BA57B07F645EFEB6A746F6CDCAFBFBF
          B2096D52368D1E483A70E59B806FDA9BED9A77B5705A2A0EC241E5C127DFA67C
          7BE350E8A1CEC3DCC3CDDF997FB7F508EB48792BD23ABF75AC2DA36DA03DA1BD
          EFE88CA39D1D5E1D47BEB7FF7EEF31E36375C7358F579EA09D283DF1F9E48293
          E3A764A79E9D4E3F3DD499DC79F74CFC996B5D515DBD6743CF9E3F1774EE4CB7
          5FF7C9F3DEE78F5DF0BC70F422F762DB25B74BAD3DAE3D477E70FDE148AF5B6F
          EB65F7CBED573CAE74F44DEB3BD1EFD37FFA6AC0D573D7F8D72E5D9F79BDEFC6
          EC1BB76E26DD1CB825BAF5F876F6ED17770AEE4CDC5D7A8F78AFFCBEDAFDEA07
          FA0FEA7FB4FEB165C06DE0F860C060CFC3590FEF0E09879EFE94FFD387E1D247
          CC47D52346238D8F9D1F1F1B0D1ABDF264CE93E1A7B2A713CFCA7E56FF79EB73
          ABE7DFFDE2FB4BCF58FCD8F00BF98BCFBFAE79A9F372EFABA9AF3AC723C71FBC
          CE793DF1A6FCADCEDB7DEFB8EFBADFC7BD1F9928FC40FE50F3D1FA63C7A7D04F
          F73EE77CFEFC2FF784F3FB25D29F330000011A4944415478DA63FCFFFF3F0325
          8071181B6019AAC0C22DC8BA9E9583517FFBA45B72241BE098A8BC464A932798
          959389E1D3CB5F4BD7B55C8D21DA00FB38A59512EA3C614A26820C1C6C9C0C2F
          9FBC65F8F2E6F7FC45851792081A6013A9B8484A8B2756C1849FE1EFEF7F0C6C
          ECAC0C92FC0A0C0F5FDE62F8F6E14FFFF4F8D345380D00FA7B81B4364FBC8209
          1FC39F5FFF1898981819D83858198478C41984B9A4181E7FB8C1F0F1D3A78EFE
          80E39518069807C9CF066A4E5130E66360666362E064E762E064E361E066E563
          E062E565E004D24C8C2C0C179EECFBCFC0C8D0D9E971A412C500BB58A5FF6C9C
          CC0CAC1C4C0CECDC401A18781CBC2C0CEC5CCC0C6CDC4C0C1039660616161690
          F2AFEDEE0779689B0E46900100C49970E1FBA7F52B0000000049454E44AE4260
          82}
        Name = 'PngImage3'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000097048597300001EC100001EC101C369545300000A4D694343505068
          6F746F73686F70204943432070726F66696C65000078DA9D53775893F7163EDF
          F7650F5642D8F0B1976C81002223AC08C81059A21092006184101240C585880A
          561415119C4855C482D50A489D88E2A028B867418A885A8B555C38EE1FDCA7B5
          7D7AEFEDEDFBD7FBBCE79CE7FCCE79CF0F8011122691E6A26A003952853C3AD8
          1F8F4F48C4C9BD80021548E0042010E6CBC26705C50000F00379787E74B03FFC
          01AF6F00020070D52E2412C7E1FF83BA50265700209100E02212E70B01905200
          C82E54C81400C81800B053B3640A009400006C797C422200AA0D00ECF4493E05
          00D8A993DC1700D8A21CA908008D0100992847240240BB00605581522C02C0C2
          00A0AC40222E04C0AE018059B632470280BD0500768E58900F4060008099422C
          CC0020380200431E13CD03204C03A030D2BFE0A95F7085B8480100C0CB95CD97
          4BD23314B895D01A77F2F0E0E221E2C26CB142611729106609E4229C979B2313
          48E7034CCE0C00001AF9D1C1FE383F90E7E6E4E1E666E76CEFF4C5A2FE6BF06F
          223E21F1DFFEBC8C020400104ECFEFDA5FE5E5D60370C701B075BF6BA95B00DA
          560068DFF95D33DB09A05A0AD07AF98B7938FC401E9EA150C83C1D1C0A0B0BED
          2562A1BD30E38B3EFF33E16FE08B7EF6FC401EFEDB7AF000719A4099ADC0A383
          FD71616E76AE528EE7CB0442316EF7E723FEC7857FFD8E29D1E234B15C2C158A
          F15889B850224DC779B952914421C995E212E97F32F11F96FD0993770D00AC86
          4FC04EB607B5CB6CC07EEE01028B0E58D27600407EF32D8C1A0B910010673432
          79F7000093BFF98F402B0100CD97A4E30000BCE8185CA894174CC608000044A0
          812AB041070CC114ACC00E9CC11DBCC01702610644400C24C03C104206E4801C
          0AA11896411954C03AD804B5B0031AA0119AE110B4C131380DE7E0125C81EB70
          170660189EC218BC86090441C8081361213A8811628ED822CE0817998E042261
          48349280A420E988145122C5C872A402A9426A915D4823F22D7214398D5C40FA
          90DBC820328AFC8ABC47319481B25103D4027540B9A81F1A8AC6A073D174340F
          5D8096A26BD11AB41E3D80B6A2A7D14BE87574007D8A8E6380D1310E668CD961
          5C8C87456089581A26C71663E55835568F35631D583776151BC09E61EF082402
          8B8013EC085E8410C26C82909047584C5843A825EC23B412BA085709838431C2
          272293A84FB4257A12F9C478623AB1905846AC26EE211E219E255E270E135F93
          48240EC992E44E0A21259032490B496B48DB482DA453A43ED210699C4C26EB90
          6DC9DEE408B280AC209791B7900F904F92FBC9C3E4B7143AC588E24C09A22452
          A494124A35653FE504A59F324299A0AA51CDA99ED408AA883A9F5A496DA07650
          2F5387A91334759A25CD9B1643CBA42DA3D5D09A696769F7682FE974BA09DD83
          1E4597D097D26BE807E9E7E983F4770C0D860D83C7486228196B197B19A718B7
          192F994CA605D39799C85430D7321B9967980F986F55582AF62A7C1591CA1295
          3A9556957E95E7AA545573553FD579AA0B54AB550FAB5E567DA64655B350E3A9
          09D416ABD5A91D55BBA936AECE5277528F50CF515FA3BE5FFD82FA630DB28685
          46A08648A35463B7C6198D2116C63265F15842D6725603EB2C6B984D625BB2F9
          EC4C7605FB1B762F7B4C534373AA66AC6691669DE671CD010EC6B1E0F039D99C
          4ACE21CE0DCE7B2D032D3F2DB1D66AAD66AD7EAD37DA7ADABEDA62ED72ED16ED
          EBDAEF75709D409D2C9DF53A6D3AF77509BA36BA51BA85BADB75CFEA3ED363EB
          79E909F5CAF50EE9DDD147F56DF4A3F517EAEFD6EFD11F373034083690196C31
          3863F0CC9063E86B9869B8D1F084E1A811CB68BA91C468A3D149A327B826EE87
          67E33578173E66AC6F1C62AC34DE65DC6B3C61626932DBA4C4A4C5E4BE29CD94
          6B9A66BAD1B4D374CCCCC82CDCACD8ACC9EC8E39D59C6B9E61BED9BCDBFC8D85
          A5459CC54A8B368BC796DA967CCB05964D96F7AC98563E567956F556D7AC49D6
          5CEB2CEB6DD6576C501B579B0C9B3A9BCBB6A8AD9BADC4769B6DDF14E2148F29
          D229F5536EDA31ECFCEC0AEC9AEC06ED39F661F625F66DF6CF1DCC1C121DD63B
          743B7C727475CC766C70BCEBA4E134C3A9C4A9C3E957671B67A1739DF33517A6
          4B90CB1297769717536DA78AA76E9F7ACB95E51AEEBAD2B5D3F5A39BBB9BDCAD
          D96DD4DDCC3DC57DABFB4D2E9B1BC95DC33DEF41F4F0F758E271CCE39DA79BA7
          C2F390E72F5E765E595EFBBD1E4FB39C269ED6306DC8DBC45BE0BDCB7B603A3E
          3D65FACEE9033EC63E029F7A9F87BEA6BE22DF3DBE237ED67E997E07FC9EFB3B
          FACBFD8FF8BFE179F216F14E056001C101E501BD811A81B3036B031F049904A5
          0735058D05BB062F0C3E15420C090D591F72936FC017F21BF96333DC672C9AD1
          15CA089D155A1BFA30CC264C1ED6118E86CF08DF107E6FA6F94CE9CCB60888E0
          476C88B81F69199917F97D14292A32AA2EEA51B453747174F72CD6ACE459FB67
          BD8EF18FA98CB93BDB6AB6727667AC6A6C526C63EC9BB880B8AAB8817887F845
          F1971274132409ED89E4C4D8C43D89E37302E76C9A339CE49A54967463AEE5DC
          A2B917E6E9CECB9E773C593559907C3885981297B23FE5832042502F184FE5A7
          6E4D1D13F2849B854F45BEA28DA251B1B7B84A3C92E69D5695F638DD3B7D43FA
          68864F4675C633094F522B79911992B923F34D5644D6DEACCFD971D92D39949C
          949CA3520D6996B42BD730B728B74F662B2B930DE479E66DCA1B9387CAF7E423
          F973F3DB156C854CD1A3B452AE500E164C2FA82B785B185B78B848BD485AD433
          DF66FEEAF9230B82167CBD90B050B8B0B3D8B87859F1E022BF45BB16238B5317
          772E315D52BA647869F0D27DCB68CBB296FD50E2585255F26A79DCF28E5283D2
          A5A5432B82573495A994C9CB6EAEF45AB9631561956455EF6A97D55B567F2A17
          955FAC70ACA8AEF8B046B8E6E2574E5FD57CF5796DDADADE4AB7CAEDEB48EBA4
          EB6EACF759BFAF4ABD6A41D5D086F00DAD1BF18DE51B5F6D4ADE74A17A6AF58E
          CDB4CDCACD03356135ED5BCCB6ACDBF2A136A3F67A9D7F5DCB56FDADABB7BED9
          26DAD6BFDD777BF30E831D153BDEEF94ECBCB52B78576BBD457DF56ED2EE82DD
          8F1A621BBABFE67EDDB847774FC59E8F7BA57B07F645EFEB6A746F6CDCAFBFBF
          B2096D52368D1E483A70E59B806FDA9BED9A77B5705A2A0EC241E5C127DFA67C
          7BE350E8A1CEC3DCC3CDDF997FB7F508EB48792BD23ABF75AC2DA36DA03DA1BD
          EFE88CA39D1D5E1D47BEB7FF7EEF31E36375C7358F579EA09D283DF1F9E48293
          E3A764A79E9D4E3F3DD499DC79F74CFC996B5D515DBD6743CF9E3F1774EE4CB7
          5FF7C9F3DEE78F5DF0BC70F422F762DB25B74BAD3DAE3D477E70FDE148AF5B6F
          EB65F7CBED573CAE74F44DEB3BD1EFD37FFA6AC0D573D7F8D72E5D9F79BDEFC6
          EC1BB76E26DD1CB825BAF5F876F6ED17770AEE4CDC5D7A8F78AFFCBEDAFDEA07
          FA0FEA7FB4FEB165C06DE0F860C060CFC3590FEF0E09879EFE94FFD387E1D247
          CC47D52346238D8F9D1F1F1B0D1ABDF264CE93E1A7B2A713CFCA7E56FF79EB73
          ABE7DFFDE2FB4BCF58FCD8F00BF98BCFBFAE79A9F372EFABA9AF3AC723C71FBC
          CE793DF1A6FCADCEDB7DEFB8EFBADFC7BD1F9928FC40FE50F3D1FA63C7A7D04F
          F73EE77CFEFC2FF784F3FB25D29F330000011E4944415478DA63FCFFFF3F0325
          8071D4008401953BEDBF0029EE3F7FFE30FCFEF197E1D77720FEFA8FE1E7B7BF
          0C3F3E03C5BE03D95FFF02E5FE81E50E2DBEC7886240F90E9B7686FF0CE50632
          4E8CFFFEFF61F8FEFB13C3B7DF9F19BE02E9EFBFBE307CFFF98DE1EFAF7F0C0F
          CE7E62787AF5CB9C93EB1EA66278A17083653B3F1F5F85AC8006C3DB6FCF18DE
          7D79C9F0EBC76F867FFFFE33B0B031313C3803D6BCF0F8EA070938C32073A169
          1F97004BA1BCB81AC3F38F0F187EFDFCCDC0CC0AD2FC91E1D9B52F8B8F2CBF1F
          473010E3FA0DE6F188B0268ACB0833FCF8F59DE1DE99F70C2F6E7E597570D1BD
          70A26321A8467B099F385B3428F09E5DFFB276FFFCBB212447A3679EDAA3DF3F
          FE5FFCFAFE7720D0DF7F689B0E86AE01002653BFE17F380C610000000049454E
          44AE426082}
        Name = 'PngImage4'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002954944415478DAA593ED4B536118C6AF33DBD636734C13
          7599914E320B3243C9425351316C516964122E2A08C5FD0581627F4120414484
          1A884403732A4A6AA010256192F992DB7CD964BE8496DACE1967E7799E8E130D
          6B7EA9EBD3CD03D78FFBB9EFEBE61863F81F717F023C566B1223B44202A96462
          20968282316991803653465A4E3C6F75ED0998AFB1964A9434441C37C5E9D2D2
          C019F4805F4060D18BD5DE5E7C5F5D59208C584FBF68B3FD05D83413429A220B
          7275BAB45320AE3160C9038822B87003B8230958B177C133EBF4512259325ABB
          6D3B00774D4DA2DCF660544E96519B910ED2DF0E5EF0832301A8554A70948189
          7E20351DDFBADF607EC9ED254CCA3EFFF2ED74103057555DAB3546D5475EBB0A
          FABE0F84DF802008D82F0ABBE6437C02949979986C7C8A3525EA725E0D3C0C02
          66AAEF3B620A734C4AC90F7E6E0AD2A80BA1A48AD543119300DF9A80F12F03CE
          5CDBBBE420C059758F4FB852A2E1A646C0AFAF41FFE05148C0F24D33940603C2
          CE9CC5C7F64621FFF590360870DCB5F0878BF3359CE313A8DC85A6F6C99E00EE
          801EEACC7318EA782614B40D6F0126EFDC72C4A4269B344A02C93D03DEFB2374
          6A140AA8534E62DD2F6262A4C759D4F979EB0B63B7CB6BD5FC46FDA1EB3720F6
          74802A24043602BB07B8B96E850AFA8B660CDB1EE3A7C8D715778D6F0D71D452
          9648146CF0A036C21899970BC16E87BC6B304240C0C96E2A23F621E2D265B8FB
          BB30B73CEE251CCB2EE99C98DE09D27085B99432A9293A3C4A179D570871D605
          D1E5021529D4C74C50C51F85A7CF8E9995291FE5A84536FF0ED2B63E9417C969
          941AD4448C8B4FC992D7660CBEF35E379C6303E0897F41365BB7CD218F69B0EC
          42129302155218AD6494C4CA0705B95E94EB662A492D25DD5FF73EA67FD12FCA
          BE71F0E82977BB0000000049454E44AE426082}
        Name = 'PngImage3'
        Background = clWindow
      end>
    Left = 392
    Top = 252
    Bitmap = {}
  end
end