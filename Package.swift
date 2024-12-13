// swift-tools-version: 6.0

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "PrefsKit",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(name: "PrefsKit", targets: ["PrefsKit"]),
        .library(name: "PrefsKitCore", targets: ["PrefsKitCore", "PrefsKitMacros"]),
        .library(name: "PrefsKitUI", targets: ["PrefsKitUI"])
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0-latest")
    ],
    targets: [
        .target(
            name: "PrefsKit",
            dependencies: ["PrefsKitCore", "PrefsKitMacros", "PrefsKitUI"]
        ),
        .target(
            name: "PrefsKitCore",
            dependencies: []
        ),
        .target(
            name: "PrefsKitMacros",
            dependencies: ["PrefsKitCore", "PrefsKitMacrosImplementation"]
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
            dependencies: ["PrefsKitCore"]
        ),
        .testTarget(
            name: "PrefsKitMacrosTests",
            dependencies: [
                "PrefsKitMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax")
            ]
        )
    ]
)
