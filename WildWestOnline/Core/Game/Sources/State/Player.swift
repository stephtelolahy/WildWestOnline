//
//  Player.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 26/09/2024.
//
import Foundation

public struct Player: Equatable, Codable {
    public var health: Int
    public var attributes: [PlayerAttribute: Int]
    public let abilities: Set<String>
    public let figure: String
    public var hand: [String]
    public var inPlay: [String]
}

public extension Player {
    class Builder {
        private var id: String = UUID().uuidString
        private var figure: String = ""
        private var abilities: Set<String> = []
        private var attributes: [PlayerAttribute: Int] = [:]
        private var health: Int = 0
        private var hand: [String] = []
        private var inPlay: [String] = []

        public func build() -> Player {
            .init(
                health: health,
                attributes: attributes,
                abilities: abilities,
                figure: figure,
                hand: hand,
                inPlay: inPlay
            )
        }

        public func buildHand() -> [String] {
            hand
        }

        public func buildInPlay() -> [String] {
            inPlay
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

        public func withAttributes(_ value: [PlayerAttribute: Int]) -> Self {
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
