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
        private var playCounter: [String: Int] = [:]
        private var deck: CardStack?
        private var discard: CardStack?
        private var arena: CardLocation?
        private var isOver: GameOver?
        private var event: GameAction?
        private var error: GameError?
        private var failed: GameAction?
        private var chooseOne: ChooseOne?
        private var active: ActiveCards?
        private var queue: [GameAction]?
        private var cardRef: [String: Card]?

        public func build() -> GameState {
            let deck = deck ?? .init()
            let discard = discard ?? .init()
            let queue = queue ?? []
            let cardRef = cardRef ?? [:]

            return GameState(
                players: players,
                playOrder: playOrder,
                startOrder: playOrder,
                turn: turn,
                playCounter: playCounter,
                deck: deck,
                discard: discard,
                arena: arena,
                isOver: isOver,
                event: event,
                error: error,
                failed: failed,
                chooseOne: chooseOne,
                active: active,
                queue: queue,
                cardRef: cardRef
            )
        }

        public func withTurn(_ value: String) -> Self {
            turn = value
            return self
        }

        public func withDeck(_ value: String...) -> Self {
            deck = CardStack(cards: value)
            return self
        }

        public func withDiscard(_ value: String...) -> Self {
            discard = CardStack(cards: value)
            return self
        }

        public func withArena(_ value: String...) -> Self {
            arena = CardLocation(cards: value)
            return self
        }

        public func withPlayCounter(_ key: String, value: Int) -> Self {
            playCounter[key] = value
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

        public func withQueue(_ value: GameAction...) -> Self {
            queue = value
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
