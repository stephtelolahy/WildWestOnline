//
//  OnDiscarded.swift
//  
//
//  Created by Hugues Telolahy on 02/09/2023.
//

struct OnDiscarded: EventReqMatcherProtocol {
    func match(state: GameState, ctx: EffectContext) -> Bool {
        // TODO: handle discardInPlay and stealInPlay
        if case let .discard(card, player) = state.event,
              player == ctx.get(.actor),
              card == ctx.get(.card) {
            true
        } else {
            false
        }
    }
}
