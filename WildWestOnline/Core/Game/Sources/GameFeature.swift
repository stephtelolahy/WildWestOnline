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

    public static func reduce(
        into state: inout State,
        action: ActionProtocol,
        dependencies: Void
    ) throws -> Effect {
        guard let action = action as? Action else {
            return .none
        }

        guard !state.isOver else {
            fatalError("Unexpected game is over")
        }

        if action == state.queue.first {
            state.queue.remove(at: 0)
        }

        if state.active.isNotEmpty {
            guard action.name == .preparePlay,
                  state.active.contains(where: { $0.key == action.payload.player && $0.value.contains(action.payload.played) }) else {
                fatalError("Unexpected unwaited action \(action)")
            }

            state.active.removeValue(forKey: action.payload.player)
        }

        if action.selectors.isNotEmpty {
            if state.pendingChoice != nil {
                fatalError("Unexpected waiting user choice")
            }

            var pendingAction = action
            let selector = pendingAction.selectors.remove(at: 0)
            let children = try selector.resolve(pendingAction, state)

            state.queue.insert(contentsOf: children, at: 0)
        } else {
            state = try action.name.reduce(state, action.payload)
        }

        return .none
    }
}
