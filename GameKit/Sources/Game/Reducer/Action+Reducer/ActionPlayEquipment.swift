//
//  ActionPlayEquipment.swift
//
//
//  Created by Hugues Telolahy on 10/06/2023.
//

struct ActionPlayEquipment: GameActionReducer {
    let player: String
    let card: String

    func reduce(state: GameState) throws -> GameState {
        // verify rule: not already inPlay
        let cardName = card.extractName()
        let playerObj = state.player(player)
        guard playerObj.inPlay.cards.allSatisfy({ $0.extractName() != cardName }) else {
            throw GameError.cardAlreadyInPlay(cardName)
        }

        // put card on self's play
        var state = state
        try state[keyPath: \GameState.players[player]]?.hand.remove(card)
        state[keyPath: \GameState.players[player]]?.inPlay.add(card)

        // save played card
        state.incrementPlayCounter(for: cardName)

        // queue triggered effect
        state.queueOnPlayEffect(card: card,
                                player: player,
                                state: state,
                                action: .playEquipment(card, player: player))

        return state
    }
}
