//
//  PlayerTarget.swift
//  
//
//  Created by Hugues Telolahy on 16/01/2023.
//
import GameRules

/// target player
public struct PlayerTarget: ArgPlayer, Equatable {
    
    public init() {}
    
    public func resolve(_ ctx: Game, playCtx: PlayContext) -> Result<ArgOutput, Error> {
        guard let current = playCtx.target else {
            fatalError(InternalError.missingTarget)
        }
        return .success(.identified([current]))
    }
}
