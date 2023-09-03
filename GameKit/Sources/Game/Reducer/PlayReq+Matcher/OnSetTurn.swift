//
//  OnSetTurn.swift
//  
//
//  Created by Hugues Telolahy on 03/05/2023.
//

struct OnSetTurn: PlayReqMatcherProtocol {
    func match(state: GameState, ctx: EffectContext) -> Bool {
        if case let .setTurn(turn) = state.event,
              turn == ctx.get(.actor) {
            true
        } else {
            false
        }
    }
}
