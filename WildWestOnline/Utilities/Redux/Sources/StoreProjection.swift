//
//  StoreProjection.swift
//
//  Created by Hugues Stephano TELOLAHY on 29/11/2023.
//
/// An app should have a single real Store, holding a single source-of-truth.
/// However, we can "derive" this store to small subsets, called store projections,
/// that will handle a smaller part of the state,
/// as long as we can map back-and-forth to the original store types.
/// It won't store anything, only project the original store.
private class StoreProjection<
    LocalState: Equatable,
    GlobalState,
    Dependencies
>: Store<LocalState, Void> {
    private let globalStore: Store<GlobalState, Dependencies>

    init(
        globalStore: Store<GlobalState, Dependencies>,
        deriveState: @escaping (GlobalState) -> LocalState?
    ) {
        guard let initialState = deriveState(globalStore.state) else {
            fatalError("failed mapping to local state")
        }

        self.globalStore = globalStore
        super.init(initialState: initialState, dependencies: ())
        self.errorPublisher = globalStore.errorPublisher

        globalStore.$state
            .map(deriveState)
            .compactMap { $0 }
            .removeDuplicates()
            .assign(to: &self.$state)
    }

    override func dispatch(_ action: Action) async {
        await globalStore.dispatch(action)
    }
}

public extension Store {
    /// Creates a subset of the current store by applying any transformation to the State.
    func projection<LocalState: Equatable>(deriveState: @escaping (State) -> LocalState?) -> Store<LocalState, Void> {
        StoreProjection(globalStore: self, deriveState: deriveState)
    }
}
