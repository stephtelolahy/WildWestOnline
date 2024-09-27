/// All aspects of game state
/// Game is turn based, cards have actions, cards have properties and cards have rules
/// These state objects are passed around everywhere and maintained on both client and server seamlessly
public struct GameState: Codable, Equatable {
    public var players: [String: Player]
    public let cards: [String: Card]
    public var deck: [String]
    public var discard: [String]
    public var discovered: [String]
    public let startOrder: [String]
    public var playOrder: [String]
    public var turn: String?
    public var turnPlayedBang: Int
    public var queue: [GameAction]
    public var chooseOne: [String: ChooseOne]
    public var active: [String: [String]]
    public var winner: String?
    public var waitDelaySeconds: Double
    public var playMode: [String: PlayMode]
}

public enum PlayMode: Equatable, Codable {
    case manual
    case auto
}

public struct ChooseOne: Codable, Equatable {
    public let type: ChoiceType
    public let options: [String]
}

/// ChooseOne options
public extension String {
    static let hiddenHand = "hiddenHand"
    static let pass = "pass"
}

// MARK: - Convenience

public extension GameState {
    /// Getting player with given identifier
    func player(_ id: String) -> Player {
        players.get(id)
    }
}

// MARK: - Builder

public extension GameState {
    class Builder {
        private var players: [String: Player] = [:]
        private var hand: [String: [String]] = [:]
        private var inPlay: [String: [String]] = [:]
        private var playOrder: [String] = []
        private var turn: String?
        private var deck: [String] = []
        private var discard: [String] = []
        private var discovered: [String] = []
        private var winner: String?
        private var chooseOne: [String: ChooseOne] = [:]
        private var active: [String: [String]] = [:]
        private var queue: [GameAction] = []
        private var turnPlayedBang: Int = 0
        private var playMode: [String: PlayMode] = [:]
        private var cards: [String: Card] = [:]
        private var waitDelaySeconds: Double = 0

        public func build() -> GameState {
            .init(
                players: players,
                cards: cards,
                deck: deck,
                discard: discard,
                discovered: discovered,
                startOrder: playOrder,
                playOrder: playOrder,
                turn: turn,
                turnPlayedBang: turnPlayedBang,
                queue: queue,
                chooseOne: chooseOne,
                active: active,
                winner: winner,
                waitDelaySeconds: waitDelaySeconds,
                playMode: playMode
            )
        }

        public func withTurn(_ value: String) -> Self {
            turn = value
            return self
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

        public func withTurnPlayedBang(_ value: Int) -> Self {
            turnPlayedBang = value
            return self
        }

        public func withWinner(_ value: String) -> Self {
            winner = value
            return self
        }

        public func withCards(_ value: [String: Card]) -> Self {
            cards = value
            return self
        }

        public func withExtraCards(_ cards: [String: Card]) -> Self {
            self.cards.merge(cards) { _, new in new }
            return self
        }

        public func withChooseOne(_ type: ChoiceType, options: [String], player: String) -> Self {
            chooseOne = [player: ChooseOne(type: type, options: options)]
            return self
        }

        public func withActive(_ cards: [String], player: String) -> Self {
            active = [player: cards]
            return self
        }

        public func withSequence(_ value: [GameAction]) -> Self {
            queue = value
            return self
        }

        public func withPlayModes(_ value: [String: PlayMode]) -> Self {
            playMode = value
            return self
        }

        public func withPlayer(_ id: String, builderFunc: (Player.Builder) -> Player.Builder = { $0 }) -> Self {
            let builder = Player.makeBuilder()
            _ = builderFunc(builder)
            players[id] = builder.build()
            playOrder.append(id)
            return self
        }

        public func withWaitDelaySeconds(_ value: Double) -> Self {
            waitDelaySeconds = value
            return self
        }
    }

    static func makeBuilder() -> Builder {
        Builder()
    }
}
