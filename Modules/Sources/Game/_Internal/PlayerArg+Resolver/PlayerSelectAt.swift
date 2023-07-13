//
//  PlayerSelectAt.swift
//  
//
//  Created by Hugues Telolahy on 17/04/2023.
//

struct PlayerSelectAt: PlayerArgResolverProtocol {
    let distance: Int

    func resolve(state: GameState, ctx: EffectContext) -> PlayerArgOutput {
        let others = state.playersAt(distance, from: ctx.get(.actor))
        return .selectable(others)
    }
}
