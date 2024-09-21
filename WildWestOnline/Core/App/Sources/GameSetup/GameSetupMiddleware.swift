//
//  GameSetupMiddleware.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 21/09/2024.
//

import Combine
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

                return [
                    GameSetupAction.setGame(newGame),
                    NavigationStackAction<MainDestination>.push(.game)
                ].publisher.eraseToAnyPublisher()

            case GameSetupAction.quitGame:
                return [
                    GameSetupAction.unsetGame,
                    NavigationStackAction<MainDestination>.pop
                ].publisher.eraseToAnyPublisher()

            default:
                return Empty().eraseToAnyPublisher()
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

        let manualPlayer: String? = settings.simulation ? nil : game.round.playOrder[0]
        game.playMode = game.round.startOrder.reduce(into: [:]) {
            $0[$1] = $1 == manualPlayer ? .manual : .auto
        }

        game.waitDelaySeconds = settings.waitDelaySeconds

        return game
    }
}
