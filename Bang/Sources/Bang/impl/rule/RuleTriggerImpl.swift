//
//  RuleTriggerImpl.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//

extension GameRules: RuleTrigger {
    
    public func triggeredMoves(_ ctx: Game) -> [Effect] {
        var result: [Effect] = []
        for playerId in ctx.playOrder {
            for ability in ctx.player(playerId).abilities {
                if case .success = willTrigger(ability, actor: playerId, ctx: ctx) {
                    result.append(Trigger(actor: playerId, card: ability.id))
                }
            }
        }
        
        return result
    }
    
    private func willTrigger(_ card: Card, actor: String, ctx: Game) -> Result<Void, GameError> {
        guard !card.triggers.isEmpty else {
            return .failure(.unknown)
        }
        
        /// add queue data
        var ctx = ctx
        ctx.queueActor = actor
        ctx.queueCard = card
        
        /// verify all requirements
        for playReq in card.triggers {
            if case let .failure(error) = playReq.verify(ctx) {
                return .failure(error)
            }
        }
        
        return .success
    }
}
