//
//  ActionCancel.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 22/06/2023.
//

struct ActionCancel: GameActionReducer {
    let arg: ArgCancel

    func reduce(state: GameState) throws -> GameState {
        var state = state

        switch arg {
        case .next:
            state.queue.remove(at: 0)

        case let .effectOfCardNamed(cardName):
            if let index = state.queue.firstIndex(where: { $0.isEffectTriggeredByCardNamed(cardName) }) {
                state.queue.remove(at: index)
            }
        }

        return state
    }
}
