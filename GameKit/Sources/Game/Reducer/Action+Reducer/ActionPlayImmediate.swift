//
//  ActionPlayImmediate.swift
//
//
//  Created by Hugues Telolahy on 09/04/2023.
//

struct ActionPlayImmediate: GameActionReducer {
    let player: String
    let card: String
    let target: String?

    func reduce(state: GameState) throws -> GameState {
        // discard card from hand
        var state = state
        try state[keyPath: \GameState.players[player]]?.hand.remove(card)
        state.discard.push(card)

        // save played card
        state.incrementPlayedThisTurn(for: card.extractName())

        // queue triggered effect
        let effectResolver = PlayEffectResolver(player: player, card: card)
        let children = effectResolver.resolve(state: state, target: target)
        state.sequence.insert(contentsOf: children, at: 0)

        return state
    }
}
