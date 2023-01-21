//
//  EngineRuleImpl.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
public struct EngineRuleImpl: EngineRule {
    
    public init() {}
    
    public func active(_ ctx: Game) -> [Move]? {
        guard let playerId = ctx.turn else {
            return nil
        }
        
        let playerObj = ctx.player(playerId)
        let playableCards = playerObj.hand + playerObj.abilities
        let moves: [Play] = playableCards
            .map { Play(actor: playerId, card: $0.id) }
            .filter { $0.isValid(ctx).isSuccess }
            .compactMap { $0 }
        
        guard !moves.isEmpty else {
            return nil
        }
        
        return moves
    }
    
    public func triggered(_ ctx: Game) -> [Event]? {
        var result: [Trigger] = []
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
        
        return result
    }
}
