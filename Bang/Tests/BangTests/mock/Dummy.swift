//
//  Dummy.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
import Bang

/// Dummy efffect
struct Dummy: Effect, Equatable {

    func resolve(_ ctx: Game) -> Result<EffectOutput, GameError> {
        .success(EffectOutputImpl())
    }
}
