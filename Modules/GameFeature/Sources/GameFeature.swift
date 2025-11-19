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
        public let cards: [String: Card]
        public var deck: [String]
        public var discard: [String]
        public var discovered: [String]
        public var playOrder: [String]
        public let startOrder: [String]
        public var queue: [Action]
        public var turn: String?
        public var active: [String: [String]]
        public var lastEvent: Action?
        public var lastError: Error?

        // Modifiers
        var playedThisTurn: [String: Int]
        var isOver: Bool

        // Configuration
        public let playMode: [String: PlayMode]
        public let actionDelayMilliSeconds: Int
        let showPlayableCards: Bool

        public struct Player: Equatable, Codable, Sendable {
            public let figure: String
            public var health: Int
            public var hand: [String]
            public var inPlay: [String]

            // Modifiers
            var abilities: [String]
            var maxHealth: Int
            var weapon: Int
            var magnifying: Int
            var remoteness: Int
            var handLimit: Int
            var cardsPerDraw: Int
            var playLimitsPerTurn: [String: Int]
        }

        public enum PlayMode: Equatable, Codable, Sendable {
            case manual
            case auto
        }
    }

    public struct Action: Equatable, Codable, Sendable {
        public let name: Card.ActionName
        public var sourcePlayer: String = ""
        public var playedCard: String = ""
        public var triggeredBy: [Self] = []
        public var targetedPlayer: String?
        public var targetedCard: String?
        public var amount: Int?
        public var chosenOption: String?
        public var nestedEffects: [Self]?
        public var affectedCards: [String]?
        public var amountPerTurn: [String: Int]?
        public var contextCardsPerTurn: Int = 0
        public var contextAdditionalMissed: Int = 0
        public var selectors: [Card.Selector] = []

        public static func == (lhs: Self, rhs: Self) -> Bool {
            NonStandardLogic.areActionsEqual(lhs, rhs)
        }
    }

    public enum Error: Swift.Error, Equatable, Codable {
        case insufficientDeck
        case insufficientDiscard
        case playerAlreadyMaxHealth(String)
        case cardNotPlayable(String)
        case cardAlreadyInPlay(String)
        case noReq(Card.Selector.PlayRequirement)
        case noTarget(Card.Selector.PlayerGroup)
        case noChoosableTarget([Card.Selector.PlayerFilter])
        case noChoosableCard([Card.Selector.CardFilter])
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
