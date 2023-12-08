//
//  ActionChooseOne.swift
//  
//
//  Created by Hugues Telolahy on 08/05/2023.
//

struct ActionChooseOne: GameActionReducer {
    let chooser: String
    let options: [String: GameAction]

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state.chooseOne[chooser] = options
        return state
    }
}
