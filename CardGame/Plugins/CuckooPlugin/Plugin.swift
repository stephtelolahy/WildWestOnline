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

        return [
            .prebuildCommand(
                displayName: "Cuckoo plugin",
                executable: executable,
                arguments: ["generate",
                            "--testable",
                            "CardGame",
                            "--output",
                            context.package.directory.appending(subpath: "/Tests/CardGameTests/GeneratedMocks.swift"),
                            context.package.directory.appending(subpath: "/Sources/CardGame/CardGame.swift"),
                            context.package.directory.appending(subpath: "/Sources/CardGame/CardGameEngine.swift")],
                outputFilesDirectory: context.pluginWorkDirectory
            )
        ]
    }
}
