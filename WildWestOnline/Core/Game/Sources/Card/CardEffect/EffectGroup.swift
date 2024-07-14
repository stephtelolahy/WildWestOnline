//
//  EffectGroup.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//

struct EffectGroup: EffectResolver {
    let effects: [CardEffect]

    func resolve(state: GameState, ctx: EffectContext) throws -> SequenceState {
        let children: [GameAction] = effects.map { .effect($0, ctx: ctx) }

        var sequence = state.sequence
        sequence.queue.insert(contentsOf: children, at: 0)
        return sequence
    }
}
