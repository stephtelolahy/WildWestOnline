//
//  AppState.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//
import GameCore
import Redux
import SettingsCore

/// Global app state
/// Organize State Structure Based on Data Types, Not Components
/// https://redux.js.org/style-guide/#organize-state-structure-based-on-data-types-not-components
public struct AppState: Codable, Equatable {
    public var screens: ScreenState
    public var settings: SettingsState
    public var inventory: InventoryState
    public var game: GameState?

    public init(
        screens: ScreenState,
        settings: SettingsState,
        inventory: InventoryState,
        game: GameState? = nil
    ) {
        self.screens = screens
        self.settings = settings
        self.inventory = inventory
        self.game = game
    }
}

public extension AppState {
    static let reducer: ThrowingReducer<Self> = { state, action in
            .init(
                screens: try ScreenState.reducer(state.screens, action),
                settings: try SettingsState.reducer(state.settings, action),
                inventory: state.inventory,
                game: try state.game.flatMap { try GameState.reducer($0, action) }
            )
    }
}
/*
private extension AppState {
    static let gamePlayReducer: SelectorReducer<Self, GameState?> = { state, action in
        state.game
        switch action {
        case AppAction.startGame:
            try startGameReducer(state, action)

        case AppAction.exitGame:
            try exitGameReducer(state, action)

        default:
            try state.game.flatMap { try GameState.reducer($0, action) }
        }
    }

    static let startGameReducer: ThrowingReducer<Self> = { state, action in
        guard case AppAction.startGame = action else {
            fatalError("unexpected")
        }

        var state = state
        state.game = createGame(settings: state.settings, inventory: state.inventory)
        // TODO: emit screen change as middleware
        state.screens.append(.game)
        return state
    }

    static let exitGameReducer: ThrowingReducer<Self> = { state, action in
        guard case AppAction.exitGame = action else {
            fatalError("unexpected")
        }

        var state = state
        // TODO: emit screen change as middleware
        state.screens.removeLast()
        state.game = nil
        return state
    }

    static func createGame(settings: SettingsState, inventory: InventoryState) -> GameState {
        var game = Setup.buildGame(
            playersCount: settings.playersCount,
            inventory: inventory,
            preferredFigure: settings.preferredFigure
        )

        let manualPlayer: String? = settings.simulation ? nil : game.round.playOrder[0]
        game.config.playMode = game.round.startOrder.reduce(into: [:]) {
            $0[$1] = $1 == manualPlayer ? .manual : .auto
        }

        game.config.waitDelayMilliseconds = settings.waitDelayMilliseconds

        return game
    }
}
*/
