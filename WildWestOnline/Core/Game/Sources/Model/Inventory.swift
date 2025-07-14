//
//  Inventory.swift
//
//  Created by Hugues Telolahy on 28/12/2024.
//

public struct Inventory: Codable, Equatable, Sendable {
    public let cards: [String: Card]
    public let figures: [String]
    public let deck: [String: [String]]
    public let playerAbilities: [String]

    public init(
        cards: [String: Card],
        figures: [String],
        deck: [String: [String]],
        playerAbilities: [String]
    ) {
        self.cards = cards
        self.figures = figures
        self.deck = deck
        self.playerAbilities = playerAbilities
    }
}
