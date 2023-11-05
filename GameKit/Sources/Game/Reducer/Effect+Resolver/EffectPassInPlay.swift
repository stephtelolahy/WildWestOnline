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
        let ownerId = ctx.target!
        let toPlayerId = try toPlayer.resolveUnique(state: state, ctx: ctx)
        let cardContext = ArgCardContext(ctx: ctx)
        return try card.resolve(state: state, ctx: cardContext) {
            .passInplay($0, target: toPlayerId, player: ownerId)
        }
    }
}
