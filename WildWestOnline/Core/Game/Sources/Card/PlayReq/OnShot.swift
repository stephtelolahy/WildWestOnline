//
//  OnShot.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 12/10/2023.
//

struct OnShot: PlayReqMatcher {
    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        if case let .effect(cardEffect, effectCtx) = ctx.event,
           case .shoot = cardEffect,
           ctx.actor == effectCtx.resolvingTarget {
            true
        } else {
            false
        }
    }
}
