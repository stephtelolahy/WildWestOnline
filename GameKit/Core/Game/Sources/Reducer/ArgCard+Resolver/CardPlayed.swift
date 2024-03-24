//
//  CardPlayed.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 27/06/2023.
//

struct CardPlayed: ArgCardResolver {
    func resolve(state: GameState, ctx: EffectContext) -> CardArgOutput {
        .identified([ctx.sourceCard])
    }
}
