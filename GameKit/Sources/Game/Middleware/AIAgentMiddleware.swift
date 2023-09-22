//  AIAgentMiddleware.swift
//  
//
//  Created by Hugues Telolahy on 14/07/2023.
//

import Redux
import Combine

public let aiAgentMiddleware: Middleware<GameState> = { state, _ in
    if let action = evaluateAIMove(state: state) {
        Just(action).eraseToAnyPublisher()
    } else {
        Empty().eraseToAnyPublisher()
    }
}

private func evaluateAIMove(state: GameState) -> GameAction? {
    guard state.isOver == nil else {
        return nil
    }

    if let active = state.active {
        // swiftlint:disable:next force_unwrapping
        let randomCard = active.cards.randomElement()!
        let randomAction = GameAction.play(randomCard, player: active.player)
        return randomAction
    }

    if let chooseOne = state.chooseOne {
        // swiftlint:disable:next force_unwrapping
        let randomAction = chooseOne.options.values.randomElement()!
        return randomAction
    }

    return nil
}
