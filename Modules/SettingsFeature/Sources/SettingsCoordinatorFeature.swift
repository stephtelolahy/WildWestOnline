//
//  SettingsCoordinatorFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 04/12/2025.
//

import Redux

public enum SettingsCoordinatorFeature {
    public struct State: Equatable, Codable, Sendable {
        var home: SettingsHomeFeature.State

        public var path: [Destination]

        public enum Destination: Equatable, Codable, Sendable {
            case figures(SettingsFiguresFeature.State)
            case collectibles(SettingsCollectiblesFeature.State)
        }
    }

    public enum Action {
        case home(SettingsHomeFeature.Action)
        case figures(SettingsFiguresFeature.Action)
        case collectibles(SettingsCollectiblesFeature.Action)
        case setPath([State.Destination])
    }

    public static func reducer(
        state: inout State,
        action: Action,
        dependencies: Dependencies
    ) -> Effect<Action> {
        switch action {
        default:
            return .none
        }
    }
}
