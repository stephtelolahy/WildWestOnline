//
//  PlayEquipment.swift
//  
//
//  Created by Hugues Telolahy on 18/01/2023.
//

/// Playing equipement card
struct PlayEquipment: Move {
    let actor: String
    let card: String
    
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
        
        /// put equipement in self's inPlay
        guard let handIndex = playerObj.hand.firstIndex(where: { $0.id == card }) else {
            fatalError(.unexpected)
        }
        
        playerObj.hand.remove(at: handIndex)
        playerObj.inPlay.append(cardObj)
        ctx.players[actor] = playerObj
        
        /// push child effects
        var children: [Effect]?
        if !cardObj.onPlay.isEmpty {
            children = cardObj.onPlay
        }
        
        return .success(EventOutputImpl(state: ctx, children: children))
    }
    
    func isValid(_ ctx: Game) -> Result<Void, GameError> {
        let playerObj = ctx.player(actor)
        let cardObj = playerObj.card(card)
        let playCtx = PlayContextImpl(actor: actor, playedCard: cardObj)
        
        /// verify all requirements
        for playReq in cardObj.canPlay {
            if case let .failure(error) = playReq.match(ctx, playCtx: playCtx) {
                return .failure(error)
            }
        }
        
        return .success
    }
}
