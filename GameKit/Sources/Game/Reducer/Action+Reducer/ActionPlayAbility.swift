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
        let effectResolver = PlayEffectResolver(player: player, card: card)
        let children = effectResolver.resolve(state: state)
        state.sequence.insert(contentsOf: children, at: 0)

        return state
    }
}
