//
//  EffectBuild.swift
//  
//
//  Created by Hugues Telolahy on 18/05/2023.
//

/// Build an action with context
struct EffectBuild: EffectResolverProtocol {
    let action: (EffectContext) -> GameAction

    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        return [action(ctx)]
    }
}
