// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "StreamLayerPlugins",
  platforms: [.iOS(.v14), .tvOS(.v15)],
  products: [
    .library(
      name: "StreamLayerSDKPluginsWatchParty",
      type: .static,
      targets: ["StreamLayerSDKPluginsWatchParty"]
    ),
    .library(
      name: "StreamLayerSDKPluginsGooglePAL",
      type: .static,
      targets: ["StreamLayerSDKPluginsGooglePAL"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/StreamLayer/sdk-ios", from: "8.22.105")
  ],
  targets: [
    .target(
      name: "StreamLayerSDKPluginsWatchParty",
      dependencies: [
        .product(name: "StreamLayer", package: "sdk-ios", condition: .when(platforms: [.iOS])),
        // .product(name: "StreamLayerTVOS", package: "sdk-ios", condition: .when(platforms: [.tvOS])),
        .product(name: "StreamLayerWatchParty", package: "sdk-ios", condition: .when(platforms: [.iOS]))
      ],
      path: "Sources/WatchParty/"
    ),
    .target(
      name: "StreamLayerSDKPluginsGooglePAL",
      dependencies: [
        .product(name: "StreamLayer", package: "sdk-ios", condition: .when(platforms: [.iOS])),
        // .product(name: "StreamLayerTVOS", package: "sdk-ios", condition: .when(platforms: [.tvOS])),
        .product(name: "StreamLayerGooglePAL", package: "sdk-ios", condition: .when(platforms: [.iOS, .tvOS]))
      ],
      path: "Sources/GooglePAL/"
    )
  ]
)
