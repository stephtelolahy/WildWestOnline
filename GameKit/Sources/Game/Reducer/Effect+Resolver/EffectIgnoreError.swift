//
//  EffectIgnoreError.swift
//  
//
//  Created by Hugues Telolahy on 12/11/2023.
//

struct EffectIgnoreError: EffectResolver {
    let effect: CardEffect
    
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        do {
            let children = try effect.resolve(state: state, ctx: ctx)
            return children
        } catch {
            return []
        }
    }
}
