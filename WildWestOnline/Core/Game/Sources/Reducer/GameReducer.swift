//
//  GameReducer.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 15/09/2024.
//

import Redux

public extension GameState {
    static let reducer: Reducer<Self> = { state, action in
        var state = state
        state.players = try PlayersState.reducer(state.players, action)
        state.field = try FieldState.reducer(state.field, action)
        state.round = try RoundState.reducer(state.round, action)
        state.sequence = try SequenceState.reducer(state, action).sequence
        return state
    }
}
