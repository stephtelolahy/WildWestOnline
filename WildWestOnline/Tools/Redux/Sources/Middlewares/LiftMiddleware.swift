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
public struct LiftMiddleware<State, Action, LocalState, LocalAction>: Middleware {
    private let partMiddleware: any Middleware
    private let deriveState: (State) -> LocalState?
    private let deriveAction: (Action) -> LocalAction?
    private let embedAction: (LocalAction) -> Action

    init(
        partMiddleware: any Middleware<LocalState, LocalAction>,
        deriveState: @escaping (State) -> LocalState?,
        deriveAction: @escaping (Action) -> LocalAction?,
        embedAction: @escaping (LocalAction) -> Action
    ) {
        self.partMiddleware = partMiddleware
        self.deriveState = deriveState
        self.deriveAction = deriveAction
        self.embedAction = embedAction
    }

    public func handle(_ action: Action, state: State) async -> Action? {
        guard let localState = deriveState(state),
              let localAction = deriveAction(action) else {
            // This middleware doesn't care about this action type
            return nil
        }

        guard let typedMiddleware = partMiddleware as? any Middleware<LocalState, LocalAction> else {
            fatalError("invalid middleware type")
        }

        let nextLocalAction = await typedMiddleware.handle(localAction, state: localState)
        return nextLocalAction.flatMap(embedAction)
    }
}

public extension Middleware {
    func lift<GlobalState, GlobalAction>(
        deriveState: @escaping (GlobalState) -> State?,
        deriveAction: @escaping (GlobalAction) -> Action?,
        embedAction: @escaping (Action) -> GlobalAction
    ) -> any Middleware<GlobalState, GlobalAction> {
        LiftMiddleware(
            partMiddleware: self,
            deriveState: deriveState,
            deriveAction: deriveAction,
            embedAction: embedAction
        )
    }
}
