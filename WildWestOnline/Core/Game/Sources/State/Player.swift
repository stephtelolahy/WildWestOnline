//
//  Player.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 26/09/2024.
//
public struct Player: Equatable, Codable {
    public let figure: String
    public var abilities: [String]
    public var hand: [String]
    public var inPlay: [String]
    public var health: Int
    public var maxHealth: Int
    public var weapon: Int
    public var handLimit: Int
    public var magnifying: Int
    public var remoteness: Int
    public var flippedCards: Int
}

public extension Player {
    class Builder {
        private var figure: String = ""
        private var abilities: [String] = []
        private var hand: [String] = []
        private var inPlay: [String] = []
        private var health: Int = 0
        private var maxHealth: Int = 0
        private var weapon: Int = 0
        private var handLimit: Int = 0
        private var magnifying: Int = 0
        private var remoteness: Int = 0
        private var flippedCards: Int = 0

        public func build() -> Player {
            .init(
                figure: figure,
                abilities: abilities,
                hand: hand,
                inPlay: inPlay,
                health: health,
                maxHealth: maxHealth,
                weapon: weapon,
                handLimit: handLimit,
                magnifying: magnifying,
                remoteness: remoteness,
                flippedCards: flippedCards
            )
        }

        public func withFigure(_ value: String) -> Self {
            figure = value
            return self
        }

        public func withHealth(_ value: Int) -> Self {
            health = value
            return self
        }

        public func withMaxHealth(_ value: Int) -> Self {
            maxHealth = value
            return self
        }

        public func withAbilities(_ value: [String]) -> Self {
            abilities = value
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

        public func withWeapon(_ value: Int) -> Self {
            weapon = value
            return self
        }

        public func withHandLimit(_ value: Int) -> Self {
            handLimit = value
            return self
        }

        public func withRemoteness(_ value: Int) -> Self {
            remoteness = value
            return self
        }

        public func withMagnifying(_ value: Int) -> Self {
            magnifying = value
            return self
        }
    }

    static func makeBuilder() -> Builder {
        Builder()
    }
}
