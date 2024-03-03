// swiftlint:disable:this file_name
//
//  AttributeKey.swift
//
//
//  Created by Hugues Telolahy on 06/05/2023.
//

/// Well known player attributes
/// Sorted by order in which attributes are settled
public extension String {
    /// Max health
    static let maxHealth = "maxHealth"

    /// Gun range
    static let weapon = "weapon"

    /// Increment distance from others, default: 0
    static let mustang = "mustang"

    /// Decrement distance to others, default: 0
    static let scope = "scope"

    /// Number of flipped cards on a draw
    static let flippedCards = "flippedCards"

    /// If defined, this attribute overrides the maximum allowed hand cards at the end of his turn
    /// by default the maximum allowed hand cards is equal to health
    static let handLimit = "handLimit"
}
