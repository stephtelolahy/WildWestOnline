//
//  OnHandEmpty.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 09/11/2023.
//

struct OnHandEmpty: PlayReqMatcher {
    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        if case let .playImmediate(_, _, player) = state.event,
           player == ctx.actor,
           state.player(ctx.actor).hand.cards.isEmpty {
            return true
        }

        if case let .playHandicap(_, _, player) = state.event,
           player == ctx.actor,
           state.player(ctx.actor).hand.cards.isEmpty {
            return true
        }

        if case let .discardHand(_, player) = state.event,
           player == ctx.actor,
           state.player(ctx.actor).hand.cards.isEmpty {
            return true
        }

        if case let .stealHand(_, target, _) = state.event,
           target == ctx.actor,
           state.player(ctx.actor).hand.cards.isEmpty {
            return true
        }

        return false
    }
}
