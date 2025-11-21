//
//  GameFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 28/03/2025.
//
import Redux

public enum GameFeature {
    /// All aspects of game state
    public struct State: Equatable, Codable, Sendable {
        public var players: [String: Player]
        public var playOrder: [String]
        public let startOrder: [String]
        public var turn: String?
        public var deck: [String]
        public var discard: [String]

        let cards: [String: Card]
        var discovered: [String]
        var queue: [Action]
        public var playable: [String: [String]]
        public var lastEvent: Action?
        var lastError: Error?
        var auras: [String]
        var playedThisTurn: [String: Int]
        var isOver: Bool
        public let playMode: [String: PlayMode]
        let actionDelayMilliSeconds: Int
        let showPlayableCards: Bool

        public struct Player: Equatable, Codable, Sendable {
            public let figure: String
            public var health: Int
            public var weapon: Int
            public var magnifying: Int
            public var remoteness: Int
            public var hand: [String]
            public var inPlay: [String]

            var abilities: [String]
            var maxHealth: Int
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
        public var targetedPlayer: String?
        public var targetedCard: String?
        public var amount: Int?

        var triggeredBy: [Self] = []
        var chosenOption: String?
        var nestedEffects: [Self]?
        var affectedCards: [String]?
        var amountPerTurn: [String: Int]?
        var contextCardsPerTurn: Int = 0
        var contextAdditionalMissed: Int = 0
        var selectors: [Card.Selector] = []

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
