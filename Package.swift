// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DebugMenu",
    platforms: [.iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "DebugMenu",
            targets: ["DebugMenu"]),
        .library(
            name: "DebugMenu-Dynamic",
            type: .dynamic,
            targets: ["DebugMenu"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DebugMenu",
            dependencies: []),
        .testTarget(
            name: "DebugMenuTests",
            dependencies: ["DebugMenu"]),
    ]
)
