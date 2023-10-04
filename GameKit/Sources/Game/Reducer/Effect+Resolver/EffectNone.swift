//
//  EffectNone.swift
//  
//
//  Created by Hugues Telolahy on 11/06/2023.
//

struct EffectNone: EffectResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        []
    }
}
