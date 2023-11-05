//
//  EffectPassInPlay.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 27/06/2023.
//

struct EffectPassInPlay: EffectResolver {
    let card: ArgCard
    let owner: ArgPlayer
    
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let targetId = ctx.target!
        let ownerId = try owner.resolveUnique(state: state, ctx: ctx)
        let cardContext = ArgCardContext(owner: ownerId, chooser: ownerId, played: ctx.card)
        return try card.resolve(state: state, ctx: cardContext) {
            .passInplay($0, target: targetId, player: ownerId)
        }
    }
}
