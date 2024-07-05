import Foundation

/// All aspects of game state
/// Game is turn based, cards have actions, cards have properties and cards have rules
/// These state objects are passed around everywhere and maintained on both client and server seamlessly
public struct GameState: Codable, Equatable {
    /// Players
    public var players: PlayersState

    /// Card locations
    public var field: FieldState

    /// Round
    public var round: RoundState

    /// Current turn's number of times a card was played
    public var playedThisTurn: [String: Int]

    /// Game over
    public var winner: String?

    /// Occurred error
    public var error: GameError?

    /// Last occurred renderable event
    public var event: GameAction?

    /// Pending action by player
    public var chooseOne: [String: ChooseOne]

    /// Playable cards by player
    public var active: [String: [String]]

    /// Play mode by player
    public var playMode: [String: PlayMode]

    /// Queued effects
    public var sequence: [GameAction]

    /// All cards reference by cardName
    public let cards: [String: Card]

    /// Wait delay between two visible actions
    public var waitDelayMilliseconds: Int
}

// MARK: - Convenience

public extension GameState {
    /// Getting player with given identifier
    func player(_ id: String) -> Player {
        players.get(id)
    }
}
