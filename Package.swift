// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "StreamLayerSDKPlugins",
  platforms: [.iOS(.v14)],
  products: [
    .library(
      name: "StreamLayerSDKPlugins",
      targets: ["StreamLayerSDKPlugins"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/StreamLayer/sdk-ios.git", from: "8.0.0")
  ],
  targets: [
    .target(
      name: "sl-plugins",
      dependencies: [
        .product(name: "StreamLayerSDK", package: "StreamLayerSDK"),
        .product(name: "StreamLayerSDKWatchParty", package: "StreamLayerSDK"),
      ]
    ),
  ]
)
