// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftCompactor",
    products: [
        .library(
            name: "Compactor",
            targets: ["Compactor"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Compactor",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "CompactorTests",
            dependencies: ["Compactor"],
            path: "Tests"
        ),
    ]
)
