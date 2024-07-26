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
}

public extension RoundState {
    static let reducer: Reducer<Self, GameAction> = { state, action in
        switch action {
        case .startTurn:
            try startTurnReducer(state, action)

        case .endTurn:
            try endTurnReducer(state, action)

        case .eliminate:
            try eliminateReducer(state, action)

        default:
            state
        }
    }
}

private extension RoundState {
    static let startTurnReducer: Reducer<Self, GameAction> = { state, action in
        guard case let .startTurn(player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.turn = player
        return state
    }

    static let endTurnReducer: Reducer<Self, GameAction> = { state, action in
        guard case let .endTurn(player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.turn = nil
        return state
    }

    static let eliminateReducer: Reducer<Self, GameAction> = { state, action in
        guard case let .eliminate(player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.playOrder.removeAll { $0 == player }
        return state
    }
}
