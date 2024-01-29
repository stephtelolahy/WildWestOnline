//
//  ActionChoose.swift
//
//
//  Created by Hugues Telolahy on 08/01/2024.
//

/// Apply next effect with chosen option
struct ActionChoose: GameActionReducer {
    let player: String
    let option: String

    func reduce(state: GameState) throws -> GameState {
        guard let nextAction = state.sequence.first,
              case let .effect(cardEffect, ctx) = nextAction,
              case .matchAction = cardEffect else {
            fatalError("Next action should be an effect.matchAction")
        }

        var updatedContext = ctx
        updatedContext.chosenOption = option
        let updatedAction = GameAction.effect(cardEffect, ctx: updatedContext)
        var state = state
        state.sequence[0] = updatedAction

        return state
    }
}
