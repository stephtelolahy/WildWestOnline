//
//  GameState.swift
//  Bang
//
//  Created by Hugues Telolahy on 27/10/2024.
//

/// All aspects of game state
/// These state objects are passed around everywhere
/// and maintained on both client and server seamlessly
public struct GameState {
    public var players: [String: Player]
    public var cards: [String: Card]
    public var deck: [String]
    public var discard: [String]
    public var discovered: [String]
    public var queue: [GameAction]
}

public struct Player: Equatable, Codable {
    public var health: Int
    public var maxHealth: Int
    public var hand: [String]
}

public extension GameState {
    class Builder {
        private var players: [String: Player] = [:]
        private var deck: [String] = []
        private var discard: [String] = []
        private var discovered: [String] = []
        private var cards: [String: Card] = [:]
        private var queue: [GameAction] = []

        public func build() -> GameState {
            .init(
                players: players,
                cards: cards,
                deck: deck,
                discard: discard,
                discovered: discovered,
                queue: queue
            )
        }

        public func withDeck(_ value: [String]) -> Self {
            deck = value
            return self
        }

        public func withDiscard(_ value: [String]) -> Self {
            discard = value
            return self
        }

        public func withDiscovered(_ value: [String]) -> Self {
            discovered = value
            return self
        }

        public func withPlayer(_ id: String, builderFunc: (Player.Builder) -> Player.Builder = { $0 }) -> Self {
            let builder = Player.makeBuilder()
            _ = builderFunc(builder)
            players[id] = builder.build()
            return self
        }

        public func withCards(_ value: [String: Card]) -> Self {
            cards = value
            return self
        }
    }

    static func makeBuilder() -> Builder {
        Builder()
    }
}

public extension Player {
    class Builder {
        private var health: Int = 0
        private var maxHealth: Int = 0
        private var hand: [String] = []

        public func build() -> Player {
            .init(
                health: health,
                maxHealth: maxHealth,
                hand: hand
            )
        }

        public func withHealth(_ value: Int) -> Self {
            health = value
            return self
        }

        public func withMaxHealth(_ value: Int) -> Self {
            maxHealth = value
            return self
        }

        public func withHand(_ value: [String]) -> Self {
            hand = value
            return self
        }
    }

    static func makeBuilder() -> Builder {
        Builder()
    }
}
