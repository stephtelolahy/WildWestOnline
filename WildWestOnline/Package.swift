// swift-tools-version: 6.0
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
        .library(name: "CardsData", targets: ["CardsData"]),
        .library(name: "SettingsData", targets: ["SettingsData"]),

        // UI
        .library(name: "HomeUI", targets: ["HomeUI"]),
        .library(name: "SettingsUI", targets: ["SettingsUI"]),
        .library(name: "GameUI", targets: ["GameUI"]),
        .library(name: "MainUI", targets: ["MainUI"]),

        // Utilities
        .library(name: "Redux", targets: ["Redux"]),
        .library(name: "Serialization", targets: ["Serialization"]),
        .library(name: "Theme", targets: ["Theme"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
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
                .plugin(name: "SwiftLintPlugin")
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
                .plugin(name: "SwiftLintPlugin")
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
                .plugin(name: "SwiftLintPlugin")
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
                .plugin(name: "SwiftLintPlugin")
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
                "NavigationCore"
            ],
            path: "AppCore/Sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin")
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
            path: "Theme/sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin")
            ]
        ),
        .target(
            name: "HomeUI",
            dependencies: [
                "AppCore",
                "Theme"
            ],
            path: "HomeUI/Sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin")
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
                .plugin(name: "SwiftLintPlugin")
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
                "CardsData"
            ],
            path: "GameUI/Sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin")
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
            name: "MainUI",
            dependencies: [
                "HomeUI",
                "GameUI",
                "SettingsUI"
            ],
            path: "MainUI/Sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin")
            ]
        ),
        .testTarget(
            name: "MainUITests",
            dependencies: [
                "MainUI"
            ],
            path: "MainUI/Tests"
        ),
        .target(
            name: "CardsData",
            dependencies: [
                "GameCore"
            ],
            path: "CardsData/Sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin")
            ]
        ),
        .testTarget(
            name: "CardsDataTests",
            dependencies: [
                "CardsData"
            ],
            path: "CardsData/Tests"
        ),
        .target(
            name: "SettingsData",
            dependencies: [
                "SettingsCore",
                "Serialization"
            ],
            path: "SettingsData/Sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin")
            ]
        ),
        .binaryTarget(
            name: "SwiftLintBinary",
            path: "SwiftLintBinary.artifactbundle"
        ),
        .plugin(
            name: "SwiftLintPlugin",
            capability: .buildTool(),
            dependencies: ["SwiftLintBinary"],
            path: "SwiftLintPlugin/Sources"
        )
    ]
)
