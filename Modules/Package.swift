// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WildWestOnline",
    defaultLocalization: "fr",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        // Bootstrap
        .library(name: "AppBootstrap", targets: ["AppBootstrap"]),

        // Features
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "GameFeature", targets: ["GameFeature"]),
        .library(name: "SettingsFeature", targets: ["SettingsFeature"]),
        .library(name: "NavigationFeature", targets: ["NavigationFeature"]),

        // UI
        .library(name: "AppUI", targets: ["AppUI"]),
        .library(name: "GameUI", targets: ["GameUI"]),
        .library(name: "SettingsUI", targets: ["SettingsUI"]),
        .library(name: "HomeUI", targets: ["HomeUI"]),

        // Dependencies abstraction
        .library(name: "CardsClient", targets: ["CardsClient"]),
        .library(name: "SettingsClient", targets: ["SettingsClient"]),
        .library(name: "AudioClient", targets: ["AudioClient"]),

        // Dependencies implementation
        .library(name: "CardsClientLive", targets: ["CardsClientLive"]),
        .library(name: "SettingsClientLive", targets: ["SettingsClientLive"]),
        .library(name: "AudioClientLive", targets: ["AudioClientLive"]),

        // Utilities
        .library(name: "Redux", targets: ["Redux"]),
        .library(name: "Theme", targets: ["Theme"]),
        .library(name: "Utils", targets: ["Utils"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.62.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Redux",
            dependencies: [],
            path: "Redux/Sources"
        ),
        .testTarget(
            name: "ReduxTests",
            dependencies: [
                "Redux"
            ],
            path: "Redux/Tests"
        ),
        .target(
            name: "Utils",
            dependencies: [],
            path: "Utils/Sources",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "UtilsTests",
            dependencies: [
                "Utils"
            ],
            path: "Utils/Tests"
        ),
        .target(
            name: "GameFeature",
            dependencies: [
                "Redux"
            ],
            path: "GameFeature/Sources",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "GameFeatureTests",
            dependencies: [
                "GameFeature"
            ],
            path: "GameFeature/Tests"
        ),
        .target(
            name: "SettingsClient",
            path: "SettingsClient/Sources",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "SettingsFeature",
            dependencies: [
                "Redux",
                "SettingsClient"
            ],
            path: "SettingsFeature/Sources",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "SettingsFeatureTests",
            dependencies: [
                "SettingsFeature"
            ],
            path: "SettingsFeature/Tests"
        ),
        .target(
            name: "NavigationFeature",
            dependencies: [
                "Redux"
            ],
            path: "NavigationFeature/Sources",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "NavigationFeatureTests",
            dependencies: [
                "NavigationFeature"
            ],
            path: "NavigationFeature/Tests"
        ),
        .target(
            name: "AppFeature",
            dependencies: [
                "GameFeature",
                "SettingsFeature",
                "NavigationFeature",
                "AudioClient"
            ],
            path: "AppFeature/Sources",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "AppFeatureTests",
            dependencies: [
                "AppFeature"
            ],
            path: "AppFeature/Tests"
        ),
        .target(
            name: "Theme",
            dependencies: [],
            path: "Theme/Sources",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "AudioClient",
            dependencies: [],
            path: "AudioClient/Sources",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "AudioClientLive",
            dependencies: [
                "AudioClient"
            ],
            path: "AudioClientLive/Sources",
            resources: [
                .process("Resources")
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "HomeUI",
            dependencies: [
                "AppFeature",
                "Theme",
                "AudioClient"
            ],
            path: "HomeUI/Sources",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "HomeUITests",
            dependencies: [
                "HomeUI"
            ],
            path: "HomeUI/Tests"
        ),
        .target(
            name: "SettingsUI",
            dependencies: [
                "AppFeature",
                "Theme"
            ],
            path: "SettingsUI/Sources",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "SettingsUITests",
            dependencies: [
                "SettingsUI"
            ],
            path: "SettingsUI/Tests"
        ),
        .target(
            name: "GameUI",
            dependencies: [
                "AppFeature",
                "Theme",
                "CardsClientLive"
            ],
            path: "GameUI/Sources",
            resources: [
                .process("Resources")
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "GameUITests",
            dependencies: [
                "GameUI"
            ],
            path: "GameUI/Tests"
        ),
        .target(
            name: "AppUI",
            dependencies: [
                "HomeUI",
                "GameUI",
                "SettingsUI"
            ],
            path: "AppUI/Sources",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "AppUITests",
            dependencies: [
                "AppUI"
            ],
            path: "AppUI/Tests"
        ),
        .target(
            name: "CardsClient",
            dependencies: [
                "GameFeature"
            ],
            path: "CardsClient/Sources",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "CardsClientLive",
            dependencies: [
                "CardsClient"
            ],
            path: "CardsClientLive/Sources",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "CardsClientLiveTests",
            dependencies: [
                "CardsClientLive"
            ],
            path: "CardsClientLive/Tests"
        ),
        .target(
            name: "SettingsClientLive",
            dependencies: [
                "SettingsClient",
                "Utils"
            ],
            path: "SettingsClientLive/Sources",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "AppBootstrap",
            dependencies: [
                "AppUI",
                "CardsClientLive",
                "SettingsClientLive",
                "AudioClientLive"
            ],
            path: "AppBootstrap/Sources",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
    ]
)
