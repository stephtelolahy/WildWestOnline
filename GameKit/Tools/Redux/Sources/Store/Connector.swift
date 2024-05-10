//
//  Connector.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 10/05/2024.
//

public protocol Connector {
    associatedtype GlobalState: Equatable
    associatedtype LocalState: Equatable

    func connect(state: GlobalState) -> LocalState
}

public extension Store {
    func projection<C: Connector>(
        using connector: C
    ) -> Store<C.LocalState> where C.GlobalState == State {
        StoreProjection(globalStore: self, stateMap: connector.connect)
    }
}


public enum Connectors {}
