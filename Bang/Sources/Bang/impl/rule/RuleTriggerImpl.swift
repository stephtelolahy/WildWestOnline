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
            let playerObj = ctx.player(playerId)
            let triggerableCards = playerObj.inPlay + playerObj.abilities
            let events: [Trigger] = triggerableCards
                .map { Trigger(actor: playerId, card: $0.id) }
                .filter { $0.isValid(ctx).isSuccess }
                .compactMap { $0 }
            result.append(contentsOf: events)
        }
        
        guard !result.isEmpty else {
            return nil
        }
        
        // TODO: sort effects by priority
        return result
    }
}
