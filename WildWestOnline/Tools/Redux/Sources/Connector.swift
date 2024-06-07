//
//  Connector.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/06/2024.
//

public protocol Connector {
    associatedtype State
    associatedtype Action
    associatedtype ViewState: Equatable
    associatedtype ViewAction

    func deriveState(state: State) -> ViewState?
    func embedAction(action: ViewAction) -> Action
}

public enum Connectors {}

public extension Store {
    func projection<C: Connector>(
        using connector: C
    ) -> Store<C.ViewState, C.ViewAction> where C.State == State, C.Action == Action {
        StoreProjection(
            globalStore: self,
            deriveState: connector.deriveState,
            embedAction: connector.embedAction
        )
    }
}
