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
        // Core
        .library(name: "GameCore", targets: ["GameCore"]),
        .library(name: "SettingsCore", targets: ["SettingsCore"]),
        .library(name: "NavigationCore", targets: ["NavigationCore"]),
        .library(name: "AppCore", targets: ["AppCore"]),

        // Data
        .library(name: "GameData", targets: ["GameData"]),
        .library(name: "SettingsData", targets: ["SettingsData"]),

        // UI
        .library(name: "HomeUI", targets: ["HomeUI"]),
        .library(name: "SettingsUI", targets: ["SettingsUI"]),
        .library(name: "GameUI", targets: ["GameUI"]),
        .library(name: "AppUI", targets: ["AppUI"]),

        // Utilities
        .library(name: "Redux", targets: ["Redux"]),
        .library(name: "Serialization", targets: ["Serialization"]),
        .library(name: "Theme", targets: ["Theme"]),
        .library(name: "AudioPlayer", targets: ["AudioPlayer"]),
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
            name: "Serialization",
            dependencies: [],
            path: "Serialization/Sources",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "SerializationTests",
            dependencies: [
                "Serialization"
            ],
            path: "Serialization/Tests"
        ),
        .target(
            name: "GameCore",
            dependencies: [
                "Redux"
            ],
            path: "GameCore/Sources",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "GameCoreTests",
            dependencies: [
                "GameCore"
            ],
            path: "GameCore/Tests"
        ),
        .target(
            name: "SettingsCore",
            dependencies: [
                "Redux"
            ],
            path: "SettingsCore/Sources",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "SettingsCoreTests",
            dependencies: [
                "SettingsCore"
            ],
            path: "SettingsCore/Tests"
        ),
        .target(
            name: "NavigationCore",
            dependencies: [
                "Redux"
            ],
            path: "NavigationCore/Sources",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "NavigationCoreTests",
            dependencies: [
                "NavigationCore"
            ],
            path: "NavigationCore/Tests"
        ),
        .target(
            name: "AppCore",
            dependencies: [
                "GameCore",
                "SettingsCore",
                "NavigationCore",
                "AudioPlayer"
            ],
            path: "AppCore/Sources",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "AppCoreTests",
            dependencies: [
                "AppCore"
            ],
            path: "AppCore/Tests"
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
            name: "AudioPlayer",
            dependencies: [],
            path: "AudioPlayer/Sources",
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
                "AppCore",
                "Theme",
                "AudioPlayer"
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
                "AppCore",
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
                "AppCore",
                "Theme",
                "GameData"
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
            name: "GameData",
            dependencies: [
                "GameCore"
            ],
            path: "GameData/Sources",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "GameDataTests",
            dependencies: [
                "GameData"
            ],
            path: "GameData/Tests"
        ),
        .target(
            name: "SettingsData",
            dependencies: [
                "SettingsCore",
                "Serialization"
            ],
            path: "SettingsData/Sources",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
    ]
)
