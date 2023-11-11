//
//  OnChangeInPlay.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 05/10/2023.
//

struct OnChangeInPlay: PlayReqMatcher {
    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        if case let .playEquipment(_, player) = state.event,
           player == ctx.actor {
            return true
        }

        if case let .discardInPlay(_, player) = state.event,
           player == ctx.actor {
            return true
        }

        if case let .stealInPlay(_, target, _) = state.event,
           target == ctx.actor {
            return true
        }

        if case let .passInplay(_, target, player) = state.event,
           target == ctx.actor || player == ctx.actor {
            return true
        }

        return false
    }
}
