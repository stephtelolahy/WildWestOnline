import Foundation
import Utils

/// All aspects of game state
/// Game is turn based, cards have actions, cards have properties and cards have rules
/// These state objects are passed around everywhere and maintained on both client and server seamlessly
public struct GameState: Codable, Equatable, DocumentConvertible {
    /// All players
    public var players: [String: Player]

    /// Playing order
    public var playOrder: [String]

    /// Initial order
    public let startOrder: [String]

    /// Current turn's player
    public var turn: String?

    /// Current turn's number of times a card was played
    public var playedThisTurn: [String: Int]

    /// Deck
    public var deck: [String]

    /// Discard pile
    public var discard: [String]

    /// Cards shop
    public var arena: [String]

    /// Game over
    public var winner: String?

    /// Occurred error
    public var error: GameError?

    /// Last occurred renderable event
    public var event: GameAction?

    /// Occurred renderable event history
    public var events: [GameAction]

    /// Pending action by player
    public var chooseOne: [String: ChooseOne]

    /// Playable cards by player
    public var active: [String: [String]]

    /// Play mode by player
    public var playMode: [String: PlayMode]

    /// Queued effects
    public var sequence: [GameAction]

    /// All cards reference by cardName
    public let cardRef: [String: Card]

    /// Wait delay between two visible actions
    public var waitDelayMilliseconds: Int
}

// MARK: - Convenience

public extension GameState {
    /// Getting player with given identifier
    func player(_ id: String) -> Player {
        guard let player = players[id] else {
            fatalError("player not found \(id)")
        }
        return player
    }
}
