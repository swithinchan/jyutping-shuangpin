// swift-tools-version: 6.3

import PackageDescription

let package = Package(
        name: "ShuangpinCore",
        products: [
                .library(name: "ShuangpinCore", targets: ["ShuangpinCore"])
        ],
        targets: [
                .target(name: "ShuangpinCore"),
                .testTarget(
                        name: "ShuangpinCoreTests",
                        dependencies: ["ShuangpinCore"]
                )
        ]
)
