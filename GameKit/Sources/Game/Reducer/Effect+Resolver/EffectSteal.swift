//
//  EffectSteal.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 20/06/2023.
//

struct EffectSteal: EffectResolverProtocol {
    let card: ArgCard
    let chooser: ArgPlayer
    
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let owner = ctx.get(.target)
        let chooserId = try chooser.resolveUnique(state: state, ctx: ctx)
        
        return try card.resolve(state: state, ctx: ctx, chooser: chooserId, owner: owner) {
            if state.player(owner).hand.contains($0) {
                return .stealHand($0, target: owner, player: chooserId)
            }
            if state.player(owner).inPlay.contains($0) {
                return .stealInPlay($0, target: owner, player: chooserId)
            }
            fatalError("card not found \($0)")
        }
    }
}
