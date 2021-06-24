// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DebugMenu",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "DebugMenu",
            targets: ["DebugMenu"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.1"),
    ],
    targets: [
        .target(
            name: "DebugMenu",
            dependencies: [
                .product(name: "Logging", package: "swift-log")
            ]),
        .testTarget(
            name: "DebugMenuTests",
            dependencies: ["DebugMenu"]),
    ]
)
