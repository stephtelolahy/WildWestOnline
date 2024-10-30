//
//  GameMiddleware.swift
//  Bang
//
//  Created by Hugues Telolahy on 28/10/2024.
//
import Redux
import Combine

/// Game loop features
public extension Middlewares {
    static func updateGame() -> Middleware<GameState> {
        { state, _ in
            guard !state.queue.isEmpty else {
                return Empty().eraseToAnyPublisher()
            }

            return Just(state.queue[0]).eraseToAnyPublisher()
        }
    }
}
