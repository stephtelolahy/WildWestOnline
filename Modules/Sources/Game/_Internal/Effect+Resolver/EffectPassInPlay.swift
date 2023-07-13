//
//  EffectPassInPlay.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 27/06/2023.
//

struct EffectPassInPlay: EffectResolverProtocol {
    let card: CardArg
    let owner: PlayerArg
    
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let targetId = ctx.get(.target)
        let ownerId = try owner.resolveAsUniqueId(state: state, ctx: ctx)
        
        return try card.resolve(state: state, ctx: ctx, chooser: ownerId, owner: ownerId) {
            .passInplay($0, target: targetId, player: ownerId)
        }
    }
}
