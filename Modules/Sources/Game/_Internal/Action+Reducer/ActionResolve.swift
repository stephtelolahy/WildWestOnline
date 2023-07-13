//
//  ActionResolve.swift
//
//
//  Created by Hugues Telolahy on 07/05/2023.
//

struct ActionResolve: GameReducerProtocol {
    let effect: CardEffect
    let ctx: EffectContext
    
    func reduce(state: GameState) throws -> GameState {
        var state = state
        let children = try effect.resolve(state: state, ctx: ctx)
        state.queue.insert(contentsOf: children, at: 0)
        return state
    }
}
