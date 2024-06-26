object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Clock'
  ClientHeight = 159
  ClientWidth = 277
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClick = FormClick
  OnCreate = FormCreate
  OnDblClick = FormDblClick
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lb_bottomclock: TSharpESkinLabel
    Left = 18
    Top = 0
    Width = 12
    Height = 21
    AutoSize = True
    Visible = False
    OnClick = lb_clockClick
    OnDblClick = lb_clockDblClick
    OnMouseUp = lb_clockMouseUp
    Caption = '.'
    AutoPos = apBottom
    LabelStyle = lsSmall
  end
  object lb_clock: TSharpESkinLabel
    Left = 2
    Top = 0
    Width = 12
    Height = 21
    AutoSize = True
    OnClick = lb_clockClick
    OnDblClick = lb_clockDblClick
    OnMouseUp = lb_clockMouseUp
    Caption = '.'
    AutoPos = apCenter
    LabelStyle = lsMedium
  end
  object MenuPopup: TPopupMenu
    Images = PngImageList1
    Left = 128
    Top = 72
    object OpenWindowsDateTimesettings1: TMenuItem
      Caption = 'Open Windows Date/Time Settings'
      ImageIndex = 0
      OnClick = lb_clockDblClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Configure1: TMenuItem
      Caption = 'Configure'
      ImageIndex = 1
      OnClick = Configure1Click
    end
  end
  object ClockTimer: TTimer
    Enabled = False
    OnTimer = ClockTimerTimer
    Left = 160
    Top = 72
  end
  object PngImageList1: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000003094944415478DAA5D35B4893011407F0FFF63937E7A6CE
          5A8AA5D39A86CEBC14350A292B4864116968F4A06426065AB687EE57A9696A0C
          8AEA41BBA8599929485A98E5A5C8BB6679A7520B6BE934756EF353F76D5FEB0B
          7A480CA2F372DE7EE7702E2C9AA6F13FC1FA13A829CCDCC2250CA778BCB92082
          4308CD148D6923396E34A091A4EC327626A6352C08BC2A4ABB21729A8A177946
          D8721DC4E0F245A0690B0C931A8C0F75E36B5F8D51A7E764EC565EBB300FA82D
          545D71F7763EE42C5160745A888E8F3A6827A641996988843CF84B0510D1FDE8
          79998F112D7534EED4CDACDFC0B3BB9742163B8D557BCA9339DD1A2EC6266611
          E8ED0C27073668B030AE33A3A97714022E1B7E8E7D6829CB9B2609E790849337
          DA19E045DEB1A79E81A1E19448CE548EDEEA85099D0E634612EE6EAE4C87D651
          A0E0493FFC3D38203BAEA0BF4F5370E0E2831806A8CE3FF8CD3734D1B5AA9787
          35B22590B80A6199239157F81051BB2261C7E3A1B2B60EE2E56BD0D4FA19E1D2
          5E3494167D4A5095783140555E32B97AFB095E4EC577EC8DF405874DC0DEDAEE
          B9F3A9900504A1F3DD5B6C0D0B879B2C18B70BDAA15400CF7332C97DAA623E03
          546427926B238EF1AE954F615F940C5C82C0DC9C11B939D9D0EB0D504444C2CF
          7F153EEB4CC8BDDB86233B66ADC055323EBDE41750A28E1D08DEB6C7EB71CF52
          04AF96C0679923CC26133ADA9AE11BB00A7C470790B340FBE0245AEBDF237A65
          235E97550F2565957A3040AE2AF68EA7D46DAFAD6F3C5EF5D1D81FE50382026C
          889F7B02CC16EB10AD597DEF3D36AD98C2CC9BCB18FC443D3A7CB9389A016EA5
          2705714C63F57285C2AE55EB8F2F7A7B84AD7381D4C51ED63D62406B4459C330
          1671462117D5A0AEBC65C6CC176F4C51DD6EF97D48D9A971C7055C437AF0E6CD
          1866CBD1D04561524F59ABD310F281F57E34C4B39568AE6C068945A9CA8CFBE7
          E79DF2F5D331673894FEA88B842FF0F091C1C94D62ED80C2F7A10F18ECECC288
          C66234D908D4CACC0767177CA6EB67E2D65133534AB6D9B4C1864D8B9923B2B0
          46CD6C9B4696AD409D9296DFF4D76FFCD7F801488A6AF06C96715B0000000049
          454E44AE426082}
        Name = 'PngImage0'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000003A34944415478DA3D937F4C535714C7BFEFBDFE6E696B0B
          A5564AAD552965E8520D712C0C8DDB9C91410021FED8203A1613B265CEB1FD63
          86F887FBE5424C4CDC10DD06891B2ECC68A859361205129A6D41E2C602B4522A
          369D50A0B695FEEEEBDBEDCBE64DBE3937E79EF339F7DE9C43711C87E86D8A06
          D049544F9424AA921FE072F6D9223185C4FC4A94206A21E7AE9C9F7AF21384C4
          9E13161F392232B76D887BAF0666FF093FF851762343FCE5FFE54F35C59A695B
          B1DE26106BA9E4CCB939E23BA86EE07CD4D2F7382DB1BCD12E311D3244BC83A1
          85472EC1B06148A190B0900AB37C763C4D23158B62EF62636CA3AD0E0C1B89C6
          A6BB7DE46817E5FB161FABECA74FC6C27EDAB3E0524C6CBE2E289409C0865208
          AD44916101A5460A91568444D88DCAF0675993BD8D8B4C747AD2A1D95ACAF335
          AAD294ECCA0A6D291AB7DC9219E50288A32CB66FD140ADA4C1814230CCE2F799
          65A4A50CE4C14194460793C2B599693117394CE53EB1E3EAD079466DEEB0142A
          A04E7268DE6BC69370182BD1388C063DFF8C0C070C3BAEC1161902A328477465
          1454C2DFCA038EF64C8E18B4A26A8B5C84EA723D4CFA3C645371F40D5C475363
          03A41209EEDDED86551482B4A00A2AB31D21AF13B3BF5C59E201072F8CAD1A75
          791A3DC7E05843298434B9AA98C699AEB328DBF63CE2BE9B687CC50485D28EE0
          9C0BAA7C0B44793ACCDCE94FF080DA4F7F5ED5176835064684B79ACA206618A4
          52517CD77B191AC68DC3AFEAA0DAB40FC9C70388AF5208CCC6108983A312412B
          0F78AD737044BD4E5B5D9AAFC2EE172CD85AA4029B4EC3F35B2FB6ADF741B5B9
          0E09FF57A04519A4D74C5818FD131703FBEFF574BEB39307ECF9B0AF4B2A579D
          D9B24187F5AA7CB4356D45E8EF5B50249DD03D574F922F811666907A6A867F64
          1217566BE17E2A3B7BF77C6B170F78F1DD4B3BC947F7C9D5465B19A95E229845
          75D11C4A5EAA416AA90F1493223D5084C7A393E80ABC095F30324DE25BC72FB6
          4FF080DCAA78FBCB133B2C85DD6C604A76F2650132940E5AED38D6E9720D64C4
          A3B1295C5E3B8454361BFBEBE1F2A93F7A3B7AF859F81FE0743AF72895CA3BD3
          B7DF4373FB3770FDF001FC0F9D10176F4770318E1BC93A1C3F50C1D134455A0B
          BB2B2B2BC79E011C0E4701D9CF5BAD56C5C017F5F8E8F8098066717FF8261ECC
          7BB90176FFA437A1717C7274D7296B49499EDBEDCE0D9AB5A6A6C6C303FAFBFB
          15C43141641EEA7D9FB36F2A602A4ACDE08449673CB07CECF5CFA7E673D548DC
          4662EEE7A69B68474B4BCBE2BFEE668BEAE1F8943A0000000049454E44AE4260
          82}
        Name = 'PngImage1'
        Background = clWindow
      end>
    Left = 96
    Top = 72
    Bitmap = {}
  end
end
