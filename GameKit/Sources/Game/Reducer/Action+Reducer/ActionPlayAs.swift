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
        state[keyPath: \GameState.players[player]]?.hand.remove(card)
        state.discard.push(card)

        // save played card
        state.incrementPlayedThisTurn(for: aliasCardName)

        // queue triggered effect
        let event = GameAction.playAs(aliasCardName, card: card, target: target, player: player)
        let children = PlayEffectResolver.triggeredEffect(event: event, state: state)
        state.sequence.insert(contentsOf: children, at: 0)

        return state
    }
}
