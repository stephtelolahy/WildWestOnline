//
//  OnEliminated.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//

/// When just eliminated
public struct OnEliminated: PlayReq, Equatable {
    
    public init() {}
    
    public func verify(_ ctx: Game) -> Result<Void, GameError> {
        guard case let .success(effect) = ctx.event,
              let eliminate = effect as? Eliminate,
              let playerId = (eliminate.player as? PlayerId)?.id,
              playerId == ctx.actor else {
            return .failure(.unknown)
        }
        
        return .success
    }
}
