//
//  AppCore.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//

import Redux
import NavigationCore
import SettingsCore
import GameCore

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
        let settings: SettingsFeature.Dependencies

        public init(settings: SettingsFeature.Dependencies) {
            self.settings = settings
        }
    }

    public static var reducer: Reducer<State, Action, Dependencies> {
        combine(
            reducerMain,
            pullback(
                GameFeature.reducer,
                state: \.game!,
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
                state: \.settings,
                action: { globalAction in
                    if case let .settings(localAction) = globalAction {
                        return localAction
                    }
                    return nil
                },
                embedAction: Action.settings,
                dependencies: { $0.settings }
            ),
            pullback(
                AppNavigationFeature.reducer,
                state: \.navigation,
                action: { globalAction in
                    if case let .navigation(localAction) = globalAction {
                        return localAction
                    }
                    return nil
                },
                embedAction: Action.navigation,
                dependencies: { _ in () }
            )
        )
    }

    private static func reducerMain(
        into state: inout State,
        action: Action,
        dependencies: Dependencies
    ) -> Effect<Action> {
        switch action {
        case .start:
            let state = state
            return .group([
                .run {
                    .setGame(.create(settings: state.settings, inventory: state.inventory))
                },
                .run {
                    .navigation(.push(.game))
                }
            ])

        case .quit:
            return .group([
                .run {
                    .unsetGame
                },
                .run {
                    .navigation(.pop)
                }
            ])

        case .setGame(let game):
            state.game = game

        case .unsetGame:
            state.game = nil

        case .navigation:
            break

        case .settings:
            break

        case .game:
            break
        }

        return .none
    }
}

private extension GameFeature.State {
    static func create(settings: SettingsFeature.State, inventory: Inventory) -> Self {
        var game = GameSetupService.buildGame(
            playersCount: settings.playersCount,
            inventory: inventory,
            preferredFigure: settings.preferredFigure
        )

        let manualPlayer: String? = settings.simulation ? nil : game.playOrder[0]
        game.playMode = game.playOrder.reduce(into: [:]) {
            $0[$1] = $1 == manualPlayer ? .manual : .auto
        }

        game.actionDelayMilliSeconds = settings.actionDelayMilliSeconds

        return game
    }
}
