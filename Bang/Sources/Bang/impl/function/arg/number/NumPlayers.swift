//
//  NumPlayers.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// Number of active players
public struct NumPlayers: ArgNumber, Equatable {

    public init() {}
    
    public func resolve(_ ctx: Game) -> Result<Int, GameError> {
        .success(ctx.playOrder.count)
    }
}
