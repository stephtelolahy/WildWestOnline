//
//  ArgCard.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

/// Card argument
public protocol ArgCard {
    
    /// Resolving card argument
    /// - Parameters:
    ///   - ctx: game state
    ///   - chooser: player making choice if any
    ///   - owner: player owning the card if any
    func resolve(_ ctx: Game, chooser: String, owner: String?) -> Result<ArgResolved, GameError>
}
