//
//  NumPlayerAddAttr.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 20/11/2023.
//

struct NumPlayerAddAttr: ArgNumResolver {
    let amount: Int
    let key: String

    func resolve(state: GameState, ctx: EffectContext) throws -> Int {
        let playerObj = state.player(ctx.actor)
        guard let value = playerObj.attributes[key] else {
            fatalError("undefined attribute \(key)")
        }
        return value + amount
    }
}
