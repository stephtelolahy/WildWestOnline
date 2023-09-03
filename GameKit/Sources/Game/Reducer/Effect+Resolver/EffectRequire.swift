//
//  EffectRequire.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 31/08/2023.
//

struct EffectRequire: EffectResolverProtocol {
    let playReq: PlayReq
    let effect: CardEffect

    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        try playReq.match(state: state, ctx: ctx)
        return [.resolve(effect, ctx: ctx)]
    }
}
