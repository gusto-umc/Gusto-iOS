// swift-tools-version: 6.1
import PackageDescription

let package = Package(
  name: "gusto-ios-network",
  platforms: [
    .iOS(.v16)
  ],
  products: [
    .library(
      name: "Network",
      targets: ["Network"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.10.0"),
    .package(path: "../Core")
  ],
  targets: [
    .target(
      name: "Network",
      dependencies: [
        .product(name: "Dependencies", package: "swift-dependencies"),
        .product(name: "Core", package: "Core")
      ]
    ),
    
  ]
)
