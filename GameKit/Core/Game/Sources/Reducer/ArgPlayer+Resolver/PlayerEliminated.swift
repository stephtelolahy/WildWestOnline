//
//  PlayerEliminated.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 09/11/2023.
//

struct PlayerEliminated: ArgPlayerResolver {
    func resolve(state: GameState, ctx: EffectContext) -> PlayerArgOutput {
        guard case let .eliminate(player) = ctx.sourceEvent else {
            fatalError("invalid triggering action")
        }

        return .identified([player])
    }
}
