//
//  ArgPlayer.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

public enum ArgPlayer: Codable, Equatable {
    
    /// who is playing the card
    case actor
    
    /// other players
    case others
    
    /// all players
    case all
    
    /// player after current turn
    case next
    
    /// current player on a group effect
    case current
    
    /// all damaged players
    case damaged
    
    /// select any other player at given distance
    case select(Distance)
    
    /// identified by
    case id(String)
}

public extension ArgPlayer {
    
    enum Distance: Codable, Equatable {
        
        /// any reachable player
        case reachable
        
        /// any other player
        case any
        
        /// any player at distance of X
        case at(Int)
    }
}
