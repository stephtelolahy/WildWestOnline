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
        let executable = context.package.directory.appending(subpath: ".build/checkouts/Cuckoo/run")

        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: executable.string) else {
            fatalError("Missing executable")
        }
 
        let configuration = loadConfiguration("cuckoo.json", context: context)
        let arguments = buildArguments(configuration, context: context, target: target)
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

struct CuckooPluginConfiguration: Decodable {
    let targetName: String
    let inputDir: String
    let inputFiles: [String]
    let outputFile: String
}

private extension CuckooPlugin {

    func loadConfiguration(_ configFileName: String,
                           context: PackagePlugin.PluginContext) -> CuckooPluginConfiguration {
        let configFile = context.package.directory.appending(configFileName)
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: configFile.string) else {
            fatalError("Missing configuration file ")
        }

        let fileUrl = NSURL.fileURL(withPath: configFile.string)
        guard let data = try? Data(contentsOf: fileUrl) else {
            fatalError("Invalid configuration file")
        }

        let decoder = JSONDecoder()
        guard let configuration = try? decoder.decode(CuckooPluginConfiguration.self, from: data) else {
            fatalError("Decoding error")
        }

        return configuration
    }

    func buildArguments(_ configuration: CuckooPluginConfiguration,
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
