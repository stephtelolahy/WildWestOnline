//
//  PlayEquipment.swift
//  
//
//  Created by Hugues Telolahy on 18/01/2023.
//
import GameCore

/// Playing equipement card
struct PlayEquipment: PlayMode {
    
    func resolve(_ eventCtx: EventContext, ctx: Game) -> Result<Game, Error> {
        /// put equipement in self's inPlay
        var ctx = ctx
        let actor = eventCtx.actor
        var playerObj = ctx.player(actor)
        let cardObj = eventCtx.card
        playerObj.hand.removeAll(where: { $0.id == cardObj.id })
        playerObj.inPlay.append(cardObj)
        ctx.players[actor] = playerObj
        return .success(ctx)
    }
    
    func isValid(_ eventCtx: EventContext, ctx: Game) -> Result<Void, Error> {
        .success
    }
}