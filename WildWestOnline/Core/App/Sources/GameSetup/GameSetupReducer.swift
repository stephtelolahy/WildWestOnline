//
//  GameSetupReducer.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 15/09/2024.
//

import Redux
import GameCore
import SettingsCore

extension AppState {
    static let gameSetupReducer: Reducer<Self> = { state, action in
        switch action {
        case GameSetupAction.start:
            try startReducer(state, action)

        case GameSetupAction.quit:
            try quitReducer(state, action)

        default:
            state
        }
    }
}

private extension AppState {
    static let startReducer: Reducer<Self> = { state, action in
        guard case GameSetupAction.start = action else {
            fatalError("unexpected")
        }

        var state = state
        state.game = createGame(settings: state.settings, inventory: state.inventory)
        // TODO: should emit navigation action through middleware
        state.navigation.root.path.append(.game)
        return state
    }

    static let quitReducer: Reducer<Self> = { state, action in
        guard case GameSetupAction.quit = action else {
            fatalError("unexpected")
        }

        var state = state
        // TODO: should emit navigation action through middleware
        state.navigation.root.path.removeLast()
        state.game = nil
        return state
    }

    static func createGame(settings: SettingsState, inventory: Inventory) -> GameState {
        var game = Setup.buildGame(
            playersCount: settings.playersCount,
            inventory: inventory,
            preferredFigure: settings.preferredFigure
        )

        let manualPlayer: String? = settings.simulation ? nil : game.round.playOrder[0]
        game.playMode = game.round.startOrder.reduce(into: [:]) {
            $0[$1] = $1 == manualPlayer ? .manual : .auto
        }

        game.waitDelayMilliseconds = settings.waitDelayMilliseconds

        return game
    }
}
