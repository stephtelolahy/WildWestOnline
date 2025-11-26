//
//  GameReducerMechanics.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 28/03/2025.
//
import Redux

extension GameFeature {
    static func reducerMechanics(
        into state: inout State,
        action: Action,
        dependencies: QueueModifierClient
    ) -> Effect<Action> {
        guard !state.isOver else {
            fatalError("Unexpected game is over")
        }

        if action == state.queue.first {
            state.queue.remove(at: 0)
        }

        if state.playable.isNotEmpty {
            guard action.name == .preparePlay,
                  state.playable.contains(where: { $0.key == action.sourcePlayer && $0.value.contains(action.playedCard) }) else {
                fatalError("Not playable card \(action.playedCard)")
            }

            state.playable.removeValue(forKey: action.sourcePlayer)
        }

        do {
            if action.selectors.isNotEmpty {
                if let choice = state.pendingChoice {
                    fatalError("Waiting user choice \(choice)")
                }

                var pendingAction = action
                let selector = pendingAction.selectors.remove(at: 0)
                let children = try selector.resolve(pendingAction, state: state)
                state.queue.insert(contentsOf: children, at: 0)
            } else {
                state = try action.name.reduce(action, state: state, dependencies: dependencies)
            }

            if action.isResolved {
                state.lastEvent = action
                state.events.insert(action, at: 0)
            } else {
                state.lastEvent = nil
            }
            state.lastError = nil
        } catch {
            state.lastError = error
            state.lastEvent = nil
        }

        return .none
    }
}
