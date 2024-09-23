//
//  EffectRepeat.swift
//  
//
//  Created by Hugues Telolahy on 10/04/2023.
//

struct EffectRepeat: EffectResolver {
    let effect: CardEffect
    let times: ArgNum

    func resolve(state: GameState, ctx: EffectContext) throws -> EffectOutput {
        /*
        let number = try times.resolve(state: state, ctx: ctx)
        let children: [GameAction] = Array(repeating: .prepareEffect(effect, ctx: ctx), count: number)
        return .push(children)
         */
        fatalError()
    }
}
