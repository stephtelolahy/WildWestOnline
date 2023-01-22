//
//  PlayEquipment.swift
//  
//
//  Created by Hugues Telolahy on 18/01/2023.
//
import GameRules

/// Playing equipement card
struct PlayEquipment: PlayMode {
    
    func resolve(_ playCtx: PlayContext, ctx: Game) -> Result<Game, Error> {
        /// put equipement in self's inPlay
        var ctx = ctx
        let actor = playCtx.actor
        var playerObj = ctx.player(actor)
        let cardObj = playCtx.playedCard
        playerObj.hand.removeAll(where: { $0.id == cardObj.id })
        playerObj.inPlay.append(cardObj)
        ctx.players[actor] = playerObj
        return .success(ctx)
    }
    
    func isValid(_ playCtx: PlayContext, ctx: Game) -> Result<Void, Error> {
        .success
    }
}
