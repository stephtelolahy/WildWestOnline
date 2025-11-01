//
//  AppCore.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//

import Redux
import NavigationFeature
import SettingsFeature
import GameFeature
import AudioClient
import SettingsClient

public typealias AppStore = Store<AppFeature.State, AppFeature.Action, AppFeature.Dependencies>

public enum AppFeature {
    /// Global app state
    /// Organize State Structure Based on Data Types, Not Components
    /// https://redux.js.org/style-guide/#organize-state-structure-based-on-data-types-not-components
    public struct State: Codable, Equatable, Sendable {
        public let inventory: Inventory
        public var navigation: AppNavigationFeature.State
        public var settings: SettingsFeature.State
        public var game: GameFeature.State?

        public init(
            inventory: Inventory,
            navigation: AppNavigationFeature.State,
            settings: SettingsFeature.State,
            game: GameFeature.State? = nil
        ) {
            self.inventory = inventory
            self.navigation = navigation
            self.settings = settings
            self.game = game
        }
    }

    public enum Action {
        case start
        case quit
        case setGame(GameFeature.State)
        case unsetGame
        case navigation(AppNavigationFeature.Action)
        case settings(SettingsFeature.Action)
        case game(GameFeature.Action)
    }

    public struct Dependencies {
        let settingsClient: SettingsClient
        let audioClient: AudioClient

        public init(
            settingsClient: SettingsClient,
            audioClient: AudioClient
        ) {
            self.settingsClient = settingsClient
            self.audioClient = audioClient
        }
    }

    public static var reducer: Reducer<State, Action, Dependencies> {
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
                embedAction: Action.game,
                dependencies: { _ in () }
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
                embedAction: Action.settings,
                dependencies: { $0.settingsClient }
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
                embedAction: Action.navigation,
                dependencies: { _ in () }
            ),
            pullback(
                reducerSound,
                state: { _ in
                    \.self
                },
                action: { $0 },
                embedAction: \.self,
                dependencies: { $0.audioClient }
            )
        )
    }
}
