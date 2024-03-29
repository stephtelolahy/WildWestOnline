//
//  PlayerNext.swift
//  
//
//  Created by Hugues Telolahy on 01/05/2023.
//

struct PlayerNext: ArgPlayerResolver {
    func resolve(state: GameState, ctx: EffectContext) -> PlayerArgOutput {
        guard let turn = state.turn,
              let next = state.startOrder
            .filter({ state.playOrder.contains($0) || $0 == turn })
            .element(after: turn) else {
            return .identified([])
        }

        return .identified([next])
    }
}
