//
//  GameReducer.swift
//  Bang
//
//  Created by Hugues Telolahy on 27/10/2024.
//

public struct GameReducer {
    public init() {}

    public func reduce(_ state: GameState, _ action: Action) throws -> GameState {
        guard let action = action as? GameAction else {
            return state
        }

        var state = state

        if action == state.queue.first {
            state.queue.remove(at: 0)
        }

        if action.payload.selectors.isNotEmpty {
            var action = action
            let selector = action.payload.selectors.remove(at: 0)

            if state.pendingChoice != nil {
                fatalError("Unexpected, waiting user choice")
            }

            let children = try selector.resolve(action, state)
            state.queue.insert(contentsOf: children, at: 0)
            return state
        } else {
            return try  action.kind.reduce(state, action.payload)
        }
    }
}
