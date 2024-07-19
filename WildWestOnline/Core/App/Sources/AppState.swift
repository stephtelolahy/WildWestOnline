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

private extension AppState {
    static let screenReducer: Reducer<Self> = { state, action in

        var state = state
        switch action {
        case .startGame:
            state.game = createGame(settings: state.settings)
            state.screens.append(.game)

        case .exitGame:
            state.screens.removeLast()
            state.game = nil
        }
        return state
    }

    static func createGame(settings: SettingsState) -> GameState {
        var game = Setup.buildGame(
            playersCount: settings.playersCount,
            inventory: settings.inventory,
            preferredFigure: settings.preferredFigure
        )

        let manualPlayer: String? = settings.simulation ? nil : game.playOrder[0]
        game.playMode = game.startOrder.reduce(into: [:]) {
            $0[$1] = $1 == manualPlayer ? .manual : .auto
        }

        game.waitDelayMilliseconds = settings.waitDelayMilliseconds

        return game
    }
}
