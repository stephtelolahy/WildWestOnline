//
//  CheckGameOverMiddleware.swift
//  
//
//  Created by Hugues Telolahy on 31/12/2023.
//

import Redux

extension Middlewares {
    static func checkGameOver() -> Middleware<GameState> {
        { state, action in
            guard case GameAction.eliminate = action,
                  state.round.playOrder.count <= 1 else {
                return nil
            }

            let winner = state.round.playOrder.first ?? ""
            return GameAction.endGame(winner: winner)
        }
    }
}
