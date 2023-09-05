//
//  ActionPlayEquipment.swift
//  
//
//  Created by Hugues Telolahy on 10/06/2023.
//

struct ActionPlayEquipment: GameReducerProtocol {
    let player: String
    let card: String
    
    func reduce(state: GameState) throws -> GameState {
        // verify inPlay no duplication rule
        let cardName = card.extractName()
        let playerObj = state.player(player)
        guard playerObj.inPlay.cards.allSatisfy({ $0.extractName() != cardName }) else {
            throw GameError.cardAlreadyInPlay(cardName)
        }
        
        // put card in play
        var state = state
        try state[keyPath: \GameState.players[player]]?.hand.remove(card)
        state[keyPath: \GameState.players[player]]?.inPlay.add(card)
        
        // save played card
        state.playCounter[card] = (state.playCounter[card] ?? 0) + 1
        return state
    }
}
