//
//  Inventory+Builder.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//

public extension Inventory {
    class Builder {
        private var cards: [String: Card] = [:]
        private var deck: [String: [String]] = [:]

        public func build() -> Inventory {
            .init(
                cards: cards,
                deck: deck
            )
        }

        public func withCards(_ value: [String: Card]) -> Self {
            cards = value
            return self
        }

        public func  withSample() -> Self {
            deck = [:]
            let sampleCard = Card(
                name: "",
                type: .character,
                behaviour: [
                    .permanent: [
                        .init(
                            name: .setMaxHealth,
                            amount: 1
                        )
                    ]
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
