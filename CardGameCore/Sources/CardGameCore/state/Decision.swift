//
//  File.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 31/05/2022.
//

/// A decision to be resolved by a player
public struct Decision {
    
    /// Moves to choose
    public let options: [Move]
    
    /// Played card's reference
    public let cardRef: String?
    
    public init(options: [Move], cardRef: String? = nil) {
        self.options = options
        self.cardRef = cardRef
    }
}
