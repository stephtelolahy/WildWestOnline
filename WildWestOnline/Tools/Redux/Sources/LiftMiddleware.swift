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
    private let partMiddleware: Middleware<LocalState,  LocalAction>
    private let stateMap: (GlobalState) -> LocalState?
    private let actionMap: (GlobalAction) -> LocalAction?
    private let embedAction: (LocalAction) -> GlobalAction

    init(
        partMiddleware: Middleware<LocalState,  LocalAction>,
        stateMap: @escaping (GlobalState) -> LocalState?,
        actionMap: @escaping (GlobalAction) -> LocalAction?,
        embedAction: @escaping (LocalAction) -> GlobalAction
    ) {
        self.partMiddleware = partMiddleware
        self.stateMap = stateMap
        self.actionMap = actionMap
        self.embedAction = embedAction
    }

    override func handle(_ action: GlobalAction, state: GlobalState) async -> GlobalAction? {
        guard let localState = stateMap(state),
              let localAction = actionMap(action) else {
            return nil
        }

        guard let nextLocalAction = await partMiddleware.handle(localAction, state: localState) else {
            return nil
        }

        return embedAction(nextLocalAction)
    }
}

public extension Middleware {
    func lift<
        GlobalState,
        GlobalAction
    >(
        stateMap: @escaping (GlobalState) -> State?,
        actionMap: @escaping (GlobalAction) -> Action?
    ) -> Middleware<GlobalState, GlobalAction> {
        LiftMiddleware(
            partMiddleware: self,
            stateMap: stateMap,
            actionMap: actionMap
        )
    }
}
