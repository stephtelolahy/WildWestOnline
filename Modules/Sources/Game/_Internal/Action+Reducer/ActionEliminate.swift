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
        state.queue.removeAll(where: { $0.isAnEffectTriggeredBy(player) })
        return state
    }
}

private extension GameAction {
    func isAnEffectTriggeredBy(_ player: String) -> Bool {
        guard case let .resolve(_, ctx) = self,
                ctx.get(.actor) == player else {
            return false
        }
        return true
    }
}
