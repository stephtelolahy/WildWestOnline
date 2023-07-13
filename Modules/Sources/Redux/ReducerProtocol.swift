//
//  ReducerProtocol.swift
//  
//
//  Created by Hugues Telolahy on 13/04/2023.
//

/// A protocol that describes how to evolve the current state of an application to the next state,given an action
public protocol ReducerProtocol<State, Action> {

    /// A type that holds the current state of the reducer.
    associatedtype State

    /// A type that holds all possible actions that cause the ``State`` of the reducer to change
    associatedtype Action

    /// Evolves the current state of the reducer to the next state.
    func reduce(state: State, action: Action) -> State
}

/// A protocol that describes how to evolve the current state of an application to the next state,given an action
public protocol ThrowableReducerProtocol<State, Action> {

    /// A type that holds the current state of the reducer.
    associatedtype State

    /// A type that holds all possible actions that cause the ``State`` of the reducer to change
    associatedtype Action

    /// Evolves the current state of the reducer to the next state.
    func reduce(state: State, action: Action) throws -> State
}
