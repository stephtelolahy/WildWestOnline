//
//  GameFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 28/03/2025.
//
import Redux

public enum GameFeature {
    /// All aspects of game state
    /// These state objects are passed around everywhere
    /// and maintained on both client and server seamlessly
    public struct State: Equatable, Codable, Sendable {
        public var players: [String: Player]
        public var cards: [String: Card]
        public var deck: [String]
        public var discard: [String]
        public var discovered: [String]
        public var playOrder: [String]
        public var startOrder: [String]
        public var queue: [Action]
        public var lastSuccessfulAction: Action?
        public var lastActionError: Card.PlayError?
        public var playedThisTurn: [String: Int]
        public var turn: String?
        public var active: [String: [String]]
        public var isOver: Bool
        public var playMode: [String: PlayMode]
        public var actionDelayMilliSeconds: Int

        public struct Player: Equatable, Codable, Sendable {
            public var figure: String
            public var health: Int
            public var maxHealth: Int
            public var hand: [String]
            public var inPlay: [String]
            public var magnifying: Int
            public var remoteness: Int
            public var weapon: Int
            public var abilities: [String]
            public var handLimit: Int
            public var playLimitPerTurn: [String: Int]
            public var drawCards: Int
        }

        public enum PlayMode: Equatable, Codable, Sendable {
            case manual
            case auto
        }
    }

    public struct Action: Equatable, Codable, Sendable {
        public let name: Card.EffectName

        public let sourcePlayer: String
        public let playedCard: String
        public let triggeredBy: [Self]

        public var targetedPlayer: String?
        public var targetedCard: String?
        public var amount: Int?
        public var chosenOption: String?
        public var nestedEffects: [Self]?
        public var affectedCards: [String]?
        public var amountPerTurn: [String: Int]?

        public var selectors: [Card.Selector]

        public init(
            name: Card.EffectName,
            sourcePlayer: String = "",
            playedCard: String = "",
            triggeredBy: [Self] = [],
            targetedPlayer: String? = nil,
            targetedCard: String? = nil,
            amount: Int? = nil,
            chosenOption: String? = nil,
            nestedEffects: [Self]? = nil,
            affectedCards: [String]? = nil,
            amountPerTurn: [String: Int]? = nil,
            selectors: [Card.Selector] = []
        ) {
            self.name = name
            self.selectors = selectors
            self.sourcePlayer = sourcePlayer
            self.playedCard = playedCard
            self.triggeredBy = triggeredBy
            self.targetedPlayer = targetedPlayer
            self.targetedCard = targetedCard
            self.amount = amount
            self.chosenOption = chosenOption
            self.nestedEffects = nestedEffects
            self.affectedCards = affectedCards
            self.amountPerTurn = amountPerTurn
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            NonStandardLogic.areActionsEqual(lhs, rhs)
        }
    }

    public static var reducer: Reducer<State, Action, Void> {
        combine(
            reducerMechanics,
            reducerLoop,
            reducerAI
        )
    }
}

public extension GameFeature.State {
    var pendingChoice: Card.Selector.ChoicePrompt? {
        guard let nextAction = queue.first,
              let selector = nextAction.selectors.first,
              case let .chooseOne(_, prompt, selection) = selector,
              selection == nil else {
            return nil
        }

        return prompt
    }
}
