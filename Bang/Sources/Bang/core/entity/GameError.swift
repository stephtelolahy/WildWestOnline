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
    
    /// Expected player to have cards matching pattern
    case playerHasNoMatchingCard(String)
    
    /// Expected card to have onPlay effect
    case cardHasNoPlayingEffect
    
    /// Expected card to have onTriggered effect
    case cardHasNoTriggeredEffect
    
    /// Expected some player damaged
    case noPlayerDamaged
    
    /// Expected store to contain come cards
    case noCardInStore
    
    /// Expected some players at given range
    case noPlayersAt(Int)
    
    /// Expected to play below limit per turn
    case reachedLimitPerTurn(Int)
    
    /// Defaut  error
    case unknown
}
