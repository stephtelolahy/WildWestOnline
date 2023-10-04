//
//  PlayerSelectAt.swift
//  
//
//  Created by Hugues Telolahy on 17/04/2023.
//

struct PlayerSelectAt: ArgPlayerResolver {
    let distance: Int

    func resolve(state: GameState, ctx: ArgPlayerContext) -> PlayerArgOutput {
        let others = state.playersAt(distance, from: ctx.actor)
        return .selectable(others)
    }
}
