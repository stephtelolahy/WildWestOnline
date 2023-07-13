//
//  ActionCancel.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 22/06/2023.
//

struct ActionCancel: GameReducerProtocol {
    let arg: CancelArg

    func reduce(state: GameState) throws -> GameState {
        var state = state

        switch arg {
        case .next:
            state.queue.remove(at: 0)

        case let .effectOfCardNamed(cardName):
            if let index = state.queue.firstIndex(where: { $0.isEffectOfCardNamed(cardName) }) {
                state.queue.remove(at: index)
            }
        }

        return state
    }
}

private extension GameAction {
    func isEffectOfCardNamed(_ cardName: String) -> Bool {
        guard case let .resolve(_, ctx) = self,
              ctx.get(.card) == cardName else {
            return false
        }
        
        return true
    }
}
