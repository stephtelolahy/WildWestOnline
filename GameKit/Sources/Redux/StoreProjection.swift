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
final class StoreProjection<GlobalState, LocalState>: Store<LocalState> {
    private let globalStore: Store<GlobalState>
    private let stateMap: (GlobalState) -> LocalState
    private var globalStateObservation: AnyCancellable?

    init(globalStore: Store<GlobalState>, stateMap: @escaping (GlobalState) -> LocalState) {
        self.globalStore = globalStore
        self.stateMap = stateMap
        super.init(
            initial: stateMap(globalStore.state),
            reducer: { state, _ in state },
            middlewares: []
        )
        observeGlobalState()
    }

    override func dispatch(_ action: Action) {
        globalStore.dispatch(action)
    }

    private func observeGlobalState() {
        globalStateObservation = globalStore.$state.sink { [weak self] globalState in
            guard let self else {
                return
            }

            let newState = self.stateMap(globalState)
            self.state = newState
        }
    }
}

public extension Store {
    /// Creates a subset of the current store by applying any transformation to the State.
    func projection<LocalState>(stateMap: @escaping (State) -> LocalState) -> Store<LocalState> {
        StoreProjection(globalStore: self, stateMap: stateMap)
    }
}
