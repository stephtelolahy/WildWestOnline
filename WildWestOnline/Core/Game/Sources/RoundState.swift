//
//  RoundState.swift
//  
//
//  Created by Hugues Telolahy on 05/07/2024.
//
import Redux

public struct RoundState: Codable, Equatable {
    /// Initial order
    public let startOrder: [String]

    /// Playing order
    public var playOrder: [String]

    /// Current turn's player
    public var turn: String?

    /// Game over
    public var winner: String?
}

public extension RoundState {
    static let reducer: ThrowingReducer<Self> = { state, action in
        switch action {
        case GameAction.startTurn:
            try startTurnReducer(state, action)

        case GameAction.endTurn:
            try endTurnReducer(state, action)

        case GameAction.eliminate:
            try eliminateReducer(state, action)

        case GameAction.setGameOver:
            try setGameOverReducer(state, action)

        default:
            state
        }
    }
}

private extension RoundState {
    static let startTurnReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.startTurn(player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.turn = player
        return state
    }

    static let endTurnReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.endTurn(player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.turn = nil
        return state
    }

    static let eliminateReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.eliminate(player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.playOrder.removeAll { $0 == player }
        return state
    }

    static let setGameOverReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.setGameOver(winner) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.winner = winner
        return state
    }
}
