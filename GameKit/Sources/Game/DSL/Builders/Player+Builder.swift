//
//  Player+Builder.swift
//
//
//  Created by Hugues Telolahy on 22/10/2023.
//

import Foundation

public extension Player {
    class Builder {
        var id: String?
        var attributes: Attributes = .init()
        var abilities: [String] = .init()
        var health: Int?
        var hand: CardLocation?
        var inPlay: CardLocation?

        public func build() -> Player {
            let id = id ?? UUID().uuidString
            let hand = hand ?? .init()
            let inPlay = inPlay ?? .init()
            let health = health ?? 0

            return Player(id: id,
                          name: id,
                          startAttributes: attributes,
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

        public func withAttribute(_ key: AttributeKey, value: Int) -> Self {
            attributes[key] = value
            return self
        }

        public func withAbility(_ value: String) -> Self {
            abilities.append(value)
            return self
        }

        public func withHand(_ value: String...) -> Self {
            hand = CardLocation(cards: value)
            return self
        }

        public func withInPlay(_ value: String...) -> Self {
            inPlay = CardLocation(cards: value)
            return self
        }
    }

    static func makeBuilder() -> Builder {
        Builder()
    }
}
