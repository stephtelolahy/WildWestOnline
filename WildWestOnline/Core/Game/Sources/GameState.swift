import Foundation
import Redux

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

    /// Play sequence
    public var sequence: SequenceState

    /// All cards reference by cardName
    public let cards: CardsState

    /// Configuration
    public let config: ConfigState
}

// MARK: - Convenience

public extension GameState {
    /// Getting player with given identifier
    func player(_ id: String) -> Player {
        players.get(id)
    }
}

// MARK: - Reducer

public extension GameState {
    static let reducer: ThrowingReducer<Self> = { state, action in
            .init(
                players: try PlayersState.reducer(state.players, action),
                field: try FieldState.reducer(state.field, action),
                round: try RoundState.reducer(state.round, action),
                sequence: try SequenceState.reducer(state.sequence, action),
                cards: state.cards,
                config: state.config
            )
    }
}
