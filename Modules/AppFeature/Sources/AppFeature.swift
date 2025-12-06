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
        var home: HomeFeature.State
        var settings: SettingsFeature.State
        var gameSession: GameSessionFeature.State

        var path: [Destination]
        var isSettingsPresented: Bool

        public enum Destination: Hashable {
            case gameSession
        }

        public init(
            home: HomeFeature.State = .init(),
            settings: SettingsFeature.State = .init(),
            gameSession: GameSessionFeature.State = .init(),
            path: [Destination] = [],
            isSettingsPresented: Bool = false
        ) {
            self.home = home
            self.settings = settings
            self.gameSession = gameSession
            self.path = path
            self.isSettingsPresented = isSettingsPresented
        }
    }

    public enum Action {
        case setPath([State.Destination])
        case setSettingsPresented(Bool)

        case home(HomeFeature.Action)
        case settings(SettingsFeature.Action)
        case gameSession(GameSessionFeature.Action)
    }

    public static var reducer: Reducer<State, Action> {
        combine()
        /*
        combine(
            reducerMain,
            pullback(
                GameFeature.reducer,
                state: { globalState in
                    globalState.game != nil ? \.game! : nil
                },
                action: { globalAction in
                    if case let .game(localAction) = globalAction {
                        return localAction
                    }
                    return nil
                },
                embedAction: Action.game
            ),
            pullback(
                SettingsFeature.reducer,
                state: { _ in
                    \.settings
                },
                action: { globalAction in
                    if case let .settings(localAction) = globalAction {
                        return localAction
                    }
                    return nil
                },
                embedAction: Action.settings
            ),
            pullback(
                AppNavigationFeature.reducer,
                state: { _ in
                    \.navigation
                },
                action: { globalAction in
                    if case let .navigation(localAction) = globalAction {
                        return localAction
                    }
                    return nil
                },
                embedAction: Action.navigation
            ),
            pullback(
                reducerSound,
                state: { _ in \.self },
                action: { $0 },
                embedAction: \.self
            )
        )
         */
    }
}
