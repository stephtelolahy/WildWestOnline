//
//  EffectGroup.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//

struct EffectGroup: EffectResolverProtocol {
    let effects: [CardEffect]
    
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        effects.map { .resolve($0, ctx: ctx) }
    }
}
