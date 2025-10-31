//
//  Reducer+Combine.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2025.
//

/// Combine reducers —
/// multiple reducers for the same State and Action
public func combine<State, Action, Dependencies>(
    _ reducers: Reducer<State, Action, Dependencies>...
) -> Reducer<State, Action, Dependencies> {
    { state, action, dependencies in
        let effects = reducers.map { $0(&state, action, dependencies) }
        return .group(effects)
    }
}
