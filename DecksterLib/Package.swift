// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "DecksterLib",
    platforms: [.iOS(.v16), .macOS(.v14)],
    products: [
        .library(
            name: "DecksterLib",
            targets: ["DecksterLib"]
        ),
    ],
    targets: [
        .target(
            name: "DecksterLib"
        ),
        .testTarget(
            name: "DecksterLibTests",
            dependencies: ["DecksterLib"]
        ),
    ]
)
