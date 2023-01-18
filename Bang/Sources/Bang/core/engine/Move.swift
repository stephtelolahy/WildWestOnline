//
//  Move.swift
//  
//
//  Created by Hugues Telolahy on 18/01/2023.
//

/// An action taken by the player
public protocol Move: Event {
    
    /// Player Id who is performing the move
    var actor: String { get }
    
    /// Verify if applicable
    func isValid(_ ctx: Game) -> Result<Void, GameError>
}
