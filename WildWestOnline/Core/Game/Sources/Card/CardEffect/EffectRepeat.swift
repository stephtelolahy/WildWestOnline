//
//  EffectRepeat.swift
//  
//
//  Created by Hugues Telolahy on 10/04/2023.
//

struct EffectRepeat: EffectResolver {
    let effect: CardEffect
    let times: ArgNum

    func resolve(state: GameState, ctx: EffectContext) throws -> SequenceState {
        let number = try times.resolve(state: state, ctx: ctx)
        let children: [GameAction] = Array(repeating: .effect(effect, ctx: ctx), count: number)

        var sequence = state.sequence
        sequence.queue.insert(contentsOf: children, at: 0)
        return sequence
    }
}
