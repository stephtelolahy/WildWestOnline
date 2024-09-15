//
//  GameSetupAction.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 23/06/2024.
//

import Redux
import GameCore
import SettingsCore
import NavigationCore

public enum GameSetupAction: Action {
    case setGame(GameState)
    case unsetGame
}

public extension GameSetupAction {
    static let start: Thunk = { arg in
        guard let state = arg.getState() as? AppState else {
            fatalError("unexpected")
        }

        let newGame = AppState.createGame(
            settings: state.settings,
            inventory: state.inventory
        )

        arg.dispatch(GameSetupAction.setGame(newGame))
        arg.dispatch(NavigationStackAction<RootDestination>.push(.game))
    }

    static let quit: Thunk = { arg in
        arg.dispatch(NavigationStackAction<RootDestination>.pop)
        arg.dispatch(GameSetupAction.unsetGame)
    }
}

private extension AppState {
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
