//
//  Player+Builder.swift
//
//
//  Created by Hugues Telolahy on 22/10/2023.
//

import Foundation

public extension Player {
    class Builder {
        private var id: String = UUID().uuidString
        private var figure: String = ""
        private var abilities: Set<String> = []
        private var attributes: [String: Int] = [:]
        private var health: Int = 0
        private var hand: [String] = []
        private var inPlay: [String] = []

        public func build() -> Player {
            Player(
                id: id,
                figure: figure,
                abilities: abilities,
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

        public func withFigure(_ value: String) -> Self {
            figure = value
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

        public func withAbilities(_ value: [String]) -> Self {
            abilities = Set(value)
            return self
        }

        public func withHand(_ value: [String]) -> Self {
            hand = value
            return self
        }

        public func withInPlay(_ value: [String]) -> Self {
            inPlay = value
            return self
        }
    }

    static func makeBuilder() -> Builder {
        Builder()
    }
}
