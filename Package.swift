// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NoughtyUI",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "NoughtyUI", targets: ["NoughtyUI"])
    ],
    dependencies: [
        .package(url: "https://github.com/roberthein/TinyConstraints.git", from: "4.0.0")
    ],
    targets: [
        .target(name: "NoughtyUI", dependencies: [.byNameItem(name: "TinyConstraints", condition: .none)]),
        .testTarget(name: "NoughtyUITests", dependencies: ["NoughtyUI"])
    ]
)
