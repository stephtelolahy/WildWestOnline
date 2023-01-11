//
//  EmitError.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
import Bang

/// Effect resulting an error
struct EmitError: Effect, Equatable {
    
    let error: GameError
    
    func resolve(_ ctx: Game) -> Result<EffectOutput, GameError> {
        .failure(error)
    }
}
