//
//  ActionPassInPlay.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 27/06/2023.
//

struct ActionPassInPlay: GameReducerProtocol {
    let card: String
    let target: String
    let player: String
 
    func reduce(state: GameState) throws -> GameState {
        var state = state
        try state[keyPath: \GameState.players[player]]?.removeCard(card)
        state[keyPath: \GameState.players[target]]?.inPlay.add(card)
        return state
    }
}
