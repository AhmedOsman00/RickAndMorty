// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "UIExtensions",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "UIExtensions",
            targets: ["UIExtensions", "Router"]),
    ],
    dependencies: [
        .package(name: "Resources", path: "../Resources"),
    ],
    targets: [
        .target(
            name: "UIExtensions",
            dependencies: [
                "Resources",
            ]),
        .target(name: "Router"),
    ]
)
