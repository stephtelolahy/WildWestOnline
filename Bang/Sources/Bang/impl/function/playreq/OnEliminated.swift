//
//  OnEliminated.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//

/// When just eliminated
public struct OnEliminated: PlayReq, Equatable {
    
    public init() {}
    
    public func match(_ ctx: Game, playCtx: PlayContext) -> Result<Void, GameError> {
        guard case let .success(event) = ctx.event,
              let eliminate = event as? Eliminate,
              let playerId = (eliminate.player as? PlayerId)?.id,
              playerId == playCtx.actor else {
            return .failure(.unknown)
        }
        
        return .success
    }
}
