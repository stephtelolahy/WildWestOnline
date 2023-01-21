//
//  EffectEmitError.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
import GameRules

struct EffectEmitError: Effect, Equatable {
    @EquatableCast var error: Error
    @EquatableIgnore var playCtx: PlayContext = PlayContextImpl()
    
    func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        .failure(error)
    }
}
