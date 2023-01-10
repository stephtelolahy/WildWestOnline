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
        
        /// any hand or inPlay card
        case any
        
        /// any hand card
        case hand
        
        /// any hand card matching given name
        case match(String)
        
        /// any store card
        case store
    }
}
