//
//  OnDiscardedInPlay.swift
//
//
//  Created by Hugues Telolahy on 02/09/2023.
//

struct OnDiscardedInPlay: PlayReqMatcherProtocol {
    func match(state: GameState, ctx: EffectContext) -> Bool {
        if case let .discardInPlay(card, player) = state.event,
              player == ctx.get(.actor),
              card == ctx.get(.card) {
            true
        } else {
            false
        }
    }
}
