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
            targets: ["GustoFont", "GustoComponent"]
        ),
    ],
    targets: [
        .target(
            name: "GustoFont",
            resources: [
                .process("Font")
            ]
        ),
        .target(
            name: "GustoComponent",
            dependencies: [
              .target(name: "GustoFont")
            ]
        ),
    ]
)
