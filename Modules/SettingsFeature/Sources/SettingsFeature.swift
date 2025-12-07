//
//  SettingsFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 04/12/2025.
//

import Redux

public enum SettingsFeature {
    public struct State: Equatable {
        public var path: [Destination]

        var home: SettingsHomeFeature.State
        var figures: SettingsFiguresFeature.State
        var collectibles: SettingsCollectiblesFeature.State

        public enum Destination: Hashable, Sendable {
            case figures
            case collectibles
        }

        public init(
            path: [Destination] = [],
            home: SettingsHomeFeature.State = .init(),
            figures: SettingsFiguresFeature.State = .init(),
            collectibles: SettingsCollectiblesFeature.State = .init()
        ) {
            self.home = home
            self.figures = figures
            self.collectibles = collectibles
            self.path = path
        }
    }

    public enum Action {
        case setPath([State.Destination])

        case home(SettingsHomeFeature.Action)
        case figures(SettingsFiguresFeature.Action)
        case collectibles(SettingsCollectiblesFeature.Action)
    }

    public static func reducer(
        state: inout State,
        action: Action,
        dependencies: Dependencies
    ) -> Effect<Action> {
        .none
    }
}
