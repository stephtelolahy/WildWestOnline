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

        return [.setGameOver(winner: state.playOrder.first)]
    }
}