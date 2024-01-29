//
//  PlaySequenceMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 27/11/2023.
//

import Combine
import Redux

public final class PlaySequenceMiddleware: Middleware<GameState> {
    override public func handle(action: Action, state: GameState) -> AnyPublisher<Action, Never>? {
        guard let action = action as? GameAction else {
            return nil
        }

        switch action {
        case .setGameOver,
                .chooseOne,
                .activate:
            return nil

        default:
            guard let nextAction = state.sequence.first else {
                return nil
            }

            return Just(nextAction).eraseToAnyPublisher()
        }
    }
}
