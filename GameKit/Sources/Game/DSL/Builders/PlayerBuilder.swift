//
//  PlayerBuilder.swift
//
//
//  Created by Hugues Telolahy on 22/10/2023.
//

import Foundation

public extension Player {
    class Builder {
        private var id: String = UUID().uuidString
        private var name: String = ""
        private var abilities: [String] = []
        private var attributes: Attributes = [:]
        private var startAttributes: Attributes = [:]
        private var health: Int = 0
        private var hand: CardLocation = .init(cards: [])
        private var inPlay: CardLocation = .init(cards: [])

        public func build() -> Player {
            Player(
                id: id,
                name: name,
                abilities: abilities,
                startAttributes: startAttributes,
                attributes: attributes,
                health: health,
                hand: hand,
                inPlay: inPlay
            )
        }

        public func withId(_ value: String) -> Self {
            id = value
            return self
        }

        public func withHealth(_ value: Int) -> Self {
            health = value
            return self
        }

        public func withStartAttributes(_ value: Attributes) -> Self {
            startAttributes = value
            return self
        }

        public func withAttributes(_ value: Attributes) -> Self {
            attributes = value
            return self
        }

        public func withAbilities(_ value: [String]) -> Self {
            abilities = value
            return self
        }

        public func withHand(_ value: [String]) -> Self {
            hand = CardLocation(cards: value)
            return self
        }

        public func withInPlay(_ value: [String]) -> Self {
            inPlay = CardLocation(cards: value)
            return self
        }
    }

    static func makeBuilder() -> Builder {
        Builder()
    }
}