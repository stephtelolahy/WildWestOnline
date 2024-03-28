//
//  EffectMatchAction.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2024.
//

struct EffectMatchAction: EffectResolver {
    let actions: [String: GameAction]

    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        guard let choice = ctx.resolvingOption,
           let action = actions[choice] else {
            fatalError("expected a valid ctx.chosenOption")
        }

        return [action]
    }
}
