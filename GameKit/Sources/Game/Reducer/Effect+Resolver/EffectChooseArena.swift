//
//  EffectChooseArena.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 20/06/2023.
//

struct EffectChooseArena: EffectResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let player = ctx.target!
        let card = ArgCard.selectArena
        return try card.resolve(state: state, ctx: ctx) {
            .chooseArena($0, player: player)
        }
    }
}
