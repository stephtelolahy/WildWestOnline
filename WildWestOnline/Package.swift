// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WildWestOnline",
    defaultLocalization: "fr",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.

        // Utilities
        .library(name: "Redux", targets: ["Redux"]),
        .library(name: "Serialization", targets: ["Serialization"]),
        .library(name: "Theme", targets: ["Theme"]),

        // Core
        .library(name: "GameCore", targets: ["GameCore"]),
        .library(name: "Bang", targets: ["Bang"]),
        .library(name: "SettingsCore", targets: ["SettingsCore"]),
        .library(name: "NavigationCore", targets: ["NavigationCore"]),
        .library(name: "AppCore", targets: ["AppCore"]),

        // Data
        .library(name: "CardsData", targets: ["CardsData"]),
        .library(name: "SettingsData", targets: ["SettingsData"]),

        // UI
        .library(name: "SplashUI", targets: ["SplashUI"]),
        .library(name: "HomeUI", targets: ["HomeUI"]),
        .library(name: "SettingsUI", targets: ["SettingsUI"]),
        .library(name: "GameUI", targets: ["GameUI"])
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
            path: "Utilities/Redux/Sources"
        ),
        .testTarget(
            name: "ReduxTests",
            dependencies: [
                "Redux"
            ],
            path: "Utilities/Redux/Tests"
        ),
        .target(
            name: "Serialization",
            dependencies: [],
            path: "Utilities/Serialization/Sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin")
            ]
        ),
        .testTarget(
            name: "SerializationTests",
            dependencies: [
                "Serialization"
            ],
            path: "Utilities/Serialization/Tests"
        ),
        .target(
            name: "GameCore",
            dependencies: [
                "Redux"
            ],
            path: "Core/Game/Sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin")
            ]
        ),
        .target(
            name: "Bang",
            path: "Core/Bang/Sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin")
            ]
        ),
        .testTarget(
            name: "BangTests",
            dependencies: [
                "Bang"
            ],
            path: "Core/Bang/Tests"
        ),
        .target(
            name: "SettingsCore",
            dependencies: [
                "Redux"
            ],
            path: "Core/Settings/Sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin")
            ]
        ),
        .testTarget(
            name: "SettingsCoreTests",
            dependencies: [
                "SettingsCore"
            ],
            path: "Core/Settings/Tests"
        ),
        .target(
            name: "NavigationCore",
            dependencies: [
                "Redux"
            ],
            path: "Core/Navigation/Sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin")
            ]
        ),
        .testTarget(
            name: "NavigationCoreTests",
            dependencies: [
                "NavigationCore"
            ],
            path: "Core/Navigation/Tests"
        ),
        .target(
            name: "AppCore",
            dependencies: [
                "GameCore",
                "SettingsCore",
                "NavigationCore"
            ],
            path: "Core/App/Sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin")
            ]
        ),
        .testTarget(
            name: "AppCoreTests",
            dependencies: [
                "AppCore"
            ],
            path: "Core/App/Tests"
        ),
        .target(
            name: "Theme",
            dependencies: [],
            path: "Utilities/Theme/sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin")
            ]
        ),
        .target(
            name: "SplashUI",
            dependencies: [
                "AppCore",
                "Theme"
            ],
            path: "UI/Splash/Sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin")
            ]
        ),
        .testTarget(
            name: "SplashUITests",
            dependencies: [
                "SplashUI"
            ],
            path: "UI/Splash/Tests"
        ),
        .target(
            name: "HomeUI",
            dependencies: [
                "AppCore",
                "Theme"
            ],
            path: "UI/Home/Sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin")
            ]
        ),
        .testTarget(
            name: "HomeUITests",
            dependencies: [
                "HomeUI"
            ],
            path: "UI/Home/Tests"
        ),
        .target(
            name: "SettingsUI",
            dependencies: [
                "AppCore",
                "Theme"
            ],
            path: "UI/Settings/Sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin")
            ]
        ),
        .testTarget(
            name: "SettingsUITests",
            dependencies: [
                "SettingsUI"
            ],
            path: "UI/Settings/Tests"
        ),
        .target(
            name: "GameUI",
            dependencies: [
                "AppCore",
                "Theme",
                "CardsData"
            ],
            path: "UI/Game/Sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin")
            ]
        ),
        .testTarget(
            name: "GameUITests",
            dependencies: [
                "GameUI"
            ],
            path: "UI/Game/Tests"
        ),
        .target(
            name: "CardsData",
            dependencies: [
                "GameCore"
            ],
            path: "Data/Cards/Sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin")
            ]
        ),
        .testTarget(
            name: "CardsDataTests",
            dependencies: [
                "CardsData"
            ],
            path: "Data/Cards/Tests"
        ),
        .target(
            name: "SettingsData",
            dependencies: [
                "SettingsCore",
                "Serialization"
            ],
            path: "Data/Settings/Sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin")
            ]
        ),
        .binaryTarget(
            name: "SwiftLintBinary",
            path: "Utilities/SwiftLintBinary.artifactbundle"
        ),
        .plugin(
            name: "SwiftLintPlugin",
            capability: .buildTool(),
            dependencies: ["SwiftLintBinary"],
            path: "Utilities/SwiftLintPlugin/Sources"
        )
    ]
)
