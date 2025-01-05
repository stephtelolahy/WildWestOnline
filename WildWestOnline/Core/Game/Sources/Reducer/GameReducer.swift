//
//  GameReducer.swift
//
//  Created by Hugues Telolahy on 27/10/2024.
//
import Redux

public func gameReducer(
    state: inout GameState,
    action: Action,
    dependencies: Void
) throws -> Effect {
    guard let action = action as? GameAction else {
        return .none
    }

    try prepareReducer(state: &state, action: action)
    try updateReducer(state: &state, action: action)
    return .group([
        try triggerEffectsReducer(state: &state, action: action),
        try playAIMoveReducer(state: &state, action: action)
    ])
}

private func prepareReducer(
    state: inout GameState,
    action: GameAction
) throws {
    guard !state.isOver else {
        fatalError("Unexpected game is over")
    }

    if action == state.queue.first {
        state.queue.remove(at: 0)
    }

    if state.active.isNotEmpty {
        guard action.kind == .play,
              let card = action.payload.card,
              state.active.contains(where: { $0.key == action.payload.target && $0.value.contains(card) }) else {
            fatalError("Unexpected unwaited action \(action)")
        }

        state.active.removeValue(forKey: action.payload.target)
    }
}

private func updateReducer(
    state: inout GameState,
    action: GameAction
) throws {
    if action.payload.selectors.isNotEmpty {
        if state.pendingChoice != nil {
            fatalError("Unexpected waiting user choice")
        }

        var pendingAction = action
        let selector = pendingAction.payload.selectors.remove(at: 0)
        let children = try selector.resolve(pendingAction, state)

        state.queue.insert(contentsOf: children, at: 0)
    } else {
        state = try action.kind.reduce(state, action.payload)
    }
}

private func triggerEffectsReducer(
    state: inout GameState,
    action: GameAction
) throws -> Effect {
    // TODO: triggered effects
    .none
}

private func playAIMoveReducer(
    state: inout GameState,
    action: GameAction
) throws -> Effect {
    // TODO: AI moves
    .none
}
