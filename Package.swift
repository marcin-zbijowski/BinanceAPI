// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BinanceAPI",
    dependencies: [
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMinor(from: "0.8.0"))
    ],
    targets: [
        .target(
            name: "BinanceAPI",
            dependencies: ["CryptoSwift"]),
        .testTarget(
            name: "BinanceAPITests",
            dependencies: ["BinanceAPI"]
        )
    ]
)
