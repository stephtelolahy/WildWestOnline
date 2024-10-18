//
//  PlayerSelectReachable.swift
//  
//
//  Created by Hugues Telolahy on 17/04/2023.
//

struct PlayerSelectReachable: ArgPlayerResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> PlayerArgOutput {
        /*
        let playerObj = state.player(ctx.sourceActor)
        let range = playerObj.attributes.get(.weapon)
        return try PlayerSelectAt(distance: range).resolve(state: state, ctx: ctx)
         */
        fatalError()
    }
}
