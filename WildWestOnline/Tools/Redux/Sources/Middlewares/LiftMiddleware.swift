//
//  LiftMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 07/06/2024.
//

/// This is a container that lifts a sub-state middleware to a global state middleware.
/// Internally you find the middleware responsible for handling events and actions for a sub-state (`Part`),
/// while this outer class will be able to compose with global state (`Whole`) in your `Store`.
/// You should not be able to instantiate this class directly,
/// instead, create a middleware for the sub-state and call `Middleware.lift(_:)`,
/// passing as parameter the keyPath from whole to part.
final class LiftMiddleware<
    GlobalState,
    GlobalAction,
    LocalState,
    LocalAction
>: Middleware<GlobalState, GlobalAction> {
    private let partMiddleware: Middleware<LocalState, LocalAction>
    private let deriveState: (GlobalState) -> LocalState?
    private let deriveAction: (GlobalAction) -> LocalAction?
    private let embedAction: (LocalAction) -> GlobalAction

    init(
        partMiddleware: Middleware<LocalState, LocalAction>,
        deriveState: @escaping (GlobalState) -> LocalState?,
        deriveAction: @escaping (GlobalAction) -> LocalAction?,
        embedAction: @escaping (LocalAction) -> GlobalAction
    ) {
        self.partMiddleware = partMiddleware
        self.deriveState = deriveState
        self.deriveAction = deriveAction
        self.embedAction = embedAction
    }

    override func handle(_ action: GlobalAction, state: GlobalState) async -> GlobalAction? {
        guard let localState = deriveState(state),
              let localAction = deriveAction(action) else {
            // This middleware doesn't care about this action type
            return nil
        }

        let nextLocalAction = await partMiddleware.handle(localAction, state: localState)
        return nextLocalAction.flatMap(embedAction)
    }
}

public extension Middleware {
    func lift<GlobalState, GlobalAction>(
        deriveState: @escaping (GlobalState) -> State?,
        deriveAction: @escaping (GlobalAction) -> Action?,
        embedAction: @escaping (Action) -> GlobalAction
    ) -> Middleware<GlobalState, GlobalAction> {
        LiftMiddleware(
            partMiddleware: self,
            deriveState: deriveState,
            deriveAction: deriveAction,
            embedAction: embedAction
        )
    }
}
