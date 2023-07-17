// swiftlint:disable:this file_name
//  GameLoopMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 26/04/2023.
//
import Redux
import Combine

/// Dispatching queued side effects
let gameLoopMiddleware: Middleware<GameState, GameAction> = { state, _ in
    if let action = state.evaluateNextAction() {
        Just(action).eraseToAnyPublisher()
    } else {
        Empty().eraseToAnyPublisher()
    }
}

private extension GameState {
    func evaluateNextAction() -> GameAction? {
        if queue.isNotEmpty,
           isOver == nil,
           chooseOne == nil,
           active == nil {
            queue[0]
        } else {
            nil
        }
    }
}
