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
    private let embedAction: (LocalAction, GlobalState) -> GlobalAction

    init(
        globalStore: Store<GlobalState, GlobalAction>,
        deriveState: @escaping (GlobalState) -> LocalState?,
        embedAction: @escaping (LocalAction, GlobalState) -> GlobalAction
    ) {
        guard let initialState = deriveState(globalStore.state) else {
            fatalError("failed mapping to local state")
        }

        self.globalStore = globalStore
        self.deriveState = deriveState
        self.embedAction = embedAction
        super.init(initial: initialState)

        globalStore.$state
            .map(self.deriveState)
            .compactMap { $0 }
            .removeDuplicates()
            .assign(to: &self.$state)

//        globalStore.event
//            .assign(to: &self.event)
    }

    override func dispatch(_ action: LocalAction) {
        let globalAction = embedAction(action, globalStore.state)
        globalStore.dispatch(globalAction)
    }
}

public extension Store {
    /// Creates a subset of the current store by applying any transformation to the State.
    func projection<LocalState: Equatable, LocalAction>(
        _ deriveState: @escaping (State) -> LocalState?,
        _ embedAction: @escaping (LocalAction, State) -> Action
    ) -> Store<LocalState, LocalAction> {
        StoreProjection(
            globalStore: self,
            deriveState: deriveState,
            embedAction: embedAction
        )
    }
}
