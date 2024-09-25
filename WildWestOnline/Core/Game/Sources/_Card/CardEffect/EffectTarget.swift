//
//  EffectTarget.swift
//  
//
//  Created by Hugues Telolahy on 22/04/2023.
//

struct EffectTarget: EffectResolver {
    let target: ArgPlayer
    let effect: CardEffect

    func resolve(state: GameState, ctx: EffectContext) throws -> EffectOutput {
        /*
        let children = try target.resolve(state: state, ctx: ctx) {
            var contextWithTarget = ctx
            contextWithTarget.resolvingTarget = $0
            return GameAction.prepareEffect(effect, ctx: contextWithTarget)
        }

        return .push(children)
         */
        fatalError()
    }
}
