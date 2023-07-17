//
//  CardPlayed.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 27/06/2023.
//

struct CardPlayed: CardArgResolverProtocol {
    func resolve(state: GameState, ctx: EffectContext, chooser: String, owner: String?) -> CardArgOutput {
        .identified([ctx.get(.card)])
    }
}
