// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GameKit",
    defaultLocalization: "fr",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "Redux", targets: ["Redux"]),
        .library(name: "Game", targets: ["Game"]),
        .library(name: "Inventory", targets: ["Inventory"]),
        .library(name: "Theme", targets: ["Theme"]),
        .library(name: "GameUI", targets: ["GameUI"]),
        .library(name: "HomeUI", targets: ["HomeUI"]),
        .library(name: "SplashUI", targets: ["SplashUI"]),
        .library(name: "SettingsUI", targets: ["SettingsUI"]),
        .library(name: "AppUI", targets: ["AppUI"])
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
        .testTarget(
            name: "SimulationTests",
            dependencies: [
                "Inventory"
            ]),
        .target(
            name: "Routing",
            dependencies: [
                "Redux"
            ]
        ),
        .target(
            name: "Theme",
            dependencies: []),
        .target(
            name: "GameUI",
            dependencies: [
                "Redux",
                "Routing",
                "Theme",
                "Game",
                "Inventory"
            ],
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]),
        .target(
            name: "HomeUI",
            dependencies: [
                "Redux",
                "Routing",
                "Theme"
            ],
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]),
        .target(
            name: "SplashUI",
            dependencies: [
                "Redux",
                "Routing",
                "Theme"
            ],
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]),
        .target(
            name: "SettingsUI",
            dependencies: [
                "Redux",
                "Routing",
                "Theme"
            ],
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]),
        .target(
            name: "AppUI",
            dependencies: [
                "Redux",
                "Routing",
                "Game",
                "Inventory",
                "GameUI",
                "HomeUI",
                "SplashUI",
                "SettingsUI"
            ],
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]),
        .testTarget(
            name: "AppUITests",
            dependencies: ["AppUI"])
    ]
)
