//
//  OnLooseLastHealth.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//

/// When loosing last life point
public struct OnLooseLastHealth: PlayReq, Equatable {
    
    public init() {}
    
    public func match(_ ctx: Game, playCtx: PlayContext) -> Result<Void, GameError> {
        guard case let .success(event) = ctx.event,
              let damage = event as? Damage,
              let playerId = (damage.player as? PlayerId)?.id,
              ctx.player(playerId).health <= 0,
              playerId == playCtx.actor else {
            return .failure(.unknown)
        }
        
        return .success
    }
}
