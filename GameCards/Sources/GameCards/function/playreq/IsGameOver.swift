//
//  IsGameOver.swift
//  
//
//  Created by Hugues Telolahy on 18/01/2023.
//
import GameRules

/// When game is over
public struct IsGameOver: PlayReq {

    public init() {}
    
    public func match(_ ctx: Game, playCtx: PlayContext) -> Result<Void, GameError> {
        guard ctx.playOrder.count == 1 else {
            return .failure(.unknown)
        }
        
        return .success
    }
}
