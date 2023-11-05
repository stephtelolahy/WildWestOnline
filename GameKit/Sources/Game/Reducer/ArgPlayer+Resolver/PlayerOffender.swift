//
//  PlayerOffender.swift
//
//
//  Created by Hugues Telolahy on 04/11/2023.
//

struct PlayerOffender: ArgPlayerResolver {
    func resolve(state: GameState, ctx: EffectContext) -> PlayerArgOutput {
        guard case let .damage(_, player) = ctx.event,
              player == ctx.actor,
              let turnPlayer = state.turn,
              player != turnPlayer else {
            fatalError("invalid triggering action")
        }

        return .identified([turnPlayer])
    }
}
