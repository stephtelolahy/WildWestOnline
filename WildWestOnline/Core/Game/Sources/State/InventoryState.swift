//
//  InventoryState.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 20/07/2024.
//

public struct InventoryState: Codable, Equatable {
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

public extension InventoryState {
    class Builder {
        private var figures: [String] = []
        private var cardSets: [String: [String]] = [:]
        private var cards: [String: Card] = [:]

        public func build() -> InventoryState {
            .init(
                cards: cards,
                figures: figures,
                cardSets: cardSets
            )
        }

        public func withFigures(_ value: [String]) -> Self {
            figures = value
            return self
        }

        public func withCards(_ value: [String: Card]) -> Self {
            cards = value
            return self
        }

        public func  withSample() -> Self {
            figures = (1...16).map { "c\($0)" }
            cardSets = [:]
            let sampleCard = Card.makeBuilder(name: "").withAttributes([.maxHealth: 4]).build()
            cards = Dictionary(
                uniqueKeysWithValues: (1...100).map { "c\($0)" }.map { ($0, sampleCard) }
            )
            return self
         }
    }

    static func makeBuilder() -> Builder {
        Builder()
    }
}
