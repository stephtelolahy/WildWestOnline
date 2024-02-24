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
        .library(name: "Utils", targets: ["Utils"]),
        .library(name: "GameCore", targets: ["GameCore"]),
        .library(name: "SettingsCore", targets: ["SettingsCore"]),
        .library(name: "AppCore", targets: ["AppCore"]),
        .library(name: "Theme", targets: ["Theme"]),
        // TODO: review ------------------------------------
        .library(name: "Inventory", targets: ["Inventory"]),
        .library(name: "GamePlay", targets: ["GamePlay"]),
        .library(name: "Splash", targets: ["Splash"]),
        .library(name: "Home", targets: ["Home"]),
        .library(name: "Settings", targets: ["Settings"]),
        .library(name: "App", targets: ["App"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/lukepistrol/SwiftLintPlugin", from: "0.2.2")
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
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]
        ),
        .target(
            name: "GameCore",
            dependencies: [
                "Redux",
                "Utils"
            ],
            path: "Core/Game/Sources",
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
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
                "GameCore"
            ],
            path: "Core/Settings/Sources",
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
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
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
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
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]
        ),
        .target(
            name: "Splash",
            dependencies: [
                "AppCore",
                "Theme"
            ],
            path: "Scenes/Splash/Sources",
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]
        ),
        .testTarget(
            name: "SplashTests",
            dependencies: [
                "Splash"
            ],
            path: "Scenes/Splash/Tests"
        ),
        .target(
            name: "Home",
            dependencies: [
                "AppCore",
                "Theme"
            ],
            path: "Scenes/Home/Sources",
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]
        ),
        .testTarget(
            name: "HomeTests",
            dependencies: [
                "Home"
            ],
            path: "Scenes/Home/Tests"
        ),
        .target(
            name: "Settings",
            dependencies: [
                "AppCore",
                "Theme"
            ],
            path: "Scenes/Settings/Sources",
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]
        ),
        .testTarget(
            name: "SettingsTests",
            dependencies: [
                "Settings"
            ],
            path: "Scenes/Settings/Tests"
        ),
        .target(
            name: "GamePlay",
            dependencies: [
                "AppCore",
                "Theme"
            ],
            path: "Scenes/GamePlay/Sources",
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]
        ),
        .testTarget(
            name: "GamePlayTests",
            dependencies: [
                "GamePlay"
            ],
            path: "Scenes/GamePlay/Tests"
        ),
        // TODO: review ------------------------------------
        .target(
            name: "Inventory",
            dependencies: [
                "GameCore"
            ],
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]),
        .testTarget(
            name: "InventoryTests",
            dependencies: [
                "Inventory"
            ]),
        .testTarget(
            name: "SimulationTests",
            dependencies: [
                "Inventory"
            ]),
        .target(
            name: "App",
            dependencies: [
                "GamePlay",
                "Home",
                "Splash",
                "Settings"
            ],
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ])
    ]
)
