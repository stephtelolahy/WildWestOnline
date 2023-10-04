//
//  PlayerTarget.swift
//  
//
//  Created by Hugues Telolahy on 10/04/2023.
//

struct PlayerTarget: ArgPlayerResolver {
    func resolve(state: GameState, ctx: ArgPlayerContext) -> PlayerArgOutput {
        .identified([ctx.target.unsafelyUnwrapped])
    }
}
