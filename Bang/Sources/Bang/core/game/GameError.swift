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
    
    /// Card has no effect
    case cardHasNoEffect
}
