// swiftlint:disable:this file_name
//
//  CardAttribute.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 22/03/2024.
//

/// Well known card attributes
public extension String {
    /// Max health
    static let maxHealth = "maxHealth"

    /// Gun range
    static let weapon = "weapon"

    /// Increment distance from others
    static let remoteness = "remoteness"

    /// Decrement distance to others
    static let magnifying = "magnifying"

    /// Number of flipped cards on a draw
    static let flippedCards = "flippedCards"

    /// If defined, this attribute overrides the maximum allowed hand cards at the end of his turn
    /// By default the maximum allowed hand cards is equal to health
    static let handLimit = "handLimit"
}
