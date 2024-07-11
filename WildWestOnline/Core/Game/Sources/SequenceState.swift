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

    /// Current turn's number of times a card was played
    public var played: [String: Int]

    /// Game over
    public var winner: String?
}

public extension SequenceState {
    static let reducer: ThrowingReducer<Self> = { state, action in
        switch action {
        case GameAction.activate:
            try activateReducer(state, action)

        case GameAction.chooseOne:
            try chooseOneReducer(state, action)

        case GameAction.setGameOver:
            try setGameOverReducer(state, action)

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

    static let setGameOverReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.setGameOver(winner) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.winner = winner
        return state
    }
}
