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
            if let index = state.queue.firstIndex(where: { $0.isEffectTriggeredByCardNamed(cardName) }) {
                state.queue.remove(at: index)
            }
        }

        return state
    }
}

private extension GameAction {
    func isEffectTriggeredByCardNamed(_ cardName: String) -> Bool {
        if case let .resolve(_, ctx) = self,
              ctx.get(.card) == cardName {
            true
        } else {
            false
        }
    }
}
