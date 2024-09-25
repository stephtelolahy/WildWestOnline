//
//  NumPlayerAddAttr.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 20/11/2023.
//

struct NumPlayerAddAttr: ArgNumResolver {
    let amount: Int
    let key: PlayerAttribute

    func resolve(state: GameState, ctx: EffectContext) throws -> Int {
        let playerObj = state.player(ctx.sourceActor)
        guard let value = playerObj.attributes[key] else {
            fatalError("undefined attribute \(key)")
        }
        return value + amount
    }
}
