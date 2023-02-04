//
//  PlayerTarget.swift
//  
//
//  Created by Hugues Telolahy on 16/01/2023.
//
import GameCore

/// target player
public struct PlayerTarget: ArgPlayer, Equatable {
    
    public init() {}
    
    public func resolve(_ ctx: Game, eventCtx: EventContext) -> Result<ArgOutput, Error> {
        guard let current = eventCtx.target else {
            fatalError(InternalError.missingTarget)
        }
        return .success(.identified([current]))
    }
}
