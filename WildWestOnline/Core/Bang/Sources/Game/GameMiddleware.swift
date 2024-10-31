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
            if state.queue.isEmpty {
                Empty().eraseToAnyPublisher()
            } else {
                Just(state.queue[0]).eraseToAnyPublisher()
            }
        }
    }
}
