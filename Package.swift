// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "PrefsKit",
    products: [
        .library(name: "PrefsKit", targets: ["PrefsKit"])
    ],
    targets: [
        .target(name: "PrefsKit"),
        .target(name: "PrefsKitUI", dependencies: ["PrefsKit"]),
        .testTarget(name: "PrefsKitTests", dependencies: ["PrefsKit"])
    ]
)
