//
//  ArgLuckCard.swift
//  
//
//  Created by Hugues Telolahy on 18/11/2023.
//

/// Card argument for luck effect
public enum ArgLuckCard: Codable, Equatable {
    /// Determine luck using last drawn card
    case drawn

    /// Determine luck using last drawn hand card
    case drawnHand
}
