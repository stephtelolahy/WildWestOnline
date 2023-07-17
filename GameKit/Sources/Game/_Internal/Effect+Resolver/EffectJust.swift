//
//  EffectJust.swift
//
//
//  Created by Hugues Telolahy on 18/05/2023.
//

/// Build an action with context
struct EffectJust: EffectResolverProtocol {
    let action: (EffectContext) -> GameAction

    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        [action(ctx)]
    }
}
