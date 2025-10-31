//
//  AppNavigationFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 29/03/2025.
//

import Redux

public enum AppNavigationFeature {
    public struct State: Equatable, Codable, Sendable {
        public var path: [Destination]
        public var settingsSheet: SettingsNavigationFeature.State?

        public enum Destination: String, Codable, Sendable {
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

    public enum Action {
        case push(State.Destination)
        case pop
        case setPath([State.Destination])
        case presentSettingsSheet
        case dismissSettingsSheet
        case settingsSheet(SettingsNavigationFeature.Action)
    }

    public static var reducer: Reducer<State, Action, Void> {
        combine(
            reducerMain,
            pullback(
                SettingsNavigationFeature.reducer,
                state: { globalState in
                    globalState.settingsSheet == nil ? nil : \.settingsSheet!
                },
                action: { globalAction in
                    if case let .settingsSheet(localAction) = globalAction {
                        return localAction
                    }
                    return nil
                },
                embedAction: Action.settingsSheet,
                dependencies: { $0 }
            )
        )
    }

    private static func reducerMain(
        into state: inout State,
        action: Action,
        dependencies: Void
    ) -> Effect<Action> {
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

        case .settingsSheet:
            break
        }

        return .none
    }
}
