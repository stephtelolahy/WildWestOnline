//
//  IsGameOver.swift
//  
//
//  Created by Hugues Telolahy on 18/01/2023.
//
import GameRules

/// When game is over
struct IsGameOver: PlayReq {
    
    func match(_ ctx: Game, eventCtx: EventContext) -> Result<Void, Error> {
        guard ctx.playOrder.count == 1 else {
            return .failure(GameError.unknown)
        }
        
        return .success
    }
}
