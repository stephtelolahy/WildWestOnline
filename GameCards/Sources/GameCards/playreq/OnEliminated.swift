//
//  OnEliminated.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//
import GameCore

/// When just eliminated
struct OnEliminated: PlayReq, Equatable {
    
    func match(_ ctx: Game, eventCtx: EventContext) -> Result<Void, Error> {
        guard case let .success(event) = ctx.event,
              let eliminate = event as? Eliminate,
              let playerId = (eliminate.player as? PlayerId)?.id,
              playerId == eventCtx.actor else {
            return .failure(GameError.unknown)
        }
        
        return .success
    }
}
