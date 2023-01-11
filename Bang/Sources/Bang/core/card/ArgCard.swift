//
//  ArgCard.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

public enum ArgCard: Codable, Equatable {
    
    /// a random hand card
    case randomHand
    
    /// all cards
    case all
    
    /// select any card from given zone
    case select(Zone)
    
    /// identified by
    case id(String)
}

public extension ArgCard {
    
    enum Zone: Codable, Equatable {
        
        /// any player's hand or inPlay card
        case any
        
        /// any player's hand card
        case hand
        
        /// any player's hand card matching given name
        case match(String)
        
        /// any store card
        case store
    }
}

public extension ArgCard {
    
    /// Random hand card label
    /// displayed when choosing random hand card
    static let randomHandLabel = "randomHand"
}
