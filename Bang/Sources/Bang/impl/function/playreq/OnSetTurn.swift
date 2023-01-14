//
//  OnSetTurn.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//

/// When setting turn
public struct OnSetTurn: PlayReq, Equatable {
    
    public init() {}
    
    public func match(_ ctx: Game) -> Result<Void, GameError> {
        guard case let .success(effect) = ctx.event,
              let seTurn = effect as? SetTurn,
              let playerId = (seTurn.player as? PlayerId)?.id,
              playerId == ctx.actor else {
            return .failure(.unknown)
        }
        
        return .success
    }
}
