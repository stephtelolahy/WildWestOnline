//
//  File.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 31/05/2022.
//

/// A decision to be resolved by a player
public struct Decision {
    
    /// Played card's reference
    public var cardRef: String?
    
    /// Moves to choose
    public let options: [Move]
}
