//
//  EmitError.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

/// Effect resulting an error
public struct EmitError: Effect, Equatable {
    
    private let error: GameError
    
    public init(error: GameError) {
        self.error = error
    }
    
    public func resolve(_ ctx: Game) -> Result<EffectOutput, GameError> {
        .failure(error)
    }
}
