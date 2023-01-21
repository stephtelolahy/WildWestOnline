//
//  OnSetTurn.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//
import GameRules

/// When setting turn
public struct OnSetTurn: PlayReq, Equatable {
    
    public init() {}
    
    public func match(_ ctx: Game, playCtx: PlayContext) -> Result<Void, GameError> {
        guard case let .success(event) = ctx.event,
              let seTurn = event as? SetTurn,
              let playerId = (seTurn.player as? PlayerId)?.id,
              playerId == playCtx.actor else {
            return .failure(.unknown)
        }
        
        return .success
    }
}
