// swiftlint:disable:this file_name
//  AIAgentMiddleware.swift
//  
//
//  Created by Hugues Telolahy on 14/07/2023.
//

import Redux
import Combine

public let aiAgentMiddleware: Middleware<GameState> = { state, _ in
    if let action = state.evaluateAIMove() {
        Just(action).eraseToAnyPublisher()
    } else {
        Empty().eraseToAnyPublisher()
    }
}

extension GameState {
    func evaluateAIMove() -> GameAction? {
        guard isOver == nil else {
            return nil
        }

        if let active {
            // swiftlint:disable:next force_unwrapping
            let randomCard = active.cards.randomElement()!
            let randomAction = GameAction.play(randomCard, actor: active.player)
            return randomAction
        }

        if let chooseOne {
            // swiftlint:disable:next force_unwrapping
            let randomAction = chooseOne.options.values.randomElement()!
            return randomAction
        }

        return nil
    }
}
