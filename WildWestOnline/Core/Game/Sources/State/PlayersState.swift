//
//  PlayersState.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 24/06/2024.
//
import Foundation

public typealias PlayersState = [String: Player]

public struct Player: Equatable, Codable {
    /// Life points
    public var health: Int

    /// Current attributes
    public var attributes: [String: Int]

    /// Inner abilities
    public let abilities: Set<String>

    /// Figure name. Determining initial attributes
    public let figure: String
}

public extension PlayersState {
    enum Error: Swift.Error, Equatable {
        /// Expected player to be damaged
        case playerAlreadyMaxHealth(String)
    }
}

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
            .init(
                health: health,
                attributes: attributes,
                abilities: abilities,
                figure: figure
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
