//
//  Inventory.swift
//
//  Created by Hugues Telolahy on 28/12/2024.
//
import GameFeature

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
