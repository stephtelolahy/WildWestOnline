//
//  PlayHandicap.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//
import GameRules

/// Playing handicap card
public struct PlayHandicap: PlayMode {
    
    public init() {}
    
    public func resolve(_ playCtx: PlayContext, ctx: Game) -> Result<EventOutput, GameError> {
        let actor = playCtx.actor
        var playerObj = ctx.player(playCtx.actor)
        let cardObj = playCtx.playedCard
        
        /// verify can play
        if case let .failure(error) = isValid(playCtx, ctx: ctx) {
            return .failure(error)
        }
        
        var ctx = ctx
        
        /// set playing data
        ctx.played.append(cardObj.name)
        
        guard let target = playCtx.target else {
            fatalError(.missingTarget)
        }
        
        /// put handicap in target's inPlay
        var targetObj = ctx.player(target)
        playerObj.hand.removeAll(where: { $0.id == cardObj.id })
        targetObj.inPlay.append(cardObj)
        ctx.players[actor] = playerObj
        ctx.players[target] = targetObj
        
        /// push child effects
        let playCtx = PlayContextImpl(actor: actor, playedCard: cardObj)
        let children = cardObj.onPlay?.withCtx(playCtx)
        
        return .success(EventOutputImpl(state: ctx, children: children))
    }
    
    public func isValid(_ playCtx: PlayContext, ctx: Game) -> Result<Void, GameError> {
        let cardObj = playCtx.playedCard
        
        /// verify all requirements
        if let playReqs = cardObj.canPlay {
            for playReq in playReqs {
                if case let .failure(error) = playReq.match(ctx, playCtx: playCtx) {
                    return .failure(error)
                }
            }
        }
        
        return .success
    }
}
