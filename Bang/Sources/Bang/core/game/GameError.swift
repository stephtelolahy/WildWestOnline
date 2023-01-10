//
//  GameError.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

/// Elementary game play error
public enum GameError: Error, Equatable {
    
    /// Expected player to be damaged
    case playerAlreadyMaxHealth(String)
    
    /// Expected players count to be leat X
    case playersMustBeAtLeast(Int)
}
