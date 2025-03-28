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
        public var queue: [Card.Effect]
        public var error: Card.Failure?
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

    public typealias Action = Card.Effect
}
