//
//  File.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 12/10/2025.
//

/// Combine reducers — multiple reducers for the same State and Action
public func combine<State, Action, Dependencies>(
    _ reducers: Reducer<State, Action, Dependencies>...
) -> Reducer<State, Action, Dependencies> {
    { state, action, dependencies in
        let effects = reducers.map { $0(&state, action, dependencies) }
        return .group(effects)
    }
}

/// Pull back reducers — make a small reducer that operates on part of the state/action,
/// and lift it into a global one.
public func pullback<
    LocalState,
    LocalAction,
    GlobalState,
    GlobalAction,
    Dependencies
>(
    _ localReducer: @escaping Reducer<LocalState, LocalAction, Dependencies>,
    state toLocalState: WritableKeyPath<GlobalState, LocalState>,
    action toLocalAction: @escaping (GlobalAction) -> LocalAction?,
    embedAction: @escaping (LocalAction) -> GlobalAction
) -> Reducer<GlobalState, GlobalAction, Dependencies> {
    return { globalState, globalAction, dependencies in
        // Only handle actions that map to the local domain
        guard let localAction = toLocalAction(globalAction) else {
            return .none
        }

        // Run the local reducer on the local portion of state
        let localEffect = localReducer(&globalState[keyPath: toLocalState], localAction, dependencies)

        // Lift the effect’s actions back into the global space
        return localEffect.map(embedAction)
    }
}

private extension Effect {
    func map<NewAction>(_ transform: @escaping (Action) -> NewAction) -> Effect<NewAction> {
        switch self {
        case .none:
            return .none
        case .publisher(let publisher):
            return .publisher(publisher.map(transform).eraseToAnyPublisher())
        case .run(let asyncWork):
            return .run {
                if let result = await asyncWork() {
                    return transform(result)
                }
                return nil
            }
        case .group(let effects):
            return .group(effects.map { $0.map(transform) })
        }
    }
}
