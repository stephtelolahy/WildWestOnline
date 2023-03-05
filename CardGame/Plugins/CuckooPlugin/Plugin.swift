//
//  Plugin.swift
//  
//
//  Created by Hugues Telolahy on 04/03/2023.
//
import PackagePlugin
import Foundation

@main
struct CuckooPlugin: BuildToolPlugin {
    func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
        let configuration = CuckooPluginConfiguration.sample

        let executable = context.package.directory.appending(subpath: ".build/checkouts/Cuckoo/run")
        let arguments = buildArguments(configuration: configuration, context: context, target: target)
        return [
            .prebuildCommand(
                displayName: "Cuckoo BuildTool Plugin",
                executable: executable,
                arguments: arguments,
                outputFilesDirectory: context.pluginWorkDirectory
            )
        ]
    }
}

struct CuckooPluginConfiguration {
    let targetName: String
    let inputDir: String
    let inputFiles: [String]
    let outputFile: String
}

private extension CuckooPlugin {
    func buildArguments(configuration: CuckooPluginConfiguration,
                                context: PackagePlugin.PluginContext,
                                target: PackagePlugin.Target) -> [CustomStringConvertible] {
        let inputDirectory = context.package.directory.appending(subpath: configuration.inputDir)
        return [
            "generate",
            "--testable",
            configuration.targetName,
            "--output",
            context.package.directory.appending(subpath: configuration.outputFile)
        ]
        + configuration.inputFiles.map { inputDirectory.appending(subpath: $0) }
    }
}


private extension CuckooPluginConfiguration {
    static let sample = CuckooPluginConfiguration(
        targetName: "CardGame",
        inputDir: "/Sources/CardGame",
        inputFiles: [
            "/CardGame.swift",
            "/CardGameEngine.swift"
        ],
        outputFile: "/Tests/CardGameTests/GeneratedMocks.swift")
}
