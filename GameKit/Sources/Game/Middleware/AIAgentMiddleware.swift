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
        guard state.winner == nil else {
            return nil
        }

        if let active = state.active.first,
           state.playMode[active.key] == .auto,
           let randomCard = active.value.randomElement() {
            return GameAction.play(randomCard, player: active.key)
        }

        if let chooseOne = state.chooseOne.first,
           state.playMode[chooseOne.key] == .auto,
           let randomAction = chooseOne.value.values.randomElement() {
            return randomAction
        }

        return nil
    }
}
