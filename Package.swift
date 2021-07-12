// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NoughtyUI",
    platforms: [.iOS(.v14), .macOS(.v11)],
    products: [
        .library(
            name: "NoughtyUI",
            targets: ["NoughtyUI"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", .branch("iso"))
    ],
    targets: [
        .target(
            name: "NoughtyUI",
            dependencies: [
            .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
        ]
        ),
        .testTarget(
            name: "NoughtyUITests",
            dependencies: ["NoughtyUI"]
        ),
    ]
)
