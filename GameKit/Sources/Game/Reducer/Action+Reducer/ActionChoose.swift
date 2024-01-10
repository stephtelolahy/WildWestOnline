//
//  ActionChoose.swift
//
//
//  Created by Hugues Telolahy on 08/01/2024.
//

struct ActionChoose: GameActionReducer {
    let player: String
    let option: String

    func reduce(state: GameState) throws -> GameState {
        var state = state

        guard let nextAction = state.sequence.first,
              case let .effect(cardEffect, ctx) = nextAction else {
            fatalError("Next action should be an effect")
        }

        var updatedContext = ctx
        updatedContext.option = option
        let updateAction = GameAction.effect(cardEffect, ctx: updatedContext)
        state.sequence[0] = updateAction

        return state
    }
}
