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
        var figures: SettingsFiguresFeature.State
        var collectibles: SettingsCollectiblesFeature.State

        public var path: [Destination]

        public enum Destination: Hashable, Codable, Sendable {
            case figures
            case collectibles
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
