//
//  EffectRevealLastHand.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 29/01/2024.
//

struct EffectRevealLastHand: EffectResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> SequenceState {
        let player = ctx.sourceActor
        let handCards = state.field.hand.get(player)
        guard let lastHandCard = handCards.last else {
            fatalError("missing drawn card")
        }
        let children: [GameAction] = [.revealHand(lastHandCard, player: player)]

        var sequence = state.sequence
        sequence.queue.insert(contentsOf: children, at: 0)
        return sequence
    }
}
