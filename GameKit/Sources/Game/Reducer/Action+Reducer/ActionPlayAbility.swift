//
//  ActionPlayAbility.swift
//
//
//  Created by Hugues Telolahy on 20/05/2023.
//

struct ActionPlayAbility: GameReducerProtocol {
    let player: String
    let card: String

    func reduce(state: GameState) throws -> GameState {
        // save played card
        var state = state
        state.playCounter[card] = (state.playCounter[card] ?? 0) + 1
        return state
    }
}
