//
//  GameError.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

/// Elementary game play error
public enum GameError: Error, Codable, Equatable {
    
    /// Expected player to be damaged
    case playerAlreadyMaxHealth(String)
    
    /// Expected players count to be leat X
    case playersMustBeAtLeast(Int)
    
    /// Expected card to have onPlay effect
    case cardHasNoEffect
    
    /// Expected some player damaged
    case noPlayerDamaged
}
