//
//  Connector.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/06/2024.
//

public protocol Connector {
    associatedtype GlobalState: Equatable
    associatedtype GlobalAction: Equatable
    associatedtype LocalState: Equatable
    associatedtype LocalAction: Equatable

    func connect(state: GlobalState) -> LocalState?
    func connect(action: LocalAction) -> GlobalAction
}

public enum Connectors {}

public extension Store {
    func projection<C: Connector>(
        using connector: C
    ) -> Store<C.LocalState, C.LocalAction> where C.GlobalState == State, C.GlobalAction == Action {
        StoreProjection(
            globalStore: self,
            stateMap: connector.connect,
            actionMap: connector.connect
        )
    }
}
