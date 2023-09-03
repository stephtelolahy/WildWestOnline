//
//  AttributeKey.swift
//  
//
//  Created by Hugues Telolahy on 06/05/2023.
//

/// Initial game element attributes
public enum AttributeKey: String, Codable, CodingKeyRepresentable {

    /// Max health
    case maxHealth

    /// Override maximum allowed hand cards at the end of his turn
    /// by default health is maximum allowed hand cards
    case handLimit

    /// Gun range, default: 1
    case weapon

    /// Increment distance from others, default: 0
    case mustang

    /// Decrement distance to others, default: 0
    case scope

    /// Cards to draw at beginning of turn, default: 2
    case startTurnCards

    /// Number of flipped cards on a draw, default: 1
    case flippedCards

    /// Number of bangs per turn, default: 1
    case bangsPerTurn
}

public typealias Attributes = [AttributeKey: Int]
