// swift-tools-version: 6.2

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "ConfigView",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "ConfigView",
            targets: ["ConfigView"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0-latest"),
    ],
    targets: [.macro(
            name: "ConfigViewMacros",
            dependencies: [
              .product(name: "SwiftSyntax", package: "swift-syntax"),
              .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
              .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "ConfigView", dependencies: ["ConfigViewMacros"]),
        .executableTarget(
          name: "ConfigViewClient",
          dependencies: [
            "ConfigView",
            .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
          ]
        ),
        .testTarget(
            name: "ConfigViewTests",
            dependencies: [
                "ConfigViewMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
        
    ]
)

