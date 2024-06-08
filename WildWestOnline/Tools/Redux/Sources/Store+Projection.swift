//
//  Store+Projection.swift
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
public extension Store {
    /// Creates a subset of the current store by applying any transformation to the State.
    func projection<ViewState: Equatable, ViewAction>(
        deriveState: @escaping (State) -> ViewState?,
        embedAction: @escaping (ViewAction) -> Action
    ) -> Store<ViewState, ViewAction> {
        guard let viewState = deriveState(self.state) else {
            fatalError("failed mapping to local state")
        }

        let viewStore = Store<ViewState, ViewAction>(initial: viewState) { [weak self] state, action in
            self?.dispatch(embedAction(action))
            return state
        }

        $state
            .map(deriveState)
            .compactMap { $0 }
            .removeDuplicates()
            .assign(to: &viewStore.$state)

        return viewStore
    }
}

public protocol Connector {
    associatedtype State
    associatedtype Action
    associatedtype ViewState: Equatable
    associatedtype ViewAction

    func deriveState(state: State) -> ViewState?
    func embedAction(action: ViewAction) -> Action
}

public enum Connectors {}

public extension Store {
    func projection<C: Connector>(
        using connector: C
    ) -> Store<C.ViewState, C.ViewAction> where C.State == State, C.Action == Action {
        projection(
            deriveState: connector.deriveState,
            embedAction: connector.embedAction
        )
    }
}
