//
//  OnSetTurn.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//
import GameRules

/// When setting turn
struct OnSetTurn: PlayReq, Equatable {
    
    func match(_ ctx: Game, eventCtx: EventContext) -> Result<Void, Error> {
        guard case let .success(event) = ctx.event,
              let seTurn = event as? SetTurn,
              let playerId = (seTurn.player as? PlayerId)?.id,
              playerId == eventCtx.actor else {
            return .failure(GameError.unknown)
        }
        
        return .success
    }
}
