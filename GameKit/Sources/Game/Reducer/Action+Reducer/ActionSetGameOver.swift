//
//  ActionSetGameOver.swift
//  
//
//  Created by Hugues Telolahy on 02/07/2023.
//

struct ActionSetGameOver: GameReducerProtocol {
    let winner: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state.isOver = GameOver(winner: winner)
        return state
    }
}
