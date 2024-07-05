//
//  PlayerNext.swift
//  
//
//  Created by Hugues Telolahy on 01/05/2023.
//

struct PlayerNext: ArgPlayerResolver {
    let pivot: ArgPlayer

    func resolve(state: GameState, ctx: EffectContext) throws -> PlayerArgOutput {
        let pivotId = try pivot.resolveUnique(state: state, ctx: ctx)
        guard let next = state.round.startOrder
            .filter({ state.round.playOrder.contains($0) || $0 == pivotId })
            .element(after: pivotId) else {
            return .identified([])
        }

        return .identified([next])
    }
}
