//
//  PlayerOffender.swift
//
//
//  Created by Hugues Telolahy on 04/11/2023.
//

struct PlayerOffender: ArgPlayerResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> PlayerArgOutput {
        guard case let .damage(_, player) = ctx.sourceEvent,
              player == ctx.sourceActor,
              let turnPlayer = state.round.turn else {
            fatalError("invalid triggering action")
        }

        guard player != turnPlayer else {
            return .identified([])
        }

        return .identified([turnPlayer])
    }
}
