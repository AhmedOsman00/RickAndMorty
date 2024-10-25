// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Networking",
            targets: ["Networking", "Pager"])
    ],
    targets: [
        .target(
            name: "Networking"),
        .target(
            name: "Pager",
            dependencies: ["Networking"]),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking", "Pager"])
    ]
)
