//
//  EffectContext.swift
//
//
//  Created by Hugues Telolahy on 09/04/2023.
//

public typealias EffectContext = [ContextKey: String]

/// Context data associated to an effect
public enum ContextKey: String, Codable, CodingKeyRepresentable {
    
    /// the actor playing card
    case actor
    
    /// played card
    case card
    
    /// selected target
    case target
}
