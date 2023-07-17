//
//  PlayerSelectReachable.swift
//  
//
//  Created by Hugues Telolahy on 17/04/2023.
//

struct PlayerSelectReachable: PlayerArgResolverProtocol {
    func resolve(state: GameState, ctx: EffectContext) -> PlayerArgOutput {
        let actorObj = state.player(ctx.get(.actor))
        let range = actorObj.attributes[.weapon] ?? 0
        return PlayerSelectAt(distance: range)
            .resolve(state: state, ctx: ctx)
    }
}
