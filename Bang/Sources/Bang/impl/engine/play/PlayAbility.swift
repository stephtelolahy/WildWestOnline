//
//  PlayAbility.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//

struct PlayAbility: Move {
    let actor: String
    let card: String
    let target: String?
    
    func resolve(_ ctx: Game) -> Result<EventOutput, GameError> {
        let playerObj = ctx.player(actor)
        let cardObj = playerObj.card(card)
        
        /// set playing data
        let playCtx = PlayContextImpl(actor: actor, playedCard: cardObj, target: target)
        
        /// verify can play
        if case let .failure(error) = isValid(ctx) {
            return .failure(error)
        }
        
        var ctx = ctx
        
        /// set playing data
        ctx.played.append(cardObj.name)
        
        /// push child effects
        let children = cardObj.onPlay.withCtx(playCtx)
        
        return .success(EventOutputImpl(state: ctx, children: children))
    }
    
    func isValid(_ ctx: Game) -> Result<Void, GameError> {
        let playerObj = ctx.player(actor)
        let cardObj = playerObj.card(card)
        let playCtx = PlayContextImpl(actor: actor, playedCard: cardObj, target: target)
        
        /// verify playing effects not empty
        guard !cardObj.onPlay.isEmpty else {
            return .failure(.cardHasNoPlayingEffect)
        }
        
        /// verify all requirements
        for playReq in cardObj.canPlay {
            if case let .failure(error) = playReq.match(ctx, playCtx: playCtx) {
                return .failure(error)
            }
        }
        
        return .success
    }
}
