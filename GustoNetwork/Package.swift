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
  targets: [
    .target(
      name: "GustoNetwork"
    ),
    
  ]
)
