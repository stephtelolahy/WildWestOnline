//
//  GameState+Builder.swift
//
//
//  Created by Hugues Telolahy on 22/10/2023.
//

public extension GameState {
    class Builder {
        private var players: [String: Player] = [:]
        private var playOrder: [String] = []
        private var turn: String?
        private var playedThisTurn: [String: Int] = [:]
        private var deck: CardStack = .init(cards: [])
        private var discard: CardStack = .init(cards: [])
        private var arena: CardLocation?
        private var isOver: GameOver?
        private var error: GameError?
        private var chooseOne: ChooseOne?
        private var active: ActiveCards?
        private var sequence: [GameAction] = []
        private var cardRef: [String: Card] = [:]

        public func build() -> GameState {
            GameState(
                players: players,
                playOrder: playOrder,
                startOrder: playOrder,
                turn: turn,
                playedThisTurn: playedThisTurn,
                deck: deck,
                discard: discard,
                arena: arena,
                isOver: isOver,
                error: error,
                chooseOne: chooseOne,
                active: active,
                sequence: sequence,
                cardRef: cardRef
            )
        }

        public func withTurn(_ value: String) -> Self {
            turn = value
            return self
        }

        public func withDeck(_ value: [String]) -> Self {
            deck = CardStack(cards: value)
            return self
        }

        public func withDiscard(_ value: [String]) -> Self {
            discard = CardStack(cards: value)
            return self
        }

        public func withArena(_ value: [String]) -> Self {
            arena = CardLocation(cards: value)
            return self
        }

        public func withPlayedThisTurn(_ value: [String: Int]) -> Self {
            playedThisTurn = value
            return self
        }

        public func withWinner(_ value: String) -> Self {
            isOver = GameOver(winner: value)
            return self
        }

        public func withCardRef(_ value: [String: Card]) -> Self {
            cardRef = value
            return self
        }

        public func withChooseOne(_ chooser: String, options: [String: GameAction]) -> Self {
            chooseOne = ChooseOne(chooser: chooser, options: options)
            return self
        }

        public func withSequence(_ value: [GameAction]) -> Self {
            sequence = value
            return self
        }

        public func withPlayer(_ id: String, builderFunc: (Player.Builder) -> Player.Builder = { $0 }) -> Self {
            let builder = Player.makeBuilder().withId(id)
            let player = builderFunc(builder).build()
            players[player.id] = player
            playOrder.append(player.id)
            return self
        }
    }

    static func makeBuilder() -> Builder {
        Builder()
    }
}