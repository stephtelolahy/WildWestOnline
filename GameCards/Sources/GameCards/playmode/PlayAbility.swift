//
//  PlayAbility.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//
import GameRules

/// Invoking ability
struct PlayAbility: PlayMode {
    
    init() {}
    
    func resolve(_ playCtx: PlayContext, ctx: Game) -> Result<EventOutput, Error> {
        let cardObj = playCtx.playedCard
        
        /// verify can play
        if case let .failure(error) = isValid(playCtx, ctx: ctx) {
            return .failure(error)
        }
        
        var ctx = ctx
        
        /// set playing data
        ctx.played.append(cardObj.name)
        
        /// push child effects
        let children = cardObj.onPlay?.withCtx(playCtx)
        
        return .success(EventOutputImpl(state: ctx, children: children))
    }
    
    func isValid(_ playCtx: PlayContext, ctx: Game) -> Result<Void, Error> {
        let cardObj = playCtx.playedCard
        
        /// verify playing effects not empty
        guard cardObj.onPlay != nil else {
            return .failure(GameError.cardHasNoPlayingEffect)
        }
        
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
