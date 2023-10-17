//
//  PlayerSelectReachable.swift
//  
//
//  Created by Hugues Telolahy on 17/04/2023.
//

struct PlayerSelectReachable: ArgPlayerResolver {
    func resolve(state: GameState, ctx: ArgPlayerContext) -> PlayerArgOutput {
        let playerObj = state.player(ctx.actor)
        let range = playerObj.attributes.get(.weapon)
        return PlayerSelectAt(distance: range).resolve(state: state, ctx: ctx)
    }
}
