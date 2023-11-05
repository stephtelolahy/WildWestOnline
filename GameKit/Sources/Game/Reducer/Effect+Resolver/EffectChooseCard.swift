//
//  EffectChooseCard.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 20/06/2023.
//

struct EffectChooseCard: EffectResolver {
    let card: ArgCard

    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let player = ctx.target!
        return try card.resolve(state: state, ctx: ctx) {
            .chooseArena($0, player: player)
        }
    }
}
