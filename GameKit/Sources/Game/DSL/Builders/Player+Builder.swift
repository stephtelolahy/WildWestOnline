//
//  Player+Builder.swift
//
//
//  Created by Hugues Telolahy on 22/10/2023.
//

import Foundation

public extension Player {
    class Builder {
        private var id: String?
        private var name: String?
        private var attributes: Attributes?
        private var startAttributes: Attributes?
        private var abilities: [String]?
        private var health: Int?
        private var hand: CardLocation?
        private var inPlay: CardLocation?

        public func build() -> Player {
            let id = id ?? UUID().uuidString
            let name = name ?? .init()
            let abilities = abilities ?? .init()
            let attributes = attributes ?? .init()
            let startAttributes = startAttributes ?? attributes
            let hand = hand ?? .init()
            let inPlay = inPlay ?? .init()
            let health = health ?? 0

            return Player(id: id,
                          name: name,
                          startAttributes: startAttributes,
                          attributes: attributes,
                          abilities: abilities,
                          health: health,
                          hand: hand,
                          inPlay: inPlay)
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
