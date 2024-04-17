//
//  CheckGameOverMiddleware.swift
//  
//
//  Created by Hugues Telolahy on 31/12/2023.
//

import Redux

public final class CheckGameOverMiddleware: Middleware<GameState> {
    override public func effect(on action: Action, state: GameState) async -> Action? {
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
        return GameAction.setGameOver(winner: winner)
    }
}
