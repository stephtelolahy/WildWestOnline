//
//  CardSelectHandMatch.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// select any hand card matching given name
public struct CardSelectHandMatch: ArgCard, Equatable {
    
    public init() {}

    public func resolve(_ ctx: Game, chooser: String, owner: String?) -> Result<ArgResolved, GameError> {
        fatalError()
    }
}
