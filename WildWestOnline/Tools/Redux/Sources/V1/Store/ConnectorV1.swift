//
//  ConnectorV1.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 10/05/2024.
//

public protocol ConnectorV1 {
    associatedtype GlobalState: Equatable
    associatedtype LocalState: Equatable

    func connect(state: GlobalState) -> LocalState?
}

public enum Connectors {}

public extension StoreV1 {
    func projection<C: ConnectorV1>(
        using connector: C
    ) -> StoreV1<C.LocalState> where C.GlobalState == State {
        StoreProjectionV1(globalStore: self, stateMap: connector.connect)
    }
}
