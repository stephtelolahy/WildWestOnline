//
//  EffectDrawArena.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 20/06/2023.
//

struct EffectDrawArena: EffectResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> SequenceState {
        let children = try ArgCard.selectArena.resolve(.cardToDraw, state: state, ctx: ctx) {
            .drawArena($0, player: ctx.targetOrActor())
        }

        var sequence = state.sequence
        sequence.queue.insert(contentsOf: children, at: 0)
        return sequence
    }
}
