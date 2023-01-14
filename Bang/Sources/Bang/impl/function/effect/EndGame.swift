//
//  EndGame.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//

/// Mark game over
public struct EndGame: Effect, Equatable {
    
    public init() {}

    public func resolve(_ ctx: Game) -> Result<EffectOutput, GameError> {
        var ctx = ctx
        ctx.isOver = true
        return .success(EffectOutputImpl(state: ctx))
    }
}
