//
//  Middleware.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 27/11/2023.
//
import Combine

/// ``Middleware`` is a plugin, or a composition of several plugins, that are assigned to the app global  state pipeline in order to
/// handle each action received action, to execute side-effects in response, and eventually dispatch more actions
public typealias Middleware<State> = (State, Action) -> AnyPublisher<Action, Never>?
//public protocol Middleware {
//    associatedtype State
//    
//    func handle(action: Action, state: State) -> AnyPublisher<Action, Never>?
//}
