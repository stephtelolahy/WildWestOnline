// swift-tools-version: 5.9
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
        .library(name: "Utils", targets: ["Utils"]),
        .library(name: "Theme", targets: ["Theme"]),

        // Core
        .library(name: "GameCore", targets: ["GameCore"]),
        .library(name: "SettingsCore", targets: ["SettingsCore"]),
        .library(name: "AppCore", targets: ["AppCore"]),

        // Repository
        .library(name: "CardsRepository", targets: ["CardsRepository"]),
        .library(name: "SettingsRepository", targets: ["SettingsRepository"]),

        // UI
        .library(name: "Splash", targets: ["Splash"]),
        .library(name: "Home", targets: ["Home"]),
        .library(name: "Settings", targets: ["Settings"]),
        .library(name: "GamePlay", targets: ["GamePlay"]),
        .library(name: "App", targets: ["App"])
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
            path: "Tools/Redux/Sources"
        ),
        .testTarget(
            name: "ReduxTests",
            dependencies: [
                "Redux"
            ],
            path: "Tools/Redux/Tests"
        ),
        .target(
            name: "Utils",
            dependencies: [],
            path: "Tools/Utils/Sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin")
            ]
        ),
        .testTarget(
            name: "UtilsTests",
            dependencies: [
                "Utils"
            ],
            path: "Tools/Utils/Tests"
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
        .testTarget(
            name: "GameCoreTests",
            dependencies: [
                "GameCore"
            ],
            path: "Core/Game/Tests"
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
            name: "AppCore",
            dependencies: [
                "GameCore",
                "SettingsCore"
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
            path: "Tools/Theme/sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin")
            ]
        ),
        .target(
            name: "Splash",
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
            name: "SplashTests",
            dependencies: [
                "Splash"
            ],
            path: "UI/Splash/Tests"
        ),
        .target(
            name: "Home",
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
            name: "HomeTests",
            dependencies: [
                "Home"
            ],
            path: "UI/Home/Tests"
        ),
        .target(
            name: "Settings",
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
            name: "SettingsTests",
            dependencies: [
                "Settings"
            ],
            path: "UI/Settings/Tests"
        ),
        .target(
            name: "GamePlay",
            dependencies: [
                "AppCore",
                "Theme",
                "CardsRepository"
            ],
            path: "UI/GamePlay/Sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin")
            ]
        ),
        .testTarget(
            name: "GamePlayTests",
            dependencies: [
                "GamePlay"
            ],
            path: "UI/GamePlay/Tests"
        ),
        .target(
            name: "CardsRepository",
            dependencies: [
                "GameCore"
            ],
            path: "Data/Cards/Sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin")
            ]
        ),
        .testTarget(
            name: "CardsRepositoryTests",
            dependencies: [
                "CardsRepository"
            ],
            path: "Data/Cards/Tests"
        ),
        .target(
            name: "SettingsRepository",
            dependencies: [
                "SettingsCore",
                "Utils"
            ],
            path: "Data/Settings/Sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin")
            ]
        ),
        .target(
            name: "App",
            dependencies: [
                "Splash",
                "Home",
                "Settings",
                "GamePlay",
                "CardsRepository",
                "SettingsRepository"
            ],
            path: "UI/App/Sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin")
            ]
        ),
        .testTarget(
            name: "AppTests",
            dependencies: [
                "App"
            ],
            path: "UI/App/Tests"
        ),
        .binaryTarget(
            name: "SwiftLintBinary",
            path: "Tools/SwiftLintBinary.artifactbundle"
        ),
        .plugin(
            name: "SwiftLintPlugin",
            capability: .buildTool(),
            dependencies: ["SwiftLintBinary"],
            path: "Tools/SwiftLintPlugin/Sources"
        )
    ]
)
