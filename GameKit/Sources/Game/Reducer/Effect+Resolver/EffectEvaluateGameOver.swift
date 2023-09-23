//
//  EffectEvaluateGameOver.swift
//
//
//  Created by Hugues Telolahy on 02/07/2023.
//

struct EffectEvaluateGameOver: EffectResolverProtocol {
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        if let winner = evaluateWinner(state: state) {
            [.setGameOver(winner: winner)]
        } else {
            []
        }
    }
}

private func evaluateWinner(state: GameState) -> String? {
    if state.playOrder.count == 1 {
        return state.playOrder[0]
    }

    return nil
}
