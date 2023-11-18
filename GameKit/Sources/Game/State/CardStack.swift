//
//  CardStack.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
import InitMacro

/// Stack of cards
@Init(defaults: ["cards": []])
public struct CardStack: Codable, Equatable {
    /// Content
    public var cards: [String]
}

public extension CardStack {
    /// number of cards in the stack
    var count: Int { cards.count }

    /// Looks at the card at the top of this stack without removing it from the stack.
    var top: String? { cards.first }
}
