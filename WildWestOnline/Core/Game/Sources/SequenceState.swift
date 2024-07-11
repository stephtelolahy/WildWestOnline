//
//  SequenceState.swift
//  
//
//  Created by Hugues Telolahy on 06/07/2024.
//

import Redux

public struct SequenceState: Codable, Equatable {
    /// Queued effects
    public var queue: [GameAction]

    /// Pending action by player
    public var chooseOne: [String: ChooseOne]

    /// Playable cards by player
    public var active: [String: [String]]
}

public extension SequenceState {
    static let reducer: ThrowingReducer<Self> = { state, action in
        switch action {
        case GameAction.activate:
            try activateReducer(state, action)

        case GameAction.chooseOne:
            try chooseOneReducer(state, action)

        default:
            state
        }
    }
}

private extension SequenceState {
    static let activateReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.activate(cards, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.active[player] = cards
        return state
    }

    static let chooseOneReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.chooseOne(type, options, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.chooseOne[player] = ChooseOne(
            type: type,
            options: options
        )
        return state
    }
}
