//
//  OnForceDiscardHandNamed.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 21/06/2023.
//

struct OnForceDiscardHandNamed: EventReqMatcherProtocol {
    let cardName: String
    
    func match(state: GameState, ctx: EffectContext) -> Bool {
        guard let event = state.event,
              case let .resolve(cardEffect, effectCtx) = event,
              case let .force(effect, _) = cardEffect,
              case let .discard(cardArg, chooser) = effect,
              case let .selectHandNamed(name) = cardArg,
              chooser == nil,
              cardName == name,
              ctx.get(.actor) == effectCtx.get(.target) else {
            return false
        }
        
        return true
    }
}
