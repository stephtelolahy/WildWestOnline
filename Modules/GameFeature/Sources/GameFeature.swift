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
        public var lastError: GameFeature.Error?
        public var turn: String?
        public var playedThisTurn: [String: Int]
        public var cardsToDrawThisTurn: Int
        public var active: [String: [String]]
        public var isOver: Bool
        public var playMode: [String: PlayMode]
        public var actionDelayMilliSeconds: Int

        public struct Player: Equatable, Codable, Sendable {
            public var figure: String
            public var abilities: [String]
            public var health: Int
            public var maxHealth: Int
            public var hand: [String]
            public var inPlay: [String]
            public var weapon: Int
            public var magnifying: Int
            public var remoteness: Int
            public var handLimit: Int
            public var playLimitsPerTurn: [String: Int]
            public var cardsPerDraw: Int
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
