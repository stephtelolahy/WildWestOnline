//
//  ActionPlayHandicap.swift
//  
//
//  Created by Hugues Telolahy on 11/06/2023.
//

struct ActionPlayHandicap: GameReducerProtocol {
    let actor: String
    let card: String
    let target: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        let actorObj = state.player(actor)
        guard actorObj.hand.contains(card) else {
            throw GameError.cardNotFound(card)
        }

        let cardName = card.extractName()
        let targetObj = state.player(target)
        guard targetObj.inPlay.cards.allSatisfy({ $0.extractName() != cardName }) else {
            throw GameError.cardAlreadyInPlay(cardName)
        }
        
        try state[keyPath: \GameState.players[actor]]?.hand.remove(card)
        state[keyPath: \GameState.players[target]]?.inPlay.add(card)

        state.playCounter[card] = (state.playCounter[card] ?? 0) + 1
        return state
    }
}
