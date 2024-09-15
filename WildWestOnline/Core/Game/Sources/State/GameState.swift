/// All aspects of game state
/// Game is turn based, cards have actions, cards have properties and cards have rules
/// These state objects are passed around everywhere and maintained on both client and server seamlessly
public struct GameState: Codable, Equatable {
    /// Players
    public var players: PlayersState

    /// Card locations
    public var field: FieldState

    /// Round
    public var round: RoundState

    /// Play sequence
    public var sequence: SequenceState

    /// All cards reference by cardName
    public let cards: [String: Card]

    /// Wait delay between two visible actions
    public var waitDelayMilliseconds: Int

    /// Play mode by player
    public var playMode: [String: PlayMode]
}

public enum PlayMode: Equatable, Codable {
    /// Player is controller by user
    case manual

    /// Player is controlled by AI agent
    case auto
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
        private var playedThisTurn: [String: Int] = [:]
        private var deck: [String] = []
        private var discard: [String] = []
        private var arena: [String] = []
        private var winner: String?
        private var chooseOne: [String: ChooseOne] = [:]
        private var active: [String: [String]] = [:]
        private var queue: [GameAction] = []
        private var playMode: [String: PlayMode] = [:]
        private var cards: [String: Card] = [:]
        private var waitDelayMilliseconds: Int = 0

        public func build() -> GameState {
            .init(
                players: players,
                field: .init(
                    deck: deck,
                    discard: discard,
                    arena: arena,
                    hand: hand,
                    inPlay: inPlay
                ),
                round: .init(
                    startOrder: playOrder,
                    playOrder: playOrder,
                    turn: turn
                ),
                sequence: .init(
                    queue: queue,
                    chooseOne: chooseOne,
                    active: active,
                    played: playedThisTurn,
                    winner: winner
                ),
                cards: cards,
                waitDelayMilliseconds: waitDelayMilliseconds,
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

        public func withArena(_ value: [String]) -> Self {
            arena = value
            return self
        }

        public func withPlayedThisTurn(_ value: [String: Int]) -> Self {
            playedThisTurn = value
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
            let builder = Player.makeBuilder().withId(id)
            _ = builderFunc(builder)
            players[id] = builder.build()
            hand[id] = builder.buildHand()
            inPlay[id] = builder.buildInPlay()
            playOrder.append(id)
            return self
        }

        public func withWaitDelayMilliseconds(_ value: Int) -> Self {
            waitDelayMilliseconds = value
            return self
        }
    }

    static func makeBuilder() -> Builder {
        Builder()
    }
}
