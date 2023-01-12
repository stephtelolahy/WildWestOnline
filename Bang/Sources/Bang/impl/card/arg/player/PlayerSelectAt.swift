//
//  PlayerSelectAt.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// any other player at distance of X
public struct PlayerSelectAt: ArgPlayer, Equatable {
    private let distance: Int
    
    public init(_ distance: Int) {
        self.distance = distance
    }
    
    public func resolve(_ ctx: Game) -> Result<ArgResolved, GameError> {
        let players = ctx.playersAt(distance, from: ctx.actor)
        guard !players.isEmpty else {
            return .failure(.noPlayersAt(distance))
        }
        
        return .success(.selectable(players.toOptions()))
    }
}
