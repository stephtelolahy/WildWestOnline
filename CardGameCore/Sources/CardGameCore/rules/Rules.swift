//
//  File.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 01/06/2022.
//

/// Implementing basic game rules
struct Rules {
    
    /// Check if game is over
    func isGameOver(ctx: State) -> Bool {
        #warning("implement game over")
        return ctx.players.contains { $0.value.health == 0 }
    }
    
    /// Generate active moves
    func possibleMoves(actor: String, ctx: State) -> [Move]? {
        let actorObj = ctx.player(actor)
        let moves = (actorObj.common + actorObj.hand)
            .map { possibleMoves(card: $0, actor: actor, ctx: ctx) ?? [] }
            .flatMap { $0 }
        
        guard !moves.isEmpty else {
            return nil
        }
        
        return moves
    }
}

private extension Rules {
    
    func possibleMoves(card: Card, actor: String, ctx: State) -> [Move]? {
        guard canPlay(card: card, actor: actor, ctx: ctx) else {
            return nil
        }
        
        if let target = card.target {
            guard case let .success(pIds) = Args.resolveTarget(target, ctx: ctx, actor: actor) else {
                return nil
            }
            
            return pIds.map { Play(card: card.id, actor: actor, target: $0) }
        } else {
            return [Play(card: card.id, actor: actor)]
        }
    }
    
    func canPlay(card: Card, actor: String, ctx: State) -> Bool {
        if ctx.turnNotStarted,
           card.activationMode != .activePrepareTurn {
            return false
        }
        
        if !ctx.turnNotStarted,
           card.activationMode != .active {
            return false
        }
        
        for playReq in card.canPlay {
            if case .failure = playReq.verify(ctx: ctx, actor: actor, card: card) {
                return false
            }
        }
        
        return true
    }
}
