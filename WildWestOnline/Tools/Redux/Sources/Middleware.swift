//
//  Middleware.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/06/2024.
//

/// ``Middleware`` is a plugin, or a composition of several plugins,
/// that are assigned to the app global state pipeline in order to
/// Handle each received action, to execute side-effects in response, and eventually dispatch more actions
open class Middleware<State, Action> {
    public init() {}

    open func handle(_ action: Action, state: State) async -> Action? {
        nil
    }
}