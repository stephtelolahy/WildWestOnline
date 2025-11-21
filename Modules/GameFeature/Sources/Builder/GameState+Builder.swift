//
//  GameState+Builder.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//

public extension GameFeature.State {
    class Builder {
        private var players: [String: Player] = [:]
        private var cards: [String: Card] = [:]
        private var deck: [String] = []
        private var discard: [String] = []
        private var discovered: [String] = []
        private var playOrder: [String] = []
        private var startOrder: [String] = []
        private var queue: [GameFeature.Action] = []
        private var turn: String?
        private var playedThisTurn: [String: Int] = [:]
        private var playable: [String: [String]] = [:]
        private var isOver: Bool = false
        private var playMode: [String: PlayMode] = [:]
        private var actionDelayMilliSeconds: Int = 0
        private var showPlayableCards: Bool = false
        private var auras: [String] = []

        public func build() -> GameFeature.State {
            .init(
                players: players,
                playOrder: playOrder,
                startOrder: startOrder,
                turn: turn,
                deck: deck,
                discard: discard,
                playable: playable,
                cards: cards,
                discovered: discovered,
                queue: queue,
                auras: auras,
                playedThisTurn: playedThisTurn,
                isOver: isOver,
                playMode: playMode,
                actionDelayMilliSeconds: actionDelayMilliSeconds,
                showPlayableCards: showPlayableCards
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
            startOrder.append(id)
            return self
        }

        public func withCards(_ value: [String: Card]) -> Self {
            for (key, val) in value {
                cards[key] = val
            }
            return self
        }

        public func withPlayedThisTurn(_ value: [String: Int]) -> Self {
            playedThisTurn = value
            return self
        }

        public func withTurn(_ value: String) -> Self {
            turn = value
            return self
        }

        public func withQueue(_ value: [GameFeature.Action]) -> Self {
            queue = value
            return self
        }

        public func withPlayMode(_ value: [String: PlayMode]) -> Self {
            playMode = value
            return self
        }

        public func withActionDelayMilliSeconds(_ value: Int) -> Self {
            actionDelayMilliSeconds = value
            return self
        }

        public func withShowPlayableCards(_ value: Bool) -> Self {
            showPlayableCards = value
            return self
        }

        public func withPlayable(_ value: [String: [String]]) -> Self {
            playable = value
            return self
        }

        public func withPendingAction(name: Card.ActionName, prompt: Card.Selector.ChoicePrompt) -> Self {
            let nextAction = GameFeature.Action(
                name: name,
                selectors: [.chooseOne(.targetCard(), prompt: prompt, selection: nil)]
            )
            queue.insert(nextAction, at: 0)
          return self
        }

        public func withAuras(_ value: [String]) -> Self {
            auras = value
            return self
        }
    }

    static func makeBuilder() -> Builder {
        Builder()
    }
}

public extension GameFeature.State.Player {
    class Builder {
        private var figure: [String] = []
        private var health: Int = 0
        private var maxHealth: Int = 0
        private var hand: [String] = []
        private var inPlay: [String] = []
        private var magnifying: Int = 0
        private var remoteness: Int = 0
        private var weapon: Int = 0
        private var handLimit: Int = 0
        private var playLimitsPerTurn: [String: Int] = [:]
        private var cardsPerDraw: Int = 0

        public func build() -> GameFeature.State.Player {
            .init(
                figure: figure,
                health: health,
                maxHealth: maxHealth,
                weapon: weapon,
                magnifying: magnifying,
                remoteness: remoteness,
                hand: hand,
                inPlay: inPlay,
                handLimit: handLimit,
                cardsPerDraw: cardsPerDraw,
                playLimitsPerTurn: playLimitsPerTurn
            )
        }

        public func withFigure(_ value: [String]) -> Self {
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

        public func withHandLimit(_ value: Int) -> Self {
            handLimit = value
            return self
        }

        public func withPlayLimitsPerTurn(_ value: [String: Int]) -> Self {
            playLimitsPerTurn = value
            return self
        }

        public func withCardsPerDraw(_ value: Int) -> Self {
            cardsPerDraw = value
            return self
        }
    }

    static func makeBuilder() -> Builder {
        Builder()
    }
}
