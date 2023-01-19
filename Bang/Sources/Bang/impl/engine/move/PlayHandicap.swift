//
//  PlayHandicap.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//

struct PlayHandicap: Move {
    let actor: String
    let card: String
    let target: String?

    func resolve(_ ctx: Game) -> Result<EventOutput, GameError> {
        var playerObj = ctx.player(actor)
        let cardObj = playerObj.card(card)
        
        /// verify can play
        if case let .failure(error) = isValid(ctx) {
            return .failure(error)
        }
        
        var ctx = ctx
        
        /// set playing data
        ctx.played.append(cardObj.name)
        
        /// put handicap in target's inPlay
        guard let handIndex = playerObj.hand.firstIndex(where: { $0.id == card }) else {
            fatalError(.missingPlayerCard(card))
        }
        
        guard let target = self.target else {
            fatalError(.missingTarget)
        }
        
        var targetObj = ctx.player(target)
        playerObj.hand.remove(at: handIndex)
        targetObj.inPlay.append(cardObj)
        ctx.players[actor] = playerObj
        ctx.players[target] = targetObj
        
        /// push child effects
        let playCtx = PlayContextImpl(actor: actor, playedCard: cardObj)
        let children = cardObj.onPlay?.withCtx(playCtx)
        
        return .success(EventOutputImpl(state: ctx, children: children))
    }
    
    func isValid(_ ctx: Game) -> Result<Void, GameError> {
        let playerObj = ctx.player(actor)
        let cardObj = playerObj.card(card)
        let playCtx = PlayContextImpl(actor: actor, playedCard: cardObj, target: target)
        
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
