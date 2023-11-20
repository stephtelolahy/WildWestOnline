//
//  CardLocation.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

/// Card zone
public struct CardLocation: Codable, Equatable {
    /// Content
    public var cards: [String]

    /// Cards are hidden for other players except the owner
    public let hidden: Bool

    public init(cards: [String] = [], hidden: Bool = false) {
        self.cards = cards
        self.hidden = hidden
    }
}

public extension CardLocation {
    /// Number of cards in the location
    var count: Int { cards.count }
}
