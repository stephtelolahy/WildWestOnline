//
//  GameFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 28/03/2025.
//
import Redux
public enum GameFeature {
    public struct State: Equatable, Sendable {
        public var players: [String: Player]
        public var playOrder: [String]
        public let startOrder: [String]
        public var turn: String?
        public var deck: [String]
        public var discard: [String]
        public var discovered: [String]
        public var playable: PlayableCards?
        public var lastEvent: Action?
        public var lastError: Error?

        let cards: [String: Card]
        var auras: [String]
        var queue: [Action]
        var events: [Action]
        var isOver: Bool
        let playMode: [String: PlayMode]
        let actionDelayMilliSeconds: Int
        let showPlayableCards: Bool

        public struct Player: Equatable, Sendable {
            public let figure: [String]
            public var health: Int
            public let maxHealth: Int
            public var weapon: Int
            public var magnifying: Int
            public var remoteness: Int
            public var hand: [String]
            public var inPlay: [String]
        }

        public enum PlayMode: Equatable, Sendable {
            case manual
            case auto
        }

        public struct PlayableCards: Equatable, Sendable {
            public var player: String
            public var cards: [String]
        }
    }

    public struct Action: Equatable, Sendable {
        public var actionID: Card.ActionID = .init(rawValue: "undefined")
        @available(*, deprecated, message: "Use actionID instead")
        public var name: Card.ActionName?
        public var sourcePlayer: String = ""
        public var playedCard: String = ""
        var triggeredBy: [Self] = []
        public var targetedPlayer: String?
        public var targetedCard: String?
        var amount: Int?
        var requiredMisses: Int?
        var selection: String?
        var alias: String?
        var playableCards: [String]?
        @available(*, deprecated, message: "Use actionID instead")
        var modifier: Card.ModifierName?
        var children: [Self]?
        var selectors: [Card.Selector] = []

        public static func == (lhs: Self, rhs: Self) -> Bool {
            NonStandardLogic.areActionsEqual(lhs, rhs)
        }
    }

    public enum Error: Swift.Error, Equatable {
        case insufficientDeck
        case insufficientDiscard
        case playerAlreadyMaxHealth(String)
        case cardNotPlayable(String)
        case cardAlreadyInPlay(String, player: String)
        case noReq(Card.Selector.PlayRequirement)
        case noTarget(Card.Selector.PlayerGroup)
        case noChoosableTarget([Card.Selector.PlayerFilter])
        case noChoosableCard([Card.Selector.CardFilter], player: String)
    }

    public static var reducer: Reducer<State, Action> {
        combine(
            reducerMain,
            reducerLoop
        )
    }
}
