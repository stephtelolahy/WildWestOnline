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
    State: Equatable,
    Action: Equatable,
    ViewState: Equatable,
    ViewAction: Equatable
>: Store<ViewState, ViewAction> {
    private let globalStore: Store<State, Action>
    private let deriveState: (State) -> ViewState?
    private let embedAction: (ViewAction) -> Action

    init(
        globalStore: Store<State, Action>,
        deriveState: @escaping (State) -> ViewState?,
        embedAction: @escaping (ViewAction) -> Action
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
    }

    override func dispatch(_ action: ViewAction) {
        globalStore.dispatch(embedAction(action))
    }
}

public extension Store {
    /// Creates a subset of the current store by applying any transformation to the State.
    func projection<ViewState: Equatable, ViewAction: Equatable>(
        deriveState: @escaping (State) -> ViewState?,
        embedAction: @escaping (ViewAction) -> Action
    ) -> Store<ViewState, ViewAction> {
        StoreProjection(
            globalStore: self,
            deriveState: deriveState,
            embedAction: embedAction
        )
    }
}
