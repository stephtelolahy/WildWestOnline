//
//  Inventory.swift
//
//  Created by Hugues Telolahy on 28/12/2024.
//

public struct Inventory: Codable, Equatable, Sendable {
    public let cards: [Card]
    public let deck: [String: [String]]

    public init(
        cards: [Card],
        deck: [String: [String]]
    ) {
        self.cards = cards
        self.deck = deck
    }
}

public extension Inventory {
    var figures: [String] {
        cards.filter { $0.type == .character }.map(\.name)
    }

    var playerAbilities: [String] {
        cards.filter { $0.type == .ability }.map(\.name)
    }
}

public extension Array where Element == Card {
    var toDictionary: [String: Card] {
        reduce(into: [:]) { result, card in
            result[card.name] = card
        }
    }
}
