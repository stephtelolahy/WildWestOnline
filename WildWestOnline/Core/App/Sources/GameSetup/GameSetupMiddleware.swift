//
//  GameSetupMiddleware.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 21/09/2024.
//

import Redux
import NavigationCore
import GameCore
import SettingsCore

public extension Middlewares {
    static func gameSetup() -> Middleware<AppState> {
        { state, action in
            switch action {
            case GameSetupAction.startGame:
                let newGame = AppState.createGame(
                    settings: state.settings,
                    inventory: state.inventory
                )

                // TODO: emit multiple actions
//                return [
//                    GameSetupAction.setGame(newGame),
//                    NavigationStackAction<MainDestination>.push(.game)
//                ]
                return nil

            case GameSetupAction.quitGame:
                // TODO: emit multiple actions
//                return [
//                    GameSetupAction.unsetGame,
//                    NavigationStackAction<MainDestination>.pop
//                ]
                return nil

            default:
                return nil
            }
        }
    }
}

private extension AppState {
    static func createGame(settings: SettingsState, inventory: Inventory) -> GameState {
        var game = Setup.buildGame(
            playersCount: settings.playersCount,
            inventory: inventory,
            preferredFigure: settings.preferredFigure
        )

        let manualPlayer: String? = settings.simulation ? nil : game.playOrder[0]
        game.playMode = game.playOrder.reduce(into: [:]) {
            $0[$1] = $1 == manualPlayer ? .manual : .auto
        }

        // TODO: store `settings.waitDelay` as UInt64
        game.visibleActionDelayMilliSeconds = UInt64(settings.waitDelaySeconds * 1000)

        return game
    }
}
