//
//  PlayerCurrent.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// current player on a group effect
public struct PlayerCurrent: ArgPlayer, Equatable {
    
    public init() {}
    
    public func resolve(_ ctx: Game) -> Result<ArgResolved, GameError> {
        guard let current = ctx.queuePlayer else {
            fatalError(.missingCurrentPlayer)
        }
        return .success(.identified([current]))
    }
}
