//
//  EffectRevealLastHand.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 29/01/2024.
//

struct EffectRevealLastHand: EffectResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> EffectOutput {
        let player = ctx.sourceActor
        let children: [GameAction] = [.showLastHand(player: player)]
        return .push(children)
    }
}
