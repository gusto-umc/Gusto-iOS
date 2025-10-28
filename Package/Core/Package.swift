// swift-tools-version: 6.1
import PackageDescription

let package = Package(
  name: "gusto-ios-core",
  platforms: [
    .iOS(.v14)
  ],
  products: [
    .library(
      name: "Core",
      targets: ["Core"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.10.0"),
  ],
  targets: [
    .target(
      name: "Core",
      dependencies: [
        .product(name: "Dependencies", package: "swift-dependencies"),
      ]
    ),
    
  ]
)
