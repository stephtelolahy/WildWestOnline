//
//  OnChangeInPlay.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 05/10/2023.
//

struct OnChangeInPlay: PlayReqMatcher {
    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        if case let .playEquipment(_, player) = ctx.event,
           player == ctx.actor {
            return true
        }

        if case let .discardInPlay(_, player) = ctx.event,
           player == ctx.actor {
            return true
        }

        if case let .drawInPlay(_, target, _) = ctx.event,
           target == ctx.actor {
            return true
        }

        if case let .passInPlay(_, target, player) = ctx.event,
           target == ctx.actor || player == ctx.actor {
            return true
        }

        return false
    }
}
