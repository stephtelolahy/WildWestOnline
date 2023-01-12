//
//  CardAll.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// all cards
public struct CardAll: ArgCard, Equatable {
    
    public init() {}

    public func resolve(_ ctx: Game, chooser: String, owner: String?) -> Result<ArgResolved, GameError> {
        fatalError()
    }
}
