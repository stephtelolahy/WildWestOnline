//
//  PlayerTarget.swift
//  
//
//  Created by Hugues Telolahy on 16/01/2023.
//

/// target player
public struct PlayerTarget: ArgPlayer, Equatable {
    
    public init() {}
    
    public func resolve(_ ctx: Game, playCtx: PlayContext) -> Result<ArgOutput, GameError> {
        guard let current = playCtx.target else {
            fatalError(.missingTarget)
        }
        return .success(.identified([current]))
    }
}
