//
//  EffectChooseOnePlayOrPass.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 12/10/2023.
//

struct EffectChooseOnePlayOrPass: EffectResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        [.chooseOne(player: ctx.actor,
                    options: [
                        ctx.card: .playImmediate(ctx.card, player: ctx.actor),
                        .pass: .group([])
                    ])
        ]
    }
}
