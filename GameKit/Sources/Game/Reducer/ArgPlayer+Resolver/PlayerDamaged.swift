//
//  PlayerDamaged.swift
//  
//
//  Created by Hugues Telolahy on 10/04/2023.
//

struct PlayerDamaged: ArgPlayerResolver {
    func resolve(state: GameState, ctx: EffectContext) -> PlayerArgOutput {
        let damaged = state.playOrder
            .starting(with: ctx.actor)
            .filter { state.player($0).isDamaged }
        return .identified(damaged)
    }
}
