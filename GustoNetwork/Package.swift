// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
  name: "gusto-ios-network",
  platforms: [
    .iOS(.v18)
  ],
  products: [
    .library(
      name: "GustoNetwork",
      targets: ["GustoNetwork"]
    ),
  ],
  dependencies: [
    .package(name: "3rdParty", path: "../3rdParty"),
  ],
  targets: [
    .target(
      name: "GustoNetwork",
      dependencies: [
        .product(name: "PFDependencies", package: "3rdParty"),
      ],
      path: "Sources/Network"
    ),
  ]
)
