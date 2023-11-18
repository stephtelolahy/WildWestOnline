//
//  AttributeKey.swift
//  
//
//  Created by Hugues Telolahy on 06/05/2023.
//

/// Player attributes
public extension String {
    /// Max health
    static let maxHealth = "maxHealth"

    /// Gun range, default: 1
    static let weapon = "weapon"

    /// Increment distance from others, default: 0
    static let mustang = "mustang"

    /// Decrement distance to others, default: 0
    static let scope = "scope"

    /// Cards to draw at beginning of turn, default: 2
    static let startTurnCards = "startTurnCards"

    /// Number of flipped cards on a draw, default: 1
    static let flippedCards = "flippedCards"

    /// Number of bangs per turn, default: 1
    static let bangsPerTurn = "bangsPerTurn"

    /// If defined, this attribute overrides the maximum allowed hand cards at the end of his turn
    /// by default the maximum allowed hand cards is equal to health
    static let handLimit = "handLimit"
}

/// Order in which attributes are settled
/// sorted from highest to lowest priority
enum AttributeKey {
    static let priorities: [String] = [
        .maxHealth,
        .weapon,
        .mustang,
        .scope,
        .startTurnCards,
        .flippedCards,
        .bangsPerTurn
    ]
}
