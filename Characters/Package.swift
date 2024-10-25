// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Characters",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "Characters", targets: ["Characters"])
    ],
    dependencies: [
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git", from: "3.1.2"),
        .package(name: "Networking", path: "../Networking"),
        .package(name: "Resources", path: "../Resources"),
        .package(name: "UIExtensions", path: "../UIExtensions"),
    ],
    targets: [
        .target(name: "Characters",
                dependencies: [
                    "Networking",
                    "Resources",
                    "UIExtensions",
                    .product(name: "SDWebImageSwiftUI", package: "SDWebImageSwiftUI")
                ]),
        .testTarget(
            name: "CharactersTests",
            dependencies: ["Characters"])
    ]
)
