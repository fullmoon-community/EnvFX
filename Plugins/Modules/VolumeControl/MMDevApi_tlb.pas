unit MMDevApi_tlb;

interface
  uses Windows, ActiveX, Classes, Graphics, OleServer, OleCtrls, StdVCL,ComObj;
const
  // TypeLibrary Major and minor versions

  CLSID_MMDeviceEnumerator: TGUID              = '{BCDE0395-E52F-467C-8E3D-C4579291692E}';
  IID_IMMDeviceEnumerator: TGUID                = '{A95664D2-9614-4F35-A746-DE8DB63617E6}';
  IID_IMMDevice: TGUID                          = '{D666063F-1587-4E43-81F1-B948E807363F}';
  IID_IMMDeviceCollection: TGUID                = '{0BD7A1BE-7A1A-44DB-8397-CC5392387B5E}';
  IID_IAudioEndpointVolume: TGUID               = '{5CDF2C82-841E-4546-9722-0CF74078229A}';
  IID_IAudioMeterInformation : TGUID            = '{C02216F6-8C67-4B5B-9D00-D008E73E0064}';
  IID_IAudioEndpointVolumeCallback: TGUID       = '{657804FA-D6AD-4496-8A60-352752AF4F89}';
  GUID_NULL: TGUID                              = '{00000000-0000-0000-0000-000000000000}';

  DEVICE_STATE_ACTIVE                   = $00000001;
  DEVICE_STATE_UNPLUGGED                = $00000002;
  DEVICE_STATE_NOTPRESENT               = $00000004;
  DEVICE_STATEMASK_ALL                  = $00000007;

type
  EDataFlow = TOleEnum;
const
  eRender                               = $00000000;
  eCapture                              = $00000001;
  eAll                                  = $00000002;
  EDataFlow_enum_count                  = $00000003;

type
  ERole = TOleEnum;
const
  eConsole                              = $00000000;
  eMultimedia                           = $00000001;
  eCommunications                       = $00000002;
  ERole_enum_count                      = $00000003;

type
  IAudioEndpointVolumeCallback = interface(IUnknown)
  ['{657804FA-D6AD-4496-8A60-352752AF4F89}']
  end;

  IMMAudioEndpointVolume = interface(IUnknown)
  ['{5CDF2C82-841E-4546-9722-0CF74078229A}']
    Function RegisterControlChangeNotify( AudioEndPtVol: IAudioEndpointVolumeCallback): Integer; stdcall;
    Function UnregisterControlChangeNotify( AudioEndPtVol: IAudioEndpointVolumeCallback): Integer; stdcall;
    Function GetChannelCount(out PInteger): Integer; stdcall;
    Function SetMasterVolumeLevel(fLevelDB: single; pguidEventContext: PGUID):Integer; stdcall;
    Function SetMasterVolumeLevelScalar(fLevelDB: single; pguidEventContext: PGUID):Integer; stdcall;
    Function GetMasterVolumeLevel(out fLevelDB: single):Integer; stdcall;
    Function GetMasterVolumeLevelScalar(out fLevel: single):Integer; stdcall;
    Function SetChannelVolumeLevel(nChannel: Integer; fLevelDB: double; pguidEventContext: TGUID):Integer; stdcall;
    Function SetChannelVolumeLevelScalar(nChannel: Integer; fLevelDB: single; pguidEventContext: TGUID):Integer; stdcall;
    Function GetChannelVolumeLevel(nChannel: Integer; out fLevelDB: double) : Integer; stdcall;
    Function GetChannelVolumeLevelScalar(nChannel: Integer; out fLevel: double) : Integer; stdcall;
    Function SetMute(bMute: Boolean ; pguidEventContext: PGUID) :Integer; stdcall;
    Function GetMute(out bMute: Boolean ) :Integer; stdcall;
    Function GetVolumeStepInfo( pnStep: Integer; out pnStepCount: Integer):Integer; stdcall;
    Function VolumeStepUp(pguidEventContext: TGUID) :Integer; stdcall;
    Function VolumeStepDown(pguidEventContext: TGUID) :Integer; stdcall;
    Function QueryHardwareSupport(out pdwHardwareSupportMask): Integer; stdcall;
    Function GetVolumeRange(out pflVolumeMindB: double; out pflVolumeMaxdB: double; out pflVolumeIncrementdB: double): Integer; stdcall;
  end;

{  IAudioMeterInformation = interface(IUnknown)
  ['{C02216F6-8C67-4B5B-9D00-D008E73E0064']
  end;}

  IPropertyStore = interface(IUnknown)
  end;

type
  IMMDevice = interface(IUnknown)
  ['{D666063F-1587-4E43-81F1-B948E807363F}']
    Function Activate(  const refId :TGUID;
                        dwClsCtx: DWORD;
                        pActivationParams: PInteger ;
                        out pEndpointVolume: IMMAudioEndpointVolume): Hresult; stdCall;
    Function OpenPropertyStore(stgmAccess: DWORD; out ppProperties :IPropertyStore): Hresult; stdcall;
    Function GetId(out ppstrId: PLPWSTR ): Hresult; stdcall;
    Function GetState(out State :Integer): Hresult; stdcall;
  end;

  IMMDeviceCollection = interface(IUnknown)
  ['{0BD7A1BE-7A1A-44DB-8397-CC5392387B5E}']
  end;

  IMMNotificationClient = interface (IUnknown)
  ['{7991EEC9-7E89-4D85-8390-6C703CEC60C0}']
  end;

  IMMDeviceEnumerator = interface(IUnknown)
  ['{A95664D2-9614-4F35-A746-DE8DB63617E6}']
    Function EnumAudioEndpoints( dataFlow: EDataFlow; deviceState: SYSUINT; DevCollection:IMMDeviceCollection ): Hresult ; stdcall;
    Function GetDefaultAudioEndpoint(EDF: SYSUINT; ER: SYSUINT; out Dev :IMMDevice ): Hresult ; stdcall;
    Function GetDevice( pwstrId: pointer ; out Dev :IMMDevice) : HResult; stdcall;
    Function RegisterEndpointNotificationCallback(pClient :IMMNotificationClient) :Hresult; stdcall;
  end;

  implementation
end.


