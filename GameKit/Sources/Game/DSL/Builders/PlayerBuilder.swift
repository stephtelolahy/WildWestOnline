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
        private var attributes: [String: Int] = [:]
        private var health: Int = 0
        private var hand: CardLocation = .init(cards: [])
        private var inPlay: CardLocation = .init(cards: [])

        public func build() -> Player {
            Player(
                id: id,
                name: name,
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

        public func withName(_ value: String) -> Self {
            name = value
            return self
        }

        public func withHealth(_ value: Int) -> Self {
            health = value
            return self
        }

        public func withAttributes(_ value: [String: Int]) -> Self {
            attributes = value
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
