//
//  EffectGroup.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//

struct EffectGroup: EffectResolver {
    let effects: [CardEffect]

    func resolve(state: GameState, ctx: EffectContext) throws -> EffectOutput {
        /*
        let children: [GameAction] = effects.map { .prepareEffect($0, ctx: ctx) }
        return .push(children)
         */
        fatalError()
    }
}
