//
//  GameSessionFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//

import Redux
import GameCore
import SettingsCore
import NavigationCore

public enum GameSessionFeature {
    public enum Action: ActionProtocol {
        case start
        case quit
        case setGame(GameFeature.State)
        case unsetGame
    }

    public static func reduce(
        into state: inout AppFeature.State,
        action: ActionProtocol,
        dependencies: Void
    ) -> Effect {
        guard let action = action as? Action else {
            return .none
        }

        switch action {
        case .start:
            let state = state
            return .group([
                .run {
                    let newGame = createGame(settings: state.settings, inventory: state.inventory)
                    return Action.setGame(newGame)
                },
                .run {
                    MainNavigationFeature.Action.push(.game)
                }
            ])

        case .quit:
            return .group([
                .run {
                    Action.unsetGame
                },
                .run {
                    MainNavigationFeature.Action.pop
                }
            ])

        case .setGame(let game):
            state.game = game

        case .unsetGame:
            state.game = nil
        }

        return .none
    }

    private static func createGame(settings: SettingsFeature.State, inventory: Inventory) -> GameFeature.State {
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
