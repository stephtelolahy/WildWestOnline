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
private class StoreProjection<
    LocalState: Equatable,
    LocalAction,
    GlobalState,
    GlobalAction
>: Store<LocalState, LocalAction> {
    private let globalStore: Store<GlobalState, GlobalAction>
    private let deriveState: (GlobalState) -> LocalState?
    private let embedAction: (LocalAction) -> GlobalAction

    init(
        globalStore: Store<GlobalState, GlobalAction>,
        deriveState: @escaping (GlobalState) -> LocalState?,
        embedAction: @escaping (LocalAction) -> GlobalAction
    ) {
        guard let initialState = deriveState(globalStore.state) else {
            fatalError("failed mapping to local state")
        }

        self.globalStore = globalStore
        self.deriveState = deriveState
        self.embedAction = embedAction
        super.init(initial: initialState)
        self.event = globalStore.event
        self.error = globalStore.error

        globalStore.$state
            .map(self.deriveState)
            .compactMap { $0 }
            .removeDuplicates()
            .assign(to: &self.$state)
    }

    override func dispatch(_ action: LocalAction) {
        globalStore.dispatch(embedAction(action))
    }
}

public extension Store {
    /// Creates a subset of the current store by applying any transformation to the State.
    func projection<LocalState: Equatable, LocalAction>(
        _ deriveState: @escaping (State) -> LocalState?,
        _ embedAction: @escaping (LocalAction) -> Action
    ) -> Store<LocalState, LocalAction> {
        StoreProjection(
            globalStore: self,
            deriveState: deriveState,
            embedAction: embedAction
        )
    }
}
