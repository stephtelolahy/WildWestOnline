//
//  PlayerDamaged.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// all damaged players
public struct PlayerDamaged: ArgPlayer, Equatable {

    public init() {}
    
    public func resolve(_ ctx: Game) -> Result<ArgResolved, GameError> {
        let damaged = ctx.playOrder
            .starting(with: ctx.actor)
            .filter { ctx.player($0).health < ctx.player($0).maxHealth }
        
        guard !damaged.isEmpty else {
            return .failure(.noPlayerDamaged)
        }
        
        return .success(.identified(damaged))
    }
}
