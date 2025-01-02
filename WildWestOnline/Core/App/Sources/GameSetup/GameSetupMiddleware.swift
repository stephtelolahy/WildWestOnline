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
    static var setupGame: Middleware<AppState> {
        { state, action in
            guard let action = action as? GameSetupAction else {
                return nil
            }

            return switch action {
            case .startGame:
                GameSetupAction.setGame(
                        AppState.createGame(
                            settings: state.settings,
                            inventory: state.inventory
                        )
                    )

            case .setGame:
                NavigationStackAction<MainDestination>.push(.game)

            case .quitGame:
                GameSetupAction.unsetGame

            case .unsetGame:
                NavigationStackAction<MainDestination>.pop
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

        game.actionDelayMilliSeconds = settings.actionDelayMilliSeconds

        return game
    }
}
