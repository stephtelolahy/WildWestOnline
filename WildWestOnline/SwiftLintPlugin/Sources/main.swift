//
//  main.swift
//
//  Created by Stephano Hugues TELOLAHY on 27/02/2024.
//

import Foundation
import PackagePlugin

@main
struct SwiftLintPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        if ProcessInfo.processInfo.environment["DISABLE_SWIFTLINT"] != nil {
            return []
        }
        return [
            .buildCommand(
                displayName: "Running SwiftLint for \(target.name)",
                executable: try context.tool(named: "swiftlint").url,
                arguments: [
                    "lint",
                    "--config",
                    "\(context.package.directoryURL.path())/.swiftlint.yml",
                    "--cache-path",
                    "\(context.pluginWorkDirectoryURL.path())/cache",
                    target.directory.string
                ],
                environment: [:]
            )
        ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftLintPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        [
            .buildCommand(
                displayName: "Running SwiftLint for \(target.displayName)",
                executable: try context.tool(named: "swiftlint").url,
                arguments: [
                    "lint",
                    "--config",
                    "\(context.xcodeProject.directoryURL.path())/.swiftlint.yml",
                    "--cache-path",
                    "\(context.pluginWorkDirectoryURL.path())/cache",
                    context.xcodeProject.directory.string
                ],
                environment: [:]
            )
        ]
    }
}
#endif
