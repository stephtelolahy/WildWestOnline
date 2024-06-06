//
//  Connector.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/06/2024.
//

public protocol Connector {
    associatedtype State: Equatable
    associatedtype Action: Equatable
    associatedtype ViewState: Equatable
    associatedtype ViewAction: Equatable

    func connect(state: State) -> ViewState?
    func connect(action: ViewAction) -> Action
}

public enum Connectors {}

public extension Store {
    func projection<C: Connector>(
        using connector: C
    ) -> Store<C.ViewState, C.ViewAction> where C.State == State, C.Action == Action {
        StoreProjection(
            globalStore: self,
            stateMap: connector.connect,
            actionMap: connector.connect
        )
    }
}
