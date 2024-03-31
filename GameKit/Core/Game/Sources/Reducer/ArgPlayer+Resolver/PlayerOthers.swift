//
//  PlayerOthers.swift
//  
//
//  Created by Hugues Telolahy on 22/04/2023.
//

struct PlayerOthers: ArgPlayerResolver {
    func resolve(state: GameState, ctx: EffectContext) -> PlayerArgOutput {
        let others = state.playOrder
            .starting(with: ctx.sourceActor)
            .dropFirst()
        return .identified(Array(others))
    }
}
