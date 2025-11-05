// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "DesignSystem",
  platforms: [
    .iOS(.v18)
  ],
  products: [
    .library(
      name: "GustoDesign",
      targets: ["GustoResources", "GustoFont", "GustoComponent"]
    ),
  ],
  targets: [
    .target(
      name: "GustoResources",
      resources: [
        .process("Resources")
      ],
      plugins: ["AssetContants"]
    ),
    .target(
      name: "GustoFont",
      resources: [
        .process("Font")
      ]
    ),
    .target(
      name: "GustoComponent",
      dependencies: [
        .target(name: "GustoResources"),
        .target(name: "GustoFont")
      ]
    ),
    .executableTarget(name: "AssetContantsExec", path: "Plugins/AssetContantsExec"),
    .plugin(name: "AssetContants", capability: .buildTool(), dependencies: ["AssetContantsExec"])
  ]
)
