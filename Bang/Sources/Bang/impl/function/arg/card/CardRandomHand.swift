//
//  CardRandomHand.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// a random hand card
public struct CardRandomHand: ArgCard, Equatable {
    
    public init() {}

    public func resolve(_ ctx: Game, chooser: String, owner: String?) -> Result<ArgResolved, GameError> {
        fatalError()
    }
}
