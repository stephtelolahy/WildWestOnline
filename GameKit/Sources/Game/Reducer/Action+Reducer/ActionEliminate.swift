//
//  ActionEliminate.swift
//  
//
//  Created by Hugues Telolahy on 05/05/2023.
//

struct ActionEliminate: GameReducerProtocol {
    let player: String

    func reduce(state: GameState) throws -> GameState {
        var state = state
        state.playOrder.removeAll(where: { $0 == player })
        state.queue.removeAll(where: { $0.isEffectTriggeredBy(player) })
        return state
    }
}

private extension GameAction {
    func isEffectTriggeredBy(_ player: String) -> Bool {
        if case let .resolve(_, ctx) = self,
                ctx.get(.actor) == player {
            true
        } else {
            false
        }
    }
}
