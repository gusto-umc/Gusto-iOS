// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
  name: "gusto-ios-network",
  platforms: [
    .iOS(.v16)
  ],
  products: [
    .library(
      name: "GustoNetwork",
      targets: ["GustoNetwork"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.10.0"),
    .package(path: "../GustoCore")
  ],
  targets: [
    .target(
      name: "GustoNetwork",
      dependencies: [
        .product(name: "Dependencies", package: "swift-dependencies"),
        .product(name: "GustoLogger", package: "GustoCore")
      ]
    ),
    
  ]
)
