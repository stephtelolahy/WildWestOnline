//
//  EffectPassInPlay.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 27/06/2023.
//

struct EffectPassInPlay: EffectResolver {
    let card: ArgCard
    let toPlayer: ArgPlayer

    func resolve(state: GameState, ctx: EffectContext) throws -> SequenceState {
        let fromPlayerId = ctx.targetOrActor()
        let toPlayerId = try toPlayer.resolveUnique(state: state, ctx: ctx)
        let children = try card.resolve(.cardToPassInPlay, state: state, ctx: ctx) {
            .passInPlay($0, target: toPlayerId, player: fromPlayerId)
        }

        var sequence = state.sequence
        sequence.queue.insert(contentsOf: children, at: 0)
        return sequence
    }
}
