//
//  NumPlayers.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
import GameRules

/// Number of active players
public struct NumPlayers: ArgNumber, Equatable {

    public init() {}
    
    public func resolve(_ ctx: Game, eventCtx: EventContext) -> Result<Int, Error> {
        .success(ctx.playOrder.count)
    }
}
