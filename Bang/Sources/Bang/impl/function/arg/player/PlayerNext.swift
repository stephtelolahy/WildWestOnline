//
//  PlayerNext.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// player after current turn
public struct PlayerNext: ArgPlayer, Equatable {
    
    public init() {}
    
    public func resolve(_ ctx: Game) -> Result<ArgResolved, GameError> {
        guard let turn = ctx.turn else {
            fatalError(.missingTurn)
        }
        
        let next = ctx.playOrder
            .element(after: turn)
        return .success(.identified([next]))
    }
}
