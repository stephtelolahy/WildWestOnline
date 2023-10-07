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
        case .next:
            return [.cancel(state.queue[0])]

        case let .effectOfCardNamed(cardName):
            if let index = state.queue.firstIndex(where: { $0.isEffectTriggeredByCardNamed(cardName) }) {
                return [.cancel(state.queue[index])]
            }
        }

        return []
    }
}
