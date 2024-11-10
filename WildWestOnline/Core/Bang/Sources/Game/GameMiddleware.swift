//
//  GameMiddleware.swift
//  Bang
//
//  Created by Hugues Telolahy on 28/10/2024.
//
import Combine

/// Game loop features
public extension Middlewares {
    static var updateGame: Middleware<GameState> {
        { state, _ in
            guard state.queue.isNotEmpty,
                  state.pendingChoice == nil else {
                return nil
            }

            return Just(state.queue[0]).eraseToAnyPublisher()
        }
    }
}
