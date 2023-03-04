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
        [
            .prebuildCommand(
                displayName: "Cuckoo plugin",
                executable: context.pluginWorkDirectory.appending("gen-mocks.sh"),
                arguments: [],
                outputFilesDirectory: context.pluginWorkDirectory
            )
        ]
    }
}
