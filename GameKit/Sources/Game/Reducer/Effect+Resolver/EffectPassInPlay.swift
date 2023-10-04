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
        let targetId = ctx.get(.target)
        let playerContext = ArgPlayerContext(actor: ctx.get(.actor))
        let ownerId = try owner.resolveUnique(state: state, ctx: playerContext)
        
        let cardContext = ArgCardContext(owner: ownerId, chooser: ownerId, playedCard: ctx.get(.card))
        return try card.resolve(state: state, ctx: cardContext) {
            .passInplay($0, target: targetId, player: ownerId)
        }
    }
}
