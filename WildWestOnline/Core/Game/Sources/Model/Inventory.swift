//
//  Inventory.swift
//
//  Created by Hugues Telolahy on 28/12/2024.
//

public struct Inventory: Codable, Equatable, Sendable {
    public let cards: [String: Card]
    public let figures: [String]
    public let cardSets: [String: [String]]
    public let playerAbilities: [String]

    public init(
        cards: [String: Card],
        figures: [String],
        cardSets: [String: [String]],
        playerAbilities: [String]
    ) {
        self.cards = cards
        self.figures = figures
        self.cardSets = cardSets
        self.playerAbilities = playerAbilities
    }
}
