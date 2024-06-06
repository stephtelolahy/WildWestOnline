//
//  StoreProjection.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/06/2024.
//

import Combine

/// An app should have a single real `Store`, holding a single source-of-truth.
/// However, we can "derive" this store to small subsets, called store projections,
/// that will handle a smaller part of the state,
/// as long as we can map back-and-forth to the original store types.
/// It won't store anything, only project the original store.
final class StoreProjection<
    GlobalState: Equatable,
    LocalState: Equatable,
    GlobalAction: Equatable,
    LocalAction: Equatable
>: Store<LocalState, LocalAction> {
    private let globalStore: Store<GlobalState, GlobalAction>
    private let stateMap: (GlobalState) -> LocalState?
    private let actionMap: (LocalAction) -> GlobalAction

    init(
        globalStore: Store<GlobalState, GlobalAction>,
        stateMap: @escaping (GlobalState) -> LocalState?,
        actionMap: @escaping (LocalAction) -> GlobalAction
    ) {
        guard let initialState = stateMap(globalStore.state) else {
            fatalError("failed mapping to local state")
        }

        self.globalStore = globalStore
        self.stateMap = stateMap
        self.actionMap = actionMap
        super.init(initial: initialState)

        globalStore.$state
            .map(self.stateMap)
            .compactMap { $0 }
            .removeDuplicates()
            .assign(to: &self.$state)
    }

    override func dispatch(_ action: LocalAction) {
        globalStore.dispatch(actionMap(action))
    }
}

public extension Store {
    /// Creates a subset of the current store by applying any transformation to the State.
    func projection<LocalState: Equatable, LocalAction: Equatable>(
        stateMap: @escaping (State) -> LocalState?,
        actionMap: @escaping (LocalAction) -> Action
    ) -> Store<LocalState, LocalAction> {
        StoreProjection(
            globalStore: self,
            stateMap: stateMap,
            actionMap: actionMap
        )
    }
}
