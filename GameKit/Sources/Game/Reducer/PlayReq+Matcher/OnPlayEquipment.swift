//
//  OnPlayEquipment.swift
//
//
//  Created by Hugues Telolahy on 05/09/2023.
//

struct OnPlayEquipment: PlayReqMatcherProtocol {
    func match(state: GameState, ctx: EffectContext) -> Bool {
        if case let .playEquipment(card, player) = state.event,
           card == ctx.get(.card),
           player == ctx.get(.actor) {
            true
        } else {
            false
        }
    }
}
