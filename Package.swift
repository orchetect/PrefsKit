// swift-tools-version: 6.0

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "PrefsKit",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(name: "PrefsKit", targets: ["PrefsKit"]),
        .library(name: "PrefsKitCore", targets: ["PrefsKitCore"]),
        .library(name: "PrefsKitUI", targets: ["PrefsKitUI"])
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0-latest")
    ],
    targets: [
        .target(
            name: "PrefsKit",
            dependencies: ["PrefsKitCore", "PrefsKitUI"]
        ),
        .target(
            name: "PrefsKitCore",
            dependencies: ["PrefsKitTypes", "PrefsKitMacrosImplementation"]
        ),
        .target(
            name: "PrefsKitTypes",
            dependencies: []
        ),
        .macro(
            name: "PrefsKitMacrosImplementation",
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
        ),
        .testTarget(
            name: "PrefsKitTypesTests",
            dependencies: ["PrefsKitTypes"]
        )
    ]
)
