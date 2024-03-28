//
//  PlayerSelectAny.swift
//  
//
//  Created by Hugues Telolahy on 26/04/2023.
//

struct PlayerSelectAny: ArgPlayerResolver {
    func resolve(state: GameState, ctx: EffectContext) -> PlayerArgOutput {
        let others = state.playOrder
            .starting(with: ctx.sourceActor)
            .dropFirst()
        return .selectable(Array(others))
    }
}
