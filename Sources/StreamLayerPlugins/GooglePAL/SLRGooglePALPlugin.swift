//
//  SLRGooglePALPlugin.swift
//  StreamLayerPlugins
//
//  Created by Vadim Vitvitskii on 27.01.2025.
//

import Foundation
import StreamLayerSDK
import StreamLayerSDKGooglePAL

public class SLRGooglePALPlugin: SLRGooglePALServiceProtocol {
  
  private let googlePALService: SLRGooglePALServiceFacade
  
  public init() {
    self.googlePALService = SLRGooglePALServiceFacade()
  }
  
  public func requestNonceManager(
    baseURL: URL,
    options: SLRGooglePALOptions,
    completion: @escaping ((Result<URL, any Error>) -> Void)
  ) {
    let internalOptions = options.internalOptions
    googlePALService.requestNonceManager(baseURL: baseURL, options: internalOptions, completion: completion)
  }
  
  public func sendPlaybackStart() {
    googlePALService.sendPlaybackStart()
  }
  
  public func sendPlaybackEnd() {
    googlePALService.sendPlaybackEnd()
  }
  
  public func sendAdClick() {
    googlePALService.sendAdClick()
  }
}

extension SLRGooglePALOptions {
  var internalOptions: SLRGooglePALPluginOptions {
    SLRGooglePALPluginOptions(
      env: env,
      hasEnv: hasEnv,
      gdfpReq: gdfpReq,
      hasGdfpReq: hasGdfpReq,
      iu: iu,
      hasIu: hasIu,
      output: output,
      hasOutput: hasOutput,
      sz: sz,
      hasSz: hasSz,
      unviewedPositionStart: unviewedPositionStart,
      hasUnviewedPositionStart: hasUnviewedPositionStart,
      ciuSzs: ciuSzs,
      url: url,
      hasURL: hasURL,
      descriptionURL: descriptionURL,
      hasDescriptionURL: hasDescriptionURL,
      correlator: correlator,
      hasCorrelator: hasCorrelator,
      custParams: custParams,
      plcmt: plcmt,
      hasPlcmt: hasPlcmt,
      vpa: vpa,
      hasVpa: hasVpa,
      vpmute: vpmute,
      hasVpmute: hasVpmute,
      wta: wta,
      hasWta: hasWta,
      aconp: aconp,
      hasAconp: hasAconp,
      adRule: adRule,
      hasAdRule: hasAdRule,
      adType: adType,
      hasAdType: hasAdType,
      hl: hl,
      hasHl: hasHl,
      dth: dth,
      hasDth: hasDth,
      gdpr: gdpr,
      hasGdpr: hasGdpr,
      gdprConsent: gdprConsent,
      hasGdprConsent: hasGdprConsent,
      iabexcl: iabexcl,
      hasIabexcl: hasIabexcl,
      lip: lip,
      hasLip: hasLip,
      ltd: ltd,
      hasLtd: hasLtd,
      nofb: nofb,
      hasNofb: hasNofb,
      npa: npa,
      hasNpa: hasNpa,
      omidP: omidP,
      hasOmidP: hasOmidP,
      ppt: ppt,
      hasPpt: hasPpt,
      ppos: ppos,
      hasPpos: hasPpos,
      ppid: ppid,
      hasPpid: hasPpid,
      scor: scor,
      hasScor: hasScor,
      sdkApis: sdkApis,
      hasSdkApis: hasSdkApis,
      ssss: ssss,
      hasSsss: hasSsss,
      sdmax: sdmax,
      hasSdmax: hasSdmax,
      sid: sid,
      hasSid: hasSid,
      rdp: rdp,
      hasRdp: hasRdp,
      addtlConsent: addtlConsent,
      hasAddtlConsent: hasAddtlConsent,
      afvsz: afvsz,
      hasAfvsz: hasAfvsz,
      allcues: allcues,
      hasAllcues: hasAllcues,
      cmsid: cmsid,
      hasCmsid: hasCmsid,
      vid: vid,
      hasVid: hasVid,
      exclCat: exclCat,
      hasExclCat: hasExclCat,
      ipd: ipd,
      hasIpd: hasIpd,
      ipe: ipe,
      hasIpe: hasIpe,
      maxAdDuration: maxAdDuration,
      hasMaxAdDuration: hasMaxAdDuration,
      minAdDuration: minAdDuration,
      hasMinAdDuration: hasMinAdDuration,
      mridx: mridx,
      hasMridx: hasMridx,
      msid: msid,
      hasMsid: hasMsid,
      an: an,
      hasAn: hasAn,
      pmad: pmad,
      hasPmad: hasPmad,
      pmnd: pmnd,
      hasPmnd: hasPmnd,
      pmxd: pmxd,
      hasPmxd: hasPmxd,
      pod: pod,
      hasPod: hasPod,
      pp: pp,
      hasPp: hasPp,
      ppsj: ppsj,
      hasPpsj: hasPpsj,
      ptpl: ptpl,
      hasPtpl: hasPtpl,
      ptpln: ptpln,
      hasPtpln: hasPtpln,
      pubf: pubf,
      hasPubf: hasPubf,
      pvtf: pvtf,
      hasPvtf: hasPvtf,
      pvid: pvid,
      hasPvid: hasPvid,
      pvidS: pvidS,
      hasPvidS: hasPvidS,
      rdid: rdid,
      hasRdid: hasRdid,
      idtype: idtype,
      hasIdtype: hasIdtype,
      isLat: isLat,
      hasIsLat: hasIsLat,
      tfcd: tfcd,
      hasTfcd: hasTfcd,
      trt: trt,
      hasTrt: hasTrt,
      vadType: vadType,
      hasVadType: hasVadType,
      vidD: vidD,
      hasVidD: hasVidD,
      vconp: vconp,
      hasVconp: hasVconp,
      vpi: vpi,
      hasVpi: hasVpi,
      vpos: vpos,
      hasVpos: hasVpos,
      impl: impl,
      hasImpl: hasImpl,
      vadFormat: vadFormat,
      hasVadFormat: hasVadFormat
    )
  }
}
