//
//  SetupGameCore.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//

import Redux
import GameCore
import SettingsCore
import NavigationCore

public enum SetupGameAction: Action {
    case startGame
    case quitGame
    case setGame(GameState)
    case unsetGame
}

func setupGameReducer(
    state: inout AppState,
    action: Action,
    dependencies: Void
) throws -> Effect {
    guard let action = action as? SetupGameAction else {
        return .none
    }

    switch action {
    case .startGame:
        let state = state
        return .group([
            .run {
                let newGame = createGame(settings: state.settings, inventory: state.inventory)
                return SetupGameAction.setGame(newGame)
            },
            .run {
                NavigationStackAction<MainDestination>.push(.game)
            }
        ])

    case .setGame(let game):
        state.game = game

    case .quitGame:
        return .group([
            .run {
                SetupGameAction.unsetGame
            },
            .run {
                NavigationStackAction<MainDestination>.pop
            }
        ])

    case .unsetGame:
        state.game = nil
    }

    return .none
}

private func createGame(settings: SettingsState, inventory: Inventory) -> GameState {
    var game = Setup.buildGame(
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
