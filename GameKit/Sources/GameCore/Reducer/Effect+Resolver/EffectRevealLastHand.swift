//
//  EffectRevealLastHand.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 29/01/2024.
//

struct EffectRevealLastHand: EffectResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let player = ctx.actor
        let playerObj = state.player(player)
        guard let lastHandCard = playerObj.hand.last else {
            fatalError("missing drawn card")
        }
        return [.revealHand(lastHandCard, player: player)]
    }
}
