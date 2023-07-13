// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [
        .iOS(.v15),
        .macOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "Redux", targets: ["Redux"]),
        .library(name: "Game", targets: ["Game"]),
        .library(name: "Inventory", targets: ["Inventory"]),
        .library(name: "UI", targets: ["UI"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/lukepistrol/SwiftLintPlugin", from: "0.2.2"),
        .package(url: "https://github.com/Quick/Quick", from: "6.1.0"),
        .package(url: "https://github.com/Quick/Nimble", from: "11.2.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Redux",
            dependencies: []),
        .testTarget(
            name: "ReduxTests",
            dependencies: [
                "Redux"
            ]),
        .target(
            name: "Game",
            dependencies: [
                "Redux"
            ],
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]),
        .testTarget(
            name: "GameTests",
            dependencies: [
                "Game",
                "Quick",
                "Nimble"
            ]),
        .target(
            name: "Inventory",
            dependencies: [
                "Game"
            ],
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]),
        .testTarget(
            name: "InventoryTests",
            dependencies: [
                "Inventory",
                "Quick",
                "Nimble"
            ]),
        .target(
            name: "UI",
            dependencies: [
                "Redux",
                "Game",
                "Inventory"
            ],
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]),
        .testTarget(
            name: "UITests",
            dependencies: ["UI"])
    ]
)
