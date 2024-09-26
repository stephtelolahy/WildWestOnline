//
//  CheckGameOverMiddleware.swift
//  
//
//  Created by Hugues Telolahy on 31/12/2023.
//

import Combine
import Redux

extension Middlewares {
    static func checkGameOver() -> Middleware<GameState> {
        { state, action in
            guard case GameAction.eliminate = action,
                  state.playOrder.count <= 1 else {
                return Empty().eraseToAnyPublisher()
            }

            let winner = state.playOrder.first ?? ""
            return Just(GameAction.endGame(winner: winner)).eraseToAnyPublisher()
        }
    }
}
