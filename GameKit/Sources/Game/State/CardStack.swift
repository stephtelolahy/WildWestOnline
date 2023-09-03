//
//  CardStack.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

/// Stack of cards
public struct CardStack: Codable, Equatable {

    /// Content
    var cards: [String] = []
    
    /// number of cards in the stack
    public var count: Int { cards.count }
    
    /// Looks at the card at the top of this stack without removing it from the stack.
    public var top: String? { cards.first }
}
