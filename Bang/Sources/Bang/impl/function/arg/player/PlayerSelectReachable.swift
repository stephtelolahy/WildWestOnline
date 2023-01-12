//
//  PlayerSelectReachable.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// select any reachable player
public struct PlayerSelectReachable: ArgPlayer, Equatable {
    
    public init() {}
    
    public func resolve(_ ctx: Game) -> Result<ArgResolved, GameError> {
        fatalError()
    }
}
