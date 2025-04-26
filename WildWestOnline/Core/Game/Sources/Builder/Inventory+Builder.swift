//
//  Inventory+Builder.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//

public extension Inventory {
    class Builder {
        private var cards: [String: Card] = [:]
        private var figures: [String] = []
        private var cardSets: [String: [String]] = [:]
        private var playerAbilities: [String] = []

        public func build() -> Inventory {
            .init(
                cards: cards,
                figures: figures,
                cardSets: cardSets,
                playerAbilities: playerAbilities
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
                        name: .setMaxHealth,
                        payload: .init(amount: 1)
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
