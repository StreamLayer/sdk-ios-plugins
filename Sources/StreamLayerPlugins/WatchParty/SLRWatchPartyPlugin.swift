//
//  SLRWatchPartyPlugin.swift
//  sl-plugins
//
//  Created by Vadim Vitvitskii on 15.01.2025.
//

#if os(iOS)
import Foundation
import UIKit
import StreamLayerSDK
import StreamLayerSDKWatchParty

public class SLRWatchPartyPlugin: SLRWatchParyServiceProtocol {
  
  private var conferenceService: SLRVonageConferenceServiceFacade?
  
  public init() {}
  
  public weak var delegate: SLRWatchPartyServiceDelegate?
  
  public var isInitialised: Bool {
    conferenceService != nil
  }
  
  public func initialiseWatchPartyService(
    meta: SLRWatchPartySessionMeta
  ) {
    let conferenceServiceMeta = SLRVonageSessionMeta(
      myId: meta.myId,
      token: meta.token,
      sessionId: meta.sessionId,
      topicId: meta.topicId,
      apiKey: meta.apiKey,
      initialVideoEnabled: meta.initialVideoEnabled,
      initialAudioEnabled: meta.initialAudioEnabled
    )
    conferenceService = SLRVonageConferenceServiceFacade(
      meta: conferenceServiceMeta,
      delegate: self
    )
  }
  
  public func deinitialiseWatchPartyService() {
    conferenceService = nil
  }
  
  public var isConnected: Bool {
    guard let conferenceService else { return false }
    return conferenceService.isConnected
  }
  
  public var conferenceVolume: Double {
    get {
      guard let conferenceService else { return 0 }
      return conferenceService.conferenceVolume
    } set {
      conferenceService?.conferenceVolume = newValue
    }
  }
  
  public func joinConference() throws {
    try conferenceService?.joinConference()
  }
  
  public func mute(_ mute: Bool) {
    conferenceService?.mute(mute)
  }
  
  public func sendVideo(_ send: Bool) {
    conferenceService?.sendVideo(send)
  }
  
  public func switchCamera() {
    conferenceService?.switchCamera()
  }
  
  public func leaveConferenceSync() {
    conferenceService?.leaveConferenceSync()
  }
  
  public func leaveConference(completion: (() -> Void)?) {
    conferenceService?.leaveConference(completion: completion)
  }
  
  public func applySoundFix() {
    conferenceService?.applySoundFix()
  }
}

extension SLRWatchPartyPlugin: SLRVonageConferenceDelegate {
  
  public func onConferenceConnected() {
    delegate?.onConferenceConnected()
  }
  
  public func onConferenceDisconnected(error: Error?) {
    delegate?.onConferenceDisconnected(error: error)
  }
  
  public func onParticipantStatusChange(userId: String, isActive: Bool) {
    delegate?.onParticipantStatusChange(userId: userId, isActive: isActive)
  }
  
  public func onLocalVideoStreamAdded(view: UIView?, userId: String, hasVideo: Bool) {
    delegate?.onLocalVideoStreamAdded(view: view, userId: userId, hasVideo: hasVideo)
  }
  
  public func onLocalVideoStreamRemoved(userId: String) {
    delegate?.onLocalVideoStreamRemoved(userId: userId)
  }
  
  public func onLocalVideoStreamToggled(view: UIView?, enabled: Bool) {
    delegate?.onLocalVideoStreamToggled(view: view, enabled: enabled)
  }
  
  public func onLocalAudioStreamToggled(enabled: Bool) {
    delegate?.onLocalAudioStreamToggled(enabled: enabled)
  }
  
  public func onRemoteVideoStreamAdded(view: UIView?, userId: String, hasVideo: Bool, hasAudio: Bool) {
    delegate?.onRemoteVideoStreamAdded(view: view, userId: userId, hasVideo: hasVideo, hasAudio: hasAudio)
  }
  
  public func onRemoteVideoStreamRemoved(userId: String) {
    delegate?.onRemoteVideoStreamRemoved(userId: userId)
  }
  
  public func onRemoteVideoStreamToggled(view: UIView?, user: String, enabled: Bool) {
    delegate?.onRemoteVideoStreamToggled(view: view, user: user, enabled: enabled)
  }
  
  public func onRemoteAudioStreamToggled(userId: String, enabled: Bool) {
    delegate?.onRemoteAudioStreamToggled(userId: userId, enabled: enabled)
  }
  
  public func onDetectVoiceActivity(userId: String, started: Bool) {
    delegate?.onDetectVoiceActivity(userId: userId, started: started)
  }
  
  public func onConferenceUserJoinedFromAnotherDeviceException() {
    delegate?.onConferenceUserJoinedFromAnotherDeviceException()
  }
  
  public func participantsCountUpdated(count: Int) {
    delegate?.participantsCountUpdated(count: count)
  }
  
  public func prepareAudioSession() {
    delegate?.prepareAudioSession()
  }
  
  public func disableAudioSession() {
    delegate?.disableAudioSession()
  }
  
  public func requestAudioDucking() {
    delegate?.requestAudioDucking()
  }
  
  public func disableAudioDucking() {
    delegate?.disableAudioDucking()
  }
}
#endif
