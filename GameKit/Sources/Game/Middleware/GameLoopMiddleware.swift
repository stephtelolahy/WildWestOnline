// swiftlint:disable:this file_name
//  GameLoopMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 26/04/2023.
//
import Redux
import Combine

public let gameLoopMiddleware: Middleware<GameState> = { state, _ in
    if let action = NextActionEvaluator().evaluateNextAction(state) {
        Just(action).eraseToAnyPublisher()
    } else {
        Empty().eraseToAnyPublisher()
    }
}

private struct NextActionEvaluator {

    func evaluateNextAction(_ state: GameState) -> GameAction? {
        if state.queue.isNotEmpty,
           state.isOver == nil,
           state.chooseOne == nil,
           state.active == nil {
            state.queue[0]
        } else {
            nil
        }
    }
}
