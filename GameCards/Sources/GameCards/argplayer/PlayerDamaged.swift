//
//  PlayerDamaged.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
import GameCore

/// all damaged players
public struct PlayerDamaged: ArgPlayer, Equatable {

    public init() {}
    
    public func resolve(_ ctx: Game, eventCtx: EventContext) -> Result<ArgOutput, Error> {
        let damaged = ctx.playOrder
            .starting(with: eventCtx.actor)
            .filter { ctx.player($0).health < ctx.player($0).maxHealth }
        
        guard !damaged.isEmpty else {
            return .failure(GameError.noPlayerDamaged)
        }
        
        return .success(.identified(damaged))
    }
}
