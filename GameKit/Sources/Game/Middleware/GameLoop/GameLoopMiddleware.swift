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

    for handler in actionHandlers {
        if let output = handler.handle(action: action, state: state) {
            return Just(output).eraseToAnyPublisher()
        }
    }

    return Empty().eraseToAnyPublisher()
}

protocol GameActionHandler {
    func handle(action: GameAction, state: GameState) -> GameAction?
}

private let actionHandlers: [GameActionHandler] = [
    HandlerGameOver(),
    HandlerTriggeredEffects(),
    HandlerNextAction(),
    HandlerActivateCards()
]
