//
//  Inventory+Builder.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//
import GameFeature

public extension Inventory {
    class Builder {
        private var cards: [Card] = []
        private var deck: [String: [String]] = [:]

        public func build() -> Inventory {
            .init(
                cards: cards,
                deck: deck
            )
        }

        public func withCards(_ value: [Card]) -> Self {
            cards = value
            return self
        }

        public func withSample() -> Self {
            deck = [:]
            cards = (1...100).map {
                Card(
                    name: "c\($0)",
                    type: .character,
                    effects: [
                        .init(
                            trigger: .permanent,
                            action: .setMaxHealth,
                            amount: 1
                        )
                    ]
                )
            }
            return self
        }
    }

    static func makeBuilder() -> Builder {
        Builder()
    }
}
