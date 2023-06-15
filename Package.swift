// swift-tools-version: 5.7.1

import PackageDescription

let package = Package(
    name: "SCCombineExtensions",
    platforms: [
        .iOS(.v13), .tvOS(.v11), .macOS(.v10_15), .watchOS(.v4)
    ],
    products: [
        .library(
            name: "SCCombineExtensions",
            targets: ["SCCombineExtensions"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/combine-schedulers", from: "0.10.0")
    ],
    targets: [
        .target(
            name: "SCCombineExtensions",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "SCCombineExtensionsTests",
            dependencies: [
                "SCCombineExtensions",
                .product(name: "CombineSchedulers", package: "combine-schedulers")
            ],
            path: "Tests"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
