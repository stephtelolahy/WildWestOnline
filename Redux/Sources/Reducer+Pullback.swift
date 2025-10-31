//
//  Reducer+Pullback.swift
//
//  Created by Hugues Stéphano TELOLAHY on 12/10/2025.
//

/// Pull back reducers —
/// lift a small reducer that operates on part of the state/action into a global one.
public func pullback<
    LocalState,
    LocalAction,
    GlobalState,
    GlobalAction,
    LocalDependencies,
    GlobalDependencies
>(
    _ localReducer: @escaping Reducer<LocalState, LocalAction, LocalDependencies>,
    state toLocalState: @escaping (inout GlobalState) -> WritableKeyPath<GlobalState, LocalState>?,
    action toLocalAction: @escaping (GlobalAction) -> LocalAction?,
    embedAction: @escaping (LocalAction) -> GlobalAction,
    dependencies toLocalDependencies: @escaping (GlobalDependencies) -> LocalDependencies
) -> Reducer<GlobalState, GlobalAction, GlobalDependencies> {
    return { globalState, globalAction, globalDependencies in
        // Only handle actions that map to the local domain
        guard let localAction = toLocalAction(globalAction) else {
            return .none
        }

        // Try to obtain the optional key path into local state
        guard let localKeyPath = toLocalState(&globalState) else {
            return .none
        }

        // Run the local reducer directly on that portion of state
        let localDeps = toLocalDependencies(globalDependencies)
        let localEffect = localReducer(&globalState[keyPath: localKeyPath], localAction, localDeps)

        // Map local effect’s actions back into global ones
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
