import Foundation

/// All aspects of game state
/// Game is turn based, cards have actions, cards have properties and cards have rules
/// These state objects are passed around everywhere and maintained on both client and server seamlessly
public struct GameState: Codable, Equatable {

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
    public var deck: CardStack

    /// Discard pile
    public var discard: CardStack

    /// Cards shop
    public var arena: CardLocation?

    /// Is Game over
    public var isOver: GameOver?

    /// Occurred event
    public var event: GameAction?

    /// Occurred error
    public var error: GameError?

    /// Pending action
    public var chooseOne: ChooseOne?

    /// Active cards
    public var active: ActiveCards?

    /// Queued effects
    public var sequence: [GameAction]

    /// All cards reference by cardName
    public let cardRef: [String: Card]
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
