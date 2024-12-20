//
//  EffectIgnoreError.swift
//  
//
//  Created by Hugues Telolahy on 12/11/2023.
//

struct EffectIgnoreError: EffectResolver {
    let effect: CardEffect

    func resolve(state: GameState, ctx: EffectContext) throws -> EffectOutput {
        do {
            try GameAction.prepareEffect(effect, ctx: ctx).validate(state: state)
            return try effect.resolve(state: state, ctx: ctx)
        } catch {
            return .nothing
        }
    }
}
