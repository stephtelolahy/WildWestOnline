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
                    .setGame(.create(settings: state.settings, cardLibrary: state.cardLibrary))
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
    static func create(settings: SettingsFeature.State, cardLibrary: AppFeature.State.CardLibrary) -> Self {
        GameSetup.buildGame(
            playersCount: settings.playersCount,
            cards: cardLibrary.cards,
            deck: cardLibrary.deck,
            actionDelayMilliSeconds: settings.actionDelayMilliSeconds,
            preferredFigure: settings.preferredFigure,
            playModeSetup: .oneManual
        )
    }
}
