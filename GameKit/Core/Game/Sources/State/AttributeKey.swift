//
//  AttributeKey.swift
//
//
//  Created by Hugues Telolahy on 06/05/2023.
//

/// Well known player attributes
/// Sorted by order in which attributes are settled
public enum AttributeKey: String, CaseIterable, Codable, CodingKeyRepresentable {
    public static var allCases: [Self] = [
        .maxHealth,
        .weapon,
        .mustang,
        .scope,
        .flippedCards,
        .startTurnCards,
        .bangsPerTurn,
        .handLimit
    ]

    /// Max health
    case maxHealth

    /// Gun range
    case weapon

    /// Increment distance from others, default: 0
    case mustang

    /// Decrement distance to others, default: 0
    case scope

    /// Cards to draw at beginning of turn
    @available(*, deprecated, message: "Use dynamic attribute")
    case startTurnCards

    /// Number of flipped cards on a draw
    case flippedCards

    /// Number of bangs per turn
    /// Unlimited when value is 0
    @available(*, deprecated, message: "Use dynamic attribute")
    case bangsPerTurn

    /// If defined, this attribute overrides the maximum allowed hand cards at the end of his turn
    /// by default the maximum allowed hand cards is equal to health
    case handLimit
}
