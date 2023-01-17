//
//  Activate.swift
//  
//
//  Created by Hugues Telolahy on 17/01/2023.
//

/// Emit active moves
public struct Activate: Effect {
    public let moves: [Effect]
    
    public init(_ moves: [Effect]) {
        self.moves = moves
    }
    
    public func resolve(_ ctx: Game, playCtx: PlayContext) -> Result<EffectOutput, GameError> {
        fatalError(.unexpected)
    }
}
