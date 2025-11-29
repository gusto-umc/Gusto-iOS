// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "FeedTab",
  platforms: [
    .iOS(.v18)
  ],
  products: [
    .library(
      name: "FeedTab",
      targets: ["FeedTab"]
    ),
  ],
  dependencies: [
    .package(path: "../DesignSystem"),
    .package(path: "../GustoNetwork"),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.10.0"),
  ],
  targets: [
    .target(
      name: "FeedTab",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "GustoDesign", package: "DesignSystem"),
        .product(name: "GustoNetwork", package: "GustoNetwork")
      ]
    ),
    .testTarget(
      name: "FeedTabTests",
      dependencies: ["FeedTab"]
    ),
  ]
)

