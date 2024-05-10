//
//  Inventory.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//

public struct Inventory: Codable, Equatable {
    public let cards: [String: Card]
    public let figures: [String]
    public let cardSets: [String: [String]]

    public init(
        cards: [String: Card],
        figures: [String],
        cardSets: [String: [String]]
    ) {
        self.cards = cards
        self.figures = figures
        self.cardSets = cardSets
    }
}
