//
//  EffectSteal.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 20/06/2023.
//

struct EffectSteal: EffectResolverProtocol {
    let card: CardArg
    let chooser: PlayerArg
    
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let owner = ctx.get(.target)
        let chooserId = try chooser.resolveAsUniqueId(state: state, ctx: ctx)
        
        return try card.resolve(state: state, ctx: ctx, chooser: chooserId, owner: owner) {
            .steal($0, target: owner, player: chooserId)
        }
    }
}
