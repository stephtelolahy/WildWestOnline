//
//  GameReducer.swift
//
//  Created by Hugues Telolahy on 27/10/2024.
//
import Redux

public func gameReducer(
    state: inout GameState,
    action: ActionProtocol,
    dependencies: Void
) throws -> Effect {
    guard let action = action as? GameAction else {
        return .none
    }

    guard !state.isOver else {
        fatalError("Unexpected game is over")
    }

    if action == state.queue.first {
        state.queue.remove(at: 0)
    }

    if state.active.isNotEmpty {
        guard action.name == .preparePlay,
              state.active.contains(where: { $0.key == action.payload.player && $0.value.contains(action.payload.played) }) else {
            fatalError("Unexpected unwaited action \(action)")
        }

        state.active.removeValue(forKey: action.payload.player)
    }

    if action.selectors.isNotEmpty {
        if state.pendingChoice != nil {
            fatalError("Unexpected waiting user choice")
        }

        var pendingAction = action
        let selector = pendingAction.selectors.remove(at: 0)
        let children = try selector.resolve(pendingAction, state)

        state.queue.insert(contentsOf: children, at: 0)
    } else {
        state = try action.name.reduce(state, action.payload)
    }

    return .none
}
