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
    ViewState: Equatable,
    ViewAction: Sendable,
    GlobalState,
    GlobalAction: Sendable,
    Dependencies
>: Store<ViewState, ViewAction, Void> {
    private let globalStore: Store<GlobalState, GlobalAction, Dependencies>
    private let embedAction: (ViewAction) -> GlobalAction

    init(
        globalStore: Store<GlobalState, GlobalAction, Dependencies>,
        deriveState: @escaping (GlobalState) -> ViewState?,
        embedAction: @escaping (ViewAction) -> GlobalAction
    ) {
        guard let initialState = deriveState(globalStore.state) else {
            fatalError("failed mapping to local state")
        }

        self.globalStore = globalStore
        self.embedAction = embedAction
        super.init(initialState: initialState, dependencies: ())
        self.errorPublisher = globalStore.errorPublisher

        globalStore.$state
            .map(deriveState)
            .compactMap { $0 }
            .removeDuplicates()
            .assign(to: &self.$state)
    }

    override func dispatch(_ action: ViewAction) async {
        await globalStore.dispatch(embedAction(action))
    }
}

public extension Store {
    /// Creates a subset of the current store by applying any transformation to the State.
    func projection<ViewState: Equatable, ViewAction: Sendable>(
        deriveState: @escaping (State) -> ViewState?,
        embedAction: @escaping (ViewAction) -> Action
    ) -> Store<ViewState, ViewAction, Void> {
        StoreProjection(
            globalStore: self,
            deriveState: deriveState,
            embedAction: embedAction
        )
    }
}
