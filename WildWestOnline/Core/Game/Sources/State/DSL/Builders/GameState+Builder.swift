//
//  GameState+Builder.swift
//
//
//  Created by Hugues Telolahy on 22/10/2023.
//

public extension GameState {
    class Builder {
        private var playersDictionary: [String: PlayersState.Player] = [:]
        private var players: [String: Player] = [:]
        private var playOrder: [String] = []
        private var turn: String?
        private var playedThisTurn: [String: Int] = [:]
        private var deck: [String] = []
        private var discard: [String] = []
        private var arena: [String] = []
        private var winner: String?
        private var error: GameError?
        private var chooseOne: [String: ChooseOne] = [:]
        private var active: [String: [String]] = [:]
        private var sequence: [GameAction] = []
        private var playMode: [String: PlayMode] = [:]
        private var cards: [String: Card] = [:]
        private var waitDelayMilliseconds: Int = 0

        public func build() -> GameState {
            .init(
                playersState: .init(players: playersDictionary),
                players: players,
                playOrder: playOrder,
                startOrder: playOrder,
                turn: turn,
                playedThisTurn: playedThisTurn,
                deck: deck,
                discard: discard,
                arena: arena,
                winner: winner,
                error: error,
                chooseOne: chooseOne,
                active: active,
                playMode: playMode,
                sequence: sequence,
                cards: cards,
                waitDelayMilliseconds: waitDelayMilliseconds
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
            sequence = value
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
            playersDictionary[id] = builder.buildState()
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
