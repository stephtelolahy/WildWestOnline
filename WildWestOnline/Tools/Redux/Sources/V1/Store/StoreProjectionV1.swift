//
//  StoreProjectionV1.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 29/11/2023.
//

import Combine

/// An app should have a single real Store, holding a single source-of-truth.
/// However, we can "derive" this store to small subsets, called store projections,
/// that will handle a smaller part of the state,
/// as long as we can map back-and-forth to the original store types.
/// It won't store anything, only project the original store.
final class StoreProjectionV1<GlobalState: Equatable, LocalState: Equatable>: StoreV1<LocalState> {
    private let globalStore: StoreV1<GlobalState>
    private let stateMap: (GlobalState) -> LocalState?

    init(globalStore: StoreV1<GlobalState>, stateMap: @escaping (GlobalState) -> LocalState?) {
        guard let initialState = stateMap(globalStore.state) else {
            fatalError("failed mapping to local state")
        }

        self.globalStore = globalStore
        self.stateMap = stateMap
        super.init(initial: initialState)

        globalStore.$state
            .map(self.stateMap)
            .compactMap { $0 }
            .removeDuplicates()
            .assign(to: &self.$state)
    }

    override func dispatch(_ action: ActionV1) {
        globalStore.dispatch(action)
    }
}

public extension StoreV1 {
    /// Creates a subset of the current store by applying any transformation to the State.
    func projection<LocalState: Equatable>(stateMap: @escaping (State) -> LocalState?) -> StoreV1<LocalState> {
        StoreProjectionV1(globalStore: self, stateMap: stateMap)
    }
}
