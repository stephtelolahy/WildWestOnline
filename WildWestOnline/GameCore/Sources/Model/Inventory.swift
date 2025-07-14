//
//  Inventory.swift
//
//  Created by Hugues Telolahy on 28/12/2024.
//

public struct Inventory: Codable, Equatable, Sendable {
    public let cards: [String: Card]
    public let deck: [String: [String]]

    public init(
        cards: [String: Card],
        deck: [String: [String]]
    ) {
        self.cards = cards
        self.deck = deck
    }
}

public extension Inventory {
    var figures: [String] {
        cards.filter { $0.value.type == .character }.map(\.key)
    }

    var playerAbilities: [String] {
        cards.filter { $0.value.type == .ability }.map(\.key)
    }
}
