// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CardGame",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "CardGame", targets: ["CardGame"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "../ExtensionsKit"),
        .package(path: "../GameDSL"),
        .package(url: "https://github.com/Brightify/Cuckoo", from: "1.9.1"),
        .package(url: "https://github.com/stephtelolahy/CuckooPlugin", from: "1.0.0"),
        .package(url: "https://github.com/lukepistrol/SwiftLintPlugin", from: "0.2.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CardGame",
            dependencies: [
                "GameDSL",
                "ExtensionsKit"
            ],
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]),
        .testTarget(
            name: "CardGameTests",
            dependencies: [
                "CardGame",
                "Cuckoo"
            ],
            plugins: [
                .plugin(name: "CuckooPlugin", package: "CuckooPlugin")
            ]
        ),
    ]
)
