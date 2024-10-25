// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Resources",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Resources",
            targets: ["Resources"]),
    ],
    targets: [
        .target(
            name: "Resources"),
    ]
)
