//
//  ActionChooseOne.swift
//  
//
//  Created by Hugues Telolahy on 08/05/2023.
//

struct ActionChooseOne: GameActionReducer {
    let options: [String]
    let player: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state.chooseOne[player] = options
        return state
    }
}
