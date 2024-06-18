//
//  StoreProjection.swift
//
//
//  Created by Hugues Telolahy on 09/06/2024.
//

import Combine

/// An app should have a single real Store, holding a single source-of-truth.
/// However, we can "derive" this store to small subsets, called store projections,
/// that will handle a smaller part of the state,
/// as long as we can map back-and-forth to the original store types.
/// It won't store anything, only project the original store.
final class StoreProjection<
    State,
    Action,
    ViewState: Equatable,
    ViewAction
>: Store<ViewState, ViewAction> {
    private let globalStore: Store<State, Action>
    private let embedAction: (ViewAction) -> Action

    init(
        globalStore: Store<State, Action>,
        deriveState: @escaping (State) -> ViewState?,
        embedAction: @escaping (ViewAction) -> Action
    ) {
        guard let viewState = deriveState(globalStore.state) else {
            fatalError("failed mapping to local state")
        }

        self.globalStore = globalStore
        self.embedAction = embedAction
        super.init(initial: viewState)

        globalStore.$state
            .map(deriveState)
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
    func projection<ViewState: Equatable, ViewAction>(
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

public protocol Connector {
    associatedtype State
    associatedtype Action
    associatedtype ViewState: Equatable
    associatedtype ViewAction

    func deriveState(_ state: State) -> ViewState?
    func embedAction(_ action: ViewAction, state: State) -> Action
}

public extension Store {
    func projection<C: Connector>(
        using connector: C
    ) -> Store<C.ViewState, C.ViewAction> where C.State == State, C.Action == Action {
        StoreProjection(
            globalStore: self,
            deriveState: connector.deriveState,
            embedAction: { viewAction in
                // TODO: rewrite StoreProjection
                connector.embedAction(viewAction, state: self.state)
            }
        )
    }
}
