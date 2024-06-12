object frmItemswnd: TfrmItemswnd
  Left = 566
  Top = 275
  BorderStyle = bsNone
  Caption = 'frmItemswnd'
  ClientHeight = 260
  ClientWidth = 345
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object lbWeatherList: TSharpEListBoxEx
    Left = 0
    Top = 0
    Width = 345
    Height = 260
    Columns = <
      item
        Width = 50
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calLeft
        StretchColumn = True
        ColumnType = ctDefault
        VisibleOnSelectOnly = False
        Images = imlWeatherGlyphs
      end
      item
        Width = 150
        HAlign = taCenter
        VAlign = taVerticalCenter
        ColumnAlign = calRight
        StretchColumn = False
        ColumnType = ctDefault
        VisibleOnSelectOnly = True
      end
      item
        Width = 35
        HAlign = taLeftJustify
        VAlign = taVerticalCenter
        ColumnAlign = calRight
        StretchColumn = False
        ColumnType = ctDefault
        VisibleOnSelectOnly = True
        Images = imlWeatherGlyphs
      end>
    Colors.BorderColor = clBtnFace
    Colors.BorderColorSelected = clBtnShadow
    Colors.ItemColor = clWindow
    Colors.ItemColorSelected = clBtnFace
    Colors.CheckColorSelected = clBtnFace
    Colors.CheckColor = 15528425
    Colors.DisabledColor = clBlack
    DefaultColumn = 0
    OnResize = lbWeatherListResize
    ItemHeight = 30
    OnClickItem = lbWeatherListClickItem
    OnGetCellCursor = lbWeatherListGetCellCursor
    OnGetCellText = lbWeatherListGetCellText
    OnGetCellImageIndex = lbWeatherListGetCellImageIndex
    AutosizeGrid = True
    Borderstyle = bsNone
    Align = alTop
  end
  object imlWeatherGlyphs: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000001FE4944415478DAC5934D6B13511486DFC9CC6466F221AD
          D9842216DBF1A34D54B2F36F28B830D91802FD018236AEDA9DE8B23F207421C1
          45149252928A24211230213B092DFE04ADE4A39399CCB7E70EB410445C58F00E
          87E1DE7BDEE7BCE730C3F9BE8F7F59DCA5017ABD5ECCB2ACA7B66D3FA2F7038A
          2F141F4CD3DCCFE572DA5F019D4EE7452271F57524124158E46118737CFF718A
          E3E393ED42A1F0E68F806EB7BB4255B7A8DAF64DF586AC9D4DE03826045E8412
          8DE3E863539BCFE72FE97EBF582CFEE6846BB55ABBC9647247960430B169EA80
          EFC1A787E765D80E303DD3E8DC9C50A1F7BAAEBFCD66B3AD0B40A3D1186EDCB9
          B539199FC2B20C12FB703D975C008E17C2DA9A0A4992C05A9DCD66180C065F35
          4D7B96CFE73F05806AB53ABC777793003FE1D8265C9F876D330720F13A388E23
          98135413453180F4FBFD774F68058072B9BCBBBA7A7D6769E90A74DDC0F27202
          B1582C10789E07D77583600E184C511450DB1E810EA89D3DAE542AAD1886B145
          837A9C4AA5D633998C44FD06629EE7110A852E206CB1B370388CF178CC40870B
          1F52B3D93C49A7D3B769E2018055648073276CCFF2593027B55A4D5F00D4EBF5
          57AAAA16E3F17820208B018025B3399CEFA3D12846A311DAEDF6D102A052A95C
          9365F939597C48008E9C0C49C893F0FE743AF50541F846690A39DAA0BBCF94B3
          7779FFC27F03FC029BC94095581521EF0000000049454E44AE426082}
        Name = 'PngImage3'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000001FE4944415478DAC5934D6B13511486DFC9CC6466F221AD
          D9842216DBF1A34D54B2F36F28B830D91802FD018236AEDA9DE8B23F207421C1
          45149252928A24211230213B092DFE04ADE4A39399CCB7E70EB410445C58F00E
          87E1DE7BDEE7BCE730C3F9BE8F7F59DCA5017ABD5ECCB2ACA7B66D3FA2F7038A
          2F141F4CD3DCCFE572DA5F019D4EE7452271F57524124158E46118737CFF718A
          E3E393ED42A1F0E68F806EB7BB4255B7A8DAF64DF586AC9D4DE03826045E8412
          8DE3E863539BCFE72FE97EBF582CFEE6846BB55ABBC9647247960430B169EA80
          EFC1A787E765D80E303DD3E8DC9C50A1F7BAAEBFCD66B3AD0B40A3D1186EDCB9
          B539199FC2B20C12FB703D975C008E17C2DA9A0A4992C05A9DCD66180C065F35
          4D7B96CFE73F05806AB53ABC777793003FE1D8265C9F876D330720F13A388E23
          98135413453180F4FBFD774F68058072B9BCBBBA7A7D6769E90A74DDC0F27202
          B1582C10789E07D77583600E184C511450DB1E810EA89D3DAE542AAD1886B145
          837A9C4AA5D633998C44FD06629EE7110A852E206CB1B370388CF178CC40870B
          1F52B3D93C49A7D3B769E2018055648073276CCFF2593027B55A4D5F00D4EBF5
          57AAAA16E3F17820208B018025B3399CEFA3D12846A311DAEDF6D102A052A95C
          9365F939597C48008E9C0C49C893F0FE743AF50541F846690A39DAA0BBCF94B3
          7779FFC27F03FC029BC94095581521EF0000000049454E44AE426082}
        Name = 'PngImage4'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002AD4944415478DAA5935F48536114C08FD3FDBDA2D3C03F
          838CDC9C0327D1242171255692A13D64116925E5831609F522D1C3CC32A8A71E
          7CF0A52C1344AC3D0865A695A5A8889882E6726E13256F7F4CD331EFE69DF7FB
          3AFB0642992F75E070F9CE3DE777CE77BE732228A5F03F12F12740BA73594F28
          2DA5849C278424A102EA57D4274422ADDA7B2DEE6D01C1FA4B2594D086B50845
          B2426F80A89898B0DDBB0A82C3013261F50B215275C2FD76FB168078BB0A8349
          F37A420AA731A681C4CF01410D892C390564BA5DE09D7240C039B14624A97C67
          63877D13B05E57998A25F68B49293ACE680471A09B056A6C0FD9D767BB004028
          28AC05B03AF9117C8E315E22C46A68EAF2308060ABB0F923D575B1B9D67030DA
          428571379B18C07BA31C284133F6437DF0282CF47481B8C4D79A5ADEDC620074
          9891992D0679D00F1BB34E74A42C6374FD630658A9390754A24050E5FA7408CA
          95C0BF7BE1CA6CEB4B6380E59A3281CB2B506F7C18041A58C7AE539631F66E33
          032C5D2D6350A6910A50EDCF05F7D347FEBDF6410D037CBF765A88C92F540747
          07800444566A286374E575901BCDB078E50CCBCE2A932B408380E9F607FE7D1D
          2361005F7D6286B3E41AA2440144E7A74D67C59E6C90C52780AFAB239C1DED8A
          74136CA854E079F5CC95D33916BEC27CD5711BE5E2EB12F30E83AFA793398720
          898D6DEC0AFCC553D89230547BAC086611B8B2E0AE3DD03D116EA2BBA23015DF
          B63FDA64D1C59A32C0FBF23973566666018681303AC2CE7145C5B038390EF343
          AF797C766BFE5B87677390A6CEE69720A4599B91CDC599CC1098F540C0E586D0
          7FE5EE54A63F30786EA87B0D83CB0FF54EDBB78CF2F8C99C121C900655BC2E79
          87D9024A6D1C9B87C0CF65F836360CCB9F5D38CAA4FAC87BA7FDAFBB1092E1E2
          2C3D424A71717099A4DF978990D6823ED7F6CBF42FF20B25BFAEF0015EBF0E00
          00000049454E44AE426082}
        Name = 'PngImage5'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002154944415478DAB593CF6B135110C7A7EE65373F88420E
          DA92822221DD5662F1E245F0B4FE053D781384EA490988E0257AC941512F01A9
          01238B81407E1021E4E0124241025B456B2B5610BC88DA434820C9667FBFB79D
          B7A49190838274E0CB30BBFBFDCCCC7BEC9CE779F03F3177648072B97CD9719C
          ABA82BB66D03EA0DAA984AA536FF0A28954ACCFC3891485C088542E0BA2E743A
          1D5055F50342EEA4D3E9CD1940BD5E9F47D33A6A0D754A14C5133CCFC3683402
          AC81E338E876BBD06EB773994CE6C60CA05AAD3E88C562F72391081042C0B22C
          DF3C1EDF7F160804A0D16850AC5FA13630D409A0582C7E492693A2699AA0EBFA
          C4C8BA1F6616C16010FAFD3EB45A2D399FCF5F9B006459F6019AA60183B08ECC
          C82661E6C39A520AD168142A954ABF50281C9F0072B99CBF42381CF63F645DD8
          E1B1B119603018F810F6BED7EB41B3D994F1B0FF4C90CD66E7D1B88E5A1B8FFF
          1EC5A12E8D57D84609A88BA8D708DFA8D56AEAD435DE7AB9FFE81807022560B0
          6C5A9E413D2A68B667B82E152C931AC4F5047DE8DE6D3D8C1B53B770F3C5EF93
          E717F9DD4F3F4C69658157B6BE8FA49518AFA85F3569F9B4A0BCFB3C9496CE06
          958F3BFDD5B74F977ECD5CE36D79FF894B3CCE7428B15D8F332C4A884371054A
          5C9B720E663C02CED4C9BDAD67A23105B8FEFCE7C2728CDF56BFE9D2B945ECBE
          A749893302761B4AF17840D9C19C1043CADEEE7015CD93EE47FB33FD6B1C007F
          1F97F02E424D810000000049454E44AE426082}
        Name = 'PngImage6'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002154944415478DAB593CF6B135110C7A7EE65373F88420E
          DA92822221DD5662F1E245F0B4FE053D781384EA490988E0257AC941512F01A9
          01238B81407E1021E4E0124241025B456B2B5610BC88DA434820C9667FBFB79D
          B7A49190838274E0CB30BBFBFDCCCC7BEC9CE779F03F3177648072B97CD9719C
          ABA82BB66D03EA0DAA984AA536FF0A28954ACCFC3891485C088542E0BA2E743A
          1D5055F50342EEA4D3E9CD1940BD5E9F47D33A6A0D754A14C5133CCFC3683402
          AC81E338E876BBD06EB773994CE6C60CA05AAD3E88C562F72391081042C0B22C
          DF3C1EDF7F160804A0D16850AC5FA13630D409A0582C7E492693A2699AA0EBFA
          C4C8BA1F6616C16010FAFD3EB45A2D399FCF5F9B006459F6019AA60183B08ECC
          C82661E6C39A520AD168142A954ABF50281C9F0072B99CBF42381CF63F645DD8
          E1B1B119603018F810F6BED7EB41B3D994F1B0FF4C90CD66E7D1B88E5A1B8FFF
          1EC5A12E8D57D84609A88BA8D708DFA8D56AEAD435DE7AB9FFE81807022560B0
          6C5A9E413D2A68B667B82E152C931AC4F5047DE8DE6D3D8C1B53B770F3C5EF93
          E717F9DD4F3F4C69658157B6BE8FA49518AFA85F3569F9B4A0BCFB3C9496CE06
          958F3BFDD5B74F977ECD5CE36D79FF894B3CCE7428B15D8F332C4A884371054A
          5C9B720E663C02CED4C9BDAD67A23105B8FEFCE7C2728CDF56BFE9D2B945ECBE
          A749893302761B4AF17840D9C19C1043CADEEE7015CD93EE47FB33FD6B1C007F
          1F97F02E424D810000000049454E44AE426082}
        Name = 'PngImage7'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000010000000100804000000B5FA37
          EA0000000467414D410000AFC837058AE90000001974455874536F6674776172
          650041646F626520496D616765526561647971C9653C000000F44944415478DA
          63FCCF801F3092A4E0A0C3DFC83FEEBF197EEFFCB33CE4008682830E7F7A948D
          8519FE333C633877F67749FC01B88213527FD2FE84FE91D4101461F80B567C87
          E1F4AC9474B882C30D62F5920C4C40F80FA81F04191996FEFBBDF8F78CE21360
          05FBAE1A69B1412521245027C34D86030B2B12C00A765D35012B60809B0081B3
          3ED60880156C6910AF9703DAFE12A84012885F002D9366B8C1B06F6123C484F5
          52BFD37E87FE61F87DFA37F31FDBDF0C7FCEFFE1FC63F167C3DF19AD27A0DEF4
          D565506078B0F9323A0D0F075FDFE59B96146E9DCF60874A6FFE8862023A4632
          019B299B3FA20535A6FD44C5260021D198015F2E4D180000000049454E44AE42
          6082}
        Name = 'PngImage8'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002424944415478DAA593CB6B13511487CF4D9A74F2AA814C
          32A34D4B696B23F840A14B0529294545C40825DA9682B8D695EEAC8F85601174
          E9CA854F5A50AC8B0A7D18A1F43F3018349090419A49266927CD4CD32633D773
          532984C647F1C28573CE3DDFEF9E731F84520AFF33483381CA67B1953B9DDDD4
          63E275A0F0C63990CDEF4940FF24528488B628B0E5BBEEB07CAF342FD0B64199
          FC5100C10504C3BFC0788B3878786B657E16ED219C6BDE21992F7E0C84D0D67D
          6773D22E81F2A260A24BB0ECEFDC91DB0759CCD431CFE6052DFE7806D72EB074
          FE5C8E3454505E10048C8F79C2F223754EA0CE6377C0D424A0551508B100B1B5
          81012DB01E7F0A81F339D2B4050632D3B63F0CB67DA1BA00D01A4E035729585C
          1DB0514C822EC580E59914B86024BFD9D002F6B7EA393EE1354B0964CB7598D6
          456A40EC1E302C5E58FDF2FC7D30A25C6CA8A0301B600775A6F5401838A11F0C
          350160E83B30F6826DB881721DA0E5BE82262DB32A7C5DC34AB1A102F983FF89
          ABFBD20D9BDD0E66258791EAB60021607577819A4D41595ABE868815A9B99EA8
          92DE115899F18FA0F9D2111C0097D80F544F01DD2A6CEFEE10412B69B09E5982
          DA46097A2E2B64D721FE78E77FD61EC95F95DEF2935647E0A6337812388F0F2C
          B8BBB626839A8A31B81DD31FB233EC1B51C69BBEC4F434CF42BD56079FACEA4A
          C6D379AA534D2F4DE245DCC2F854DFA812FDED4B4C4DF147D1CD74471535F99A
          A7BD5714F2ED155FC1D883D0A8723FF1C2377D68AC30FCD7BFC0068213582683
          4EA0EB4530F6CF9F692FE327EC1547F0214E92010000000049454E44AE426082}
        Name = 'PngImage0'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002304944415478DA63FCFFFF3F033A58BD7AB5C3EFDFBF23
          81D8FDD7AF5F0C40BC1388971716161E4057CB886EC0AA55AB409A7B7475758D
          79787818FEFCF9C3F0E6CD1B8643870E9D051A525257577700C380CD9B374B01
          35A5017128104BEAE9E909B2B1B1317CF9F2056C002B2B2BC3870F1F18F6EDDB
          37ABB5B5351DC380B56BD736282A2AD6F3F3F38335FCF8F183E1F3E7CF0C50E7
          33FCFDFB974140408061FDFAF5FF80FCC5403C03084EC00D58BE7CF955535353
          2D90A6AF5FBFC235025D03A799989818040505C1AE02BA78E1BC79F312E0062C
          5CB8106C00C899DFBF7F67F8F7EF1F5823C82520CD303E48ADACAC2CC382050B
          3E2E59B244006EC0AC59B31A949595EB41CEFCF9F327D8BF206773737383BDF4
          F1E347B021202FBE7BF78E61C3860D0B81818D70C1E4C993A58036A4B1B3B3D7
          EBB12DFEC6C7FA8E5D49F83D332882C0F82F03C35F2063D959B57F87EFC82C06
          1A3A03181E2730A2F1EB5E711620D79749C8701DABB43BC3FFDFEF1998789418
          3E1E2BFB0614CF13F17E35176F3AF8B45BDCEDFF3F86A9EC2A912AFFBF3F64F8
          FFEF27C3C7C7371924BDEF3232E0002806BCDF21F6905333438E898509E8EE7F
          40592620F587E1EDC5A50C523EF719711AF06EBB181390EA02865331C83C7629
          1B064E093D861FAFAF337C79720AA766AC4919049EAE137DCC296329F3E5D1B1
          8F406975F9D0372F8932E0C93A113620B7985DCCA0EDDBF30B6B14C2DE843210
          0028063C5C2D1206F4C622A0509C52C49B558434E3F402290000337F6CF047B8
          24620000000049454E44AE426082}
        Name = 'PngImage9'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000003774
          455874436F6D6D656E74005279616E20436F6C6C696572202870736575646F29
          0A687474703A2F2F7777772E70736575646F636F64652E6F7267F6EF6C6E0000
          03134944415478DA5D536B6BD360147ED2A64DD24BDACEB5E20544BB79419C8A
          FB22EA10A7C274F813FCE42613744C650E44BC216E759B77BC8BF817BC8D5915
          A7E017D926A8A0DD4DF6614ED7B54DDBA449DAC493E8C6DC0BE1246FCE79DEE7
          39E77919CC5BEDB10B952CCB1EA067BBAEEB6BAD3DB7DBFDB5582CBEA5EFBB6D
          AD271373F39939850EA7D3794C103CE76AB6D570CB962D673C8200C334A1A91A
          46C786F1FACDAB42A9543A4B403102326601AC6297CBD557515159BDAB763747
          4950B50294820C17EB86AE17111045081E2F81C4B52F5F3EF76B9AB6C502B101
          629D178FAFAFDA707EEBD61A5E925228A88A7D2AC7F32046C8A4D3703A5984CA
          CA20FA0378F6FCA99A487C3B7DFCE8890EC6D2CCF3FCE0C1C626CFE4E44FA8AA
          8A5C3E0BB5A05ADA118E446018264ABA0EC1EB8187007D5E11B7EEDC2CC872BE
          CA02385F57B7B76DC9E2C56C3A93C6EFDFBFA8C0A007F07A049487C3989898B0
          A52C5DBAC4162D701E0C8F0C9BBD2F7BDA99AECBB1BEC6034DDBA6535348A592
          C82B324C3AD14B7A83A110681AD034158AAC400C04C0711CB25216E1F2081E3E
          BAFF81B9D4D59E3972B8451C4A7C839495ECD32DEDD45438E8B4403048EF6E8C
          8F8F0326B1F2112B2A2E0B2EC0956BDD39861A9869693E268EFE184132998469
          1A28150DB83917229185D444010E8703994C06ACD34912183B46228B70EDFAE5
          2CD3D9DDF1A6B1A1697BA954A4A414B2F91C244AB6BA1E8D466D8F98E4859945
          86B201BD821FF71EDC7E6F37714F5D7DEBCACA95EEE9F414E9D528CD019D747B
          7D3E7B8CBAAED9C53C2F4096651AA588A1A144F145CFF3BF63F4F97C03071B0E
          797379C936104F5DE6389ED83224A7085557ED6245C9D39E037E9F881B37AFE6
          69E41B679CD8B27AD59A33F5F5FB44299B81414E0C51932CAA167D5B1EED3BE9
          DB4F468AC77BE5C14F03A7C889DDB356A6155FB7AE6AD3CEDADDA25560D9D930
          0D7B2AD658796264F5E5D98B27D944E27B3FFDDF316BE519100ACDE4BEB3B53B
          76B12B564405CB890E92A1140A181B1B51FADEBD3572B9DC29CABBFADF659A7F
          9D29EC27469B2956FFDBFE484C3E507C3CFF3AFF01DF2C77DC015C6F30000000
          0049454E44AE426082}
        Name = 'PngImage1'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002784944415478DAA5534B68135114BD2F4D6263328DA999
          993409585283D44541ECA25D28683FF8C1AA95BA0908A228512A64E9AACDC2B5
          A220410A52228528A8A1B468136B51C145C16E4A211A28A2533BF9D0E6D76932
          9319EF0C243428BAE883CBB9EFBE7BCE3BEFCD1BA2280AEC66909D02C27B87CB
          74629D53F3D23BF6B9B98FBFACE6F9186B6E19E04BFF1528CD3B2E80A24C61A9
          03638D1AE0496E8E55AC833CF9A703DCED10CA7CB4F4F14C21C6AA2545DFD64F
          2A6BF16F38F1DA4EA548769689617DD07E36A5FCD501DACC60BADFD0D60F46E6
          3828620E40B707724BF7D258A731A69973A9A13F1CE4E6986BB83881F1B8F9E0
          D55B3A430BC85B3F01E46D207A0BE84C4ED8E21741E03E5CC79E658CAFCE8BE9
          8D06071B6F18160CD6754BE71DA8E65700AA028052C5EB908018CC00A60390FD
          F2B08ABD57DCC399A906079919FA3C6A3C35B55FB2192817C8852492258D5C10
          1D90D9F6424A708350DC94245198C997A9073E9F6FA12E909AA65B51A00BD55F
          B51EBDBB4F4607B2588482C4C26ABE07D8F65EA0280A54A7D96C163E7F9A5F11
          2A70DBEFF72FD48FF02B4A8F218C1BDC43506A3E09E94D0B14CB4DD0E1EDD2C8
          922469027ABD1E388E83783CFE241008DCAC0B702FE947AEE1F4E8F2DB5165AF
          370056AB1508211AA946D69AB166341A21140AC9954A258C11AA7FC6EF2FECA7
          7FD8EECF761E39A3116459D6A2366A7D3A9D4E1349269310894426EB02AB117B
          6FC2FA6CA2BBBBFBB03A57C9EA8EB57CA7905A578F130C06730D4F391A8D8E7B
          3C9E31866134927A692AD234ADADF33CAF39703A9D904824201C0E4F3608A025
          279EEB46B95C1E4104C445C426C463EA5C14C5254413620FC66BBC9F10D9EDEF
          FC1BA00A7508772B68BB0000000049454E44AE426082}
        Name = 'PngImage2'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C0000036A4944415478DA55536D6C5355187ECE6DBBDEDDF58BA6
          DD474A270B66E2E68C56443EC6CC102910019D0A621CA086458D683421FE31D1
          4463E20F7F49D098E0468220444C068E211F73A164421CC32222B1E8A0D2B5DD
          E8CAEED6BBDB7BCFB9C753E2C83CC9937372F2BCCF79DFF7BC0FE19C63F67AEB
          ECCBCBC5B643E05181A0805D6042E03CB7F8EECF5BBA8ECFE693190111582276
          093CB7AE76A5D35F1EC4845601CD0028D34191C5E9915ECA283B4929DBF8F5DA
          8353770544B0439C7F5A186C5C160DAF80AA3B518481844A50C69DC869163835
          508E02D2C51806538397A8495B0E6CEC9E9811F82612A87FF1F1D012E890C199
          078661E28AEA80C3E6442ACF619A14365D455D701249F534CE247EED3DDC7E6C
          2DD911DBD62C5EEFDBF9D056479C16A013A082B9002D8054C181A24970F5C624
          6019A8AAC9A132308C8572081F1CFD82892C9E2D091C8E861E6BAB7687F1A79D
          42E235A8A33262293B2C6A47223305228F4309FD0D49CEC0B27444A6AA40F469
          740EF49C280924B7DFDF16BEA86530264B68B02DC61C46B17F8843D719BC351C
          AAFF1046ACDB220B0E1F75A22EEDC4CABA08DEFF6E57BA245078BBA95DD99F89
          61D4A6A149590DB7E1C1B17316BCC169DC53ABE1776B1CC3C5389C7C12CA581E
          73F30A5E5DBA016FECF9689ABC7966ABF64ED396F2CE640FF20823E27D00FD03
          A207E52E14B22A42F30157651693A2A16ACA144D1E84CF18C66BAD9BD0F1D587
          3A79BDAFFD6647635BA87FEC37187233F4BC1D97AF2828737BC021E1F6580EFA
          AD82485F87B75282AFE22F04C845441F598E9D7B3FCB92ED3F6E3EB2A676F13A
          87D38353E99B82702FAE5D0EC3945CE0361F4CF1FF4535073635019F97C163FF
          058DF374B8B88CDDA7BEEF27DB8E3EBF8A9AACE7BDE657EC5DF11FC08803B4F8
          34C673A20CB9128C59D046FF8152750D1E3901924A6273F429BCBBE7D3D208BF
          746790367DBBBE7B51F582F5F5D5F37121731D96F4046EA51570D90F4A398AE3
          29B8FCFB608D16F170C302243323E88D9FEB1FFA24DE7A47A06DEF1AB769B0B3
          4BE6363CB822D282ABA37EDCB82E3221656202258826205CFF33EEF3CC43DF85
          011CBF743E215E6F110299BB668AEE6A758BC93A28CA7972CB32612C560DCE15
          108920E05391CD0DE1CB13DD4C5063022F88E0ECFFDC38B3967EBCE819E1B80E
          517B93C5AC39FF5D97ECFC8740A708DC379BFF2FA0E2A2600875B4EC00000000
          49454E44AE426082}
        Name = 'PngImage10'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000019449
          44415478DAA593CB4AC3401486FF7980260DC49D894B0BBA68FB1A16BA70A150
          445C6A5AC4FB465A5A14B78A062928DE0B8A1B4B2B2A49FB002AED421FC0BA89
          909ABE419C1C4B516C84EA59CC993933FF37E7CC85E5F3F94BCBB246D19B8D65
          32990BAFC3B2D9AC9B4EA77B52E772397000FB06300C8326A391288F02B55A8D
          C691F698B5C59224FD06605C1001EB0018A2D130796FB5CB5B490AFA004C8396
          359B361E1EEF61BD59B463683084582C0E455108120CFA010C13EFEF368AA52B
          ACAF6D40555402345E1B486756B138BF4C105F80699AB8BDBB81A62531A00EF0
          32185CD725C84BE30567672798994E7180D81D50E180FDC33D9C1E1748FC15E0
          F9C9A9096C6FEE40F4CBC0711CCCCEA570747042E27ABD4E07EA893B802D1DA2
          E89381D372B0BBAB239198A0123CF320E170F8B384C229B4E9A43FA052ADC2B6
          6D94AF8BC865D77E1CE2D2C20AC50451F00778913E5946B15CC4F3F313018686
          8611E7D7D8AFAA342F083E8056AB4502F6F5D975BAACE30342A03BE0CF7F41D7
          F512AF7DA417802CCBE79AA68DB793FC9F7D00E11CED111534DCB70000000049
          454E44AE426082}
        Name = 'PngImage11'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000003844944415478DA6D536D6C5365147EEEBDFDEE5D5BD68D
          D6C218B303BACEA16E86600D6E643F90B0CC3036A26046883324242684CC1F64
          610C13D004B398688888289B4EC55413DD8806131DE86620C321C49515BB391A
          4BF7D1AEB7E3B66B6F6FAFA71725FEF0244F9E37E79CF739F7DCF71C46511488
          171916403761272143D862DEA114F8A1518E83E8126199D04EF1C9829F59FC12
          5AE213DA357BF6E82A3A56A5A7CFCDDD8E0877BE307D95237FCD3FF76FB5A576
          B3DE354EAF466F673281137F90AFD5D6A28499D94FD16570BF74D050FE822B39
          ED4FCCDC9DD47CEF1AE479830CA336AFDE4E4B2CB229118DD15DA9B5DEE7C1C9
          493135D11BA6D06626FC118E5A6BBB0EA584BFD8D0CC243F567941E330692027
          B2482C88C8C980A5D8089D5D876521089FF066BEBCB643498E7587A4C4ED6626
          F41EB6488CE98305D6BD7AC4FDB5A9CCAC815E94F1F8BA62D82C2C1430880B32
          AE06E621193998E37E5489FE8CF67E6042AF245F640A3FB1F3DCE029CE56D1E9
          76F0B06514EC6EACC0A22060414CA3CCE554DBC829C0271743C8F30AA273118A
          694E9EDEEFEB5205F69EF975D865D7D5BBCD3AD4D73851EE2C423E9B46DFE717
          D0B6AB0546830197864750FA681D46C6EF22CE3288C4B297070ED436A802AD6F
          5F8995AD2C2A762A1CF6B75441CBD2A7EA591CEB398EEA8D4FE0D66F37D0B86D
          3B5CD54FE2C3817128362DC2734B71FFA167EDAA40F31BDFC69CA5F66217A7C3
          CB6DD5D0731CB25911E7CFBE8FA5A5FBD8B1B305DEC76A30234838FFF1756478
          16D1F958FC9B23DB1F083CD7ED1FB6ADB0D7579558D1F0B41BEB575B214B126E
          5EBF86AA8D3530592D48D3588D4F27F0D3CF9388A452482CC62E7FF77AEB8316
          B6BED6D763345B8FAD5BB5128F584BD0D1B61E1C8D91862B8C1A20D338E4887B
          078248A6A298BA17475A148EFF786A5F8F2AF0CCABA79FA2D43EB3ADCC5B4DD5
          9D2B1CD8B6C9814A8719F48E989A1331F84B14F762110467458889F004E5EF1B
          79E7E0982A50B04DAFBC75A0CEEDE8BD93E04DAE121E76BD1E5C9EA5EA0A2426
          07219B412E97835989A56EFE397FF8DAD9CE33EA2EFC2B303A3ABAD562B1FC30
          3B1F97BBFD412ECB98C0720635969797516A9270A4B95261E909A99B069FCF77
          E5A1C0D0D050299DA73C1E0F3F1108C48F7E76F55DAA5CFFDF65220C9FDCBBF9
          B067C386A260305858344F5353534815E8EFEFE7C93146A820D4B6B7B7FF8EFF
          31CA5B4B74A3B0DD843ACA8BFE0DA2BC83D270DDF4040000000049454E44AE42
          6082}
        Name = 'PngImage12'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002DE4944415478DAA5936D48935114C7FF8FAFB939B569E5
          66A66E0E095F52D1FAB01484243045D028B050F04B5129FA21B21714853E2424
          88A4465128BD510D47504465465343372A34CB395F524B4D5D6A5337F7BCDCEE
          1ECB0F995FEAC0E5C2BDF7FCCE39FF7B0E4308C1FF18F32720A7D1AC66052E8F
          7042FE8A930DE6880002610A109A798EBF6338AB1DDA1090DDF029D7E964EB22
          FC8962775800FCBCDCC5F3053B0783E51B7A271627A94791B16A9F6E1D20ABBE
          2FD769679BD2351269CC7619BECE3A31B560072F10F84BDCA1F4DF04CBAC0D2D
          AD834BF04081B1365BB706C8ACEB55B12C67488F942AA31432740FCF83E358EC
          0ADB0CD0FBB7237360DC18442B7C313E6783FED9C004889062BC76785804ECAF
          7D571E21259599F14A749AADE0594E8C5C752446CCEEFCEDF714047879B8212E
          4C8E27DD66987B662A4CB78E568980B41A93253F6E4BE4A29DC59875913A53E1
          E84A54CB5D7EE81A985C2D98BE5506FA41EEEF8D1BD73B068DF70B3522407BB1
          63F9747AB84FB7791676270796672980C795E35A1170A2DE200269C5F0F46090
          1A1B8A4B358FED26DD498908482E6F5B3E97A1F1793360C5927D913E26AE6038
          75201AE1DB64286DA4007AE08279D28F494B52A1BAFA91DDA42FFE0D78613996
          1A1E695D70627CE607789A8140231665C522225886E2BA57347D573F106C0D94
          2124C40FCD575B078D2D25AB2524973D2DDFA9F0AECC4850A1FDC3172A228F6C
          6D38D21343E146D5EF199AC1E57B5D2E11A08D57A1B5D38C918FA315C696D255
          11934B5A5458E10C99691A65845C8AF6BE7170AE9FE07910BA935FD113A27660
          9675E0F903C30403A418F56786D71A29A9F06E2EB1399A327262A5AA2019FA47
          A731F3DD068113200F9040131A84CFF336BC7CD8B604C6B3803AEBD6B572D2A1
          9BB920CE3A75B442B1774F24027DBDC4B4A7171C78DDD98FB13ECB24C3B81519
          F565BABFCE82CB920F36A809E1F3A868F9101CC12EF11886A1C3846606EC9D6E
          FD858D87E95FEC27BCCF85F03B2A06720000000049454E44AE426082}
        Name = 'PngImage13'
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
        Name = 'PngImage14'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002604944415478DA85935D48935118C7FF67EF6699A82392
          6A52B458765110E4D64D19E1452054A0AB8BE84229BC88B0D475B1D84DF97193
          D54518F6E117215D4497051911F485B2694E05238746E8C0B51C6BCD6DEFDEB3
          737A36D9456BAB03870387E7FCCE737EFC0F3BEE1C7B5A566AB0E874304AC814
          C0C0A484CAE55A24A60E2643A1871F1E9C4AA0C060F62EB7F799CB56F23D2A14
          461B820E6B2901BD020C8F8731E9F6BF59595EBEFCBEEF442C2FE04CB767FE7E
          6BB5FE734040D14924B94024CE71ACAA18DE00C7D462042F5ECF3D7ED959733D
          2FE074B7C7D7DF56AD2CFC10E9EEA111E0573285DD4681B24D066C3430B4F5CF
          8847970E5A0A0206DAAB956F2101EA1E9A90886B025FFC3FCD2AE7E0044C8F79
          FF6A8C09C92209BEBCB4141F21373DE426CEEC04186AB72A4B619929E40450B5
          143C0B41F3C55A13825181026E9E939BB3ACA1CBE31B7458157F38FD024185EB
          9077732BE673874DF88F9B5E56DFE9F60D5FB5292B1140C7900108EAFAD5ACDF
          DC78C4847FB969BC3925597DC7846FC071400946F57F019A6A4CC87513274894
          E6A19D1BE0E89B91ACE1C6D4E2BDD65D88248C7F00460970BEA612B96E545A13
          04DABFBD08577AA98393AEF1D921A7B5848BF59B748C9248A027630173D3D14A
          E4BAD1A828A64AECDDAA47CBDD4F92D539C746E9484592A31C90F1CC8321515A
          AEEC2337C875439743A5C0575500176E4F488ABDCC9BF186CE498DDCE873DD64
          01962D1CCDB7A60B03EC1D5E99CF4D16B0C31846CB9DAF2808A8BB36BE3AE2B2
          6DCE7593892F4D85BE6F73CF64B220A0D6F1F1ADA2637BA8741B3959CBBA5907
          304A358F96971415FF069DF9921C980053860000000049454E44AE426082}
        Name = 'PngImage15'
        Background = clWindow
      end>
    Left = 300
    Top = 220
    Bitmap = {}
  end
end