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
        state deriveState: @escaping (State) -> LocalState?,
        action embedAction: @escaping (LocalAction) -> Action
    ) -> Store<LocalState, LocalAction, Void> {
        guard let initialState = deriveState(state) else {
            fatalError("Failed deriving \(LocalState.self) from \(State.self): \(state)")
        }

        let store = Store<LocalState, LocalAction, Void>(
            initialState: initialState,
            reducer: { _, action, _ in
                .run {
                    await self.dispatch(embedAction(action))
                    return .none
                }
            },
            dependencies: ()
        )

        $state
            .map(deriveState)
            .compactMap { $0 }
            .removeDuplicates()
            .assign(to: &store.$state)

        return store
    }
}
