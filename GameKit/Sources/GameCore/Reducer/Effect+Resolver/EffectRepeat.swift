//
//  EffectRepeat.swift
//  
//
//  Created by Hugues Telolahy on 10/04/2023.
//

struct EffectRepeat: EffectResolver {
    let effect: CardEffect
    let times: ArgNum

    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let number = try times.resolve(state: state, ctx: ctx)
        return Array(repeating: .effect(effect, ctx: ctx), count: number)
    }
}