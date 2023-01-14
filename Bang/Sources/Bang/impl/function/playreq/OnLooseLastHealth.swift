//
//  OnLooseLastHealth.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//

/// When loosing last life point
public struct OnLooseLastHealth: PlayReq, Equatable {
    
    public func verify(_ ctx: Game) -> Result<Void, GameError> {
        guard case let .success(effect) = ctx.event,
              let damage = effect as? Damage,
              let playerId = (damage.player as? PlayerId)?.id,
              ctx.player(playerId).health <= 0,
              playerId == ctx.actor else {
            return .failure(.unknown)
        }
        
        return .success
    }
}
