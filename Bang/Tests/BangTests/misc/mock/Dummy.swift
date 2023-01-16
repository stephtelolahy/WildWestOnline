//
//  Dummy.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
import Bang

/// Effect resolving with a success
struct Dummy: Effect, Equatable {
    
    func resolve(_ ctx: Game, playCtx: PlayContext) -> Result<EffectOutput, GameError> {
        .success(EffectOutputImpl(state: ctx))
    }
}
