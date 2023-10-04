//
//  PlayerActor.swift
//  
//
//  Created by Hugues Telolahy on 09/04/2023.
//

struct PlayerActor: ArgPlayerResolver {
    func resolve(state: GameState, ctx: ArgPlayerContext) -> PlayerArgOutput {
        .identified([ctx.actor])
    }
}
