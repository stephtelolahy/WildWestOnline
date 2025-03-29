//
//  TreeNavigationFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 29/03/2025.
//

import Redux

public enum TreeNavigationFeature {
    public struct State: Equatable, Codable, Sendable {
        public var mainPath: [MainPathDestination]
        public var settingsSheet: SettingsSheetDestination?

        public enum MainPathDestination: String, Codable, Sendable {
            case home
            case game
        }

        public struct SettingsSheetDestination: Equatable, Codable, Sendable {
            public var path: [SettingsPathDestination]
        }

        public enum SettingsPathDestination: String, Codable, Sendable {
            case figures
        }
    }

    public enum Action: ActionProtocol {
        case push(State.MainPathDestination)
        case pop
        case setPath([State.MainPathDestination])
        case presentSettingsSheet
        case dismissSettingsSheet
        case settings(SettingsAction)
    }

    public enum SettingsAction: ActionProtocol {
        case push(State.SettingsPathDestination)
        case pop
        case setPath([State.SettingsPathDestination])
    }

    public static func reduce(
        into state: inout State,
        action: ActionProtocol,
        dependencies: Void
    ) throws -> Effect {
        guard let action = action as? Action else {
            return .none
        }

        switch action {
        case .push(let page):
            state.mainPath.append(page)

        case .pop:
            state.mainPath.removeLast()
            
        case .setPath(let path):
            state.mainPath = path

        case .presentSettingsSheet:
            state.settingsSheet = .init(path: [])

        case .dismissSettingsSheet:
            state.settingsSheet = nil

        case .settings(let settingsAction):
            switch settingsAction {
            case .push(let settingsPage):
                state.settingsSheet?.path.append(settingsPage)

            case .pop:
                state.settingsSheet?.path.removeLast()

            case .setPath(let settingsPath):
                state.settingsSheet?.path = settingsPath
            }
        }

        return .none
    }
}
