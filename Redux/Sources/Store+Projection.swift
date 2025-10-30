//
//  Store+Projection.swift
//
//  Created by Hugues Stephano TELOLAHY on 29/11/2023.
//
/// An app should have a single real Store, holding a single source-of-truth.
/// However, we can "derive" this store to small subsets, called store projections,
/// that will handle a smaller part of the state,
/// as long as we can map back-and-forth to the original store types.
/// It won't store anything, only project the original store.
public extension Store {
    func projection<LocalState: Equatable, LocalAction>(
        state toLocalState: @escaping (State) -> LocalState?,
        action embedAction: @escaping (LocalAction) -> Action
    ) -> Store<LocalState, LocalAction, Void> {
        StoreProjection(
            globalStore: self,
            deriveState: toLocalState,
            embedAction: embedAction
        )
    }
}

private final class StoreProjection<
    LocalState: Equatable,
    LocalAction,
    GlobalState,
    GlobalAction,
    Dependencies
>: Store<LocalState, LocalAction, Void> {
    private let globalStore: Store<GlobalState, GlobalAction, Dependencies>
    private let toLocalState: (GlobalState) -> LocalState?
    private let embedAction: (LocalAction) -> GlobalAction

    init(
        globalStore: Store<GlobalState, GlobalAction, Dependencies>,
        deriveState: @escaping (GlobalState) -> LocalState?,
        embedAction: @escaping (LocalAction) -> GlobalAction
    ) {
        guard let initialState = deriveState(globalStore.state) else {
            fatalError("Failed deriving \(LocalState.self) from \(GlobalState.self): \(globalStore.state)")
        }

        self.globalStore = globalStore
        self.toLocalState = deriveState
        self.embedAction = embedAction

        super.init(
            initialState: initialState,
            reducer: { _, _, _ in .none },
            dependencies: ()
        )

        globalStore.$state
            .map(deriveState)
            .compactMap { $0 }
            .removeDuplicates()
            .assign(to: &self.$state)
    }

    override func dispatch(_ action: LocalAction) async {
        await globalStore.dispatch(embedAction(action))
    }
}
