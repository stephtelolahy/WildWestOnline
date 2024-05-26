//
//  ActionHandicap.swift
//  
//
//  Created by Hugues Telolahy on 11/06/2023.
//

struct ActionHandicap: GameActionReducer {
    let player: String
    let card: String
    let target: String

    func reduce(state: GameState) throws -> GameState {
        // verify rule: not already inPlay
        let cardName = card.extractName()
        let targetObj = state.player(target)
        guard targetObj.inPlay.allSatisfy({ $0.extractName() != cardName }) else {
            throw GameError.cardAlreadyInPlay(cardName)
        }

        // put card on other's play
        var state = state
        state[keyPath: \GameState.players[player]]?.hand.remove(card)
        state[keyPath: \GameState.players[target]]?.inPlay.append(card)

        return state
    }
}
