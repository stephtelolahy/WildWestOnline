//
//  NumPlayerAttr.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 02/05/2023.
//

struct NumPlayerAttr: ArgNumResolver {
    let key: AttributeKey

    func resolve(state: GameState, ctx: ArgNumContext) throws -> Int {
        let playerObj = state.player(ctx.actor)
        guard let value = playerObj.attributes[key] else {
            fatalError("undefined attribute \(key)")
        }
        return value
    }
}
