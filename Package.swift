// swift-tools-version: 6.0
// (be sure to update the .swift-version file when this Swift version changes)

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
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "601.0.1-latest")
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
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"), // Xcode 26 won't compile test target without this
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax") // Xcode 26 won't compile test target without this
            ]
        ),
        .testTarget(
            name: "PrefsKitTypesTests",
            dependencies: ["PrefsKitTypes"]
        )
    ]
)
