//
//  OnHandEmpty.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 09/11/2023.
//

struct OnHandEmpty: PlayReqMatcher {
    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        if case let .playImmediate(_, _, player) = ctx.event,
           player == ctx.actor,
           state.player(ctx.actor).hand.isEmpty {
            return true
        }

        if case let .handicap(_, _, player) = ctx.event,
           player == ctx.actor,
           state.player(ctx.actor).hand.isEmpty {
            return true
        }

        if case let .discardHand(_, player) = ctx.event,
           player == ctx.actor,
           state.player(ctx.actor).hand.isEmpty {
            return true
        }

        if case let .drawHand(_, target, _) = ctx.event,
           target == ctx.actor,
           state.player(ctx.actor).hand.isEmpty {
            return true
        }

        return false
    }
}
