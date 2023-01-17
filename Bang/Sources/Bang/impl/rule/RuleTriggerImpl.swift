//
//  RuleTriggerImpl.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//

extension Rules: RuleTrigger {
    
    public func triggeredEffects(_ ctx: Game) -> [Event]? {
        var result: [Event] = []
        for (playerId, _) in ctx.players {
            for ability in ctx.player(playerId).abilities {
                if case .success = willTrigger(ability, actor: playerId, ctx: ctx) {
                    result.append(Trigger(actor: playerId, card: ability.id))
                }
            }
        }
        
        guard !result.isEmpty else {
            return nil
        }
        
        // TODO: sort moves by priority
        return result
    }
    
    private func willTrigger(_ card: Card, actor: String, ctx: Game) -> Result<Void, GameError> {
        // verify playing effects not empty
        guard !card.onTrigger.isEmpty else {
            return .failure(.cardHasNoTriggeredEffect)
        }
        
        /// set playing data
        let playCtx = PlayContextImpl(actor: actor, playedCard: card)
        
        /// verify all requirements
        for playReq in card.triggers {
            if case let .failure(error) = playReq.match(ctx, playCtx: playCtx) {
                return .failure(error)
            }
        }
        
        return .success
    }
}
