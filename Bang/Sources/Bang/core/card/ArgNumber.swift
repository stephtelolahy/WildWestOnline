//
//  ArgNumber.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

public enum ArgNumber: Codable, Equatable {
    
    /// Number of active players
    case numPlayers
    
    /// Number of excess cards
    case numExcessHand
    
    /// exact number
    case exact(Int)
}
