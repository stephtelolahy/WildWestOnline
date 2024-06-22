// swiftlint:disable:this file_name
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
///
public extension Middlewares {
    static func lift<LocalState, GlobalState>(
        _ partMiddleware: @escaping Middleware<LocalState>,
        stateMap: @escaping (GlobalState) -> LocalState?
    ) -> Middleware<GlobalState> {
        { state, action in
            guard let localState = stateMap(state) else {
                return nil
            }

            return await partMiddleware(localState, action)
        }
    }
}
