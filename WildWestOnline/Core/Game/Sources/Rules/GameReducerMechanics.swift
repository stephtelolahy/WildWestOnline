//
//  GameReducerMechanics.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 28/03/2025.
//
import Redux

extension GameFeature {
    static func reduceMechanics(
        into state: inout State,
        action: ActionProtocol,
        dependencies: Void
    ) -> Effect {
        guard let action = action as? Action else {
            return .none
        }

        state.lastSuccessfulAction = nil
        state.lastActionError = nil

        do {
            try updateState(&state, action: action)
            state.lastSuccessfulAction = action
        } catch {
            state.lastActionError = error
        }

        return .none
    }

    private static func updateState(_ state: inout GameFeature.State, action: GameFeature.Action) throws(Card.Failure) {
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
    }
}
