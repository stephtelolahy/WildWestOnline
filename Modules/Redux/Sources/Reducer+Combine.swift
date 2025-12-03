//
//  Reducer+Combine.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2025.
//

/// Combine reducers —
/// multiple reducers for the same State and Action
public func combine<State, Action>(
    _ reducers: Reducer<State, Action>...
) -> Reducer<State, Action> {
    { state, action, dependencies in
        let effects = reducers.map { $0(&state, action, dependencies) }
        return .group(effects)
    }
}
