//
//  NumArg.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//

/// Number argument
public enum NumArg: Codable, Equatable {

    /// Exact number
    case exact(Int)

    /// Number of active players
    case numPlayers

    /// Number of excess cards at the end of turn
    case excessHand
    
    /// Number of start turn cards
    case playerAttr(AttributeKey)
}
