//
//  NumPlayerAttr.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 02/05/2023.
//

struct NumPlayerAttr: ArgNumResolver {
    let key: String

    func resolve(state: GameState, ctx: EffectContext) throws -> Int {
        let playerObj = state.player(ctx.actor)
        guard let value = playerObj.attributes[key] else {
            fatalError("undefined attribute \(key)")
        }
        return value
    }
}
