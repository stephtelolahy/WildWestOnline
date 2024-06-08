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

public extension StoreV1 {
    func projection<C: ConnectorV1>(
        using connector: C
    ) -> StoreV1<C.LocalState> where C.GlobalState == State {
        StoreProjectionV1(globalStore: self, stateMap: connector.connect)
    }
}

public extension StoreV1 {
    func projection<C: Connector>(
        using connector: C
    ) -> Store<C.ViewState, C.ViewAction> where C.State == State, C.Action: ActionV1 {
        guard let viewState = connector.deriveState(state: self.state) else {
            fatalError("failed mapping to local state")
        }

        let viewStore = Store<C.ViewState, C.ViewAction>(initial: viewState) { [weak self] state, action in
            self?.dispatch(connector.embedAction(action: action))
            return state
        }

        $state
            .map(connector.deriveState)
            .compactMap { $0 }
            .removeDuplicates()
            .assign(to: &viewStore.$state)

        return viewStore
    }
}
