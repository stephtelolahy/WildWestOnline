//
//  RoundReducer.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 15/09/2024.
//

import Redux

public extension RoundState {
    static let reducer: Reducer<Self> = { state, action in
        switch action {
        case GameAction.startTurn:
            try startTurnReducer(state, action)

        case GameAction.endTurn:
            try endTurnReducer(state, action)

        case GameAction.eliminate:
            try eliminateReducer(state, action)

        default:
            state
        }
    }
}

private extension RoundState {
    static let startTurnReducer: Reducer<Self> = { state, action in
        guard case let GameAction.startTurn(player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.turn = player
        return state
    }

    static let endTurnReducer: Reducer<Self> = { state, action in
        guard case let GameAction.endTurn(player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.turn = nil
        return state
    }

    static let eliminateReducer: Reducer<Self> = { state, action in
        guard case let GameAction.eliminate(player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.playOrder.removeAll { $0 == player }
        return state
    }
}
