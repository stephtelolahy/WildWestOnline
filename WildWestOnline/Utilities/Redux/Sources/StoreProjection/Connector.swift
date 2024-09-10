//
//  Connector.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 11/09/2024.
//

public protocol Connector {
    associatedtype State
    associatedtype Action
    associatedtype ViewState: Equatable
    associatedtype ViewAction

    func deriveState(_ state: State) -> ViewState?
    func embedAction(_ action: ViewAction, _ state: State) -> Action
}

public extension Store {
    func projection<C: Connector>(
        using connector: C
    ) -> Store<C.ViewState, C.ViewAction> where C.State == State, C.Action == Action {
        projection(
            connector.deriveState,
            connector.embedAction
        )
    }
}
