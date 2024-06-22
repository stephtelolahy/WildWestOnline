//
//  LiftMiddleware.swift
//
//
//  Created by Hugues Telolahy on 27/11/2023.
//

/// This is a container that lifts a sub-state middleware to a global state middleware.
/// Internally you find the middleware responsible for handling events and actions for a sub-state (`Part`),
/// while this outer class will be able to compose with global state (`Whole`) in your `Store`.
/// You should not be able to instantiate this class directly,
/// instead, create a middleware for the sub-state and call `Middleware.lift(_:)`,
/// passing as parameter the keyPath from whole to part.
struct LiftMiddleware<State, LocalState>: Middleware {
    private let partMiddleware: any Middleware<LocalState>
    private let stateMap: (State) -> LocalState?

    init(
        middleware: any Middleware<LocalState>,
        stateMap: @escaping (State) -> LocalState?
    ) {
        self.stateMap = stateMap
        self.partMiddleware = middleware
    }

    func effect(on action: Action, state: State) async -> Action? {
        guard let localState = stateMap(state) else {
            return nil
        }

        return await partMiddleware.effect(on: action, state: localState)
    }
}

public extension Middleware {
    func lift<GlobalState>(stateMap: @escaping (GlobalState) -> State?) -> any Middleware<GlobalState> {
        LiftMiddleware(
            middleware: self,
            stateMap: stateMap
        )
    }
}
