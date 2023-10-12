//
//  OnShot.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 12/10/2023.
//

struct OnShot: PlayReqMatcher {
    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        if let event = state.event,
           case let .effect(cardEffect, effectCtx) = event,
           case .shoot = cardEffect,
           ctx.actor == effectCtx.target {
            true
        } else {
            false
        }
    }
}
