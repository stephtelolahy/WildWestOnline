//  AIAgentMiddleware.swift
//
//
//  Created by Hugues Telolahy on 14/07/2023.
//

import Combine
import Redux

public final class AIAgentMiddleware: Middleware<GameState> {
    override public func handle(action: Action, state: GameState) -> AnyPublisher<Action, Never>? {
        guard let move = evaluateAIMove(state: state) else {
            return nil
        }

        return Just(move).eraseToAnyPublisher()
    }

    private func evaluateAIMove(state: GameState) -> GameAction? {
        guard state.isOver == nil else {
            return nil
        }

        if let active = state.active,
           let randomCard = active.cards.randomElement() {
            return GameAction.play(randomCard, player: active.player)
        }

        if let chooseOne = state.chooseOne,
           let randomAction = chooseOne.options.values.randomElement() {
            return randomAction
        }

        return nil
    }
}
