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
        nil
    }
}

private func evaluateAIMove(state: GameState) -> GameAction? {
    guard state.isOver == nil else {
        return nil
    }

    if let active = state.active,
       let randomCard = active.cards.randomElement() {
        let randomAction = GameAction.play(randomCard, player: active.player)
        return randomAction
    }

    if let chooseOne = state.chooseOne,
       let randomAction = chooseOne.options.values.randomElement() {
        return randomAction
    }

    return nil
}