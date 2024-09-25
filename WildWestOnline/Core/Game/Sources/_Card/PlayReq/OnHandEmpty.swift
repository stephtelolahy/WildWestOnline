//
//  OnHandEmpty.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 09/11/2023.
//

struct OnHandEmpty: PlayReqMatcher {
    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        if case let .playBrown(_, player) = ctx.event,
           player == ctx.actor,
           state.field.hand.isEmpty(ctx.actor) {
            return true
        }

        if case let .discardHand(_, player) = ctx.event,
           player == ctx.actor,
           state.field.hand.isEmpty(ctx.actor) {
            return true
        }

        if case let .playHandicap(_, _, player) = ctx.event,
           player == ctx.actor,
           state.field.hand.isEmpty(ctx.actor) {
            return true
        }

        if case let .playEquipment(_, player) = ctx.event,
           player == ctx.actor,
           state.field.hand.isEmpty(ctx.actor) {
            return true
        }

        if case let .stealHand(_, target, _) = ctx.event,
           target == ctx.actor,
           state.field.hand.get(ctx.actor).isEmpty {
            return true
        }

        return false
    }
}
