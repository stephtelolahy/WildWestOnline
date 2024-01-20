//
//  EffectRequire.swift
//  
//
//  Created by Hugues Telolahy on 20/01/2024.
//

struct EffectRequire: EffectResolver {
    let requiredEffect: CardEffect
    let thenEffect: CardEffect

    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        []
    }
}
