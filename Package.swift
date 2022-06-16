// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DebugMenu",
    defaultLocalization: "en",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "DebugMenu",
            targets: ["DebugMenu"]
        ),
    ],
    targets: [
        .target(
            name: "DebugMenu",
            resources: [
                .process("Resource"),
            ]
        ),
        .testTarget(
            name: "DebugMenuTests",
            dependencies: ["DebugMenu"]),
    ]
)
