//
//  ActionPlayAs.swift
//  
//
//  Created by Hugues Telolahy on 24/11/2023.
//

struct ActionPlayAs: GameActionReducer {
    let player: String
    let aliasCardName: String
    let card: String
    let target: String?

    func reduce(state: GameState) throws -> GameState {
        // discard card from hand
        var state = state
        try state[keyPath: \GameState.players[player]]?.hand.remove(card)
        state.discard.push(card)

        // save played card
        state.incrementPlayedThisTurn(for: aliasCardName)

        // queue triggered effect
        let children = PlayEffectResolver.triggeredEffect(
            card: card,
            player: player,
            state: state,
            target: target,
            aliasCardName: aliasCardName
        )
        state.sequence.insert(contentsOf: children, at: 0)

        return state
    }
}
