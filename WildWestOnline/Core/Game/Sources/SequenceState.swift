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

    /// Play counter by card
    public var played: [String: Int]
}

public extension SequenceState {
    static let reducer: ThrowingReducer<Self> = { state, action in
        switch action {
        case GameAction.activate:
            try activateReducer(state, action)

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
}
