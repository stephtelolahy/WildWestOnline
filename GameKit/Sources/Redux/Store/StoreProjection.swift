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
final class StoreProjection<GlobalState: Equatable, LocalState: Equatable>: Store<LocalState> {
    private let globalStore: Store<GlobalState>
    private let stateMap: (GlobalState) -> LocalState?
    private var subscriptions = Set<AnyCancellable>()

    override var log: [Action] {
        globalStore.log
    }

    init(globalStore: Store<GlobalState>, stateMap: @escaping (GlobalState) -> LocalState?) {
        guard let initialState = stateMap(globalStore.state) else {
            fatalError("failed to resolve local state")
        }

        self.globalStore = globalStore
        self.stateMap = stateMap
        super.init(initial: initialState)

        globalStore.$state.sink { [weak self] globalState in
            guard let self,
                  let newState = self.stateMap(globalState),
                  newState != self.state else {
                return
            }

            self.state = newState
        }
        .store(in: &subscriptions)
    }

    override func dispatch(_ action: Action) {
        globalStore.dispatch(action)
    }
}

public extension Store {
    /// Creates a subset of the current store by applying any transformation to the State.
    func projection<LocalState: Equatable>(stateMap: @escaping (State) -> LocalState?) -> Store<LocalState> {
        StoreProjection(globalStore: self, stateMap: stateMap)
    }
}
