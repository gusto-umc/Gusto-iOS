// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MapFeature",
  platforms: [
    .iOS(.v18)
  ],
  products: [
    .library(
      name: "MapFeature",
      targets: ["MapFeature"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.2.2"),
    .package(url: "https://github.com/kakao-mapsSDK/KakaoMapsSDK-SPM.git", from: "2.12.10"),
    .package(path: "../DesignSystem"),
  ],
  targets: [
    .target(
      name: "MapFeature",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "KakaoMapsSDK-SPM", package: "KakaoMapsSDK-SPM"),
        .product(name: "GustoDesign", package: "DesignSystem")
      ]
    ),
    .testTarget(
      name: "MapTests",
      dependencies: ["MapFeature"]
    ),
  ]
)
