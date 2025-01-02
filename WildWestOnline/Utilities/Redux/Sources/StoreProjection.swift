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
    DerivedState: Equatable,
    ExtractedAction: Sendable,
    GlobalState,
    GlobalAction: Sendable,
    Dependencies
>: Store<DerivedState, ExtractedAction, Void> {
    private let globalStore: Store<GlobalState, GlobalAction, Dependencies>
    private let embedAction: (ExtractedAction) -> GlobalAction

    init(
        globalStore: Store<GlobalState, GlobalAction, Dependencies>,
        deriveState: @escaping (GlobalState) -> DerivedState?,
        embedAction: @escaping (ExtractedAction) -> GlobalAction
    ) {
        guard let initialState = deriveState(globalStore.state) else {
            fatalError("failed mapping to local state")
        }

        self.globalStore = globalStore
        self.embedAction = embedAction
        super.init(initialState: initialState, dependencies: ())
//        self.eventPublisher = globalStore.eventPublisher
        self.errorPublisher = globalStore.errorPublisher

        globalStore.$state
            .map(deriveState)
            .compactMap { $0 }
            .removeDuplicates()
            .assign(to: &self.$state)
    }

    override func dispatch(_ action: ExtractedAction) async {
        await globalStore.dispatch(embedAction(action))
    }
}

public extension Store {
    /// Creates a subset of the current store by applying any transformation to the State.
    func projection<DerivedState: Equatable, ExtractedAction: Sendable>(
        deriveState: @escaping (State) -> DerivedState?,
        embedAction: @escaping (ExtractedAction) -> Action
    ) -> Store<DerivedState, ExtractedAction, Void> {
        StoreProjection(
            globalStore: self,
            deriveState: deriveState,
            embedAction: embedAction
        )
    }
}
