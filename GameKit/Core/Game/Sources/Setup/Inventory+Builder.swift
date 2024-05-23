//
//  Inventory+Builder.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 08/05/2024.
//
// swiftlint:disable no_magic_numbers

public extension Inventory {
    class Builder {
        private var figures: [String] = []
        private var cardSets: [String: [String]] = [:]
        private var cards: [String: Card] = [:]

        public func build() -> Inventory {
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
