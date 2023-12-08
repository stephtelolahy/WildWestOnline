//
//  ArgCardLuck.swift
//  
//
//  Created by Hugues Telolahy on 18/11/2023.
//

/// Card argument for luck effect
public enum ArgCardLuck: Codable, Equatable {
    /// Determine luck using top discard
    case topDiscard

    /// Determine luck using last drawn hand card
    case lastHand
}
