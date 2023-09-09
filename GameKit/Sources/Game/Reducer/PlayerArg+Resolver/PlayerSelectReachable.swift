//
//  PlayerSelectReachable.swift
//  
//
//  Created by Hugues Telolahy on 17/04/2023.
//

struct PlayerSelectReachable: PlayerArgResolverProtocol {
    func resolve(state: GameState, ctx: EffectContext) -> PlayerArgOutput {
        let playerObj = state.player(ctx.get(.actor))
        let range = playerObj.attributes.get(.weapon)
        return PlayerSelectAt(distance: range)
            .resolve(state: state, ctx: ctx)
    }
}
