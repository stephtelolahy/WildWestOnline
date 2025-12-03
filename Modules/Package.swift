// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let lintPlugin: [Target.PluginUsage] = [
    .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
]

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
        .library(name: "AppUI", targets: ["AppUI"]),
        .library(name: "GameFeature", targets: ["GameFeature"]),
        .library(name: "GameUI", targets: ["GameUI"]),
        .library(name: "SettingsFeature", targets: ["SettingsFeature"]),
        .library(name: "SettingsUI", targets: ["SettingsUI"]),
        .library(name: "NavigationFeature", targets: ["NavigationFeature"]),
        .library(name: "HomeUI", targets: ["HomeUI"]),
        .library(name: "CardResources", targets: ["CardResources"]),

        // Dependencies
        .library(name: "PreferencesClient", targets: ["PreferencesClient"]),
        .library(name: "PreferencesClientLive", targets: ["PreferencesClientLive"]),
        .library(name: "AudioClient", targets: ["AudioClient"]),
        .library(name: "AudioClientLive", targets: ["AudioClientLive"]),

        // Utilities
        .library(name: "Redux", targets: ["Redux"]),
        .library(name: "Theme", targets: ["Theme"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.62.2")
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
            name: "GameFeature",
            dependencies: [
                "Redux"
            ],
            path: "GameFeature/Sources",
            plugins: lintPlugin
        ),
        .testTarget(
            name: "GameFeatureTests",
            dependencies: [
                "GameFeature"
            ],
            path: "GameFeature/Tests"
        ),
        .target(
            name: "PreferencesClient",
            dependencies: [
                "Redux"
            ],
            path: "PreferencesClient/Sources",
            plugins: lintPlugin
        ),
        .target(
            name: "SettingsFeature",
            dependencies: [
                "Redux",
                "PreferencesClient"
            ],
            path: "SettingsFeature/Sources",
            plugins: lintPlugin
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
            plugins: lintPlugin
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
            plugins: lintPlugin
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
            plugins: lintPlugin
        ),
        .target(
            name: "AudioClient",
            dependencies: [
                "Redux"
            ],
            path: "AudioClient/Sources",
            plugins: lintPlugin
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
            plugins: lintPlugin
        ),
        .target(
            name: "HomeUI",
            dependencies: [
                "AppFeature",
                "Theme",
                "AudioClient"
            ],
            path: "HomeUI/Sources",
            plugins: lintPlugin
        ),
        .target(
            name: "SettingsUI",
            dependencies: [
                "AppFeature",
                "CardResources",
                "Theme"
            ],
            path: "SettingsUI/Sources",
            plugins: lintPlugin
        ),
        .target(
            name: "GameUI",
            dependencies: [
                "AppFeature",
                "Theme",
                "CardResources"
            ],
            path: "GameUI/Sources",
            resources: [
                .process("Resources")
            ],
            plugins: lintPlugin
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
            plugins: lintPlugin
        ),
        .target(
            name: "CardResources",
            dependencies: [
                "GameFeature",
                "AudioClient"
            ],
            path: "CardResources/Sources",
            resources: [
                .process("Resources")
            ],
            plugins: lintPlugin
        ),
        .testTarget(
            name: "CardResourcesTests",
            dependencies: [
                "CardResources"
            ],
            path: "CardResources/Tests"
        ),
        .target(
            name: "PreferencesClientLive",
            dependencies: [
                "PreferencesClient"
            ],
            path: "PreferencesClientLive/Sources",
            plugins: lintPlugin
        ),
        .target(
            name: "AppBootstrap",
            dependencies: [
                "AppUI",
                "CardResources",
                "PreferencesClientLive",
                "AudioClientLive"
            ],
            path: "AppBootstrap/Sources",
            plugins: lintPlugin
        ),
    ]
)

