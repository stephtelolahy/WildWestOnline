// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

struct Module {
    let name: String
    var dependencies: [String] = []
    var resources: Bool = false
    var test: Bool = false
    var lint: Bool = true
}

let modules: [Module] = [
    Module(name: "Redux", test: true),
    Module(name: "Theme"),
    Module(name: "AudioClient", dependencies: ["Redux"]),
    Module(name: "AudioClientLive", dependencies: ["AudioClient"], resources: true),
    Module(name: "UserDefaultsClient", dependencies: ["Redux"]),
    Module(name: "UserDefaultsClientLive", dependencies: ["UserDefaultsClient"]),
    Module(name: "GameCore", dependencies: ["Redux"], test: true),
    Module(name: "CardResources", resources: true),
    Module(name: "CardLibrary", dependencies: ["Redux", "GameCore", "AudioClient"]),
    Module(name: "CardLibraryLive", dependencies: ["CardLibrary", "CardResources"], test: true),
    Module(name: "HomeFeature", dependencies: ["Redux", "Theme", "AudioClient", "UserDefaultsClient"], test: true),
    Module(name: "SettingsFeature", dependencies: ["Redux", "Theme", "UserDefaultsClient", "CardLibrary", "CardResources"], test: true),
    Module(name: "GameSessionFeature", dependencies: ["Theme", "GameCore", "AudioClient", "CardLibrary", "UserDefaultsClient", "CardResources"], resources: true, test: true),
    Module(name: "AppFeature", dependencies: ["HomeFeature", "GameSessionFeature", "SettingsFeature"], test: true),
    Module(name: "AppBuilder", dependencies: ["AppFeature", "UserDefaultsClientLive", "AudioClientLive", "CardLibraryLive"])
]

let lintPlugin: [Target.PluginUsage] = [
    .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
]

let products: [Product] = modules.map { .library(name: $0.name, targets: [$0.name]) }

let targets: [Target] = modules.flatMap { module -> [Target] in
    var result: [Target] = [
        .target(
            name: module.name,
            dependencies: module.dependencies.map { .byName(name: $0) },
            path: "\(module.name)/Sources",
            resources: module.resources ? [.process("Resources")] : nil,
            plugins: module.lint ? lintPlugin : []
        )
    ]
    if module.test {
        result.append(
            .testTarget(
                name: "\(module.name)Tests",
                dependencies: [.byName(name: module.name)],
                path: "\(module.name)/Tests"
            )
        )
    }
    return result
}

let package = Package(
    name: "WildWestOnline",
    defaultLocalization: "fr",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: products,
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.62.2")
    ],
    targets: targets
)
