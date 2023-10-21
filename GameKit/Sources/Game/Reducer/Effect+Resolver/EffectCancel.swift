//
//  EffectCancel.swift
//
//
//  Created by Hugues Telolahy on 07/10/2023.
//

struct EffectCancel: EffectResolver {
    let arg: ArgCancel

    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        switch arg {
        case .effectOfShoot:
            if let index = state.queue.firstIndex(where: { $0.isEffectOfShoot(ctx.actor) }) {
                return [.cancel(state.queue[index])]
            }

        case let .effectOfCard(cardName):
            if let index = state.queue.firstIndex(where: { $0.isEffectOfCard(cardName) }) {
                return [.cancel(state.queue[index])]
            }
        }

        return []
    }
}
