//
//  CheckGameOverMiddleware.swift
//  
//
//  Created by Hugues Telolahy on 31/12/2023.
//

import Redux

public final class CheckGameOverMiddleware: Middleware<GameState, GameAction> {
    public override func handle(_ action: GameAction, state: GameState) async -> GameAction? {
        guard case .eliminate = action else {
            return nil
        }

        guard state.playOrder.count <= 1 else {
            return nil
        }

        let winner = state.playOrder.first ?? ""
        return GameAction.setGameOver(winner: winner)
    }
}
