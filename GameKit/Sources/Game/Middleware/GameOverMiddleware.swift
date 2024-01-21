//
//  GameOverMiddleware.swift
//  
//
//  Created by Hugues Telolahy on 31/12/2023.
//

import Combine
import Redux

public final class GameOverMiddleware: Middleware<GameState> {
    override public func handle(action: Action, state: GameState) -> AnyPublisher<Action, Never>? {
        guard let action = action as? GameAction else {
            return nil
        }

        guard case .eliminate = action else {
            return nil
        }

        guard state.playOrder.count <= 1 else {
            return nil
        }

        let winner = state.playOrder.first ?? ""
        let gameOverAction = GameAction.setGameOver(winner: winner)

        return Just(gameOverAction).eraseToAnyPublisher()
    }
}
