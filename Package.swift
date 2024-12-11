// swift-tools-version: 6.0

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "PrefsKit",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(name: "PrefsKit", targets: ["PrefsKitCore", "PrefsKitUI"]),
        .library(name: "PrefsKitCore", targets: ["PrefsKitCore"]),
        .library(name: "PrefsKitUI", targets: ["PrefsKitUI"])
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0-latest")
    ],
    targets: [
        .target(
            name: "PrefsKitCore",
            dependencies: ["PrefsKitMacros"]
        ),
        .macro(
            name: "PrefsKitMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(
            name: "PrefsKitUI",
            dependencies: ["PrefsKitCore"]
        ),
        .testTarget(
            name: "PrefsKitCoreTests",
            dependencies: [
                "PrefsKitCore",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax")
            ]
        )
    ]
)
