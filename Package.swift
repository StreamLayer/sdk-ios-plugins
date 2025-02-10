// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "StreamLayerPlugins",
  platforms: [.iOS(.v14), .tvOS(.v15)],
  products: [
    .library(
      name: "StreamLayerSDKPlugins",
      type: .static,
      targets: ["StreamLayerSDKPlugins"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/StreamLayer/sdk-ios", from: "8.22.105")
  ],
  targets: [
    .target(
      name: "StreamLayerSDKPlugins",
      dependencies: [
        .product(name: "StreamLayer", package: "sdk-ios", condition: .when(platforms: [.iOS])),
        .product(name: "StreamLayerWatchParty", package: "sdk-ios", condition: .when(platforms: [.iOS])),
        .product(name: "StreamLayerTVOS", package: "sdk-ios", condition: .when(platforms: [.tvOS])),
        .product(name: "StreamLayerGooglePAL", package: "sdk-ios", condition: .when(platforms: [.iOS, .tvOS]))
      ]
    ),
  ]
)
