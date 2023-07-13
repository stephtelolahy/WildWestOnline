//
//  AttributeKey.swift
//  
//
//  Created by Hugues Telolahy on 06/05/2023.
//

/// Game element attributes
public typealias Attributes = [AttributeKey: Int]

public enum AttributeKey: String, Codable, CodingKeyRepresentable {

    /// Max health
    case maxHealth

    /// Life points
    case health

    /// Override maximum allowed hand cards at the end of his turn
    /// by default health is maximum allowed hand cards
    case handLimit

    /// Gun range, default: 1
    case weapon

    /// Increment distance from others
    case mustang

    /// Decrement distance to others
    case scope

    /// Cards to draw at beginning of turn
    case starTurnCards

    /// Number of flipped cards on a draw, default: 1
    case flippedCards

    /// Number of bangs per turn, default: 1
    case bangsPerTurn
}
