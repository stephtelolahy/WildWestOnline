//
//  PlayerAll.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// all players
public struct PlayerAll: ArgPlayer, Equatable {
    
    public init() {}
    
    public func resolve(_ ctx: Game, playCtx: PlayContext) -> Result<ArgResolved, GameError> {
        let players = ctx.playOrder
            .starting(with: playCtx.actor)
        return .success(.identified(players))
    }
}
