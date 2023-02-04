//
//  EngineError.swift
//  
//
//  Created by Hugues Telolahy on 21/01/2023.
//

/// Displayable gameplay error
public enum EngineError: Error, Equatable {
    
    /// Card cannot be played
    case cannotPlayThisCard
    
    /// Expected card to have onTriggered effect
    case cardHasNoTriggeredEffect
}
