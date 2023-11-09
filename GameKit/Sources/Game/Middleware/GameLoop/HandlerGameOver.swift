//
//  HandlerGameOver.swift
//  
//
//  Created by Hugues Telolahy on 03/11/2023.
//

struct HandlerGameOver: GameActionHandler {
    func handle(action: GameAction, state: GameState) -> GameAction? {
        guard case .eliminate = action,
              let gameOver = evaluateGameOver(state: state) else {
            return nil
        }
        
        return .setGameOver(winner: gameOver.winner)
    }
    
    private func evaluateGameOver(state: GameState) -> GameOver? {
        if state.playOrder.count <= 1 {
            return GameOver(winner: state.playOrder.first)
        }
        
        return nil
    }
}
