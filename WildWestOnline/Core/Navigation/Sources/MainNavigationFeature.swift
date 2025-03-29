//
//  MainNavigationFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 29/03/2025.
//

import Redux

public enum MainNavigationFeature {
    public struct State: Equatable, Codable, Sendable {
        public var path: [Destination]
        public var settingsSheet: SettingsNavigationFeature.State?

        public enum Destination: String, Codable, Sendable {
            case home
            case game
        }

        public init(
            path: [Destination] = [],
            settingsSheet: SettingsNavigationFeature.State? = nil
        ) {
            self.path = path
            self.settingsSheet = settingsSheet
        }
    }

    public enum Action: ActionProtocol {
        case push(State.Destination)
        case pop
        case setPath([State.Destination])
        case presentSettingsSheet
        case dismissSettingsSheet
    }

    public static func reduce(
        into state: inout State,
        action: ActionProtocol,
        dependencies: Void
    ) throws -> Effect {
        let settingsSheetEffect: Effect = if state.settingsSheet != nil {
            try SettingsNavigationFeature.reduce(into: &state.settingsSheet!, action: action, dependencies: dependencies)
        } else {
            .none
        }

        return .group([
            settingsSheetEffect,
            try reduceMain(into: &state, action: action, dependencies: dependencies)
        ])
    }

    private static func reduceMain(
        into state: inout State,
        action: ActionProtocol,
        dependencies: Void
    ) throws -> Effect {
        guard let action = action as? Action else {
            return .none
        }

        switch action {
        case .push(let page):
            state.path.append(page)

        case .pop:
            state.path.removeLast()

        case .setPath(let path):
            state.path = path

        case .presentSettingsSheet:
            state.settingsSheet = .init(path: [])

        case .dismissSettingsSheet:
            state.settingsSheet = nil
        }

        return .none
    }
}
