//
//  OnPlayHandicap.swift
//  
//
//  Created by Hugues Telolahy on 05/09/2023.
//

struct OnPlayHandicap: PlayReqMatcherProtocol {
    func match(state: GameState, ctx: EffectContext) -> Bool {
        if case let .playHandicap(card, target, _) = state.event,
           card == ctx.get(.card),
           target == ctx.get(.actor) {
            true
        } else {
            false
        }
    }
}
