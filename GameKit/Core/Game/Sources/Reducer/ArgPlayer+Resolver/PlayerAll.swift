//
//  PlayerAll.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//

struct PlayerAll: ArgPlayerResolver {
    func resolve(state: GameState, ctx: EffectContext) -> PlayerArgOutput {
        let all = state.playOrder
            .starting(with: ctx.actor)
        return .identified(all)
    }
}
