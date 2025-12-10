//
//  AppFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//

import Redux
import HomeFeature
import SettingsFeature
import GameSessionFeature

public enum AppFeature {
    public struct State: Equatable {
        var path: [Destination]
        var home: HomeFeature.State
        var gameSession: GameSessionFeature.State
        var settings: SettingsFeature.State?

        public enum Destination: Hashable {
            case gameSession
        }

        public init(
            path: [Destination] = [],
            home: HomeFeature.State = .init(),
            gameSession: GameSessionFeature.State = .init(),
            settings: SettingsFeature.State? = nil
        ) {
            self.path = path
            self.home = home
            self.settings = settings
            self.gameSession = gameSession
        }
    }

    public enum Action {
        // View
        case setPath([State.Destination])
        case setSettingsPresented(Bool)

        // Internal
        case home(HomeFeature.Action)
        case settings(SettingsFeature.Action)
        case gameSession(GameSessionFeature.Action)
    }

    public static var reducer: Reducer<State, Action> {
        combine(
            reducerMain,
            pullback(
                HomeFeature.reducer,
                state: { _ in
                    \.home
                },
                action: { globalAction in
                    if case let .home(localAction) = globalAction {
                        return localAction
                    }
                    return nil
                },
                embedAction: {
                    .home($0)
                }
            ),
            pullback(
                GameSessionFeature.reducer,
                state: { _ in
                    \.gameSession
                },
                action: { globalAction in
                    if case let .gameSession(localAction) = globalAction {
                        return localAction
                    }
                    return nil
                },
                embedAction: {
                    .gameSession($0)
                }
            ),
            pullback(
                SettingsFeature.reducer,
                state: {
                    $0.settings != nil ? \.settings! : nil
                },
                action: { globalAction in
                    if case let .settings(localAction) = globalAction {
                        return localAction
                    }
                    return nil
                },
                embedAction: {
                    .settings($0)
                }
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
            return .none

        case .setSettingsPresented(let presented):
            if presented {
                state.settings = .init()
            } else {
                state.settings = nil
            }
            return .none

        case .home(.delegate(.settings)):
            return .run { .setSettingsPresented(true) }

        case .home(.delegate(.play)):
            return .run { .setPath([.gameSession]) }

        case .home:
            return .none

        case .settings:
            return .none

        case .gameSession(.delegate(.settings)):
            return .run { .setSettingsPresented(true) }

        case .gameSession(.delegate(.quit)):
            return .run { .setPath([]) }

        case .gameSession:
            return .none
        }
    }
}
