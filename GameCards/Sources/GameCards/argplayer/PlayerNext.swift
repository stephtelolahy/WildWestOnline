//
//  PlayerNext.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
import GameCore

/// player after current turn
public struct PlayerNext: ArgPlayer, Equatable {
    
    public init() {}
    
    public func resolve(_ ctx: Game, eventCtx: EventContext) -> Result<ArgOutput, Error> {
        guard let turn = ctx.turn else {
            fatalError(InternalError.missingTurn)
        }
        
        guard let next = ctx.playOrder.element(after: turn) else {
            fatalError(InternalError.missingNext)
        }
        
        return .success(.identified([next]))
    }
}