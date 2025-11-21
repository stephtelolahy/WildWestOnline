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
        public var discovered: [String]
        public var playable: [String: [String]]
        public var lastEvent: Action?
        public var lastError: Error?

        let cards: [String: Card]
        var queue: [Action]
        var auras: [String]
        var playedThisTurn: [String: Int]
        var isOver: Bool
        let playMode: [String: PlayMode]
        let actionDelayMilliSeconds: Int
        let showPlayableCards: Bool

        public struct Player: Equatable, Codable, Sendable {
            public let figure: [String]
            public var health: Int
            public var maxHealth: Int
            public var weapon: Int
            public var magnifying: Int
            public var remoteness: Int
            public var hand: [String]
            public var inPlay: [String]

            var handLimit: Int
            var cardsPerDraw: Int
            var playLimitsPerTurn: [String: Int]

            public var attr: [Key: Int]

            public subscript(key: Key) -> Int {
                get { attr[key] ?? 0 }
                set { attr[key] = newValue }
            }

            public struct Key: RawRepresentable, Hashable, Codable, Sendable {
                public let rawValue: String

                public init(rawValue: String) {
                    self.rawValue = rawValue
                }
            }
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
        var selection: String?
        var children: [Self]?
        var playableCards: [String]?
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
