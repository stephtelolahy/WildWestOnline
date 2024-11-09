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
    public var playOrder: [String]
    public var queue: [GameAction]
    public var playedThisTurn: [String: Int]
}

public struct Player: Equatable, Codable {
    public var health: Int
    public var maxHealth: Int
    public var hand: [String]
    public var inPlay: [String]
    public var magnifying: Int
    public var remoteness: Int
    public var weapon: Int
}

public extension GameState {
    var pendingChoice: ActionSelector.ChooseOneResolved? {
        guard let nextAction = queue.first,
              let selector = nextAction.payload.selectors.first,
              case let .chooseOne(_, resolved, selection) = selector,
              let choice = resolved,
              selection == nil else {
            return nil
        }

        return choice
    }
}

public extension GameState {
    class Builder {
        private var players: [String: Player] = [:]
        private var cards: [String: Card] = [:]
        private var deck: [String] = []
        private var discard: [String] = []
        private var discovered: [String] = []
        private var playOrder: [String] = []
        private var queue: [GameAction] = []
        private var playedThisTurn: [String: Int] = [:]

        public func build() -> GameState {
            .init(
                players: players,
                cards: cards,
                deck: deck,
                discard: discard,
                discovered: discovered,
                playOrder: playOrder,
                queue: queue,
                playedThisTurn: playedThisTurn
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
            playOrder.append(id)
            return self
        }

        public func withCards(_ value: [String: Card]) -> Self {
            cards = value
            return self
        }

        public func withPlayedThisTurn(_ value: [String: Int]) -> Self {
            playedThisTurn = value
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
        private var inPlay: [String] = []
        private var magnifying: Int = 0
        private var remoteness: Int = 0
        private var weapon: Int = 0

        public func build() -> Player {
            .init(
                health: health,
                maxHealth: maxHealth,
                hand: hand,
                inPlay: inPlay,
                magnifying: magnifying,
                remoteness: remoteness,
                weapon: weapon
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

        public func withMagnifying(_ value: Int) -> Self {
            magnifying = value
            return self
        }

        public func withRemoteness(_ value: Int) -> Self {
            remoteness = value
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
    }

    static func makeBuilder() -> Builder {
        Builder()
    }
}
