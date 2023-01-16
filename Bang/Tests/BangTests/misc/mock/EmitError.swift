//
//  EmitError.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
import Bang

/// Effect resolving with an error
struct EmitError: Effect, Equatable {
    let error: GameError
    
    func resolve(_ ctx: Game, playCtx: PlayContext) -> Result<EffectOutput, GameError> {
        .failure(error)
    }
}
