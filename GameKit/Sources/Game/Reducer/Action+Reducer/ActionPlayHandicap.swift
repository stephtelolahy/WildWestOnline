//
//  ActionPlayHandicap.swift
//  
//
//  Created by Hugues Telolahy on 11/06/2023.
//

struct ActionPlayHandicap: GameActionReducer {
    let player: String
    let card: String
    let target: String

    func reduce(state: GameState) throws -> GameState {
        // verify rule: not already inPlay
        let cardName = card.extractName()
        let targetObj = state.player(target)
        guard targetObj.inPlay.cards.allSatisfy({ $0.extractName() != cardName }) else {
            throw GameError.cardAlreadyInPlay(cardName)
        }
        
        // put card on other's play
        var state = state
        try state[keyPath: \GameState.players[player]]?.hand.remove(card)
        state[keyPath: \GameState.players[target]]?.inPlay.add(card)

        // save played card
        state.incrementPlayCounter(for: cardName)

        // queue triggered effect
        state.queueOnPlayEffect(card: card,
                                player: player,
                                target: target,
                                state: state,
                                event: .playHandicap(card, target: target, player: player))
        return state
    }
}
