//
//  PlayHandicap.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//
import GameRules

/// Playing handicap card
struct PlayHandicap: PlayMode {
    
    func resolve(_ eventCtx: EventContext, ctx: Game) -> Result<Game, Error> {
        guard let target = eventCtx.target else {
            fatalError(InternalError.missingTarget)
        }
        
        /// put handicap in target's inPlay
        var ctx = ctx
        let actor = eventCtx.actor
        var playerObj = ctx.player(eventCtx.actor)
        let cardObj = eventCtx.card
        var targetObj = ctx.player(target)
        playerObj.hand.removeAll(where: { $0.id == cardObj.id })
        targetObj.inPlay.append(cardObj)
        ctx.players[actor] = playerObj
        ctx.players[target] = targetObj
        return .success(ctx)
    }
    
    func isValid(_ eventCtx: EventContext, ctx: Game) -> Result<Void, Error> {
        .success
    }
}
