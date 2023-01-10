//
//  Dummy.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

/// Dummy efffect
public struct Dummy: Effect, Equatable {
    
    public init() {}

    public func resolve(_ ctx: Game) -> Result<EffectOutput, GameError> {
        .success(EffectOutputImpl())
    }
}
