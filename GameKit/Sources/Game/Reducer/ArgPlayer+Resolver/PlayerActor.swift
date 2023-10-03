//
//  PlayerActor.swift
//  
//
//  Created by Hugues Telolahy on 09/04/2023.
//

struct PlayerActor: ArgPlayerResolverProtocol {
    func resolve(state: GameState, ctx: EffectContext) -> PlayerArgOutput {
        .identified([ctx.get(.actor)])
    }
}
