//
//  ActionResolveEffect.swift
//
//
//  Created by Hugues Telolahy on 07/05/2023.
//

struct ActionResolveEffect: GameActionReducer {
    let effect: CardEffect
    let ctx: EffectContext

    func reduce(state: GameState) throws -> GameState {
        var state = state
        var children = try effect.resolve(state: state, ctx: ctx)

        // TODO: improve
        // <handle chooseOne>
        if children.count == 1,
           case .chooseOne = children[0] {
            let originalEffect = GameAction.effect(effect, ctx: ctx)
            children.append(originalEffect)
        }
        // <\handle chooseOne>

        state.sequence.insert(contentsOf: children, at: 0)
        return state
    }
}
