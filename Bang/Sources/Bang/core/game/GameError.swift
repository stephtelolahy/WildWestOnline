//
//  GameError.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

/// Elementary game play error
public enum GameError: Error, Codable, Equatable {
    
    /// Expected players count to be leat X
    case playersMustBeAtLeast(Int)
    
    /// Expected player to be damaged
    case playerAlreadyMaxHealth(String)
    
    /// Expected player to have cards
    case playerHasNoCard(String)
    
    /// Expected player to have hand cards
    case playerHasNoHandCard(String)
    
    /// Expected card to have onPlay effect
    case cardHasNoEffect
    
    /// Expected some player damaged
    case noPlayerDamaged
    
    /// Expected store to contain come cards
    case noCardInStore
}
