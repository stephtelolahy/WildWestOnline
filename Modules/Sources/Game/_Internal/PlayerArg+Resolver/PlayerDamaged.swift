//
//  PlayerDamaged.swift
//  
//
//  Created by Hugues Telolahy on 10/04/2023.
//

struct PlayerDamaged: PlayerArgResolverProtocol {
    func resolve(state: GameState, ctx: EffectContext) -> PlayerArgOutput {
        let damaged = state.playOrder
            .starting(with: ctx.get(.actor))
            .filter { state.player($0).isDamaged }
        return .identified(damaged)
    }
}
