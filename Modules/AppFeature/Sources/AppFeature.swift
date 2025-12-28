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
        var isSettingsPresented: Bool

        var home: HomeFeature.State
        var gameSession: GameSessionFeature.State?
        var settings: SettingsFeature.State?

        public enum Destination: Hashable {
            case gameSession
        }

        public init(
            path: [Destination] = [],
            isSettingsPresented: Bool = false,
            home: HomeFeature.State = .init(),
            gameSession: GameSessionFeature.State? = nil,
            settings: SettingsFeature.State? = nil
        ) {
            self.path = path
            self.isSettingsPresented = isSettingsPresented
            self.home = home
            self.gameSession = gameSession
            self.settings = settings
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
                state: { _ in \.home },
                action: { if case let .home(action) = $0 { action } else { nil } },
                embedAction: Action.home
            ),
            pullback(
                GameSessionFeature.reducer,
                state: { $0.gameSession != nil ? \.gameSession! : nil },
                action: { if case let .gameSession(action) = $0 { action } else { nil } },
                embedAction: Action.gameSession
            ),
            pullback(
                SettingsFeature.reducer,
                state: { $0.settings != nil ? \.settings! : nil },
                action: { if case let .settings(action) = $0 { action } else { nil } },
                embedAction: Action.settings
            )
        )
    }

    // swiftlint:disable:next cyclomatic_complexity
    private static func reducerMain(
        into state: inout State,
        action: Action,
        dependencies: Dependencies
    ) -> Effect<Action> {
        switch action {
        case .setPath(let path):
            state.path = path
            if path.contains(.gameSession) && state.gameSession == nil {
                state.gameSession = .init()
            }
            if !path.contains(.gameSession) && state.gameSession != nil {
                state.gameSession = nil
            }
            return .none

        case .setSettingsPresented(let isPresented):
            guard isPresented != state.isSettingsPresented else {
                return .none
            }
            state.isSettingsPresented = isPresented
            if isPresented && state.settings == nil {
                state.settings = .init()
            }
            if !isPresented && state.settings != nil {
                state.settings = nil
            }
            return .none

        case .home(.delegate(.settings)):
            return .run { .setSettingsPresented(true) }

        case .home(.delegate(.play)):
            return .run { .setPath([.gameSession]) }

        case .gameSession(.delegate(.settings)):
            return .run { .setSettingsPresented(true) }

        case .gameSession(.delegate(.quit)):
            return .run { .setPath([]) }

        case .gameSession:
            return .none

        case .home:
            return .none

        case .settings:
            return .none
        }
    }
}
