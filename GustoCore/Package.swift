// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
  name: "gusto-ios-core",
  platforms: [
    .iOS(.v14)
  ],
  products: [
    .library(
      name: "GustoLogger",
      targets: ["GustoLogger"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.10.0"),
  ],
  targets: [
    .target(
      name: "GustoLogger",
      dependencies: [
        .product(name: "Dependencies", package: "swift-dependencies"),
      ]
    ),
    
  ]
)
