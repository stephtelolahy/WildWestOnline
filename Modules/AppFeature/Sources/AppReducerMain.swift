//
//  AppReducerMain.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2025.
//
import Redux
import GameFeature
import SettingsFeature

extension AppFeature {
    static func reducerMain(
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
        var game = GameSetup.buildGame(
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
