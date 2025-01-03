//
//  GameState.swift
//
//  Created by Hugues Telolahy on 27/10/2024.
//

/// All aspects of game state
/// These state objects are passed around everywhere
/// and maintained on both client and server seamlessly
public struct GameState: Equatable, Codable, Sendable {
    public var players: [String: Player]
    public var cards: [String: Card]
    public var deck: [String]
    public var discard: [String]
    public var discovered: [String]
    public var playOrder: [String]
    public var startOrder: [String]
    public var queue: [GameAction]
    public var playedThisTurn: [String: Int]
    public var turn: String?
    public var active: [String: [String]]
    public var isOver: Bool
    public var playMode: [String: PlayMode]
    public var actionDelayMilliSeconds: Int

    public enum PlayMode: Equatable, Codable, Sendable {
        case manual
        case auto
    }
}

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

public extension GameState {
    var pendingChoice: Card.Selector.ChooseOneResolved? {
        guard let nextAction = queue.first,
              let selector = nextAction.payload.selectors.first,
              case let .chooseOne(_, resolved, selection) = selector,
              let choice = resolved,
              selection == nil else {
            return nil
        }

        return choice
    }
}
