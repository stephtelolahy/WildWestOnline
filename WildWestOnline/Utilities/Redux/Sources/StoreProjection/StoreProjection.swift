//
//  StoreProjection.swift
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
private class StoreProjection<LocalState: Equatable, GlobalState>: Store<LocalState> {
    private let globalStore: Store<GlobalState>
    private let deriveState: (GlobalState) -> LocalState?

    init(
        globalStore: Store<GlobalState>,
        deriveState: @escaping (GlobalState) -> LocalState?
    ) {
        guard let initialState = deriveState(globalStore.state) else {
            fatalError("failed mapping to local state")
        }

        self.globalStore = globalStore
        self.deriveState = deriveState
        super.init(initial: initialState)
        self.event = globalStore.event
        self.error = globalStore.error

        globalStore.$state
            .map(self.deriveState)
            .compactMap { $0 }
            .removeDuplicates()
            .assign(to: &self.$state)
    }

    override func dispatch(_ action: Action) {
        globalStore.dispatch(action)
    }
}

public extension Store {
    /// Creates a subset of the current store by applying any transformation to the State.
    func projection<LocalState: Equatable>(_ deriveState: @escaping (State) -> LocalState?) -> Store<LocalState> {
        StoreProjection(
            globalStore: self,
            deriveState: deriveState
        )
    }
}

/// A function to extract ViewState from global AppState
public typealias Presenter<GlobalState, LocalState: Equatable> = (GlobalState) -> LocalState?
