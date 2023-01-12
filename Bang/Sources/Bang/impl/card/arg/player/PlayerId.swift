//
//  PlayerId.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// player identified by
public struct PlayerId: ArgPlayer, Equatable {
    let id: String
    
    public init(_ id: String) {
        self.id = id
    }
    
    public func resolve(_ ctx: Game) -> Result<ArgResolved, GameError> {
        .success(.identified([id]))
    }
}
