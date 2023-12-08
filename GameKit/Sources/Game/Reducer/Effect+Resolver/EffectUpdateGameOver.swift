//
//  EffectUpdateGameOver.swift
//  
//
//  Created by Hugues Telolahy on 23/11/2023.
//

struct EffectUpdateGameOver: EffectResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        guard state.playOrder.count <= 1 else {
            return []
        }

        let winner = state.playOrder.first ?? ""
        return [.setGameOver(winner: winner)]
    }
}
