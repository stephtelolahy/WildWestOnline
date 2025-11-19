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
        dependencies: Void
    ) -> Effect<Action> {
        guard !state.isOver else {
            fatalError("Unexpected game is over")
        }

        if action == state.queue.first {
            state.queue.remove(at: 0)
        }

        if state.active.isNotEmpty {
            guard action.name == .preparePlay,
                  state.active.contains(where: { $0.key == action.sourcePlayer && $0.value.contains(action.playedCard) }) else {
                fatalError("Unexpected unwaited action \(action)")
            }

            state.active.removeValue(forKey: action.sourcePlayer)
        }

        do {
            if action.selectors.isNotEmpty {
                if state.pendingChoice != nil {
                    fatalError("Unexpected waiting user choice")
                }

                var pendingAction = action
                let selector = pendingAction.selectors.remove(at: 0)
                let children = try selector.resolve(pendingAction, state: state)
                state.queue.insert(contentsOf: children, at: 0)
            } else {
                state = try action.name.reduce(action, state: state)
            }

            if action.isResolved {
                state.lastEvent = action
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

private extension GameFeature.Action {
    var isResolved: Bool {
        guard selectors.isEmpty else {
            return false
        }

        switch name {
        case .queue,
                .addContextCardsPerTurn,
                .addContextAdditionalMissed,
                .preparePlay:
            return false

        default:
            return true
        }
    }
}
