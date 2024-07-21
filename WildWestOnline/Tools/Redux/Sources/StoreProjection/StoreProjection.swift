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

public class TypedStore<ViewState: Equatable, ViewAction>: ObservableObject {
    @Published public internal(set) var state: ViewState

    public init(_ state: ViewState) {
        self.state = state
    }

    public func dispatch(_ viewAction: ViewAction) {
    }
}

private class StoreProjection<ViewState: Equatable, ViewAction, GlobalState: Equatable>: TypedStore<ViewState, ViewAction> {
    private let globalStore: Store<GlobalState>
    private let deriveState: (GlobalState) -> ViewState?
    private let embedAction: (ViewAction, GlobalState) -> Action

    init(
        globalStore: Store<GlobalState>,
        deriveState: @escaping (GlobalState) -> ViewState?,
        embedAction: @escaping (ViewAction, GlobalState) -> Action
    ) {
        guard let initialState = deriveState(globalStore.state) else {
            fatalError("failed mapping to local state")
        }

        self.globalStore = globalStore
        self.deriveState = deriveState
        self.embedAction = embedAction
        super.init(initialState)

        globalStore.$state
            .map(self.deriveState)
            .compactMap { $0 }
            .removeDuplicates()
            .assign(to: &self.$state)
    }

    override func dispatch(_ viewAction: ViewAction) {
        let globalAction = embedAction(viewAction, globalStore.state)
        globalStore.dispatch(globalAction)
    }
}

public extension Store {
    /// Creates a subset of the current store by applying any transformation to the State.
    func projection<ViewState: Equatable, ViewAction>(
        _ deriveState: @escaping (State) -> ViewState?,
        _ embedAction: @escaping (ViewAction, State) -> Action
    ) -> TypedStore<ViewState, ViewAction> {
        StoreProjection(
            globalStore: self,
            deriveState: deriveState,
            embedAction: embedAction
        )
    }
}
