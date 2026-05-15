//
//  SLRPublicChatPlugin.swift
//  sl-plugins
//
//  Created by Vadim Vitvitskii on 15.05.2026.
//

#if os(iOS)
import Foundation
import UIKit
import StreamLayerSDK
import StreamLayerSDKPublicChat

/// Host-app entry point for the optional Public Chat feature.
///
/// Integrators that want in-stream chat link
/// `StreamLayerSDKPluginsPublicChat`, instantiate `SLRPublicChatPlugin()`, and
/// call `StreamLayer.registerPublicChatPlugin(_:)` before `StreamLayer.setupSDK`.
/// When no plugin is registered, the main SDK silently skips chat menu items
/// and short-circuits chat overlay routes.
///
/// The plugin is the only place that imports both `StreamLayerSDK` and
/// `StreamLayerSDKPublicChat`. Its responsibilities are:
/// - **Type bridging** — projects between SDK-side types (`SLRPublicChatChannelData`,
///   `SLRPublicChatThemeInput`, `SLRPublicChatUserInput`) and the heavy module's
///   primitives-only types (`SLRPublicChatChannelInput`, `SLRPublicChatSessionInput`).
/// - **Delegation** — implements ``SLRPublicChatAnalyticsDelegate`` (forwarding
///   into the ``SLRPublicChatAnalytics`` namespace) and installs a
///   ``SLRPublicChatClient/dismissHandler`` closure so the heavy module can
///   trigger overlay dismissal without importing the main SDK.
///
/// The plugin deliberately does NOT touch `SLRDomain` or `SLRJWT`: those live
/// in shared frameworks that aren't part of the published binary distribution.
/// The SDK resolves user/token and pushes them in via ``connect(user:)``.
public final class SLRPublicChatPlugin: SLRPublicChatServiceProtocol {

  private let client: SLRPublicChatClient
  private var configuration: SLRPublicChatConfiguration?

  public init() {
    self.client = SLRPublicChatClient()
    SLRPublicChatClient.analyticsDelegate = self
    SLRPublicChatClient.dismissHandler = { StreamLayer.closeCurrentOverlay() }
    SLRPublicChatClient.localizationProvider = { SLRPublicChatLocalization.translate($0) }
    SLRPublicChatClient.isVerticalProvider = { SLRStateMachine.orientation == .vertical }
    SLRPublicChatDismissBlocker.predicate = { SLRPublicChatClient.isChatScrollContent($0) }
  }

  // MARK: - Configuration

  public func setConfiguration(_ configuration: SLRPublicChatConfiguration) {
    self.configuration = configuration
  }

  public var isEnabled: Bool {
    configuration?.enabled == true
  }

  public func setChannels(_ channels: [SLRPublicChatChannelData]) {
    client.setChannels(channels.map {
      SLRPublicChatChannelInput(id: $0.id, type: $0.type, name: $0.name ?? "")
    })
  }

  public var availableChannels: [SLRPublicChatChannelData] {
    client.availableChannels.map {
      SLRPublicChatChannelData(id: $0.id, type: $0.type, name: $0.name)
    }
  }

  // MARK: - Theme delegation

  public func applyTheme(_ theme: SLRPublicChatThemeInput) {
    SLRPublicChatAppearance.default.colorPalette.primary = theme.primary
    SLRPublicChatAppearance.default.images.sendArrow = theme.sendIcon
    SLRPublicChatAppearance.default.images.navigationClose = theme.navigationCloseIcon
    SLRPublicChatAppearance.default.images.navigationBack = theme.navigationBackIcon
  }

  public func updateNavigationContext(menuIcon: UIImage?) {
    SLRPublicChatAppearance.default.images.menuIcon = menuIcon
  }

  // MARK: - Session lifecycle

  public func connect(user: SLRPublicChatUserInput) async throws {
    guard let configuration, configuration.enabled else { return }
    let session = SLRPublicChatSessionInput(
      apiKey: configuration.apiKey,
      appID: configuration.appID,
      userId: user.userId,
      userName: user.userName,
      userImageURL: user.userImageURL,
      getStreamToken: user.getStreamToken
    )
    try await client.connect(session: session)
  }

  public func logout() {
    client.logout()
  }

  // MARK: - View controllers

  public func channelListViewController() -> UIViewController {
    client.channelListViewController()
  }

  public func channelViewController(channelId: String) -> UIViewController {
    client.channelViewController(channelId: channelId)
  }
}

// MARK: - Analytics forwarding
extension SLRPublicChatPlugin: SLRPublicChatAnalyticsDelegate {
  public func publicChatGroupConversationOpened(topicId: String) {
    SLRPublicChatAnalytics.conversationOpened(topicId: topicId)
  }

  public func publicChatMessageSent(messageId: String, conversationId: String) {
    SLRPublicChatAnalytics.messageSent(messageId: messageId, conversationId: conversationId)
  }
}
#endif
