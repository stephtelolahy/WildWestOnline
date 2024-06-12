//
//  Connector.swift
//  
//
//  Created by Hugues Telolahy on 09/06/2024.
//

/// Stateless converter between View state and App state.
/// Defines two functions.
/// The first one transforms the whole app state into the view state,
/// and the second one converts view actions into app actions.
///
public protocol Connector {
    associatedtype State
    associatedtype Action
    associatedtype ViewState: Equatable
    associatedtype ViewAction

    func deriveState(_ state: State) -> ViewState?
    func embedAction(_ action: ViewAction) -> Action
}

public enum Connectors {}

public extension Store {
    func projection<C: Connector>(
        using connector: C
    ) -> Store<C.ViewState, C.ViewAction> where C.State == State, C.Action == Action {
        projection(
            deriveState: connector.deriveState,
            embedAction: connector.embedAction
        )
    }
}
