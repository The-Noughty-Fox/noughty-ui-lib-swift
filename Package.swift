// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "noughty-ui-lib-swift",
    platforms: [.iOS(.v14) ],
    products: [
        .library(
            name: "NoughtyUI",
            targets: ["NoughtyUI"]),
    ],
    targets: [
        .target(
            name: "NoughtyUI",
            dependencies: []),
        .testTarget(
            name: "NoughtyUITests",
            dependencies: ["NoughtyUI"]),
    ]
)
