//
//  ActionChooseOne.swift
//  
//
//  Created by Hugues Telolahy on 08/05/2023.
//

struct ActionChooseOne: GameActionReducer {
    let type: ChoiceType
    let options: [String]
    let player: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state.chooseOne[player] = ChooseOne(type: type, options: options)
        return state
    }
}
