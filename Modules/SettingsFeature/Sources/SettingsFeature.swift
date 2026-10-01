//
//  SettingsFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 04/12/2025.
//

import Redux

public enum SettingsFeature {
    public struct State: Equatable {
        var path: [Destination]

        var home: SettingsHomeFeature.State
        var figures: SettingsFiguresFeature.State?
        var collectibles: SettingsCollectiblesFeature.State?
        var abilities: SettingsAbilitiesFeature.State?

        public enum Destination: Hashable, Sendable {
            case figures
            case collectibles
            case abilities
        }

        public init(
            path: [Destination] = [],
            home: SettingsHomeFeature.State = .init(),
            figures: SettingsFiguresFeature.State? = nil,
            collectibles: SettingsCollectiblesFeature.State? = nil,
            abilities: SettingsAbilitiesFeature.State? = nil,
        ) {
            self.path = path
            self.home = home
            self.figures = figures
            self.collectibles = collectibles
            self.abilities = abilities
        }
    }

    public enum Action {
        // View
        case setPath([State.Destination])

        // Internal
        case home(SettingsHomeFeature.Action)
        case figures(SettingsFiguresFeature.Action)
        case collectibles(SettingsCollectiblesFeature.Action)
        case abilities(SettingsAbilitiesFeature.Action)
    }

    public static var reducer: Reducer<State, Action> {
        combine(
            reducerMain,
            pullback(
                SettingsHomeFeature.reducer,
                state: \.home,
                action: { if case let .home(action) = $0 { action } else { nil } },
                embedAction: Action.home
            ),
            pullback(
                SettingsFiguresFeature.reducer,
                state: \.figures,
                action: { if case let .figures(action) = $0 { action } else { nil } },
                embedAction: Action.figures
            ),
            pullback(
                SettingsCollectiblesFeature.reducer,
                state: \.collectibles,
                action: { if case let .collectibles(action) = $0 { action } else { nil } },
                embedAction: Action.collectibles
            ),
            pullback(
                SettingsAbilitiesFeature.reducer,
                state: \.abilities,
                action: { if case let .abilities(action) = $0 { action } else { nil } },
                embedAction: Action.abilities
            )
        )
    }

    private static func reducerMain(
        into state: inout State,
        action: Action,
        dependencies: Dependencies
    ) -> Effect<Action> {
        switch action {
        case .setPath(let path):
            state.path = path
            if path.contains(.figures) && state.figures == nil {
                state.figures = .init()
            }
            if !path.contains(.figures) && state.figures != nil {
                state.figures = nil
            }
            if path.contains(.collectibles) && state.collectibles == nil {
                state.collectibles = .init()
            }
            if !path.contains(.collectibles) && state.collectibles != nil {
                state.collectibles = nil
            }
            if path.contains(.abilities) && state.abilities == nil {
                state.abilities = .init()
            }
            if !path.contains(.abilities) && state.abilities != nil {
                state.abilities = nil
            }
            return .none

        case .home(.delegate(.selectedCollectibles)):
            return .send(.setPath([.collectibles]))

        case .home(.delegate(.selectedFigures)):
            return .send(.setPath([.figures]))

        case .home(.delegate(.selectedAbilities)):
            return .send(.setPath([.abilities]))

        case .home:
            return .none

        case .figures:
            return .none

        case .collectibles:
            return .none

        case .abilities:
            return .none
        }
    }
}
