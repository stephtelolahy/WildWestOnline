//
//  OnDiscardedFromPlay.swift
//
//
//  Created by Hugues Telolahy on 02/09/2023.
//

struct OnDiscardedFromPlay: PlayReqMatcherProtocol {
    func match(state: GameState, ctx: EffectContext) -> Bool {
        if case let .discardInPlay(card, player) = state.event,
              player == ctx.get(.actor),
              card == ctx.get(.card) {
            return true
        }

        if case let .stealInPlay(card, _, player) = state.event,
              player == ctx.get(.actor),
              card == ctx.get(.card) {
            return true
        }
        
        return false
    }
}
