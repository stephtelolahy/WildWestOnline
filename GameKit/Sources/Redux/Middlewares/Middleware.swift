//
//  Middleware.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 27/11/2023.
//
import Combine

/// ``Middleware`` is a plugin, or a composition of several plugins, 
/// that are assigned to the app global  state pipeline in order to
/// Handle each action received action, to execute side-effects in response, and eventually dispatch more actions
open class Middleware<State> {
    public init() {}

    func handle(action: Action, state: State) -> AnyPublisher<Action, Never>? {
        nil
    }
}
