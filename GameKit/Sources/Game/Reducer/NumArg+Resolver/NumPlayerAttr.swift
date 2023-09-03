//
//  NumPlayerAttr.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 02/05/2023.
//

struct NumPlayerAttr: NumArgResolverProtocol {
    let key: AttributeKey

    func resolve(state: GameState, ctx: EffectContext) throws -> Int {
        let playerObj = state.player(ctx.get(.actor))
        return playerObj.attributes[key] ?? 0
    }
}
