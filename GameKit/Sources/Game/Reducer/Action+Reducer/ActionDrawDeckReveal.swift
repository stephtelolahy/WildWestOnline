//
//  ActionDrawDeckReveal.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 10/11/2023.
//

struct ActionDrawDeckReveal: GameActionReducer {
    let card: String
    let player: String

    func reduce(state: GameState) throws -> GameState {
        try ActionDrawDeck(player: player).reduce(state: state)
    }
}
