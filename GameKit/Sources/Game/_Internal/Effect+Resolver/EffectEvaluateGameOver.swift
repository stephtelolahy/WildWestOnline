//
//  EffectEvaluateGameOver.swift
//
//
//  Created by Hugues Telolahy on 02/07/2023.
//

struct EffectEvaluateGameOver: EffectResolverProtocol {
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        if let winner = state.evaluateWinner() {
            [.setGameOver(winner: winner)]
        } else {
            []
        }
    }
}

private extension GameState {
    func evaluateWinner() -> String? {
        if playOrder.count == 1 {
            return playOrder[0]
        }

        return nil
    }
}
