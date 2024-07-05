//
//  PlayerDamaged.swift
//  
//
//  Created by Hugues Telolahy on 10/04/2023.
//

struct PlayerDamaged: ArgPlayerResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> PlayerArgOutput {
        let damaged = state.round.playOrder
            .starting(with: ctx.sourceActor)
            .filter { state.player($0).isDamaged }
        return .identified(damaged)
    }
}

private extension Player {
    var isDamaged: Bool {
        health < attributes.get(.maxHealth)
    }
}
