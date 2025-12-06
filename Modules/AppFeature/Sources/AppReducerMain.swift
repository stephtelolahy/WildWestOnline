//
//  AppReducerMain.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2025.
//
/*
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
                    .setGame(createGame(state: state, dependencies: dependencies))
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

    private static func createGame(state: State, dependencies: Dependencies) -> GameFeature.State {
        GameSetup.buildGame(
            playersCount: state.settings.playersCount,
            cards: dependencies.cardLibrary.cards(),
            deck: dependencies.cardLibrary.deck(),
            actionDelayMilliSeconds: state.settings.actionDelayMilliSeconds,
            preferredFigure: state.settings.preferredFigure,
            playModeSetup: state.settings.simulation ? .allAuto : .oneManual
        )
    }
}
*/
