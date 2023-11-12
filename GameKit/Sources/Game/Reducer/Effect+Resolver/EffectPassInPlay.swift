//
//  EffectPassInPlay.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 27/06/2023.
//

struct EffectPassInPlay: EffectResolver {
    let card: ArgCard
    let toPlayer: ArgPlayer

    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let fromPlayerId = ctx.player()
        let toPlayerId = try toPlayer.resolveUnique(state: state, ctx: ctx)
        return try card.resolve(state: state, ctx: ctx) {
            .passInplay($0, target: toPlayerId, player: fromPlayerId)
        }
    }
}
