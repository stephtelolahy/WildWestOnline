//
//  ArgNum.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//

/// Number argument
public enum ArgNum: Codable, Equatable {

    /// Exact number
    case exact(Int)

    /// Number of active players
    case activePlayers

    /// Number of excess cards at the end of turn
    case excessHand
    
    /// Player attribute value
    case attr(String)

    /// Number of lost life points in triggering damage action
    case damage
}
