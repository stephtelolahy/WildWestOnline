// swiftlint:disable:this file_name
//  GameLoopMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 26/04/2023.
//
import Redux
import Combine

public let gameLoopMiddleware: Middleware<GameState> = { state, action in
    guard let action = action as? GameAction else {
        return Empty().eraseToAnyPublisher()
    }

    switch action {
    case .setGameOver,
            .chooseOne,
            .activateCards:
        return Empty().eraseToAnyPublisher()

    default:
        guard let nextAction = state.queue.first else {
            return Empty().eraseToAnyPublisher()
        }

        precondition(state.isOver == nil)
        precondition(state.active == nil)
        precondition(state.chooseOne == nil)
        return Just(nextAction).eraseToAnyPublisher()
    }
}
