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
    guard let action = state.evaluateNextAction() else {
        return Empty().eraseToAnyPublisher()
    }
    
    return Just(action).eraseToAnyPublisher()
}

private extension GameState {
    func evaluateNextAction() -> GameAction? {
        guard queue.isNotEmpty,
              isOver == nil,
              chooseOne == nil,
              active == nil else {
            return nil
        }

        return queue[0]
    }
}
