// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "3rdParty",
  platforms: [
    .iOS(.v18)
  ],
  products: [
    .library(
      name: "PFDependencies",
      targets: ["PFDependencies"]
    ),
    .library(
      name: "TCAProduct",
      targets: ["TCAProduct"]
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/pointfreeco/swift-composable-architecture.git",
      from: "1.22.2"
    ),
    .package(
      url: "https://github.com/pointfreeco/swift-dependencies.git",
      from: "1.10.0"
    ),
  ],
  targets: [
    .target(
      name: "TCAProduct",
      dependencies: [
        .product(
          name: "ComposableArchitecture",
          package: "swift-composable-architecture"
        )
      ]
    ),
    .target(
      name: "PFDependencies",
      dependencies: [
        .product(name: "Dependencies", package: "swift-dependencies"),
      ]
    )
  ]
)
