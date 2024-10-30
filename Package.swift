// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "PrefsKit",
    products: [
        .library(name: "PrefsKit", targets: ["PrefsKitCore", "PrefsKitUI"]),
        .library(name: "PrefsKitCore", targets: ["PrefsKitCore"]),
        .library(name: "PrefsKitUI", targets: ["PrefsKitUI"])
    ],
    targets: [
        .target(name: "PrefsKitCore"),
        .target(name: "PrefsKitUI", dependencies: ["PrefsKitCore"]),
        .testTarget(name: "PrefsKitCoreTests", dependencies: ["PrefsKitCore"])
    ]
)
