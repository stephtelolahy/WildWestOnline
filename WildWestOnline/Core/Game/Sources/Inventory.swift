//
//  Inventory.swift
//
//  Created by Hugues Telolahy on 28/12/2024.
//

public struct Inventory: Codable, Equatable {
    public let cards: [String: Card]
    public let figures: [String]
    public let cardSets: [String: [String]]
    public let defaultAbilities: [String]

    public init(
        cards: [String: Card],
        figures: [String],
        cardSets: [String: [String]],
        defaultAbilities: [String]
    ) {
        self.cards = cards
        self.figures = figures
        self.cardSets = cardSets
        self.defaultAbilities = defaultAbilities
    }
}

public extension Inventory {
    class Builder {
        private var cards: [String: Card] = [:]
        private var figures: [String] = []
        private var cardSets: [String: [String]] = [:]
        private var defaultAbilities: [String] = []

        public func build() -> Inventory {
            .init(
                cards: cards,
                figures: figures,
                cardSets: cardSets,
                defaultAbilities: defaultAbilities
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
            let sampleCard = Card(
                name: "",
                onActive: [
                    .init(
                        action: .setMaxHealth,
                        selectors: [.setAmount(1)]
                    )
                ]
            )

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
