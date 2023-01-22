//
//  OnLooseLastHealth.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//
import GameRules

/// When loosing last life point
struct OnLooseLastHealth: PlayReq, Equatable {
    
    func match(_ ctx: Game, playCtx: PlayContext) -> Result<Void, Error> {
        guard case let .success(event) = ctx.event,
              let damage = event as? Damage,
              let playerId = (damage.player as? PlayerId)?.id,
              ctx.player(playerId).health <= 0,
              playerId == playCtx.actor else {
            return .failure(GameError.unknown)
        }
        
        return .success
    }
}
