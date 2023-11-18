// swiftlint:disable:this file_name
//
//  GameLoopMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 26/04/2023.
//
// swiftlint:disable prefixed_toplevel_constant

import Combine
import Redux

public let gameLoopMiddleware: Middleware<GameState> = { state, action in
    guard let action = action as? GameAction else {
        return nil
    }

    for handler in actionHandlers {
        if let output = handler.handle(action: action, state: state) {
            return Just(output).eraseToAnyPublisher()
        }
    }

    return nil
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
