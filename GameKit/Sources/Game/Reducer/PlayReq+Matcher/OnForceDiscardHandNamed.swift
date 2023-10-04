//
//  OnForceDiscardHandNamed.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 21/06/2023.
//

struct OnForceDiscardHandNamed: PlayReqMatcher {
    let cardName: String
    
    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        if let event = state.event,
              case let .effect(cardEffect, effectCtx) = event,
              case let .force(effect, _) = cardEffect,
              case let .discard(cardArg, chooser) = effect,
              case let .selectHandNamed(name) = cardArg,
              chooser == nil,
              cardName == name,
              ctx.actor == effectCtx.get(.target) {
            true
        } else {
            false
        }
    }
}
