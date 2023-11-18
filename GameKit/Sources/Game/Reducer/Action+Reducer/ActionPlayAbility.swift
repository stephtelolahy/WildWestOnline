//
//  ActionPlayAbility.swift
//
//
//  Created by Hugues Telolahy on 20/05/2023.
//

struct ActionPlayAbility: GameActionReducer {
    let player: String
    let card: String

    func reduce(state: GameState) throws -> GameState {
        // save played card
        var state = state
        state.incrementPlayedThisTurn(for: card)

        // queue triggered effect
        state.queueOnPlayEffect(
            card: card,
            player: player,
            target: nil,
            state: state,
            event: .playAbility(card, player: player)
        )

        return state
    }
}
