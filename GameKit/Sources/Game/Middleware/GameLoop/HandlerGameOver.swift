//
//  HandlerGameOver.swift
//  
//
//  Created by Hugues Telolahy on 03/11/2023.
//

struct HandlerGameOver: GameActionHandler {
    func handle(action: GameAction, state: GameState) -> GameAction? {
        guard case .eliminate = action,
              let winner = evaluateWinner(state: state)else {
            return nil
        }

        return .setGameOver(winner: winner)
    }

    private func evaluateWinner(state: GameState) -> String? {
        if state.playOrder.count <= 1 {
            return state.playOrder.first
        }

        return nil
    }
}
