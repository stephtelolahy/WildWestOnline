// swiftlint:disable:this file_name
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
}
