//
//  MiddlewareV1.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 27/11/2023.
//

/// ``Middleware`` is a plugin, or a composition of several plugins, 
/// that are assigned to the app global  state pipeline in order to
/// Handle each action received action, to execute side-effects in response, and eventually dispatch more actions
open class MiddlewareV1<State> {
    public init() {}

    open func effect(on action: ActionV1, state: State) async -> ActionV1? {
        nil
    }
}