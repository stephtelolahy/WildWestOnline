//
//  OnSetTurn.swift
//  
//
//  Created by Hugues Telolahy on 03/05/2023.
//

struct OnSetTurn: EventReqMatcherProtocol {
    func match(state: GameState, ctx: EffectContext) -> Bool {
        guard case let .setTurn(turn) = state.event,
              turn == ctx.get(.actor) else {
            return false
        }

        return true
    }
}
